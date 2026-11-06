import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import '../controllers/providers.dart';
import '../services/network_location_service.dart';
import 's1_welcome_view.dart';
import 's2_auth_choose_view.dart';
import 's3_auth_phone_view.dart';
import 's4_auth_code_view.dart';
import 's5_auth_password_view.dart';
import 's6_auth_qr_view.dart';
import 's7_fetching_view.dart';
import 's8_permission_view.dart';
import 's9_analyzing_view.dart';
import 's10_summary_view.dart';
import 's11_preview_view.dart';
import 's12_confirm_sheet.dart';
import 's13_writing_view.dart';
import 's14_report_view.dart';
import 's17_recovery_view.dart';

class FlowScreenHost extends ConsumerStatefulWidget {
  const FlowScreenHost({super.key});

  @override
  ConsumerState<FlowScreenHost> createState() => _FlowScreenHostState();
}

class _FlowScreenHostState extends ConsumerState<FlowScreenHost> with WidgetsBindingObserver {
  DateTime? _lastBackPressTime;
  static bool _hasPromptedLanguage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndPromptLanguage();
  }

  void _checkAndPromptLanguage() {
    if (_hasPromptedLanguage) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final currentLocale = ref.read(localeProvider);
      final contextLocale = Localizations.localeOf(context);
      if (currentLocale.languageCode == 'fa' || contextLocale.languageCode == 'fa') {
        _hasPromptedLanguage = true;
        return;
      }

      bool isIranian = _isIranianUser();
      if (!isIranian) {
        try {
          final loc = await NetworkLocationService().checkLocation();
          if (loc.countryCode == 'IR') {
            isIranian = true;
          }
        } catch (_) {}
      }

      if (isIranian && !_hasPromptedLanguage && mounted) {
        _hasPromptedLanguage = true;
        _showSwitchToPersianDialog();
      }
    });
  }

  bool _isIranianUser() {
    try {
      final locales = WidgetsBinding.instance.platformDispatcher.locales;
      for (final loc in locales) {
        if (loc.languageCode.toLowerCase() == 'fa' ||
            (loc.countryCode != null && loc.countryCode!.toUpperCase() == 'IR')) {
          return true;
        }
      }
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final tzName = now.timeZoneName.toLowerCase();
      if (offset.inMinutes == 210 ||
          offset.inMinutes == 270 ||
          tzName.contains('tehran') ||
          tzName.contains('irst') ||
          tzName.contains('irdt')) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  void _showSwitchToPersianDialog() {
    if (!mounted) return;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Row(
          children: [
            const Text('🇮🇷', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'تغییر زبان به فارسی؟\nSwitch to Persian?',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'زبان پیش‌فرض برنامه انگلیسی است. آیا مایلید برنامه با زبان فارسی نمایش داده شود؟\n\nThe default app language is English. Would you like to switch to Persian?',
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 13.5,
            height: 1.5,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'خیر، English',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              ref.read(localeProvider.notifier).setLocale(const Locale('fa'));
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'بله، فارسی',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // User closed/swiped away app: immediately terminate session
      ref.read(importFlowControllerProvider.notifier).logOutAndCleanSession();
    }
  }

  Future<void> _handleBack(FlowState flowState) async {
    final controller = ref.read(importFlowControllerProvider.notifier);

    switch (flowState) {
      case WelcomeState() || DoneState():
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          if (!mounted) return;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'برای خروج، دوباره دکمه بازگشت را بزنید',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: AppTypography.fontFamily),
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else {
          await controller.logOutAndCleanSession();
          await SystemNavigator.pop();
        }

      case AuthChooseState():
        await controller.cancelFlow();

      case AuthPhoneState():
        controller.dispatch(const StartFlowEvent());

      case AuthCodeState():
        controller.chooseAuthMethod(AuthMethod.phone);

      case AuthPasswordState():
        controller.chooseAuthMethod(AuthMethod.phone);

      case AuthQrState():
        controller.dispatch(const StartFlowEvent());

      case FetchingTelegramState() ||
          PermissionRationaleState() ||
          PermissionDeniedState() ||
          ReadingPhoneBookState() ||
          AnalyzingState() ||
          SummaryState() ||
          PreviewState() ||
          WritingState() ||
          VerifyingState():
        final confirm = await _showConfirmExitDialog(
          title: 'خروج از برنامه و لغو عملیات',
          content: 'آیا می‌خواهید از برنامه خارج شوید؟ نشست تلگرام برای حفظ امنیت شما به‌طور کامل از سرور تلگرام خارج (Logout) و تمام اطلاعات پاکسازی خواهد شد.',
          confirmLabel: 'خروج از حساب و بستن برنامه',
          isDanger: true,
        );
        if (confirm == true) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('در حال خروج امن از نشست تلگرام و بستن برنامه...'),
              duration: Duration(seconds: 2),
            ),
          );
          await controller.logOutAndCleanSession();
          await SystemNavigator.pop();
        }

      case ConfirmSheetState():
        controller.closeConfirmSheet();

      case ReportState():
        await controller.finishFlow();
        await SystemNavigator.pop();

      case RecoveryCleanupState() || CleanupState():
        controller.dispatch(const CleanupFinishedEvent());
    }
  }

  Future<bool?> _showConfirmExitDialog({
    required String title,
    required String content,
    required String confirmLabel,
    bool isDanger = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Row(
          children: [
            Icon(
              isDanger ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
              color: isDanger ? Colors.red : theme.colorScheme.primary,
              size: 26,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          content,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 13.5,
            height: 1.6,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'انصراف و ماندن',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDanger ? Colors.red.shade700 : theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              confirmLabel,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flowState = ref.watch(importFlowControllerProvider);

    final currentView = switch (flowState) {
      WelcomeState() => const S1WelcomeView(),
      AuthChooseState() => const S2AuthChooseView(),
      AuthPhoneState() => const S3AuthPhoneView(),
      AuthCodeState() => S4AuthCodeView(state: flowState),
      AuthPasswordState() => S5AuthPasswordView(state: flowState),
      AuthQrState() => S6AuthQrView(state: flowState),
      FetchingTelegramState() => S7FetchingView(state: flowState),
      PermissionRationaleState() => const S8PermissionView(),
      PermissionDeniedState() => S8PermissionView(
          isDenied: true,
          isLimited: flowState.isLimitedIos,
          isPermanent: flowState.permanent,
        ),
      ReadingPhoneBookState() => S9AnalyzingView(
          progress: flowState.progress,
          count: flowState.count,
        ),
      AnalyzingState() => S9AnalyzingView(progress: flowState.progress),
      SummaryState() => S10SummaryView(state: flowState),
      PreviewState() => S11PreviewView(state: flowState),
      ConfirmSheetState() => S12ConfirmSheet(state: flowState),
      WritingState() => S13WritingView(state: flowState),
      VerifyingState() => const S13WritingView(
          state: WritingState(total: 0, processed: 0),
        ),
      ReportState() => S14ReportView(state: flowState),
      RecoveryCleanupState() => S17RecoveryView(notice: flowState.notice),
      CleanupState() => S17RecoveryView(notice: flowState.errorNotice),
      DoneState() => const S1WelcomeView(),
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack(flowState);
      },
      child: currentView,
    );
  }
}
