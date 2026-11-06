import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S10SummaryView extends ConsumerStatefulWidget {
  final SummaryState state;
  const S10SummaryView({super.key, required this.state});

  @override
  ConsumerState<S10SummaryView> createState() => _S10SummaryViewState();
}

class _S10SummaryViewState extends ConsumerState<S10SummaryView> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    final totalNew = widget.state.counters.candidatesNew +
        widget.state.counters.candidatesRelated +
        widget.state.counters.candidatesReview;

    if (totalNew == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _dialogShown) return;
        _dialogShown = true;
        _showAllSyncedDialog();
      });
    }
  }

  void _showAllSyncedDialog() {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade500.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade600,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.allContactsSyncedTitle,
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
          l10n.allContactsSyncedBody,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 14,
            height: 1.6,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.isPersian
                        ? 'در حال پاکسازی نشست و خروج از برنامه...'
                        : 'Cleaning session and exiting...',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
              await controller.logOutAndCleanSession();
              await SystemNavigator.pop();
            },
            child: Text(
              l10n.exitApp,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await controller.cancelFlow();
            },
            child: Text(
              l10n.startNewProcess,
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
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

    final newCount = widget.state.counters.candidatesNew;
    final relatedCount = widget.state.counters.candidatesRelated;
    final skippedCount = widget.state.counters.numbersAlreadyInPhone +
        widget.state.counters.numbersProbablyInPhone;
    final reviewCount = widget.state.counters.candidatesReview;
    final totalNew = newCount + relatedCount + reviewCount;
    final isAllSynced = totalNew == 0;

    return AppScaffold(
      title: l10n.contactsComparisonResult,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space16),
            InfoBanner(
              message: isAllSynced
                  ? l10n.allContactsSyncedBody
                  : l10n.contactsComparisonSuccess,
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
              isAllSynced
                  ? (l10n.isPersian
                      ? 'تمامی مخاطبین تلگرام از قبل با دفترچه تلفن شما همگام هستند.'
                      : 'All Telegram contacts are already synced with your phonebook.')
                  : l10n.confirmBody,
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
      bottomNavigationBar: isAllSynced
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  text: l10n.startNewProcess,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  onPressed: () async {
                    await controller.cancelFlow();
                  },
                ),
                const SizedBox(height: AppDimensions.space8),
                SecondaryButton(
                  text: l10n.exitApp,
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.isPersian
                              ? 'در حال پاکسازی نشست و خروج از برنامه...'
                              : 'Cleaning session and exiting...',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    await controller.logOutAndCleanSession();
                    await SystemNavigator.pop();
                  },
                ),
              ],
            )
          : PrimaryButton(
              text: l10n.viewAndSelectContacts,
              icon: const Icon(Icons.list_alt_rounded, size: 20),
              onPressed: () {
                controller.proceedToPreview();
              },
            ),
    );
  }
}
