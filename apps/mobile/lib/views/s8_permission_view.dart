import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S8PermissionView extends ConsumerWidget {
  final bool isDenied;
  final bool isLimited;
  final bool isPermanent;

  const S8PermissionView({
    super.key,
    this.isDenied = false,
    this.isLimited = false,
    this.isPermanent = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

    return AppScaffold(
      title: 'دسترسی به مخاطبین',
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
                  color: isDenied
                      ? Theme.of(context).colorScheme.error.withValues(alpha: 0.12)
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDenied ? Icons.lock_outline_rounded : Icons.contacts_rounded,
                  size: 36,
                  color: isDenied
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              isDenied ? 'دسترسی رد شد' : 'اجازه خواندن و افزودن مخاطبین',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.titleSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            InfoBanner(
              message: isDenied
                  ? (isLimited ? l10n.permLimited : l10n.permDenied)
                  : l10n.permRationale,
              type: isDenied ? BannerType.warning : BannerType.info,
            ),
            const SizedBox(height: AppDimensions.space24),
            TrustCard(
              title: l10n.securityPrivacyTitle,
              trustPoints: [
                l10n.trust1,
                l10n.trust2,
              ],
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        text: isPermanent ? l10n.openSettings : l10n.grantPermission,
        icon: const Icon(Icons.check_rounded, size: 20),
        onPressed: () {
          controller.requestPhonePermission();
        },
      ),
    );
  }
}
