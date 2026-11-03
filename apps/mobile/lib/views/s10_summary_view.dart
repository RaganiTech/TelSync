import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S10SummaryView extends ConsumerWidget {
  final SummaryState state;
  const S10SummaryView({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

    final newCount = state.counters.candidatesNew;
    final relatedCount = state.counters.candidatesRelated;
    final skippedCount = state.counters.numbersAlreadyInPhone +
        state.counters.numbersProbablyInPhone;
    final reviewCount = state.counters.candidatesReview;

    return AppScaffold(
      title: 'نتیجه بررسی مخاطبین',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space16),
            InfoBanner(
              message: 'فهرست مخاطبین با موفقیت با گوشی مقایسه شد.',
              type: BannerType.success,
            ),
            const SizedBox(height: AppDimensions.space24),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: l10n.tabNew,
                    count: '$newCount',
                    icon: Icons.person_add_alt_1_rounded,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: StatCard(
                    title: l10n.tabRelated,
                    count: '$relatedCount',
                    icon: Icons.link_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: l10n.tabSkipped,
                    count: '$skippedCount',
                    icon: Icons.check_circle_outline,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: StatCard(
                    title: l10n.tabReview,
                    count: '$reviewCount',
                    icon: Icons.help_outline_rounded,
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              l10n.confirmBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.captionSize,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        text: 'مشاهده و انتخاب مخاطبین',
        icon: const Icon(Icons.list_alt_rounded, size: 20),
        onPressed: () {
          controller.proceedToPreview();
        },
      ),
    );
  }
}
