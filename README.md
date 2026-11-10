# Contact Bridge (پل مخاطبین) 📱✨

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-ffdd00?logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/alireza)
[![Privacy](https://img.shields.io/badge/Privacy-100%25%20Local-success)](README.md)

> **انتقال امن، مستقیم و ۱۰۰٪ محلی مخاطبین تلگرام به دفترچه تلفن گوشی — بدون نیاز به سرور واسط و با حفظ کامل حریم خصوصی.**  
> *A secure, local-first open-source utility to safely import Telegram contacts directly into your phone's address book with zero server tracking.*

---

## 🌟 ویژگی‌های برجسته (Key Features)

- 🔒 **کاملاً محلی و آفلاین (100% Local & Offline):** هیچ داده یا مخاطبی به سرورهای واسط ارسال نمی‌شود؛ تمامی پردازش‌ها مستقیماً روی دستگاه شما با هسته رسمی **TDLib** انجام می‌گردد.
- 🛡️ **ادغام هوشمند و امن (Safe Contact Merging):** مخاطبین قبلی گوشی شما هرگز پاک یا بازنویسی نمی‌شوند؛ تنها مخاطبین جدید با نام انتخابی اضافه خواهند شد.
- 👀 **پیش‌نمایش و کنترل کامل (Full Preview):** قبل از افزودن هر مخاطب، لیست کامل با جزئیات نمایش داده شده و تأیید نهایی توسط خودتان انجام می‌شود.
- 🎨 **رابط کاربری مدرن (Material 3 UI):** طراحی ساده، سریع، دو زبانه (فارسی / انگلیسی) با پشتیبانی خودکار از تم روشن و تاریک.

---

## ☕ حمایت مالی (Donate / Buy Me a Coffee)

این پروژه به صورت **کاملاً متن‌باز (Open Source)** و رایگان در دسترس عموم قرار گرفته است. اگر این ابزار برای شما مفید بوده و در زمان شما صرفه‌جویی کرده است، با خرید یک فنجان قهوه می‌توانید از توسعه و نگهداری آن حمایت کنید:

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-☕-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/alireza)

> 💡 **راه‌های حمایت:**
> - **Buy Me a Coffee:** [buymeacoffee.com/alireza](https://buymeacoffee.com/alireza) *(نام کاربری خود را در `.github/FUNDING.yml` و این بخش تنظیم کنید)*
> - **حمایت ریالی:** امکان اتصال لینک‌های درگاه ریالی (مانند ریمیت یا زرین‌پال) در بخش اسپانسر گیت‌هاب وجود دارد.
> - **ستاره دادن به پروژه:** با دادن ⭐️ در گیت‌هاب به دیده شدن پروژه کمک کنید!

---

## 🚀 راهنمای بیلد و اجرا (Getting Started)

### پیش‌نیازها
- **Flutter SDK:** نسخه 3.24 یا بالاتر
- **Android SDK:** حداقل API 21 (Android 5.0+)

### ۱. اجرای نسخه توسعه:
```bash
cd apps/mobile
flutter pub get
flutter run
```

### ۲. بیلد فایل APK نهایی (Release):
```bash
cd apps/mobile
flutter build apk --release --split-per-abi
```
فایل‌های خروجی در مسیر `apps/mobile/build/app/outputs/flutter-apk/` تولید می‌شوند.

---

## 📄 مستندات فنی و معماری
برای مشاهده مستندات دقیق ساختار پکیج‌ها، اتصال به TDLib و معماری پروژه، [کتابچه راهنمای توسعه‌دهنده (Handbook)](docs/AGENT_HANDBOOK.md) را مطالعه کنید.

---

## 📜 لایسنس (License)
این پروژه تحت پروانه [MIT License](LICENSE) منتشر شده است. استفاده، ویرایش و بازنشر آن با رعایت شرایط پروانه کاملاً آزاد است.
