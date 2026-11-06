import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S4AuthCodeView extends ConsumerStatefulWidget {
  final AuthCodeState state;
  const S4AuthCodeView({super.key, required this.state});

  @override
  ConsumerState<S4AuthCodeView> createState() => _S4AuthCodeViewState();
}

class _S4AuthCodeViewState extends ConsumerState<S4AuthCodeView> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    final l10n = AppLocalizations.of(context);
    final code = _codeController.text.trim();
    if (code.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.isPersian
                ? 'لطفاً کد ۵ رقمی ارسال‌شده در تلگرام را وارد کنید.'
                : 'Please enter the 5-digit code sent by Telegram.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final controller = ref.read(importFlowControllerProvider.notifier);
    final res = await controller.submitCode(code);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res != null && res['@type'] == 'error') {
      final msg = res['message']?.toString() ?? '';
      if (msg.contains('Another authorization query has started')) {
        // A query is already being processed by TDLib; ignore duplicate alert
        return;
      }
      String userMsg = '${l10n.isPersian ? "خطا در تایید کد" : "Verification error"}: $msg';
      if (msg.contains('PHONE_CODE_EXPIRED')) {
        userMsg = l10n.isPersian
            ? 'کد ورود منقضی شده است. لطفاً مجدداً درخواست دهید.'
            : 'Code expired. Please request a new one.';
      } else if (msg.contains('PHONE_CODE_INVALID')) {
        userMsg = l10n.isPersian
            ? 'کد وارد شده اشتباه است. لطفاً کد ۵ رقمی صحیح را وارد کنید.'
            : 'Incorrect code. Please enter the valid 5-digit code.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userMsg), backgroundColor: Colors.red.shade700),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      title: l10n.otpCodeLabel,
      showBackButton: true,
      onBack: () => controller.chooseAuthMethod(AuthMethod.phone),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space12),

            // Compact Target Phone Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.mark_email_read_rounded,
                    color: Color(AppColors.telegramBlue),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.codeSentTo,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.state.phoneNumber,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(AppColors.telegramBlue),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.chooseAuthMethod(AuthMethod.phone),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Text(
                        l10n.edit,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.space16),

            Text(
              l10n.telegramCodeLabel,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: AppDimensions.space12),

            OtpField(
              controller: _codeController,
              length: 5,
              onChanged: (code) {
                if (code.length == 5 && !_isLoading) {
                  _submit();
                }
              },
              onSubmitted: (code) {
                if (code.length == 5 && !_isLoading) {
                  _submit();
                }
              },
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                l10n.isPersian
                    ? 'کد را از چت رسمی Telegram در تلگرام خود بردارید'
                    : 'Check the official Telegram chat on your app for the code',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.space20),

            PrimaryButton(
              text: l10n.isPersian ? 'ورود و استخراج مخاطبین' : 'Sign in & Fetch Contacts',
              icon: const Icon(Icons.check_rounded, size: 20),
              isLoading: _isLoading,
              onPressed: _isLoading ? () {} : _submit,
            ),

            const SizedBox(height: AppDimensions.space16),

            // Warning Banner
            InfoBanner(
              message: l10n.loginCodeWarning,
              type: BannerType.warning,
            ),

            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }
}
