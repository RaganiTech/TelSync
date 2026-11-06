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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Future<void> onStartPressed() async {
      final ok = await controller.ensureVpnIfFiltered(context);
      if (ok) {
        controller.startImport();
      }
    }

    return AppScaffold(
      title: l10n.appName,
      actions: [
        IconButton(
          icon: const Icon(Icons.language_rounded),
          tooltip: 'تغییر زبان',
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
          icon: const Icon(Icons.info_outline_rounded),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space12),

            // Hero Banner Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0284C7),
                    Color(0xFF2563EB),
                    Color(0xFF1D4ED8),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.appFullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.welcomeBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 12.5,
                      height: 1.5,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.space20),

            // Prominent Call-To-Action Card (Directs user to start)
            InkWell(
              onTap: onStartPressed,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.shade500.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.isPersian
                                ? 'برای شروع اینجا را لمس کنید'
                                : 'Tap here to get started',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.isPersian
                                ? 'یا دکمه «شروع» در پایین صفحه را بزنید'
                                : 'Or press the "Start" button below',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.space20),

            // Privacy Card
            TrustCard(
              title: l10n.securityPrivacyTitle,
              trustPoints: [
                l10n.trust1,
                l10n.trust2,
                l10n.trust3,
              ],
            ),

            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        text: l10n.start,
        icon: const Icon(Icons.arrow_forward_rounded, size: 20),
        onPressed: onStartPressed,
      ),
    );
  }
}
