# راهنمای جامع و گام‌به‌گام انتشار اپلیکیشن تلسینک (TelSync)
## در گوگل پلی استور (Google Play Store)، کافه بازار (Bazaar) و مایکت (Myket)

> **نسخه:** ۱.۰  
> **هدف:** ارائه نقشه راه عملیاتی، ریزبه‌ریز، بدون ابهام و مرحله‌به‌مرحله برای بیلد نهایی امضاشده (Signed Release)، پاسخ به سوالات ممیزی، رعایت قوانین دسترسی‌های حساس، تنظیمات فروشگاه‌ها و انتشار عمومی.

---

## فهرست مطالب

1. [فاز صفر: پیش‌نیازهای عمومی و آماده‌سازی فنی بیلد](#فاز-صفر-پیش‌نیازهای-عمومی-و-آماده‌سازی-فنی-بیلد)
   - ۱.۱ ساخت کلید امضا (Keystore / JKS)
   - ۱.۲ پیکربندی `key.properties` و `build.gradle`
   - ۱.۳ تدوین سیاست حفظ حریم خصوصی (Privacy Policy)
   - ۱.۴ آماده‌سازی اقلام گرافیکی (Graphic Assets)
   - ۱.۵ دستورات کامپایل خروجی نهایی (AAB و Split APK)
2. [فاز یک: انتشار در گوگل پلی (Google Play Console)](#فاز-یک-انتشار-در-گوگل-پلی-google-play-console)
   - ۲.۱ ایجاد حساب توسعه‌دهنده و شرایط حساب‌های شخصی جدید (قانون ۲۰ تستر)
   - ۲.۲ ایجاد برنامه (Create App)
   - ۲.۳ تکمیل فرم‌های الزامی سیاست‌ها (App Content)
   - ۲.۴ فرم فوق‌العاده حساس امنیت داده‌ها (Data Safety Form)
   - ۲.۵ اعلامیه و توجیه مجوز مخاطبین (Contacts Permissions Declaration)
   - ۲.۶ بارگذاری مشخصات فروشگاه (Store Listing)
   - ۲.۷ آپلود نسخه و انتشار در ریل‌های تست و اصلی (Production)
3. [فاز دوم: انتشار در کافه بازار (Cafe Bazaar)](#فاز-دوم-انتشار-در-کافه-بازار-cafe-bazaar)
   - ۳.۱ ایجاد حساب و احراز هویت در پیشخوان بازار
   - ۳.۲ ثبت برنامه جدید و تعیین دسته‌بندی
   - ۳.۳ بارگذاری فایل بسته و متادیتا
   - ۳.۴ ممیزی مجوز مخاطبین و رفع شبهه پوسته تلگرام در بازار
   - ۳.۵ ارسال برای بررسی و انتشار
4. [فاز سوم: انتشار در مایکت (Myket)](#فاز-سوم-انتشار-در-مایکت-myket)
   - ۴.۱ ایجاد حساب و احراز هویت در پنل مایکت
   - ۴.۲ ثبت برنامه و بارگذاری APK
   - ۴.۳ تصاویر، اسکرین‌شات‌ها و متون بازاریابی
   - ۴.۴ نکات ویژه ارزیابی کارشناسان مایکت و تایید نهایی
5. [چک‌لیست طلایی نهایی پیش از انتشار](#چک‌لیست-طلایی-نهایی-پیش-از-انتشار)

---

# فاز صفر: پیش‌نیازهای عمومی و آماده‌سازی فنی بیلد

---

### ۱.۱ ساخت کلید امضا (Upload Keystore)

برای اینکه مارکت‌ها اجازه آپلود آپدیت‌های آینده را به شما بدهند، تمامی فایل‌های بیلد باید با یک کلید رمزنگاری اختصاصی (Keystore) امضا شوند. **گم شدن این کلید به معنای ناتوانی دائمی در آپدیت نرم‌افزار در مارکت‌ها خواهد بود.**

#### دستور ساخت در ترمینال (PowerShell / Command Prompt):
در پوشه پروژه دستور زیر را وارد کنید (یک گذرواژه قوی انتخاب کنید و آن را یادداشت نمایید):

```powershell
keytool -genkey -v -keystore apps/mobile/android/upload-keystore.jks `
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 `
  -alias upload -storepass MyStrongPassword123 -keypass MyStrongPassword123 `
  -dname "CN=TelSync, OU=Mobile, O=TelSyncApp, L=Tehran, ST=Tehran, C=IR"
```

> **نکته امنیتی بسیار مهم:** فایل `upload-keystore.jks` را در گیت کامیت نکنید. این فایل در `.gitignore` قرار دارد. حتماً از این فایل و پسورد آن در دو مکان امن (مثل فلش مموری یا فضای ابری رمزگذاری‌شده خود) پشتیبان بگیرید.

---

### ۱.۲ پیکربندی `key.properties` و `build.gradle`

در مسیر `apps/mobile/android/` فایلی به نام `key.properties` بسازید (این فایل در گیت نادیده گرفته می‌شود):

```properties
storePassword=MyStrongPassword123
keyPassword=MyStrongPassword123
keyAlias=upload
storeFile=upload-keystore.jks
```

سپس در فایل `apps/mobile/android/app/build.gradle` تنظیمات `signingConfigs` به شکل زیر پیکربندی می‌شود:

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            if (keystorePropertiesFile.exists()) {
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
                storeFile file(keystoreProperties['storeFile'])
                storePassword keystoreProperties['storePassword']
            }
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

### ۱.۳ تدوین سیاست حفظ حریم خصوصی (Privacy Policy URL)

به دلیل استفاده از مجوز خواندن و نوشتن مخاطبین (`READ_CONTACTS` و `WRITE_CONTACTS`)، هر سه مارکت گوگل پلی، بازار و مایکت **اجبار قانونی** دارند که یک لینک فعال اینترنتی حاوی متن حریم خصوصی برنامه ثبت کنید.

می‌توانید متن زیر را در یک صفحه گیت‌هاب (GitHub Pages) یا وبلاگ رایگان منتشر کنید:

#### متن آماده برای Privacy Policy:
```markdown
# Privacy Policy for TelSync

Last updated: November 2026

TelSync is designed with privacy and local security as its core principles:

1. **100% On-Device Processing:** TelSync processes, normalizes, and compares contacts entirely within the user's mobile device memory and storage.
2. **Zero Third-Party Data Sharing:** The application does not transmit contact names, phone numbers, identifiers, or session keys to any third-party or developer servers.
3. **Contact Permissions:** TelSync requests READ_CONTACTS to identify missing phone numbers and WRITE_CONTACTS only after explicit user review and confirmation to save approved contacts. Existing contacts are never modified, deleted, or uploaded.
4. **Session Ephemerality:** Telegram authentication sessions are immediately terminated with a full server-side logOut upon process completion, user cancellation, or application close.
5. **No Analytics or Tracking:** TelSync contains no advertising trackers or telemetry SDKs collecting user behavior.

Contact: support@telsync.app
```

---

### ۱.۴ آماده‌سازی اقلام گرافیکی (Graphic Assets)

پیش از اقدام به بارگذاری، این تصاویر را بر اساس ابعاد استاندارد آماده کنید:

| نام دارایی | مشخصات فنی | کاربرد |
| :--- | :--- | :--- |
| **آیکون برنامه (App Icon)** | ۵۱۲ × ۵۱۲ پیکسل، فرمت PNG ۳۲ بیتی، لبه‌های شفاف، حداکثر حجم ۱۰۲۴ کیلوبایت | نمایش در صفحه برنامه در گوگل پلی، بازار و مایکت |
| **بنر معرف (Feature Graphic)** | ۱۰۲۴ × ۵۰۰ پیکسل، فرمت PNG یا JPEG بدون شفافیت | بالای صفحه در گوگل پلی و بنرهای شاخص بازار/مایکت |
| **اسکرین‌شات‌های موبایل** | حداقل ۴ تصویر و حداکثر ۸ تصویر، رزولوشن عمودی ۱۰۸۰ × ۱۹۲۰ یا ۱۰۸۰ × ۲۴۰۰ پیکسل | تصاویر اسکرین برنامه در فروشگاه |

> **اسکرین‌شات‌های طلایی پیشنهادی:**
> 1. صفحه اول (شروع و تضمین امنیت ۱۰۰٪ آفلاین)
> 2. صفحه ورود با شماره و اسکن بارکد
> 3. صفحه نتیجه بررسی و تفکیک شماره‌های جدید
> 4. صفحه پیش‌نمایش و انتخاب مخاطبین با دکمه ویرایش نام
> 5. صفحه گزارش موفقیت و دکمه بازگردانی (Undo)

---

### ۱.۵ دستورات کامپایل خروجی نهایی (AAB و Split APK)

از طریق ترمینال پروژه، دستورات زیر را اجرا کنید:

#### برای گوگل پلی (فرمت AAB الزامی است):
```powershell
powershell -ExecutionPolicy Bypass -File tools/run_env.ps1 "cd apps/mobile; flutter build appbundle --release"
```
- خروجی: `apps/mobile/build/app/outputs/bundle/release/app-release.aab`

#### برای کافه بازار و مایکت (فرمت APK اسپلیت‌شده بر اساس معماری پردازنده):
```powershell
powershell -ExecutionPolicy Bypass -File tools/run_env.ps1 "cd apps/mobile; flutter build apk --release --split-per-abi"
```
- خروجی‌ها در مسیر: `apps/mobile/build/app/outputs/flutter-apk/`
  - `app-arm64-v8a-release.apk` (حدود ۴۹ مگابایت - مخصوص گوشی‌های جدید)
  - `app-armeabi-v7a-release.apk` (حدود ۳۶ مگابایت - مخصوص گوشی‌های قدیمی ۳۲ بیتی)
  - `app-x86_64-release.apk` (مخصوص شبیه‌سازها و کروم‌بوک)

---

# فاز یک: انتشار در گوگل پلی (Google Play Console)

---

### ۲.۱ ایجاد حساب توسعه‌دهنده و شرایط حساب‌های شخصی جدید

1. ورود به سایت [play.google.com/console](https://play.google.com/console).
2. پرداخت هزینه یک‌باره ثبت‌نام (۲۵ دلار) با کارت ارزی بین‌المللی (ویزا/مسترکارت بنام خودتان یا شرکت).
3. تکمیل مدارک هویتی (پاسپورت معتبر).
4. **نکته حیاتی برای حساب‌های شخصی ساخته‌شده بعد از نوامبر ۲۰۲۳:**  
   گوگل برای حساب‌های شخصی جدید الزام کرده است که پیش از انتشار عمومی (Production)، برنامه باید به مدت **۱۴ روز متوالی** در وضعیت **Closed Testing** توسط **حداقل ۲۰ تستر واقعی** آزمایش شود. پس از پایان ۱۴ روز، دکمه تقاضای انتشار در پروداکشن فعال می‌شود. (برای حساب‌های شرکتی/سازمانی این محدودیت وجود ندارد).

---

### ۲.۲ ایجاد برنامه جدید (Create App)

1. روی دکمه **Create app** در کنسول کلیک کنید.
2. **App name:** `TelSync: Contact Sync for TG`
3. **Default language:** `English (United States) - en-US`
4. **App or game:** `App`
5. **Free or paid:** `Free`
6. تیک‌های پذیرش قوانین و اعلامیه‌ها را بزنید و روی **Create app** کلیک کنید.

---

### ۲.۳ تکمیل فرم‌های الزامی سیاست‌ها (App Content & Policy)

در منوی سمت چپ، به بخش **Policy and programs > App content** بروید و گزینه‌ها را به این صورت تکمیل کنید:

1. **Privacy Policy:**  
   لینک صفحه وب حریم خصوصی ساخته شده در فاز صفر (مثلاً `https://yourdomain.com/privacy-policy`) را وارد کنید.
2. **App Access (دسترسی به برنامه):**  
   گزینه **All or some functionality is restricted** را انتخاب کنید. سپس روی **Add instructions** کلیک کنید:
   - نام: `Demo Mode & Live Test`
   - متن راهنما برای کارشناس گوگل:  
     *"TelSync connects directly to Telegram. To review the app without an active Iranian SIM card or SMS delay, reviewers can click the 'Quick Test with Demo Data' button on the QR screen or enter the test phone number provided. No username or password is required."*
3. **Ads (تبلیغات):**  
   گزینه **No, my app does not contain ads** را انتخاب کنید.
4. **Content Rating (رده‌بندی سنی):**  
   پرسشنامه رده‌بندی را شروع کنید. ایمیل خود را وارد کرده و دسته **Utility, Productivity, Communication** را انتخاب کنید. به سوالات مربوط به خشونت، پورنوگرافی و قمار پاسخ «خیر» بدهید. رده نهایی `PEGI 3` / `Everyone` ثبت می‌شود.
5. **Target Audience and Content (مخاطب هدف):**  
   رده‌های سنی **18 and above** را تیک بزنید. در سوال آیا برنامه برای کودکان جذاب است، پاسخ **No** دهید تا مشمول قوانین سخت‌گیرانه خانواده نشوید.
6. **News / COVID-19 / Financial Features:**  
   برای همه این دسته‌ها گزینه «خیر» را انتخاب کنید.
7. **Government Apps:**  
   خیر.

---

### ۲.۴ فرم فوق‌العاده حساس امنیت داده‌ها (Data Safety Form)

به دلیل حساسیتی که گوگل روی اطلاعات شخصی دارد، این بخش را با دقت بالا مطابق حقیقت برنامه پاسخ دهید:

1. **Does your app collect or share any user data?**  
   پاسخ: **No** (برنامه هیچ اطلاعاتی را جمع‌آوری یا به سرور خود ارسال نمی‌کند).
2. **Is all user data collected by your app encrypted in transit?**  
   پاسخ: **Yes** (ارتباط با سرورهای تلگرام از طریق پروتکل رمزنگاری‌شده MTProto/TLS انجام می‌شود).
3. **Do you provide a way for users to request that their data be deleted?**  
   پاسخ: **Yes** (توضیح دهید برنامه هیچ سروری ندارد و کاربر با خروج از برنامه تمام اطلاعات موقت را پاک می‌کند).

---

### ۲.۵ اعلامیه و توجیه مجوز مخاطبین (Contacts Permissions Declaration)

از آنجا که فایل منیفست برنامه شامل مجوزهای زیر است:
- `android.permission.READ_CONTACTS`
- `android.permission.WRITE_CONTACTS`

گوگل پلی از شما فرم اعلامیه توجیهی (Declaration) می‌خواهد.

#### متن توجیهی رسمی برای گوگل (Core Functionality Declaration):
در کادر توضیحات متن زیر را کپی کنید:

```text
TelSync is an offline-first contact synchronization utility. The core and exclusive functionality of the app is to export contacts that a user holds in their Telegram cloud address book and save them into the native Android ContactsContract.

1. READ_CONTACTS is strictly required to compare Telegram contacts against existing device contacts locally on-device, preventing duplicate entries.
2. WRITE_CONTACTS is strictly required to batch-insert only the missing, user-verified contacts into the user's phone address book upon explicit user confirmation.
3. No contact data, names, or phone numbers are ever collected, uploaded, or shared with any external server or third party. All matching operations execute 100% locally on the device CPU.
```

#### ویدیوی دمو برای ممیز گوگل:
گوگل ممکن است یک لینک ویدیو بخواهد. با اسکرین ریکوردر گوشی یک ویدیوی ۱ دقیقه‌ای بگیرید که در آن:
1. برنامه باز می‌شود.
2. دکمه حالت دمو یا ورود با شماره فشرده می‌شود.
3. لیست مخاطبین نمایش داده شده و کاربر دکمه «افزودن مخاطبین» را لمس می‌کند.
4. نشان داده می‌شود که مخاطب به برنامه مخاطبین گوشی (Google Contacts) اضافه شده است.
این ویدیو را در یوتیوب به‌صورت **Unlisted** آپلود کرده و لینکش را در فرم قرار دهید.

---

### ۲.۶ بارگذاری مشخصات فروشگاه (Main Store Listing)

در منوی سمت چپ به **Grow > Store presence > Main store listing** بروید:

- **App name:** `TelSync: Contact Sync for TG`
- **Short description:**  
  `Offline-first tool to export and sync Telegram contacts to your phonebook.`
- **Full description:**  
  متن کامل انگلیسی را که در بخش ۹.۳ مستند وجود دارد، قرار دهید:
  ```text
  Have hundreds of contacts stored in Telegram whose phone numbers are missing from your phone's native address book after switching devices or losing a SIM card?

  TelSync lets you safely export and synchronize contacts from your Telegram account directly into your device's address book.

  Key Privacy & Security Guarantees:
  • 100% On-Device Processing: All contact normalization, matching, and writing happen exclusively on your device.
  • Zero Developer Backend: We operate zero servers or databases; no contact data leaves your phone.
  • Ephemeral Session: Telegram session is cleanly logged out on the server when done, wiping all local keys.
  • Read-Only Safety for Existing Contacts: Existing contacts are never modified, merged, or deleted.
  • Full Preview & Undo: Review categorized candidates, edit names, or undo additions with a single tap.
  ```
- **App icon:** فایل PNG سایز ۵۱۲×۵۱۲.
- **Feature graphic:** فایل ۱۰۲۴×۵۰۰.
- **Phone screenshots:** حداقل ۴ اسکرین‌شات عمودی ۱۰۸۰×۱۹۲۰.
- روی **Save** کلیک کنید.

---

### ۲.۷ آپلود نسخه و انتشار

1. به بخش **Release > Production** (یا Closed testing در صورت نیاز اکانت شخصی) بروید.
2. روی **Create new release** کلیک کنید.
3. فایل `apps/mobile/build/app/outputs/bundle/release/app-release.aab` را Drag & Drop کنید.
4. بخش **Release notes (en-US)**:
   ```text
   Initial release of TelSync:
   - High-speed direct Telegram contact extraction powered by official TDLib.
   - Smart on-device deduplication engine.
   - Comprehensive candidate preview and instant Undo support.
   - Ephemeral session security with automatic server logout.
   ```
5. روی **Next** و سپس **Save and Review release** کلیک کنید.
6. اگر خطای مسدودکننده‌ای نبود، دکمه **Start rollout to Production** را بزنید. بررسی گوگل معمولاً بین ۲۴ ساعت تا ۷ روز کاری زمان می‌برد.

---

# فاز دوم: انتشار در کافه بازار (Cafe Bazaar)

---

### ۳.۱ ایجاد حساب و احراز هویت در پیشخوان بازار

1. ورود به سایت [developers.cafebazaar.ir](https://developers.cafebazaar.ir).
2. ثبت‌نام با شماره موبایل معتبر ایران.
3. بارگذاری تصویر کارت ملی و وارد کردن شماره شبا به نام خودتان برای احراز هویت (رایگان است و ظرف چند ساعت تایید می‌شود).

---

### ۳.۲ ثبت برنامه جدید

1. در پنل توسعه‌دهندگان، روی دکمه **«برنامه جدید»** کلیک کنید.
2. نوع برنامه: **برنامه کاربردی**.
3. بسته نرم‌افزاری: بسته جدید.
4. دسته‌بندی: **ارتباطی** یا **ابزارها**.
5. مدل قیمت‌گذاری: **رایگان**.

---

### ۳.۳ بارگذاری بسته برنامه (APK / AAB)

1. به بخش **بسته‌ها و نسخه‌ها** بروید.
2. فایل `app-arm64-v8a-release.apk` یا فایل `app-release.aab` را آپلود کنید.
   *(کافه بازار از فایل‌های AAB نیز پشتیبانی می‌کند و خود برای کاربر بهترین APK را می‌سازد؛ اگر APK آپلود می‌کنید، می‌توانید با قابلیت چندبسته‌ای، نسخه arm64-v8a و armeabi-v7a را با کد نسخه‌های مختلف بارگذاری کنید).*
3. بازار به‌طور خودکار شناسه بسته (`com.contactbridge.mobile`) و امضای Keystore را بررسی می‌کند.

---

### ۳.۴ ممیزی مجوز مخاطبین و رفع شبهه پوسته تلگرام در بازار

کافه بازار روی دو موضوع در ممیزی بسیار حساس است:
1. **مجوز دسترسی به مخاطبین:**  
   بازار مطمئن می‌شود که برنامه با هدف فیشینگ یا سرقت شماره‌ها ساخته نشده باشد.  
   - در فیلد یادداشت برای ارزیاب بنویسید:  
     *«این برنامه تمام فرایند مقایسه شماره‌ها را روی دستگاه انجام می‌دهد و فاقد هرگونه سرور واسط است. کاربر قبل از ذخیره، لیست مخاطبین را مشاهده و تایید می‌کند و امکان بازگردانی (Undo) نیز در برنامه تعبیه شده است.»*
2. **قوانین پوسته‌های غیررسمی تلگرام:**  
   به دلیل ممنوعیت پوسته‌های غیررسمی تلگرام (مانند تلگرام‌های ضدفیلتر یا تبلیغاتی) در بازار، حتماً تصریح کنید که:  
   *«این اپلیکیشن پیام‌رسان نیست و امکان چت، عضویت در کانال یا ارسال پیام ندارد؛ این نرم‌افزار صرفاً یک ابزار اختصاصی پشتیبان‌گیری و همگام‌سازی مخاطبین بر پایه کتابخانه متن‌باز TDLib است.»*

---

### ۳.۵ تکمیل اطلاعات و ارسال نهایی

1. **عنوان برنامه (فارسی):**  
   `تلسینک - انتقال مخاطبین تلگرام به گوشی`
2. **عنوان انگلیسی:**  
   `TelSync`
3. **توضیحات کوتاه:**  
   `ذخیره و همگام‌سازی خودکار شماره‌های تلگرام در دفترچه تلفن؛ ۱۰۰٪ آفلاین و امن.`
4. **توضیحات کامل:**  
   متن فارسی آماده‌شده در بخش ۹.۲ مستند هندبوک را بدون تغییر کپی کنید.
5. **کلمات کلیدی:**  
   `انتقال مخاطب از تلگرام به گوشی` ، `ذخیره شماره های تلگرام` ، `خروجی مخاطبین تلگرام` ، `همگام سازی مخاطبین`
6. **تصاویر:**  
   - آیکون برنامه (۵۱۲×۵۱۲ با گوشه‌های تمیز)
   - حداقل ۳ اسکرین‌شات از محیط برنامه (پیش‌نمایش، لیست شماره‌ها، کارت‌های امنیت).
7. کلیک روی دکمه **«ارسال برای بررسی»**.  
   زمان بررسی بازار معمولاً بین ۲۴ تا ۴۸ ساعت کاری است.

---

# فاز سوم: انتشار در مایکت (Myket)

---

### ۴.۱ ایجاد حساب و احراز هویت در پنل مایکت

1. مراجعه به پیشخوان توسعه‌دهندگان مایکت: [developer.myket.ir](https://developer.myket.ir).
2. ورود با شماره تماس و تکمیل پروفایل فردی (کد ملی و مشخصات).
3. تایید هویت معمولاً کمتر از ۲۴ ساعت انجام می‌شود.

---

### ۴.۲ ثبت برنامه جدید

1. کلیک روی **«برنامه جدید»**.
2. نام برنامه به فارسی: `تلسینک (انتقال مخاطبین تلگرام به گوشی)`
3. نام بسته (Package Name): خودکار از فایل APK شما استخراج می‌شود.
4. دسته‌بندی: **ابزارها** یا **ارتباطات**.

---

### ۴.۳ بارگذاری فایل و اطلاعات

1. **فایل نصبی:**  
   فایل `app-arm64-v8a-release.apk` یا فایل باندل را آپلود کنید.
2. **تصاویر:**  
   - آیکون ۵۱۲×۵۱۲
   - حداقل ۳ اسکرین‌شات شفاف و واضح
3. **متن معرفی و توضیحات:**  
   متن توضیحات کامل بازار را عیناً در فیلد توضیحات مایکت کپی کنید.
4. **متن تغییرات این نسخه:**  
   - انتشار نسخه اولیه تلسینک با موتور TDLib.
   - انتقال امن مخاطبین تلگرام بدون نیاز به سرور واسط.
   - قابلیت پیش‌نمایش، ویرایش نام و خروج خودکار نشست.

---

### ۴.۴ نکات ویژه ارزیابی کارشناسان مایکت

کارشناسان مایکت اپلیکیشن را بر روی گوشی‌های فیزیکی بررسی می‌کنند. از آنجا که در ایران تلگرام فیلتر است:
- در بخش **یادداشت به کارشناس مایکت** قید کنید:  
  *«با سلام؛ برای تست فرآیند استخراج واقعی مخاطبین، گوشی تست باید به فیلترشکن متصل باشد (برنامه دارای تشخیص‌دهنده خودکار وضعیت اتصال است). همچنین برای ارزیابی سریع بدون نیاز به دریافت کد، می‌توانید از دکمه «تست سریع با داده‌های نمونه (حالت دمو)» استفاده نمایید.»*
- روی دکمه **«ارسال جهت انتشار»** کلیک کنید. بررسی مایکت معمولاً ۱ الی ۲ روز کاری زمان می‌برد.

---

# چک‌لیست طلایی نهایی پیش از انتشار

قبل از اینکه دکمه ارسال به بررسی را در هر یک از این سه استور بزنید، این جدول را مرور کنید:

| ردیف | آیتم بازبینی | وضعیت تایید | نکته مهم |
| :---: | :--- | :---: | :--- |
| **۱** | امضای نهایی (Keystore Release) | [ ] | مطمئن شوید بیلد Debug آپلود نمی‌کنید؛ فقط بیلد Release امضا شده با JKS. |
| **۲** | پشتیبان‌گیری از Keystore و رمزها | [ ] | اگر فایل `.jks` از بین برود، هرگز نمی‌توانید نسخه بعدی را آپدیت کنید! |
| **۳** | تست اجرای بدون کرش | [ ] | یک‌بار فایل Release APK نهایی را روی یک گوشی واقعی نصب و تا انتهای فلو تست کنید. |
| **۴** | فعال بودن دکمه حالت آزمایشی (Demo) | [ ] | برای ارزیابان گوگل و مارکت‌ها حیاتی است تا بدون سیم‌کارت بتوانند صفحه پیش‌نمایش را بررسی کنند. |
| **۵** | آدرس فعال Privacy Policy | [ ] | باز شدن بدون خطای صفحه حریم خصوصی در مرورگر تست شود. |
| **۶** | عدم وجود لاگ‌های اضافه | [ ] | بررسی شده که قوانین ProGuard لاگ‌های حساس را در نسخه ریلیز پاکسازی می‌کنند. |
| **۷** | اندازه و کیفیت اسکرین‌شات‌ها | [ ] | بدون نوار سیاه، ابعاد متناسب، بدون تاری و با متن‌های واضح. |

با رعایت دقیق مراحل این مستند، اپلیکیشن **تلسینک (TelSync)** با بیشترین سرعت و بدون ریجکت از سد ممیزی گوگل پلی، کافه بازار و مایکت عبور خواهد کرد.
