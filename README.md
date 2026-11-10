<p align="center">
  <img src="apps/mobile/assets/images/logo.png" width="110" alt="TelSync Logo" style="border-radius: 24px;" />
</p>

<h1 align="center">TelSync (تلسینک) 📱✨</h1>

<p align="center">
  <b>انتقال امن، مستقیم و ۱۰۰٪ محلی مخاطبین تلگرام به دفترچه تلفن گوشی</b><br />
  <i>The fast, private, and 100% on-device Telegram contacts sync utility for Android & iOS.</i>
</p>

<p align="center">
  <a href="#-فارسی">فارسی</a> •
  <a href="#-english">English</a> •
  <a href="#-دانلود-و-نصب--downloads">دانلود (Downloads)</a> •
  <a href="#-ویژگی‌های-کلیدی--key-features">ویژگی‌ها (Features)</a> •
  <a href="#-امنیت-و-حریم-خصوصی--security--privacy">امنیت (Security)</a> •
  <a href="#-راهنمای-بیلد--build-guide">بیلد (Build)</a> •
  <a href="#-حمایت-مالی--donate">حمایت (Donate)</a>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square" alt="License: MIT" /></a>
  <a href="https://github.com/alireza00138300/TelSync/releases"><img src="https://img.shields.io/badge/Release-v1.0.2-brightgreen.svg?style=flat-square" alt="Latest Release" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.24+-02569B.svg?style=flat-square&logo=flutter" alt="Flutter" /></a>
  <img src="https://img.shields.io/badge/Privacy-100%25%20On--Device-success?style=flat-square" alt="Privacy" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-orange?style=flat-square" alt="Platform" />
  <a href="https://buymeacoffee.com/alireza"><img src="https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-ffdd00.svg?style=flat-square&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee" /></a>
</p>

---

## 🇮🇷 فارسی

**تلسینک (TelSync)** یک ابزار سبک، سریع و کاملاً متن‌باز (Open Source) است که به شما امکان می‌دهد شماره‌ها و مخاطبین حساب تلگرام خود را مستقیماً، امن و بدون واسطه به دفترچه تلفن گوشی‌تان اضافه کنید.

بسیاری از کاربران سال‌هاست مخاطبین کاری و دوستان خود را در تلگرام ذخیره کرده‌اند، اما شماره تلفن آن‌ها در دفترچه تلفن گوشی ثبت نشده است. تلسینک این مشکل را بدون ارسال حتی یک بایت داده به سرورهای واسط و با حفظ ۱۰۰ درصدی حریم خصوصی شما حل می‌کند.

---

## 🇬🇧 English

**TelSync** is a lightweight, high-performance, and 100% open-source mobile utility built with Flutter and official Telegram TDLib native binaries. It bridges your Telegram contacts directly into your device's address book with zero intermediary servers, zero cloud tracking, and strict cryptographic safeguards.

---

## 🌟 ویژگی‌های کلیدی / Key Features

| قابلیت / Feature | توضیحات فارسی | English Description |
|---|---|---|
| 🔒 **پردازش ۱۰۰٪ محلی (On-Device)** | تمامی مراحل اتصال، مقایسه شماره‌ها و افزودن مخاطبین مستقیماً روی سخت‌افزار گوشی شما انجام می‌شود. | All MTProto handshakes, number matching, and address book sync execute strictly on your device. |
| 🛡️ **دست‌نخورده ماندن مخاطبین (Safe Merge)** | تلسینک به هیچ عنوان مخاطبین موجود در گوشی شما را حذف یا ویرایش نمی‌کند. فقط شماره‌های جدید افزوده می‌شوند. | Existing contacts are completely immutable; only missing Telegram contacts are imported. |
| 🧹 **خروج خودکار و پاکسازی نشست (Auto-Wipe)** | در پایان عملیات، نشست تلگرام به صورت سروری Logout شده و تمامی کلیدها و پایگاه‌داده محلی پاکسازی می‌شوند. | Automatically signs out from Telegram servers and zeroes out local SQLite cache upon completion. |
| ⚡ **محدودسازی سخت‌گیرانه (Strict Allowlist)** | هسته برنامه صرفاً مجاز به خواندن متدهای مخاطبین است و دسترسی به پیام‌ها، چت‌ها، گروه‌ها و فایل‌ها به صورت ساختاری ناممکن است. | TDLib methods are structurally constrained by a strict compile-time allowlist. Zero access to chats or media. |
| 👁️ **پیش‌نمایش قبل از ذخیره (Full Preview)** | امکان مشاهده، فیلتر کردن، جستجو و ویرایش نام مخاطبین قبل از اضافه شدن نهایی به گوشی. | Full preview & selection list with custom name editing before anything is saved. |
| 🎨 **طراحی مدرن دو زبانه (Material 3)** | پشتیبانی کامل از زبان فارسی (با فونت زیبای وزیرمتن) و انگلیسی، به همراه تم خودکار روشن و تاریک. | Bilingual UI (Persian & English) with Material 3 styling and dynamic Dark/Light themes. |

---

## 📱 دانلود و نصب / Downloads

تلسینک بسته‌های خروجی را بر اساس معماری پردازنده گوشی به صورت تفکیک‌شده و با حداقل حجم ممکن ارائه می‌دهد:

| فایل دانلود / Asset | معماری پردازنده / CPU Architecture | دستگاه‌های هدف / Target Devices |
|---|---|---|
| **[`telsync-v1.0.2-arm64-v8a.apk`](https://github.com/alireza00138300/TelSync/releases/tag/v1.0.2)** *(پیشنهادی)* | ARM 64-bit (`arm64-v8a`) | تقریباً تمام گوشی‌های مدرن اندروید (سامسونگ، شیائومی، هواوی، پیکسل) |
| **[`telsync-v1.0.2-armeabi-v7a.apk`](https://github.com/alireza00138300/TelSync/releases/tag/v1.0.2)** | ARM 32-bit (`armeabi-v7a`) | گوشی‌های قدیمی‌تر یا ارزان‌قیمت اندروید |
| **[`telsync-v1.0.2-x86_64.apk`](https://github.com/alireza00138300/TelSync/releases/tag/v1.0.2)** | Intel/AMD 64-bit (`x86_64`) | شبیه‌سازها (Emulators) و دستگاه‌های مبتنی بر معماری x86 |
| **[`telsync-v1.0.2-universal.apk`](https://github.com/alireza00138300/TelSync/releases/tag/v1.0.2)** | Universal (شامل تمامی معماری‌ها) | سازگار با همه گوشی‌ها (حجم فایل بیشتر است) |

> 💡 **راهنمای سریع:** اگر نمی‌دانید کدام نسخه مناسب گوشی شماست، نسخه **`arm64-v8a`** را دانلود کنید یا در صورت عدم اطمینان نسخه **`universal`** را نصب نمایید.

---

## 🔒 امنیت و حریم خصوصی / Security & Privacy

تلسینک با رعایت دقیق‌ترین اصول امنیتی و مهندسی معکوس تهدیدات طراحی شده است:

1. **بدون سرور واسط (Zero External Servers):** ارتباط صرفاً بین کلاینت تلگرام نصب‌شده روی گوشی شما و سرورهای رسمی تلگرام (`telegram.org`) از طریق پروتکل رسمی MTProto برقرار می‌شود.
2. **محافظت از صفحه و پیش‌نمایش (FLAG_SECURE):** در اندروید فلگ `FLAG_SECURE` فعال است تا از اسکرین‌شات و ضبط صفحه در مراحل حساس جلوگیری شود.
3. **بلور شیلد در سوییچر برنامه‌ها (Privacy Blur Shield):** در iOS در زمان خروج موقت از برنامه، محتوای صفحه جهت عدم افشای شماره‌ها تار می‌گردد.
4. **ترافیک رمزنگاری‌شده (Strict TLS):** ترافیک ناامن Cleartext به طور کامل در پیکربندی اندروید مسدود شده است.
5. **پایگاه داده موقت رمزگذاری‌شده:** تمامی دیتابیس‌های TDLib با کلید رندوم محلی در حافظه رم نگهداری شده و بلافاصله پس از اتمام کار Wipe می‌شوند.

---

## 🛠️ راهنمای بیلد / Build Guide

اگر مایلید سورس کد را خودتان کامپایل و بررسی کنید:

### پیش‌نیازها:
- Flutter SDK نسخه `3.24.0` یا بالاتر
- Android SDK (حداقل API 29) و JDK 17
- Git

### مراحل اجرا:
```bash
# ۱. کلون کردن مخزن
git clone https://github.com/alireza00138300/TelSync.git
cd TelSync

# ۲. دریافت پکیج‌ها و اجرای تست‌ها
cd apps/mobile
flutter pub get
flutter test

# ۳. اجرای اپلیکیشن در حالت دیباگ
flutter run

# ۴. تولید بسته‌های Release تفکیک‌شده
flutter build apk --release --split-per-abi
```

---

## ☕ حمایت مالی / Donate

تلسینک بدون هیچ‌گونه تبلیغات تجاری، پرداخت درون‌برنامه‌ای اجباری یا اشتراک ماهانه منتشر شده است. اگر این نرم‌افزار در زمان شما صرفه‌جویی کرده، می‌توانید با خرید یک فنجان قهوه به ادامه توسعه و بهبود آن انرژی دهید:

<p align="center">
  <a href="https://buymeacoffee.com/alireza">
    <img src="https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=☕&slug=alireza&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff" alt="Buy Me A Coffee" />
  </a>
</p>

- ☕ **Buy Me a Coffee (دلاری / بین‌المللی):** [buymeacoffee.com/alireza](https://buymeacoffee.com/alireza)
- 💳 **حمایت ریالی (کارت به کارت):** در داخل برنامه یا از طریق هماهنگی در بخش Issues.
- ⭐️ **ستاره دادن در گیت‌هاب:** اگر پروژه برای شما مفید بود، دادن ستاره (Star) به این مخزن بزرگترین انگیزه برای تیم ماست!

---

## 🤝 مشارکت در پروژه / Contributing

از تمامی توسعه‌دهندگان و علاقه‌مندان به دنیای نرم‌افزارهای آزاد و متن‌باز استقبال می‌کنیم! برای شروع، لطفاً [راهنمای مشارکت (CONTRIBUTING.md)](CONTRIBUTING.md) را مطالعه فرمایید.

---

## 📜 پروانه / License

این پروژه تحت پروانه متن‌باز **[MIT License](LICENSE)** منتشر شده است و استفاده از آن با ذکر نام سازندگان کاملاً رایگان و آزاد است.
