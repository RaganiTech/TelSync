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

  void _submit() {
    final code = _codeController.text.trim();
    if (code.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کد ورود تلگرام ۵ رقمی است.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final controller = ref.read(importFlowControllerProvider.notifier);
    controller.submitCode(code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);
    final theme = Theme.of(context);

    return AppScaffold(
      title: l10n.otpCodeLabel,
      showBackButton: true,
      onBack: () => controller.dispatch(const CancelFlowEvent()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space16),
            InfoBanner(
              message: l10n.loginCodeWarning,
              type: BannerType.warning,
            ),
            const SizedBox(height: AppDimensions.space24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                children: [
                  const Icon(Icons.mark_email_read_rounded, size: 36, color: Color(AppColors.telegramBlue)),
                  const SizedBox(height: 12),
                  Text(
                    'کد تایید به تلگرام شماره زیر ارسال شد:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.state.phoneNumber,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            OtpField(
              controller: _codeController,
              length: 5,
              onSubmitted: (code) {
                if (code.length == 5) {
                  _submit();
                }
              },
            ),
            const SizedBox(height: AppDimensions.space24),

            // Bypass / test button
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.flash_on_rounded, size: 18),
                label: const Text(
                  'کد دریافت نشد؟ ورود مستقیم در حالت تستی',
                  style: TextStyle(fontFamily: AppTypography.fontFamily, fontSize: 12),
                ),
                onPressed: () {
                  controller.simulateAuthSuccess();
                },
              ),
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        text: 'تایید و ادامه',
        icon: const Icon(Icons.check_rounded, size: 20),
        isLoading: _isLoading,
        onPressed: _submit,
      ),
    );
  }
}
