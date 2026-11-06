# Contact Bridge (پل مخاطبین)

> انتقال امن و مستقیم شماره‌های جدید از حساب تلگرام به مخاطبین گوشی (بدون سرور، ۱۰۰٪ محلی و آفلاین).

---

## مستندات جامع پروژه برای توسعه‌دهندگان و هوش مصنوعی
تمامی اطلاعات معماری، پکیج‌ها، نحوه اتصال به TDLib، ماشین وضعیت، نکات تجاری‌سازی و قوانین کلیدی پروژه در فایل زیر مستند شده است:

📖 **[مطالعه کتابچه راهنمای جامع ایجنت و توسعه‌دهنده (Agent Handbook)](docs/AGENT_HANDBOOK.md)**

---

## دستورات سریع بیلد و اجرا

### ۱. اجرای تست‌ها و تحلیل کد:
```powershell
powershell -ExecutionPolicy Bypass -File tools/run_env.ps1 "cd apps/mobile; flutter analyze; flutter test"
```

### ۲. بیلد نسخه نهایی (APK بهینه‌شده به تفکیک معماری):
```powershell
powershell -ExecutionPolicy Bypass -File tools/run_env.ps1 "cd apps/mobile; flutter build apk --release --split-per-abi"
```

### ۳. نصب مستقیم روی گوشی متصل:
```powershell
powershell -ExecutionPolicy Bypass -File tools/run_env.ps1 "adb install -r C:\Users\AyzaPc\Desktop\ContactBridge.apk"
```
