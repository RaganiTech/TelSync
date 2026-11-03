import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S2AuthChooseView extends ConsumerWidget {
  const S2AuthChooseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

    return AppScaffold(
      title: 'ورود به تلگرام',
      showBackButton: true,
      onBack: () => controller.dispatch(const CancelFlowEvent()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimensions.space16),
          InfoBanner(
            message: l10n.loginNotice,
            type: BannerType.info,
          ),
          const SizedBox(height: AppDimensions.space32),
          PrimaryButton(
            text: l10n.loginQr,
            icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
            onPressed: () {
              controller.chooseAuthMethod(AuthMethod.qr);
            },
          ),
          const SizedBox(height: AppDimensions.space16),
          SecondaryButton(
            text: l10n.loginPhone,
            icon: const Icon(Icons.phone_iphone_rounded, size: 20),
            onPressed: () {
              controller.chooseAuthMethod(AuthMethod.phone);
            },
          ),
          const Spacer(),
          Text(
            l10n.trust3,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppTypography.captionSize,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
        ],
      ),
    );
  }
}
