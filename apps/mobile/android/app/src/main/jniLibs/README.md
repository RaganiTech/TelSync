# TDLib Native Binaries for Android (libtdjson.so)

To run the application with live Telegram MTProto connections on real Android devices or emulators, the official C++ compiled `libtdjson.so` binaries must be placed in their respective architecture folders:

- `arm64-v8a/libtdjson.so` (Modern 64-bit Android devices - most common)
- `armeabi-v7a/libtdjson.so` (Older 32-bit ARM devices)
- `x86_64/libtdjson.so` (Android Studio x86_64 Emulators)

### Acquiring Pre-built `libtdjson.so`:
You can:
1. Build from source following official instructions: https://tdlib.github.io/td/build.html?language=Java
2. Or use pre-built binary releases from `tdlib/td` releases.
3. Run `tools/setup_tdlib_binaries.ps1` to place mock or downloaded binaries.
