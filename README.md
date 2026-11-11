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
512CCC823AB78BF63D0C20FA8161888254327D272BF0B3791DED9E7E93CC625E  telsync-v1.0.2-arm64-v8a.apk
99C12A7F3D35A0C18F66966C42EB8BF56E3B4349D13BFF0EF67AC9D045858E4E  telsync-v1.0.2-armeabi-v7a.apk
4DCBE55C59962E89A93F94B1B81772960DB91F86CF9A4BF9882EE98712B61E11  telsync-v1.0.2-x86_64.apk
22DE3047963E859FD64B1ACDD47E7651ED9F962E8BCA7200096B3EFB5CA77B8C  telsync-v1.0.2-universal.apk
C5A45B63DAC759307C5FE311C5389D86C0D05AAFC45BF4FD99B94325914CECCB  telsync-v1.0.2-ios-unsigned.ipa
```

---

## 🔒 Security & Privacy Principles

TelSync is engineered with zero-trust privacy foundations:
1. **Zero Intermediate Servers:** Data strictly flows between your device and official Telegram datacenter IP addresses through MTProto.
2. **Strict Network Security:** Global cleartext (unencrypted HTTP) communication is completely disabled via Android `network_security_config.xml`.
3. **RAM-Only Encryption Keys:** TDLib databases use high-entropy random keys generated on device startup and purged immediately when finished.
4. **No Telemetry / No Crashlytics:** We do not track user activity, phone numbers, or analytics. Your address book remains strictly yours.

---

## 💡 How to Sync Telegram Contacts to Phone (3 Simple Steps)

1. **Install TelSync:**  
   Download the APK matching your device from the [Direct Downloads](#-direct-downloads) section above.
2. **Connect Securely to Telegram:**  
   Sign in with your phone number or scan the QR code via your official Telegram app (direct peer connection to Telegram servers).
3. **Review & Import to Phonebook:**  
   TelSync compares Telegram contacts with your phone's address book and highlights new numbers. Tap **Import** to add them to your phonebook, after which your session is automatically logged out.

---

## ❓ Frequently Asked Questions (FAQ)

<details>
<summary><strong>1. How do I transfer or export Telegram contacts to Android or iPhone?</strong></summary>

Telegram does not have an official native button to bulk-export contacts into your phone's address book. **TelSync** solves this by connecting directly to Telegram via TDLib, matching contacts on-device, and safely saving them straight into your phone's native address book without needing a computer or third-party web services.
</details>

<details>
<summary><strong>2. Will TelSync modify or delete any existing contacts on my phone?</strong></summary>

**Never.** In TelSync, your phonebook is the absolute source of truth. The application never alters or deletes existing contacts; it only adds new, missing contacts that you choose to import.
</details>

<details>
<summary><strong>3. How does it prevent duplicate contacts?</strong></summary>

TelSync features an intelligent phone normalizer that standardizes international prefixes (such as `09xx`, `+98`, `+1`) into uniform E.164 formats. If a person is already in your phone contacts, it detects the match and prevents duplicate entries.
</details>

<details>
<summary><strong>4. Does TelSync have access to my private chats, messages, or channels?</strong></summary>

**No.** TelSync is 100% open source. The client operates under a strict TDLib method allowlist that is restricted exclusively to contact queries (`getContacts`). It has zero access to private messages, chat logs, media, or channels.
</details>

<details>
<summary><strong>5. Are phone numbers uploaded to any external server?</strong></summary>

**No.** TelSync does not operate any backend server, cloud database, or tracking service. All processing happens locally in device RAM and all temporary session keys are immediately wiped upon exit.
</details>

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

