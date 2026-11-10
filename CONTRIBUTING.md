# Contributing to TelSync (راهنمای مشارکت در تلسینک) 🤝

We love open-source contributions! Whether you are fixing bugs, improving documentation, submitting feature ideas, or improving translations, your help is welcome.

---

## 🇮🇷 راهنمای فارسی

### چگونه مشارکت کنیم؟
1. **گزارش باگ‌ها (Bug Reports):** اگر مشکلی در عملکرد برنامه مشاهده کردید، لطفاً در بخش [Issues](https://github.com/alireza00138300/TelSync/issues) با ذکر نسخه سیستم‌عامل و لاگ خطا گزارش دهید.
2. **پیشنهاد قابلیت جدید (Feature Requests):** ایده‌های خود برای بهبود رابط کاربری یا افزودن قابلیت‌های تازه را مطرح کنید.
3. **ارسال پول ریکوئست (Pull Request):**
   - مخزن را Fork کنید.
   - یک شاخه مجزا بسازید (`git checkout -b feature/awesome-feature`).
   - تغییرات را اعمال کرده و تست‌ها را اجرا کنید:
     ```bash
     flutter test
     flutter analyze
     ```
   - شاخه خود را Push کرده و یک Pull Request واضح ارسال کنید.

### اصول کلیدی کدنویسی:
- حفظ حریم خصوصی ۱۰۰٪ محلی (هیچ کدی نباید داده‌های کاربر را به سرور خارجی ارسال کند).
- رعایت ساختار Clean Architecture و تفکیک پکیج‌ها (`core_domain`, `match_engine`, `source_telegram`, `sink_phonebook`, `design_system`, `l10n`).
- نوشتن تست برای رفتارهای جدید.

---

## 🇬🇧 English Guide

### Code of Conduct
Please be respectful, helpful, and welcoming to all contributors.

### Development Workflow
1. Fork the repo and clone locally.
2. Create your feature branch (`git checkout -b feat/my-improvement`).
3. Ensure all tests and static analysis pass cleanly:
   ```bash
   cd apps/mobile
   flutter analyze
   flutter test
   ```
4. Commit with descriptive semantic messages (`feat: ...`, `fix: ...`, `docs: ...`).
5. Open a Pull Request referencing any related issues.
