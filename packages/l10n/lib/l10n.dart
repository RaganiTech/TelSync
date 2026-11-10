import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('fa'),
    Locale('en'),
  ];

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return instance ?? const AppLocalizations(Locale('fa'));
  }

  bool get isPersian => locale.languageCode == 'fa';

  String get welcomeTitle => isPersian
      ? 'مخاطبین تلگرامت را به گوشی بیاور'
      : 'Bring your Telegram contacts to your phone';

  String get welcomeBody => isPersian
      ? 'فقط شماره‌هایی که در گوشی نداری اضافه می‌شوند. هیچ مخاطبی تغییر یا حذف نمی‌شود.'
      : 'Only numbers missing from your phone are added. No existing contact is changed or deleted.';

  String get trust1 => isPersian
      ? 'همه‌چیز روی گوشی خودت انجام می‌شود و به سرور ما چیزی ارسال نمی‌شود.'
      : 'Everything runs on your phone. Nothing is sent to our servers.';

  String get trust2 => isPersian
      ? 'پیش از افزودن، فهرست را می‌بینی و تأیید می‌کنی.'
      : 'You review and confirm the list before anything is added.';

  String get trust3 => isPersian
      ? 'در پایان، نشست تلگرام به‌طور خودکار بسته می‌شود.'
      : 'When finished, the Telegram session is closed automatically.';

  String get loginNotice => isPersian
      ? 'تلگرام ورود یک دستگاه جدید را اعلام می‌کند. این طبیعی است و پایان کار خودکار خارج می‌شویم.'
      : 'Telegram will announce a new login. This is expected, and we sign out automatically when done.';

  String get loginCodeWarning => isPersian
      ? 'کد تلگرام را هرگز با کس دیگری به اشتراک نگذار.'
      : 'Never share your Telegram code with anyone else.';

  String get loginOpenTelegram => isPersian
      ? 'تأیید با برنامه تلگرام'
      : 'Confirm in the Telegram app';

  String get loginQr => isPersian ? 'نمایش کد QR' : 'Show QR code';

  String get loginPhone => isPersian
      ? 'ورود با شماره و کد'
      : 'Sign in with phone number and code';

  String get noAccount => isPersian
      ? 'این شماره حساب تلگرام ندارد.'
      : 'This number has no Telegram account.';

  String get permRationale => isPersian
      ? 'برای تشخیص شماره‌های تکراری، مخاطبین گوشی را می‌خوانیم و فقط پس از تأیید تو موارد جدید را می‌نویسیم. این اطلاعات از گوشی خارج نمی‌شود.'
      : 'To spot duplicates we read your phone contacts, and we write new ones only after you confirm. This data never leaves your phone.';

  String get permDenied => isPersian
      ? 'بدون دسترسی به مخاطبین نمی‌توانیم ادامه دهیم. چیزی تغییر نکرده است.'
      : 'We cannot continue without contacts access. Nothing has been changed.';

  String get permLimited => isPersian
      ? 'دسترسی فعلی محدود است و فهرست ناقص دیده می‌شود. برای نتیجه درست، دسترسی کامل را در تنظیمات بده.'
      : 'Current access is limited, so the list would be incomplete. Please allow full access in Settings.';

  String get analyzing => isPersian
      ? 'در حال مقایسه شماره‌ها روی گوشی…'
      : 'Comparing numbers on your phone…';

  String get tabAll => isPersian ? 'همه مخاطبین' : 'All Contacts';

  String get tabNew => isPersian ? 'جدید' : 'New';

  String get tabRelated => isPersian ? 'مرتبط با مخاطب موجود' : 'Related to existing';

  String get tabReview => isPersian ? 'نیازمند بررسی' : 'Needs review';

  String get tabSkipped => isPersian ? 'ردشده' : 'Skipped';

  String get badgeRelated => isPersian
      ? 'شماره دیگری از این مخاطب در گوشی هست'
      : 'Another number of this contact is in your phone';

  String get relatedHelp => isPersian
      ? 'این شماره به‌عنوان مخاطب جدید ذخیره می‌شود و مخاطب فعلی تو تغییری نمی‌کند.'
      : 'This number is saved as a new contact; your existing contact is not changed.';

  String get deletedNotice => isPersian
      ? 'مخاطبینی که قبلاً از گوشی حذف کرده‌ای ممکن است دوباره اینجا دیده شوند.'
      : 'Contacts you deleted earlier may appear here again.';

  String get nameMissing => isPersian
      ? 'نام ندارد؛ برای افزودن یک نام وارد کن.'
      : 'No name. Enter a name to add it.';

  String destination(String account) => isPersian
      ? 'ذخیره در: $account'
      : 'Save to: $account';

  String get cloudSyncNote => isPersian
      ? 'این مخاطبین با آن حساب همگام می‌شوند.'
      : 'These contacts will sync with that account.';

  String selectedCount(int n) => isPersian
      ? '$n مورد انتخاب‌شده'
      : '$n selected';

  String confirmTitle(int n) => isPersian
      ? '$n مخاطب جدید اضافه شود؟'
      : 'Add $n new contacts?';

  String get confirmBody => isPersian
      ? 'مخاطبین فعلی تو بدون تغییر می‌مانند.'
      : 'Your existing contacts stay unchanged.';

  String get writing => isPersian ? 'در حال افزودن…' : 'Adding…';

  String reportAdded(int n) => isPersian
      ? '$n مخاطب اضافه شد'
      : '$n contacts added';

  String reportFailed(int n) => isPersian
      ? '$n مورد انجام نشد'
      : '$n could not be added';

  String get undo => isPersian ? 'بازگردانی افزوده‌ها' : 'Undo what was added';

  String get doneDisconnect => isPersian ? 'پایان و قطع اتصال' : 'Done and disconnect';

  String logoutFailed(String device) => isPersian
      ? 'نشست تلگرام ممکن است هنوز فعال باشد. در تلگرام: تنظیمات ← دستگاه‌ها، نشست «$device» را ببند.'
      : 'Your Telegram session may still be active. In Telegram: Settings → Devices, end the session “$device”.';

  String floodWait(int seconds) => isPersian
      ? 'تلگرام موقتاً درخواست‌ها را محدود کرده است. $seconds ثانیه دیگر دوباره امتحان کن.'
      : 'Telegram is temporarily limiting requests. Try again in $seconds seconds.';

  String get networkError => isPersian
      ? 'اتصال برقرار نشد. اینترنت یا VPN را بررسی کن.'
      : 'Could not connect. Check your internet or VPN.';

  // VPN Location Detection & Warning
  String get vpnModalTitle => isPersian
      ? 'لطفاً VPN خود را روشن کنید'
      : 'Please turn on your VPN';

  String get vpnModalSubtitle => isPersian
      ? 'لوکیشن شما ایران تشخیص داده شد. از آنجا که تلگرام در ایران فیلتر است، برنامه برای اتصال پایدار منتظر تغییر آی‌پی و فعال‌سازی فیلترشکن شماست.'
      : 'Your location is detected as Iran. Since Telegram is filtered in Iran, the app is waiting for your VPN to connect.';

  String get vpnWaitingText => isPersian
      ? 'در حال بررسی خودکار اتصال (هر ۲۰ ثانیه)...'
      : 'Auto-checking connection (every 20s)...';

  String get vpnConnectedSuccess => isPersian
      ? 'ارتباط آزاد با موفقیت برقرار شد! در حال ادامه...'
      : 'VPN connected successfully! Resuming...';

  String get vpnCheckNow => isPersian ? 'بررسی مجدد' : 'Check Now';
  String get vpnBypass => isPersian ? 'ادامه در هر صورت' : 'Proceed anyway';
  String get vpnCurrentIpLabel => isPersian ? 'آی‌پی فعلی:' : 'Current IP:';
  String get vpnCurrentCountryLabel => isPersian ? 'کشور:' : 'Country:';
  String get vpnIranDetected => isPersian ? 'ایران (فیلترشده)' : 'Iran (Filtered)';

  // 2FA Password
  String get password2faTitle => isPersian
      ? 'تأیید دو مرحله‌ای تلگرام'
      : 'Telegram 2-Step Verification';

  String get password2faSubtitle => isPersian
      ? 'این حساب تلگرام دارای تأیید هویت دو مرحله‌ای (گذرواژه ابری) است. لطفاً رمز عبور خود را وارد کنید.'
      : 'This account has Two-Step Verification (Cloud Password) enabled. Please enter your password.';

  String get password2faHintPrefix => isPersian ? 'راهنمای رمز: ' : 'Password hint: ';
  String get password2faErrorInvalid => isPersian
      ? 'رمز عبور وارد شده اشتباه است. لطفاً دوباره تلاش کنید.'
      : 'Incorrect 2FA password. Please try again.';

  // Extra common actions & UI labels
  String get retry => isPersian ? 'تلاش مجدد' : 'Retry';
  String get cancel => isPersian ? 'انصراف' : 'Cancel';
  String get confirm => isPersian ? 'تأیید' : 'Confirm';
  String get continueText => isPersian ? 'ادامه' : 'Continue';
  String get start => isPersian ? 'شروع' : 'Start';
  String get selectAll => isPersian ? 'انتخاب همه' : 'Select all';
  String get deselectAll => isPersian ? 'لغو انتخاب همه' : 'Deselect all';
  String get phoneNumberLabel => isPersian ? 'شماره موبایل' : 'Phone number';
  String get otpCodeLabel => isPersian ? 'کد تأیید' : 'Confirmation code';
  String get passwordLabel => isPersian ? 'گذرواژه دومرحله‌ای' : '2-Step Verification Password';
  String get settings => isPersian ? 'تنظیمات' : 'Settings';
  String get about => isPersian ? 'درباره و حریم خصوصی' : 'About & Privacy';
  String get openSettings => isPersian ? 'باز کردن تنظیمات' : 'Open Settings';
  String get grantPermission => isPersian ? 'دادن دسترسی' : 'Grant permission';
  String get clearSession => isPersian ? 'پاکسازی و خروج اضطراری' : 'Emergency wipe & exit';

  // Welcome Screen Guide
  String get welcomeSubtitle => isPersian
      ? 'مخاطبینی که در تلگرام دارید اما در گوشی ذخیره نشده‌اند را به سادگی به دفترچه تلفن خود اضافه کنید.'
      : 'Easily export and save Telegram contacts that are missing from your phone contacts.';
  String get localProcessingBadge => isPersian
      ? 'پردازش ۱۰۰٪ محلی و امن روی همین گوشی'
      : '100% local and secure processing on this device';
  String get howItWorks => isPersian
      ? 'این برنامه چگونه کار می‌کند؟'
      : 'How does this app work?';
  String get step1Title => isPersian
      ? 'ورود مستقیم و امن به تلگرام'
      : 'Direct & Secure Telegram Sign-in';
  String get step1Desc => isPersian
      ? 'با وارد کردن شماره تلفن خود، کد ورود رسمی از سمت تلگرام برای شما فرستاده می‌شود.'
      : 'Enter your phone number to receive an official sign-in code directly from Telegram.';
  String get step2Title => isPersian
      ? 'اسکن و مقایسه هوشمند'
      : 'Smart Scan & Comparison';
  String get step2Desc => isPersian
      ? 'برنامه مخاطبین تلگرام را با مخاطبین فعلی گوشی مقایسه کرده و شماره‌های جدید را جدا می‌کند.'
      : 'The app compares your Telegram contacts with your phonebook to find missing numbers.';
  String get step3Title => isPersian
      ? 'پیش‌نمایش و انتخاب دستی'
      : 'Preview & Custom Selection';
  String get step3Desc => isPersian
      ? 'قبل از ذخیره، نام و شماره هر مخاطب را بررسی کرده و موارد دلخواه را به گوشی انتقال دهید.'
      : 'Review names and numbers before importing, choosing exactly who to add to your phone.';

  String get appName => 'telSync';
  String get appFullName => 'telSync';

  // Security & Privacy Title
  String get securityPrivacyTitle => isPersian
      ? 'تضمین امنیت و حریم خصوصی'
      : 'Security & Privacy Guaranteed';

  // Auth Methods Screen
  String get authChooseTitle => isPersian ? 'روش ورود به تلگرام' : 'Sign in to Telegram';
  String get phoneMethodSubtitle => isPersian
      ? 'بهترین روش برای همین گوشی؛ کد ورود ۵ رقمی به تلگرام شما ارسال می‌شود.'
      : 'Best for this device. A 5-digit sign-in code is sent to your Telegram.';
  String get phoneMethodBadge => isPersian ? 'توصیه شده برای این گوشی' : 'Recommended for this phone';
  String get qrMethodSubtitle => isPersian
      ? 'مناسب زمانی که تلگرام روی کامپیوتر یا گوشی دوم شما باز است و با دوربین اسکن می‌کنید.'
      : 'Best when Telegram is open on your computer or second device to scan with camera.';

  // Phone Auth Screen
  String get phoneAuthTitle => isPersian ? 'ورود با شماره موبایل' : 'Sign in with Phone Number';
  String get phoneInputLabel => isPersian
      ? 'شماره موبایل حساب تلگرام خود را وارد کنید:'
      : 'Enter your Telegram account phone number:';
  String get phoneInputHelper => isPersian
      ? 'شماره را با یا بدون صفر اولیه وارد کنید (مثال: 09121234567 یا 9121234567)'
      : 'Enter number with or without leading zero (e.g. 9121234567 or +1...)';
  String get getTelegramCode => isPersian ? 'دریافت کد تایید تلگرام' : 'Get Telegram Verification Code';
  String get phoneAuthNote => isPersian
      ? 'کد ورود به صورت پیامک یا در اپلیکیشن تلگرام برای همین شماره فرستاده می‌شود.'
      : 'The sign-in code will be sent via SMS or inside Telegram for this number.';
  String get phoneInvalidError => isPersian
      ? 'شماره موبایل وارد شده معتبر نیست. لطفاً شماره را بررسی کنید.'
      : 'The entered phone number is invalid. Please check the number.';
  String get phoneUnoccupiedError => isPersian
      ? 'این شماره در تلگرام حسابی ندارد.'
      : 'No Telegram account found with this phone number.';
  String get phoneBannedError => isPersian
      ? 'این شماره توسط تلگرام مسدود شده است.'
      : 'This phone number has been banned by Telegram.';
  String get floodWaitError => isPersian
      ? 'تعداد تلاش بیش از حد مجاز تلگرام؛ لطفاً چند دقیقه صبر کنید.'
      : 'Too many attempts. Please wait a few minutes before trying again.';
  String get requestTimeoutError => isPersian
      ? 'عدم پاسخ از سرورهای تلگرام. لطفاً اتصال اینترنت یا فیلترشکن را بررسی کنید.'
      : 'No response from Telegram servers. Please check your internet or VPN.';

  // OTP Screen
  String get telegramCodeLabel => isPersian ? 'کد ۵ رقمی تلگرام را وارد کنید:' : 'Enter the 5-digit Telegram code:';
  String get codeSentTo => isPersian ? 'کد ارسال شد به:' : 'Code sent to:';
  String get edit => isPersian ? 'ویرایش' : 'Edit';
  String get confirmCode => isPersian ? 'تأیید کد تلگرام' : 'Confirm Code';

  // Summary & All Synced
  String get contactsComparisonResult => isPersian ? 'نتیجه بررسی مخاطبین' : 'Contacts Comparison Result';
  String get contactsComparisonSuccess => isPersian
      ? 'فهرست مخاطبین با موفقیت با گوشی مقایسه شد.'
      : 'Contacts list successfully compared with your phone.';
  String get viewAndSelectContacts => isPersian ? 'مشاهده و انتخاب مخاطبین' : 'View & Select Contacts';
  String get allContactsSyncedTitle => isPersian ? 'همگام‌سازی کامل است' : 'Contacts Already Synced';
  String get allContactsSyncedBody => isPersian
      ? 'تمام مخاطبین تلگرام از قبل در گوشی شما موجود هستند و مخاطب جدیدی برای ذخیره یافت نشد.'
      : 'All Telegram contacts are already in your phone contacts. There are no new contacts to import.';
  String get exitApp => isPersian ? 'خروج از برنامه' : 'Exit App';
  String get startNewProcess => isPersian ? 'شروع فرایند جدید' : 'Start New Process';

  // Language Dialog
  String get switchLanguageTitle => isPersian ? 'تغییر زبان به فارسی؟' : 'Switch to Persian?';
  String get switchLanguageBody => isPersian
      ? 'زبان پیش‌فرض برنامه انگلیسی است. آیا مایلید برنامه به زبان فارسی نمایش داده شود؟'
      : 'The default language is English. Would you like to switch to Persian?';
  String get yesPersian => isPersian ? 'بله، فارسی' : 'Yes, Persian';
  String get noEnglish => isPersian ? 'خیر، English' : 'No, English';

  // Report
  String get reportDataWipedNotice => isPersian
      ? 'هیچ ردپایی از داده‌های تلگرام روی حافظه گوشی یا سرور باقی نمی‌ماند.'
      : 'No trace of Telegram data remains on the device or servers.';

  // About Sheet
  String get aboutAppTitle => isPersian
      ? 'تلسینک (TelSync) - نسخه ۱.۰.۲'
      : 'TelSync (v1.0.2)';
  String get aboutDescription => isPersian
      ? 'این برنامه برای انتقال امن و هوشمند مخاطبین تلگرام به دفترچه تلفن طراحی شده است و پایبند به اصول زیر است:\n\n'
        '۱. پردازش ۱۰۰٪ محلی درون دستگاه بدون سرور واسط.\n'
        '۲. دفترچه تلفن اصل حقیقت است؛ هیچ مخاطبی هرگز حذف یا ویرایش نمی‌شود.\n'
        '۳. نشست تلگرام در پایان به‌صورت سروری Logout شده و تمام کلیدها و پایگاه داده محلی پاکسازی می‌شوند.\n'
        '۴. محدودیت فراخوانی توابع TDLib بر اساس Allowlist سخت‌گیرانه برای عدم دسترسی به پیام‌ها، گروه‌ها و کانال‌ها.'
      : 'This app is designed for secure, smart transfer of Telegram contacts into your phonebook while adhering to core principles:\n\n'
        '1. 100% on-device local processing with zero external intermediary servers.\n'
        '2. The phonebook is the single source of truth; no existing contact is ever modified or deleted.\n'
        '3. The Telegram session is cleanly logged out on the server when finished, wiping all local keys and cache.\n'
        '4. Strict TDLib method allowlisting ensures zero access to your private messages, groups, or channels.';
  String get aboutFooter => isPersian
      ? 'نسخه ۱.۰.۲ — ساخته شده با ❤️ در مجموعه RaganiTech'
      : 'Version 1.0.2 — Made with ❤️ in RaganiTech collection';

  // Coffee & Open-Source Donation
  String get coffeeCardTitle => isPersian
      ? 'یک فنجان قهوه برای سازنده ☕'
      : 'Buy me a coffee ☕';
  String get coffeeCardSubtitle => isPersian
      ? 'تلسینک کاملاً متن‌باز، رایگان و بدون تبلیغات است. اگر در وقت شما صرفه‌جویی شد، با خرید یک قهوه حامی توسعه‌دهنده باشید!'
      : 'TelSync is 100% open-source, free, and ad-free. If this tool saved your time, consider buying the dev a coffee!';
  String get coffeeBuyAction => isPersian
      ? 'خرید قهوه در Buy Me a Coffee ☕'
      : 'Buy a Coffee via BuyMeACoffee ☕';
  String get coffeeOtherWays => isPersian
      ? 'سایر روش‌های حمایت (کارت، گیت‌هاب) 💛'
      : 'Other ways to support (Card, GitHub) 💛';
  String get coffeeExitPromptTitle => isPersian
      ? 'پایان موفقیت‌آمیز عملیات 🎉'
      : 'Sync Completed Successfully 🎉';
  String get coffeeExitPromptBody => isPersian
      ? 'مخاطبین به گوشی اضافه شدند و نشست تلگرام پاکسازی شد.\nاگر از برنامه راضی بودید، خوشحال می‌شویم با یک فنجان قهوه گرم یا ستاره دادن در گیت‌هاب خستگی را از تن ما به در کنید.'
      : 'Contacts were synced and Telegram session was securely wiped.\nIf you enjoyed using TelSync, consider buying the developer a coffee or starring the repo on GitHub.';
  String get coffeeExitDismiss => isPersian
      ? 'متشکرم، خروج از برنامه'
      : 'Thanks, Exit App';
  String get coffeeGitHubStar => isPersian
      ? 'ستاره دادن در گیت‌هاب ⭐'
      : 'Star on GitHub ⭐';
  String get coffeeCardPaymentTitle => isPersian
      ? 'حمایت ریالی (کارت به کارت)'
      : 'Direct Card Transfer (Iran)';
  String get coffeeCopyCardNumber => isPersian
      ? 'کپی شماره کارت'
      : 'Copy Card Number';
  String get coffeeCardCopiedNotice => isPersian
      ? 'شماره کارت در حافظه کپی شد ✨'
      : 'Card number copied to clipboard ✨';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['fa', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
