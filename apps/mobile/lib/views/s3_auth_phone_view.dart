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

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

    return AppScaffold(
      title: l10n.loginPhone,
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
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.titleSize,
                letterSpacing: 1.5,
              ),
              decoration: InputDecoration(
                labelText: l10n.phoneNumberLabel,
                prefixIcon: const Icon(Icons.phone),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        text: l10n.continueText,
        onPressed: () {
          controller.submitPhoneNumber(_phoneController.text);
        },
      ),
    );
  }
}
