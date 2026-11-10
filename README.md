<div align="center" dir="ltr">

[**🇮🇷 فارسی (Persian)**](README_fa.md) / [**🇺🇸 English**](README.md)

</div>

<br>

<p align="center">
  <img src="docs/assets/logo.png" width="130" alt="TelSync Logo" style="border-radius: 26px;" />
</p>

<h1 align="center">TelSync (تلسینک)</h1>

<p align="center">
  <strong>Fast, private, and 100% on-device sync between Telegram contacts and your phone's address book.</strong>
</p>

<div align="center">

[![Latest Release](https://img.shields.io/badge/Release-v1.0.2-34D399.svg?style=flat-square&logo=github)](https://github.com/RaganiTech/TelSync/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-3B82F6.svg?style=flat-square)](LICENSE)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.24+-02569B.svg?style=flat-square&logo=flutter)](https://flutter.dev)
[![Privacy](https://img.shields.io/badge/Privacy-100%25%20On--Device-success?style=flat-square)](#-security--privacy-principles)
[![Crafted with AI](https://img.shields.io/badge/Crafted%20with-AI%20Assisted-8A2BE2.svg?style=flat-square&logo=openai&logoColor=white)](#-acknowledgements--credits)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-orange?style=flat-square)](#-direct-downloads)
[![Donate Reymit](https://img.shields.io/badge/Donate-Reymit-FF5722.svg?style=flat-square&logo=coffeescript&logoColor=white)](https://reymit.ir/raganitech)
[![Donate USDT](https://img.shields.io/badge/Donate-USDT-26A17B.svg?style=flat-square&logo=tether&logoColor=white)](#-3-crypto-wallets-tether-usdt)

</div>

---

## 📖 What is TelSync?

**TelSync** is a modern, privacy-first mobile application built with Flutter that bridges your Telegram contacts directly with your smartphone's native address book (Android Contacts / iOS Contacts).

Unlike other converters or unsafe third-party apps that upload your sensitive contact book to unknown cloud servers, **TelSync operates entirely on your physical device**:
- **No external middleman servers:** All communication takes place solely between your phone and official Telegram MTProto endpoints (`telegram.org`) via TDLib.
- **Smart Duplicate Prevention:** Normalizes domestic and international phone numbers (e.g. `09xx`, `+989xx`, E.164 standard) to ensure existing contacts are safely merged without cluttering your phonebook.
- **Instant Transient Cleanup:** Temporary session tokens and in-memory databases are completely wiped as soon as your sync is complete.

---

## 🚀 Key Features

- 🛡️ **100% On-Device & Zero Middleman Servers:** No backend servers, no analytics trackers, no data logging. Pure end-to-end device execution.
- ⚡ **Smart Phone Normalizer & Deduplication Engine:** Recognizes local prefix variants (`09xx`, `0098`, `+98`) and standardizes numbers into E.164. Safely flags conflicts before writing to phone storage.
- 📲 **High-Performance Native Batch Sync:** Employs high-speed native platform channels (Type-safe Pigeon) for smooth batch insertions into Android Contacts Provider and iOS Contacts Framework.
- 🔐 **Privacy Protection System:**
  - **Screen Guard (`FLAG_SECURE`):** Prevents accidental screenshots or screen recording during sensitive authentication steps on Android.
  - **App Switcher Privacy Shield:** Blurs application content on iOS when task switching to protect phone numbers from shoulder surfing.
- 🌙 **Adaptive Modern UI & Vazirmatn Typography:** Responsive interface equipped with dynamic light/dark themes and bundled with Saber Rastikerdar's beautiful [Vazirmatn](https://github.com/rastikerdar/vazirmatn) font.
- 🌐 **Full Bilingual Support:** Native, polished Persian (فارسی) and English (US) translations.
- 🤖 **AI-Assisted Craftsmanship:** Architected, coded, and rigorously tested with advanced AI pair programming, applying Clean Architecture and zero-trust security standards.
- 📴 **100% Free & Open Source:** Ad-free, no subscription barriers, no locked features. Supported entirely by voluntary coffee donations.

---

## 📥 Direct Downloads

Download the pre-compiled production release for your device architecture:

<div align="center">

| Architecture / پلتفرم | Package / فایل نصبی (v1.0.2) | Target Devices / دستگاه‌های سازگار |
| :--- | :--- | :--- |
| **Android 64-bit** *(Recommended)* | [![Download ARM64](https://img.shields.io/badge/Download-APK%20(arm64--v8a)-168039?style=for-the-badge&logo=android)](https://github.com/RaganiTech/TelSync/releases/download/v1.0.2/telsync-v1.0.2-arm64-v8a.apk) | Modern smartphones (Samsung, Xiaomi, Pixel, OnePlus, Honor, etc.) |
| **Android 32-bit** | [![Download ARMv7](https://img.shields.io/badge/Download-APK%20(armeabi--v7a)-45bf55?style=for-the-badge&logo=android)](https://github.com/RaganiTech/TelSync/releases/download/v1.0.2/telsync-v1.0.2-armeabi-v7a.apk) | Legacy or budget 32-bit Android phones |
| **Intel / AMD 64-bit** | [![Download x86_64](https://img.shields.io/badge/Download-APK%20(x86__64)-2d7d9a?style=for-the-badge&logo=android)](https://github.com/RaganiTech/TelSync/releases/download/v1.0.2/telsync-v1.0.2-x86_64.apk) | Android Emulators (Android Studio, LDPlayer, Bluestacks) & Chromebooks |
| **Universal (All-in-one)** | [![Download Universal](https://img.shields.io/badge/Download-Universal%20APK-044d29?style=for-the-badge&logo=android)](https://github.com/RaganiTech/TelSync/releases/download/v1.0.2/telsync-v1.0.2-universal.apk) | Universal package compatible with all Android devices (larger size) |
| **iOS (Experimental)** | [![Download IPA](https://img.shields.io/badge/Download-IPA%20(Unsigned)-000000?style=for-the-badge&logo=apple)](https://github.com/RaganiTech/TelSync/releases/download/v1.0.2/telsync-v1.0.2-ios-unsigned.ipa) | iPhone / iPad (iOS 16.0+) via Sideloadly, AltStore, TrollStore, or personal certificate |

</div>

> 💡 **Quick Tip:** If you are unsure which version to pick, choose **`arm64-v8a`** for any modern phone purchased in the last 6 years, or **`universal`** for guaranteed compatibility on any phone.

> [!WARNING]
> **iOS Build Status (Experimental & Untested on Physical Hardware):**  
> The iOS `.ipa` package is built via GitHub Actions CI/CD on macOS runners with native Swift Pigeon bindings and TDLib CocoaPods. Because the maintainer develops on Windows, the iOS build has not yet undergone comprehensive physical device testing. Community testing, bug reports, and PRs are warmly welcome!

### 🔐 Package Integrity (SHA-256 Checksums)

```text
0816E33E78BF5F4D959388D2591DF39CEA95D418C3BC58E72C001D15545E3B8A  telsync-v1.0.2-arm64-v8a.apk
1FBE5E66DBED0E895F1201C4E721D9149EFC9CA47879DC7F07067C26DE6A52FB  telsync-v1.0.2-armeabi-v7a.apk
BD91BFB8C422A71BBB1B8E56C5D7EEBDAC88E5ABEF0E2C171B9AEC662BA1AB1E  telsync-v1.0.2-x86_64.apk
36F31697D468377E247A9C17D51CE89B630A1FD22392804463F78165F0265BED  telsync-v1.0.2-universal.apk
```

---

## 🔒 Security & Privacy Principles

TelSync is engineered with zero-trust privacy foundations:
1. **Zero Intermediate Servers:** Data strictly flows between your device and official Telegram datacenter IP addresses through MTProto.
2. **Strict Network Security:** Global cleartext (unencrypted HTTP) communication is completely disabled via Android `network_security_config.xml`.
3. **RAM-Only Encryption Keys:** TDLib databases use high-entropy random keys generated on device startup and purged immediately when finished.
4. **No Telemetry / No Crashlytics:** We do not track user activity, phone numbers, or analytics. Your address book remains strictly yours.

---

## 🛠️ Building From Source

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.24.0`)
- Android SDK (API 29+) & JDK 17
- Git

### Build Steps
```bash
# 1. Clone repository
git clone https://github.com/RaganiTech/TelSync.git
cd TelSync

# 2. Get dependencies & run unit tests
cd apps/mobile
flutter pub get
flutter test

# 3. Run in debug mode
flutter run

# 4. Build split release APKs
flutter build apk --release --split-per-abi
```

---

## ☕ Support & Donations

TelSync is developed and maintained as an independent open-source project. If TelSync saved your time or helped you sync your contacts effortlessly, you can support its ongoing development:

### 🌟 1. Star the Repository
Giving a **Star (⭐)** at the top right of this GitHub page helps other users find this project!

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=RaganiTech/TelSync&type=Date)](https://star-history.com/#RaganiTech/TelSync&Date)

</div>

### ☕ 2. Rial Donation (Reymit / Coffee)
You can support the developer directly using Iranian debit cards via **Reymit**:
<p align="center">
  <a href="https://reymit.ir/raganitech" target="_blank">
    <img src="https://img.shields.io/badge/Donate-Reymit.ir%2Fraganitech-FF5722?style=for-the-badge&logo=coffeescript&logoColor=white" alt="Donate via Reymit" height="45" style="border-radius: 8px;" />
  </a>
</p>

### 🪙 3. Crypto Wallets (Tether USDT)
You can support development internationally using **Tether (USDT)** via Trust Wallet:

| Cryptocurrency / Network | Address |
| :--- | :--- |
| **USDT (Tron / TRC-20)** *(Most Common · All Exchanges)* | `TVxmYBhxAwUrrg8WxqJH1CaMxuVG5c1Hgp` |
| **USDT (BNB Smart Chain / BEP-20)** *(Lowest Fees)* | `0x9529b9c712E306Eaed6c852e93239499CEA973db` |
| **USDT (Ethereum / ERC-20 & Polygon)** | `0x9529b9c712E306Eaed6c852e93239499CEA973db` |

---

## ✏️ Acknowledgements & Credits

We extend our deepest gratitude to the open-source projects and authors whose work makes TelSync possible:
- [Telegram Team & TDLib](https://core.telegram.org/tdlib) - The official Telegram Database Library.
- [Flutter](https://flutter.dev) - Google's cross-platform UI framework.
- [Vazirmatn Font](https://github.com/rastikerdar/vazirmatn) - The elegant Persian typography by the late Saber Rastikerdar.
- [Riverpod](https://riverpod.dev) - Reactive state management architecture.
- [Pigeon](https://pub.dev/packages/pigeon) - Type-safe native platform channels generator.
- [AI Coding Assistance](https://deepmind.google) - Architected and pair-programmed with AI assistance.

---

## 👥 Contributors

Thanks to everyone contributing to TelSync!

<p align="center">
  <a href="https://github.com/RaganiTech/TelSync/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=RaganiTech/TelSync" />
  </a>
</p>

<p align="center">
  Made with ❤️ for privacy and the open-source community.
</p>

