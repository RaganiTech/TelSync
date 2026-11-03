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
