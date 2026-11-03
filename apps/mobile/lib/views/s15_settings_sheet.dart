import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S15SettingsSheet extends ConsumerWidget {
  const S15SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final controller = ref.read(importFlowControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusSheetTop),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.settings,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppTypography.titleSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: AppDimensions.space8),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('زبان / Language'),
            subtitle: Text(currentLocale.languageCode == 'fa' ? 'فارسی' : 'English'),
            trailing: Switch(
              value: currentLocale.languageCode == 'fa',
              onChanged: (_) {
                ref.read(localeProvider.notifier).toggleLocale();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('حالت تاریک (Dark Mode)'),
            trailing: DropdownButton<ThemeMode>(
              value: currentThemeMode,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('سیستم')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('روشن')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('تاریک')),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                }
              },
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          SecondaryButton(
            text: l10n.clearSession,
            icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
            onPressed: () async {
              await controller.emergencyWipeAndReset();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          const SizedBox(height: AppDimensions.space16),
        ],
      ),
    );
  }
}
