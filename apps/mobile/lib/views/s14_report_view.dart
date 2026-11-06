import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';
import '../services/ad_service.dart';

class S14ReportView extends ConsumerWidget {
  final ReportState state;
  const S14ReportView({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

    final added = state.counters.added;
    final failed = state.counters.failed;

    return AppScaffold(
      title: 'گزارش پایان کار',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space24),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 40,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              l10n.reportAdded(added),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.titleSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (failed > 0) ...[
              const SizedBox(height: AppDimensions.space8),
              Text(
                l10n.reportFailed(failed),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppTypography.bodySize,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.space24),
            if (state.undoAvailable) ...[
              Container(
                padding: const EdgeInsets.all(AppDimensions.space16),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: Colors.amber.shade700,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.history_rounded, color: Colors.amber.shade900),
                        const SizedBox(width: AppDimensions.space8),
                        Expanded(
                          child: Text(
                            'تا قبل از خروج می‌توانی مخاطبین تازه اضافه‌شده را بازگردانی کنی.',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: AppTypography.captionSize,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    SecondaryButton(
                      text: l10n.undo,
                      icon: const Icon(Icons.undo_rounded, size: 18),
                      onPressed: () {
                        controller.undo();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.space24),
            ],
            TrustCard(
              title: l10n.securityPrivacyTitle,
              trustPoints: [
                l10n.trust3,
                l10n.reportDataWipedNotice,
              ],
            ),
            const SizedBox(height: AppDimensions.space16),
            const TapsellNativeBannerWidget(),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        text: l10n.doneDisconnect,
        icon: const Icon(Icons.logout_rounded, size: 20),
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('در حال خروج کامل از نشست تلگرام و بستن برنامه...'),
              duration: Duration(seconds: 2),
            ),
          );
          await AdService.instance.showInterstitialAfterCompletion();
          await controller.finishFlow();
          await SystemNavigator.pop();
        },
      ),
    );
  }
}
