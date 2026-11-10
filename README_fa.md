<div align="center" dir="ltr">

[**🇺🇸 English**](README.md) / [**🇮🇷 فارسی**](README_fa.md)

</div>

<br>

<p align="center">
  <img src="docs/assets/logo.png" width="130" alt="لوگوی تلسینک" style="border-radius: 26px;" />
</p>

<h1 align="center">تلسینک (TelSync)</h1>

<p align="center">
  <strong>انتقال امن، سریع و کاملاً آفلاین (On-Device) مخاطبین تلگرام به دفترچه تلفن گوشی</strong>
</p>

<div align="center">

[![Latest Release](https://img.shields.io/badge/Release-v1.0.2-34D399.svg?style=flat-square&logo=github)](https://github.com/alireza00138300/TelSync/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-3B82F6.svg?style=flat-square)](LICENSE)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.24+-02569B.svg?style=flat-square&logo=flutter)](https://flutter.dev)
[![حریم خصوصی](https://img.shields.io/badge/%D8%AD%D8%B1%DB%8C%D9%85%20%D8%AE%D8%B5%D9%88%D8%B5%DB%8C-%DB%B1%DB%B0%DB%B0%D9%AA%20%D9%85%D8%AD%D9%84%DB%8C-success?style=flat-square)](#-امنیت-و-حفظ-حریم-خصوصی)
[![پلتفرم](https://img.shields.io/badge/%D9%BE%D9%84%D8%AA%D9%81%D8%B1%D9%85-%D8%A7%D9%86%D8%AF%D8%B1%D9%88%DB%8C%D8%AF%20%7C%20iOS-orange?style=flat-square)](#-دانلود-مستقیم)
[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-FFDD00.svg?style=flat-square&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/alireza)

</div>

---

<div dir="rtl">

## 📖 تلسینک چیست؟

**تلسینک (TelSync)** یک اپلیکیشن موبایل مدرن، متن‌باز (Open Source) و متمرکز بر حریم خصوصی است که مخاطبین حساب تلگرام شما را به صورت مستقیم و بدون نیاز به هیچ‌گونه سرور واسط در دفترچه تلفن گوشی شما (Android Contacts / iOS Contacts) ذخیره و همگام‌سازی می‌کند.

برخلاف ربات‌ها، سایت‌ها یا اپلیکیشن‌های غیررسمی که دفترچه تلفن شما را به سرورهای ناشناس ابری ارسال می‌کنند، **تلسینک تمام عملیات را ۱۰۰٪ روی سخت‌افزار گوشی شما انجام می‌دهد**:
- **بدون هیچ سرور واسط:** ارتباط به صورت مستقیم از طریق پروتکل رسمی MTProto و کتابخانه استاندارد TDLib تنها با سرورهای تلگرام (`telegram.org`) صورت می‌گیرد.
- **جلوگیری از ایجاد مخاطبین تکراری:** با نرمال‌سازی هوشمند پیش‌شماره‌های ایران (`09xx`، `+989xx`، `00989xx`) و شماره‌های بین‌المللی، مخاطبین تکراری شناسایی شده و قابلیت ادغام یا نگه‌داری نسخه قبلی در اختیار شما قرار می‌گیرد.
- **پاک‌سازی فوری سشن‌ها:** دیتابیس‌های موقت رمزنگاری‌شده و سشن‌ها بلافاصله پس از اتمام همگام‌سازی یا فشردن دکمه خروج به طور کامل از حافظه پاک (Wipe) می‌شوند.

---

## 🚀 امکانات و قابلیت‌های اصلی

- 🛡️ **۱۰۰٪ محلی و بدون سرور واسط:** بدون هیچ سرور جانبی، بدون ردیاب آماری و بدون دسترسی شخص ثالث.
- ⚡ **موتور تطبیق و یکسان‌سازی هوشمند:** تشخیص هوشمند شماره‌های موبایل ایران و استانداردهای جهانی (E.164) و ادغام بدون خطای مخاطبین.
- 📲 **همگام‌سازی پرسرعت نیتیو (Batch Sync):** انتقال دسته‌ای و مستقیم از طریق کانال‌های نیتیو تایپ‌سیف به ارائه‌دهنده مخاطبین اندروید و فریم‌ورک Contacts در iOS.
- 🔐 **سپر محافظتی امنیتی:**
  - **محافظت از صفحه (`FLAG_SECURE`):** مسدودسازی خودکار اسکرین‌شات و ضبط صفحه در زمان ورود و احراز هویت.
  - **بلور شیلد در سوییچر اپ‌ها:** مات شدن صفحه اپلیکیشن در سوییچر iOS جهت پنهان‌سازی شماره‌های خصوصی از دید اطرافیان.
- 🌙 **طراحی مدرن با فونت چشم‌نواز وزیرمتن:** پشتیبانی کامل از حالت تاریک (Dark Mode) و روشن (Light Mode) با تایپوگرافی زیبای فونت وزیرمتن زنده‌یاد صابر راستی‌کردار.
- 🌐 **پشتیبانی کامل دوزبانه:** ترجمه روان و بی‌نقص فارسی و انگلیسی.
- 📴 **کاملاً رایگان، بدون تبلیغات و اپن سورس:** بدون هیچ‌گونه تبلیغات مزاحم یا پلن‌های پولی، با مدل حمایتی داوطلبانه خرید قهوه.

---

## 📥 دانلود مستقیم

نسخه مناسب پردازنده گوشی خود را به صورت مستقیم دریافت نمایید:

</div>

<div align="center">

| معماری پردازنده / پلتفرم | فایل نصبی / Package (v1.0.2) | گوشی‌ها و دستگاه‌های سازگار |
| :--- | :--- | :--- |
| **اندروید ۶۴ بیتی** *(پیشنهادی)* | [![دانلود ARM64](https://img.shields.io/badge/Download-APK%20(arm64--v8a)-168039?style=for-the-badge&logo=android)](https://github.com/alireza00138300/TelSync/releases/download/v1.0.2/telsync-v1.0.2-arm64-v8a.apk) | تمام گوشی‌های مدرن چند سال اخیر (سامسونگ، شیائومی، پیکسل، هواوی و...) |
| **اندروید ۳۲ بیتی** | [![دانلود ARMv7](https://img.shields.io/badge/Download-APK%20(armeabi--v7a)-45bf55?style=for-the-badge&logo=android)](https://github.com/alireza00138300/TelSync/releases/download/v1.0.2/telsync-v1.0.2-armeabi-v7a.apk) | گوشی‌های قدیمی‌تر یا اقتصادی ۳۲ بیتی |
| **اینتل و شبیه‌سازها** | [![دانلود x86_64](https://img.shields.io/badge/Download-APK%20(x86__64)-2d7d9a?style=for-the-badge&logo=android)](https://github.com/alireza00138300/TelSync/releases/download/v1.0.2/telsync-v1.0.2-x86_64.apk) | شبیه‌سازهای اندروید روی کامپیوتر (Bluestacks, LDPlayer, Android Studio) |
| **بسته جامع (یونیورسال)** | [![دانلود Universal](https://img.shields.io/badge/Download-Universal%20APK-044d29?style=for-the-badge&logo=android)](https://github.com/alireza00138300/TelSync/releases/download/v1.0.2/telsync-v1.0.2-universal.apk) | شامل تمام معماری‌ها (سازگار با همه گوشی‌ها، اما با حجم بیشتر) |
| **نسخه آیفون / iOS (آزمایشی)** | [![دانلود IPA](https://img.shields.io/badge/Download-IPA%20(Unsigned)-000000?style=for-the-badge&logo=apple)](https://github.com/alireza00138300/TelSync/releases/download/v1.0.2/telsync-v1.0.2-ios-unsigned.ipa) | آیفون و آیپد (iOS 16.0+) نصب از طریق TrollStore ،AltStore ،Sideloadly یا گواهی شخصی |

</div>

<div dir="rtl">

> 💡 **راهنمای سریع:** اگر مدل پردازنده گوشی خود را نمی‌دانید، فایل **`arm64-v8a`** را دانلود کنید (برای تمام گوشی‌های جدید مناسب است) یا در صورت عدم اطمینان نسخه **`universal`** را نصب فرمایید.

> [!WARNING]
> **وضعیت نسخه iOS (آزمایشی و بدون تست روی دستگاه فیزیکی):**  
> فایل نصبی iOS (`.ipa`) به شکل خودکار و از طریق پایپ‌لاین ابری GitHub Actions روی سرورهای macOS به همراه کدهای سوئیفت و TDLib کامپایل و آماده‌سازی شده است. با توجه به اینکه توسعه در محیط ویندوز انجام گرفته، این نسخه روی دستگاه فیزیکی آیفون توسط توسعه‌دهنده تست میدانی نشده است. گزارش باگ‌ها و بازخوردهای جامعه کاربران iOS با آغوش باز پذیرفته می‌شود!

### 🔐 اعتبارسنجی بسته‌ها (کدهای هش SHA-256)

جهت اطمینان از سلامت فایل‌های دانلود شده:

```text
0816E33E78BF5F4D959388D2591DF39CEA95D418C3BC58E72C001D15545E3B8A  telsync-v1.0.2-arm64-v8a.apk
1FBE5E66DBED0E895F1201C4E721D9149EFC9CA47879DC7F07067C26DE6A52FB  telsync-v1.0.2-armeabi-v7a.apk
BD91BFB8C422A71BBB1B8E56C5D7EEBDAC88E5ABEF0E2C171B9AEC662BA1AB1E  telsync-v1.0.2-x86_64.apk
36F31697D468377E247A9C17D51CE89B630A1FD22392804463F78165F0265BED  telsync-v1.0.2-universal.apk
```

---

## 🔒 امنیت و حفظ حریم خصوصی

اصول بنیادین امنیت در تلسینک بر پایه مدل بی‌اعتمادی (Zero Trust) بنا شده است:
1. **بدون سرور میانی:** تبادل اطلاعات صرفاً میان دستگاه شما و آی‌پی‌های رسمی تلگرام انجام می‌شود.
2. **غیرفعال‌سازی ترافیک ناامن (Cleartext):** ارسال هرگونه ترافیک متنی غیررمزنگاری‌شده از طریق فایل امنیتی اندروید به صورت سیستمی مسدود شده است.
3. **کلیدهای رمزنگاری در حافظه موقت:** دیتابیس‌های TDLib با کلیدهای رندوم با آنتروپی بالا رمزگذاری شده و پس از پایان کار پاکسازی می‌شوند.
4. **عدم ذخیره لاگ یا شماره تلفن‌ها:** هیچ سابقه‌ای از شماره‌ها یا اطلاعات شخصی در هیچ دیتابیس دائمی ذخیره نمی‌شود.

---

## 🛠️ کامپایل از روی سورس کد

### پیش‌نیازها:
- [Flutter SDK](https://flutter.dev) (نسخه `3.24.0` یا بالاتر)
- Android SDK (حداقل API 29) و JDK 17
- نرم‌افزار Git

### مراحل اجرا:
```bash
# ۱. کلون کردن مخزن
git clone https://github.com/alireza00138300/TelSync.git
cd TelSync

# ۲. دریافت پکیج‌ها و اجرای تست‌ها
cd apps/mobile
flutter pub get
flutter test

# ۳. اجرای آزمایشی روی گوشی یا شبیه‌ساز
flutter run

# ۴. تولید فایل‌های نصبی تفکیک‌شده
flutter build apk --release --split-per-abi
```

---

## ☕ حمایت مالی و دونیت (Donation)

تلسینک به عنوان یک پروژه مستقل و آزاد توسعه یافته است. در صورتی که این برنامه برای شما کاربردی بوده و از آن راضی هستید، می‌توانید با روش‌های زیر از توسعه‌دهنده حمایت کنید:

### 🌟 ۱. ستاره دادن به مخزن (Star)
ساده‌ترین و بزرگ‌ترین حمایت، زدن دکمه **ستاره (⭐ Star)** در بالای همین صفحه گیت‌هاب است که باعث دیده‌شدن پروژه در جامعه کاربری می‌شود.

</div>

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=alireza00138300/TelSync&type=Date)](https://star-history.com/#alireza00138300/TelSync&Date)

</div>

<div dir="rtl">

### ☕ ۲. خرید قهوه برای توسعه‌دهنده (Buy Me a Coffee)
می‌توانید از طریق پلتفرم Buy Me a Coffee برای توسعه‌دهنده قهوه تهیه کنید:

</div>

<p align="center">
  <a href="https://buymeacoffee.com/alireza" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="خرید قهوه برای توسعه دهنده" height="50" style="border-radius: 8px;" />
  </a>
</p>

<div dir="rtl">

### 🪙 ۳. کیف‌پول‌های ارز دیجیتال (Crypto Wallets)
امکان دونیت از طریق رمزارزها نیز فراهم است:

| شبکه و رمزارز | آدرس کیف‌پول |
| :--- | :--- |
| **تتر بر بستر ترون (USDT - TRC20)** | `TYsC1h8wN2dF9kQ4eXp7mVbZ3aL6jR5u1T` |
| **تون / ولت تلگرام (TON)** | `EQBvW8Z5huBkMJYdnF64PT5qJyVcCFK5nE48VnMaD-88Tels` |
| **بیت‌کوین (BTC)** | `bc1q9u8x2c4v7m0s6l4d5w3k1j8h6g2f9a7z0e5p` |

---

## ✏️ تقدیر و تشکر از پروژه‌های مادر

از سازندگان و نگه‌دارندگان پروژه‌های متن‌باز زیر صمیمانه سپاسگزاریم:
- [تیم تلگرام و کتابخانه TDLib](https://core.telegram.org/tdlib) - کتابخانه مرجع پایگاه داده تلگرام.
- [فریم‌ورک فلاتر (Flutter)](https://flutter.dev) - فریم‌ورک قدرتمند چندسکویی گوگل.
- [فونت وزیرمتن اثر صابر راستی‌کردار](https://github.com/rastikerdar/vazirmatn) - تایپوگرافی اصیل و زیبای فارسی.
- [ریورپاد (Riverpod)](https://riverpod.dev) - مدیریت واکنش‌گرای وضعیت.
- [پیجن (Pigeon)](https://pub.dev/packages/pigeon) - سازنده کانال‌های نیتیو پلتفرم.

---

## 👥 مشارکت‌کنندگان

با تشکر از تمام کسانی که به پیشبرد تلسینک کمک می‌کنند!

</div>

<p align="center">
  <a href="https://github.com/alireza00138300/TelSync/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=alireza00138300/TelSync" />
  </a>
</p>

<p align="center">
  ساخته‌شده با ❤️ برای ارتقای امنیت، حریم خصوصی و جامعه متن‌باز
</p>
