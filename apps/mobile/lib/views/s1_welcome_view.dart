import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';
import 's15_settings_sheet.dart';
import 's16_about_sheet.dart';

class S1WelcomeView extends ConsumerWidget {
  const S1WelcomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

    return AppScaffold(
      title: 'Contact Bridge',
      actions: [
        IconButton(
          icon: const Icon(Icons.language),
          tooltip: 'تغییر زبان / Language',
          onPressed: () {
            ref.read(localeProvider.notifier).toggleLocale();
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: l10n.settings,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) => const S15SettingsSheet(),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: l10n.about,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) => const S16AboutSheet(),
            );
          },
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimensions.space24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.import_contacts_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              l10n.welcomeTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.displaySize,
                fontWeight: FontWeight.bold,
                height: AppTypography.displayHeight,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.space12),
            Text(
              l10n.welcomeBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.bodySize,
                height: AppTypography.bodyHeight,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            TrustCard(
              trustPoints: [
                l10n.trust1,
                l10n.trust2,
                l10n.trust3,
              ],
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        text: l10n.start,
        icon: const Icon(Icons.arrow_forward_rounded, size: 20),
        onPressed: () {
          controller.startImport();
        },
      ),
    );
  }
}
