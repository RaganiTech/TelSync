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
