package com.contactbridge.sink_phonebook

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry

class SinkPhonebookPlugin : FlutterPlugin, ActivityAware, PluginRegistry.RequestPermissionsResultListener {
    private var hostApiImpl: ContactsHostApiImpl? = null
    private var activityBinding: ActivityPluginBinding? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val impl = ContactsHostApiImpl(binding.applicationContext)
        hostApiImpl = impl
        ContactsHostApi.setUp(binding.binaryMessenger, impl)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        ContactsHostApi.setUp(binding.binaryMessenger, null)
        hostApiImpl = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        hostApiImpl?.currentActivity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activityBinding?.removeRequestPermissionsResultListener(this)
        activityBinding = null
        hostApiImpl?.currentActivity = null
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        return hostApiImpl?.handlePermissionResult(requestCode, permissions, grantResults) ?: false
    }
}
