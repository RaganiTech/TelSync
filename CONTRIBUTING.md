# Contributing to TelSync (راهنمای مشارکت در پروژه تلسینک) 🤝

We love open-source contributions! Whether you are reporting a bug, proposing new features, improving documentation, fixing typos, or optimizing code, your support is warmly welcome.

Please review this guide before opening issues or submitting Pull Requests.

---

## 🇮🇷 راهنمای فارسی مشارکت

### ۱. گزارش باگ‌ها و مشکلات (Bug Reports)
- قبل از ثبت ایشو جدید، لطفاً در [لیست ایشوهای باز و بسته](https://github.com/alireza00138300/TelSync/issues) جستجو کنید.
- از فرم هوشمند [ثبت باگ](https://github.com/alireza00138300/TelSync/issues/new?template=bug_report.yaml) استفاده کنید.
- نسخه سیستم‌عامل، مدل گوشی و مراحل دقیق بازتولید مشکل را درج فرمایید.
- **مهم:** از قرار دادن شماره تلفن‌های واقعی یا کدهای تایید در لاگ‌ها و اسکرین‌شات‌ها اکیداً خودداری نمایید.

### ۲. پیشنهاد ویژگی و قابلیت تازه (Feature Requests)
- ایده‌ها و طرح‌های جدید خود برای رابط کاربری، منطق تطبیق مخاطبین یا امکانات تکمیلی را در [فرم پیشنهاد ویژگی](https://github.com/alireza00138300/TelSync/issues/new?template=feature_request.yaml) مطرح کنید.

### ۳. ارسال پول ریکوئست (Pull Request Flow)
1. ابتدا مخزن را Fork کنید.
2. یک شاخه مجزا بسازید:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. تغییرات خود را اعمال کنید و مطمئن شوید که تمامی تست‌ها و بررسی‌های استاتیک بدون اخطار اجرا می‌شوند:
   ```bash
   cd apps/mobile
   flutter analyze
   flutter test
   ```
4. کامیت‌ها را با پیام‌های استاندارد و معنادار (مانند `feat: ...` یا `fix: ...`) ثبت کنید.
5. شاخه خود را به مخزن فورک‌شده Push کرده و یک Pull Request همراه با توضیحات شفاف ایجاد نمایید.

### ۴. اصول معماری و حریم خصوصی:
- **حفظ حریم خصوصی ۱۰۰٪ آفلاین:** هیچ کدی نباید داده‌های کاربر یا اطلاعات مخاطبین را به خارج از گوشی ارسال کند.
- **تفکیک پکیج‌ها (Clean Architecture):**
  - `core_domain`: ساختار موجودیت‌ها، قواعد کسب‌وکار و ماشین وضعیت.
  - `core_phone`: نرمال‌سازی شماره‌های ایران و استاندارد E.164.
  - `match_engine`: منطق تشخیص مخاطبین تکراری و پیشنهاد ادغام.
  - `source_telegram`: ارتباط مستقیم با سرورهای تلگرام از طریق TDLib FFI.
  - `sink_phonebook`: پلاگین نیتیو Pigeon برای تعامل مستقیم با دفترچه تلفن اندروید و iOS.
  - `platform_security`: شیلد امنیتی، فلگ `FLAG_SECURE` و پاکسازی رم.
  - `design_system`: ویجت‌ها، رنگ‌ها و فونت وزیرمتن.
  - `l10n`: محلی‌سازی و متون فارسی/انگلیسی.

---

## 🇬🇧 English Contribution Guide

### 1. Reporting Bugs
- Search [existing issues](https://github.com/alireza00138300/TelSync/issues) first.
- Use our [Bug Report Form](https://github.com/alireza00138300/TelSync/issues/new?template=bug_report.yaml).
- Never attach private contact numbers, phone numbers, or Telegram session tokens in public reports.

### 2. Suggesting Features
- Propose feature ideas via our [Feature Request Form](https://github.com/alireza00138300/TelSync/issues/new?template=feature_request.yaml).

### 3. Development Setup
```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/TelSync.git
cd TelSync/apps/mobile

# Install Flutter dependencies
flutter pub get

# Run tests
flutter test

# Run static code analysis
flutter analyze
```

### 4. Coding Standards
- Maintain strict zero-network transmission for user data.
- Ensure all tests pass with 100% green status before submitting PRs.
- Adhere to effective Dart formatting (`dart format .`).
