package com.contactbridge.mobile

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    companion object {
        init {
            try {
                System.loadLibrary("tdjson")
            } catch (e: Throwable) {
                android.util.Log.e("MainActivity", "TDLib native library load notice: ${e.message}")
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // NFR-SEC-010: Protect contacts and auth credentials from screenshot/screen recording and recent tasks preview
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )
    }
}
