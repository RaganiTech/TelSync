import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S3AuthPhoneView extends ConsumerStatefulWidget {
  const S3AuthPhoneView({super.key});

  @override
  ConsumerState<S3AuthPhoneView> createState() => _S3AuthPhoneViewState();
}

class _S3AuthPhoneViewState extends ConsumerState<S3AuthPhoneView> {
  final _phoneController = TextEditingController(text: '+98');
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _phoneController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isLoading = true);
    final controller = ref.read(importFlowControllerProvider.notifier);
    controller.submitPhoneNumber(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'ورود با شماره موبایل',
      showBackButton: true,
      onBack: () => controller.dispatch(const CancelFlowEvent()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space16),
            InfoBanner(
              message: 'کد تایید مستقیماً در اپلیکیشن تلگرام رسمی یا به صورت پیامک برای این شماره ارسال خواهد شد.',
              type: BannerType.info,
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              'شماره موبایل حساب تلگرام خود را وارد کنید:',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.space12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
              decoration: InputDecoration(
                labelText: l10n.phoneNumberLabel,
                hintText: '+989121234567',
                prefixIcon: const Icon(Icons.phone_rounded),
                helperText: 'کد کشور + شماره تلفن (مثال: 09121234567 یا 989121234567+)',
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppDimensions.space24),

            // Demo Mode Helper Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, color: Colors.amber.shade900, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'برای تست سریع بدون دریافت کد، می‌توانید از حالت آزمایشی استفاده کنید:',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 11,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.startDemoMode();
                    },
                    child: Text(
                      'تست سریع',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        text: l10n.continueText,
        icon: const Icon(Icons.arrow_forward_rounded, size: 20),
        isLoading: _isLoading,
        onPressed: _submit,
      ),
    );
  }
}
