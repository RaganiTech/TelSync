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

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

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
            Text(
              'کد به تلگرام یا پیامک شماره ${widget.state.phoneNumber} فرستاده شد.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.bodySize,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            OtpField(
              controller: _codeController,
              length: 5,
              onSubmitted: (code) {
                if (code.length == 5) {
                  controller.submitCode(code);
                }
              },
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        text: l10n.confirm,
        onPressed: () {
          if (_codeController.text.length == 5) {
            controller.submitCode(_codeController.text);
          }
        },
      ),
    );
  }
}
