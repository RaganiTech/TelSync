# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Pigeon host APIs and data transfer objects
-keep class com.contactbridge.sink_phonebook.** { *; }

# TDLib JNI bindings and native libraries
-keep class org.drinkless.tdlib.** { *; }
-keepclasseswithmembernames class * {
    native <methods>;
}

# Play Core split install deferred components (suppress unused R8 warnings)
-dontwarn com.google.android.play.core.**

# Tapsell Mediation Proguard Rules
-keep class ir.tapsell.mediation.** { *; }
-dontwarn ir.tapsell.mediation.**
-keep class ir.tapsell.sdk.** { *; }
-dontwarn ir.tapsell.sdk.**
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Room/WorkManager Proguard Rules (fix crash: WorkDatabase_Impl stripped by R8)
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
-keep class androidx.room.** { *; }
-keepclassmembers class * extends androidx.room.RoomDatabase { *; }
-keep @androidx.room.Entity class * { *; }
-keep @androidx.room.Dao interface * { *; }
-keepclassmembers class * {
    @androidx.room.* *;
}

