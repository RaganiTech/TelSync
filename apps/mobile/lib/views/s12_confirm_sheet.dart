import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S12ConfirmSheet extends ConsumerWidget {
  final ConfirmSheetState state;
  const S12ConfirmSheet({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);
    final count = state.preview.selectedCount;

    return AppScaffold(
      title: 'تأیید نهایی افزودن',
      showBackButton: true,
      onBack: () => controller.closeConfirmSheet(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space24),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_task_rounded,
                  size: 32,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              l10n.confirmTitle(count),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.titleSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              l10n.confirmBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.bodySize,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            InfoBanner(
              message: l10n.cloudSyncNote,
              type: BannerType.info,
            ),
            const SizedBox(height: AppDimensions.space24),
            TrustCard(
              trustPoints: [
                l10n.trust2,
                l10n.trust3,
              ],
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            text: 'افزودن قطعی $count مخاطب',
            icon: const Icon(Icons.check, size: 20),
            onPressed: () {
              controller.confirmAndWrite();
            },
          ),
          const SizedBox(height: AppDimensions.space12),
          SecondaryButton(
            text: l10n.cancel,
            onPressed: () {
              controller.closeConfirmSheet();
            },
          ),
        ],
      ),
    );
  }
}
