package com.contactbridge.sink_phonebook

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class SinkPhonebookPlugin : FlutterPlugin, ActivityAware {
    private var hostApiImpl: ContactsHostApiImpl? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val impl = ContactsHostApiImpl(binding.applicationContext)
        hostApiImpl = impl
        ContactsHostApi.setUp(binding.binaryMessenger, impl)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        ContactsHostApi.setUp(binding.binaryMessenger, null)
        hostApiImpl = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {}
    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
    override fun onDetachedFromActivity() {}
}
