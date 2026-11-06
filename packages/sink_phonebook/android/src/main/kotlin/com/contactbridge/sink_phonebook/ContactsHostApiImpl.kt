package com.contactbridge.sink_phonebook

import android.Manifest
import android.app.Activity
import android.content.ContentProviderOperation
import android.content.ContentUris
import android.content.Context
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.ContactsContract
import android.provider.ContactsContract.CommonDataKinds.Phone
import android.provider.ContactsContract.CommonDataKinds.StructuredName
import android.provider.ContactsContract.Data
import android.provider.ContactsContract.RawContacts
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class ContactsHostApiImpl(private val context: Context) : ContactsHostApi {
    var currentActivity: Activity? = null
    var pendingPermissionCallback: ((Result<NativePermissionStatus>) -> Unit)? = null

    override fun getPermissionStatus(): NativePermissionStatus {
        val readGranted = ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.READ_CONTACTS
        ) == PackageManager.PERMISSION_GRANTED

        val writeGranted = ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.WRITE_CONTACTS
        ) == PackageManager.PERMISSION_GRANTED

        return if (readGranted && writeGranted) {
            NativePermissionStatus.GRANTED
        } else {
            NativePermissionStatus.DENIED
        }
    }

    override fun requestPermission(callback: (Result<NativePermissionStatus>) -> Unit) {
        if (getPermissionStatus() == NativePermissionStatus.GRANTED) {
            callback(Result.success(NativePermissionStatus.GRANTED))
            return
        }

        val act = currentActivity
        if (act != null) {
            pendingPermissionCallback = callback
            ActivityCompat.requestPermissions(
                act,
                arrayOf(Manifest.permission.READ_CONTACTS, Manifest.permission.WRITE_CONTACTS),
                2001
            )
        } else {
            callback(Result.success(getPermissionStatus()))
        }
    }

    fun handlePermissionResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        if (requestCode == 2001) {
            val cb = pendingPermissionCallback
            pendingPermissionCallback = null
            cb?.invoke(Result.success(getPermissionStatus()))
            return true
        }
        return false
    }

    override fun readAllContacts(callback: (Result<List<NativeContact>>) -> Unit) {
        try {
            val contactsMap = mutableMapOf<String, MutableContactBuilder>()
            val resolver = context.contentResolver

            val projection = arrayOf(
                Phone.CONTACT_ID,
                Phone.DISPLAY_NAME,
                Phone.NUMBER,
                RawContacts.ACCOUNT_NAME,
                RawContacts.ACCOUNT_TYPE
            )

            // Query Data table across all raw contacts excluding rows marked deleted (FR-PB-020)
            val cursor = resolver.query(
                Phone.CONTENT_URI,
                projection,
                null,
                null,
                "${Phone.CONTACT_ID} ASC"
            )

            cursor?.use { c ->
                val idIdx = c.getColumnIndex(Phone.CONTACT_ID)
                val nameIdx = c.getColumnIndex(Phone.DISPLAY_NAME)
                val numberIdx = c.getColumnIndex(Phone.NUMBER)
                val accNameIdx = c.getColumnIndex(RawContacts.ACCOUNT_NAME)

                while (c.moveToNext()) {
                    val contactId = if (idIdx != -1) c.getString(idIdx) else null ?: continue
                    val name = if (nameIdx != -1) c.getString(nameIdx) ?: "" else ""
                    val rawNumber = if (numberIdx != -1) c.getString(numberIdx) ?: "" else ""
                    val accountName = if (accNameIdx != -1) c.getString(accNameIdx) else null

                    val builder = contactsMap.getOrPut(contactId) {
                        MutableContactBuilder(contactId, name, accountName)
                    }
                    if (rawNumber.isNotBlank()) {
                        builder.numbers.add(rawNumber)
                    }
                }
            }

            val resultList = contactsMap.values.map { b ->
                NativeContact(
                    contactId = b.contactId,
                    displayName = b.displayName,
                    phoneNumbers = b.numbers.distinct(),
                    accountLabel = b.accountLabel
                )
            }

            callback(Result.success(resultList))
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    override fun getAvailableAccounts(callback: (Result<List<NativeAccount>>) -> Unit) {
        try {
            val accounts = mutableListOf<NativeAccount>()
            val resolver = context.contentResolver

            val projection = arrayOf(
                RawContacts.ACCOUNT_NAME,
                RawContacts.ACCOUNT_TYPE
            )

            val cursor = resolver.query(
                RawContacts.CONTENT_URI,
                projection,
                null,
                null,
                null
            )

            val seen = mutableSetOf<String>()
            cursor?.use { c ->
                val nameIdx = c.getColumnIndex(RawContacts.ACCOUNT_NAME)
                val typeIdx = c.getColumnIndex(RawContacts.ACCOUNT_TYPE)

                while (c.moveToNext()) {
                    val name = if (nameIdx != -1) c.getString(nameIdx) else null
                    val type = if (typeIdx != -1) c.getString(typeIdx) else null

                    val key = "${name ?: "local"}:${type ?: "local"}"
                    if (!seen.contains(key)) {
                        seen.add(key)
                        val isLocal = name == null || type == null || type.contains("local", ignoreCase = true)
                        val syncsToCloud = type != null && (type.contains("google", ignoreCase = true) || type.contains("cloud", ignoreCase = true))

                        accounts.add(
                            NativeAccount(
                                name = name ?: "Phone Storage (Local)",
                                type = type ?: "local",
                                isDeviceLocal = isLocal,
                                syncsToCloud = syncsToCloud
                            )
                        )
                    }
                }
            }

            if (accounts.isEmpty()) {
                accounts.add(
                    NativeAccount(
                        name = "Phone Storage",
                        type = "local",
                        isDeviceLocal = true,
                        syncsToCloud = false
                    )
                )
            }

            callback(Result.success(accounts))
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    override fun writeContactsBatch(
        candidates: List<NativeCandidate>,
        accountName: String?,
        accountType: String?,
        callback: (Result<NativeWriteResult>) -> Unit
    ) {
        val successfullyAdded = mutableListOf<String>()
        val failedCandidateIds = mutableListOf<String>()
        val createdRecordIds = mutableListOf<String>()

        try {
            val ops = ArrayList<ContentProviderOperation>()
            val candidateIndexMap = mutableMapOf<Int, String>()

            for (candidate in candidates) {
                val rawContactIndex = ops.size
                candidateIndexMap[rawContactIndex] = candidate.id

                // 1. RawContact insert
                val rawContactBuilder = ContentProviderOperation.newInsert(RawContacts.CONTENT_URI)
                if (accountName != null && accountType != null) {
                    rawContactBuilder.withValue(RawContacts.ACCOUNT_NAME, accountName)
                    rawContactBuilder.withValue(RawContacts.ACCOUNT_TYPE, accountType)
                } else {
                    rawContactBuilder.withValue(RawContacts.ACCOUNT_NAME, null)
                    rawContactBuilder.withValue(RawContacts.ACCOUNT_TYPE, null)
                }
                ops.add(rawContactBuilder.build())

                // 2. StructuredName insert
                ops.add(
                    ContentProviderOperation.newInsert(Data.CONTENT_URI)
                        .withValueBackReference(Data.RAW_CONTACT_ID, rawContactIndex)
                        .withValue(Data.MIMETYPE, StructuredName.CONTENT_ITEM_TYPE)
                        .withValue(StructuredName.DISPLAY_NAME, candidate.displayName)
                        .build()
                )

                // 3. Phone numbers insert
                for (number in candidate.numbers) {
                    if (!number.isNullOrBlank()) {
                        ops.add(
                            ContentProviderOperation.newInsert(Data.CONTENT_URI)
                                .withValueBackReference(Data.RAW_CONTACT_ID, rawContactIndex)
                                .withValue(Data.MIMETYPE, Phone.CONTENT_ITEM_TYPE)
                                .withValue(Phone.NUMBER, number)
                                .withValue(Phone.TYPE, Phone.TYPE_MOBILE)
                                .build()
                        )
                    }
                }
            }

            // Apply batch (FR-WR-020)
            val results = context.contentResolver.applyBatch(ContactsContract.AUTHORITY, ops)

            for ((index, candidateId) in candidateIndexMap) {
                if (index < results.size) {
                    val resUri: Uri? = results[index].uri
                    if (resUri != null) {
                        val recordId = ContentUris.parseId(resUri).toString()
                        successfullyAdded.add(candidateId)
                        createdRecordIds.add(recordId)
                    } else {
                        failedCandidateIds.add(candidateId)
                    }
                }
            }

            callback(
                Result.success(
                    NativeWriteResult(
                        successfullyAddedIds = successfullyAdded,
                        failedCandidateIds = failedCandidateIds,
                        createdRecordIds = createdRecordIds
                    )
                )
            )
        } catch (e: Exception) {
            // If batch fails, report failure
            callback(
                Result.success(
                    NativeWriteResult(
                        successfullyAddedIds = emptyList(),
                        failedCandidateIds = candidates.map { it.id },
                        createdRecordIds = emptyList()
                    )
                )
            )
        }
    }

    override fun undoCreatedContacts(
        recordIds: List<String>,
        callback: (Result<Long>) -> Unit
    ) {
        try {
            var deletedCount = 0L
            val resolver = context.contentResolver

            // Deletes ONLY records created in this run, identified by IDs held in RAM (INV-04a, FR-WR-040)
            for (id in recordIds) {
                val uri = ContentUris.withAppendedId(RawContacts.CONTENT_URI, id.toLong())
                val count = resolver.delete(uri, null, null)
                deletedCount += count
            }

            callback(Result.success(deletedCount))
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    private data class MutableContactBuilder(
        val contactId: String,
        val displayName: String,
        val accountLabel: String?,
        val numbers: MutableList<String> = mutableListOf()
    )
}
