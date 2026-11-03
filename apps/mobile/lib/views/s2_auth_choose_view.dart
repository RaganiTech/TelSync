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
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'روش ورود به تلگرام',
      showBackButton: true,
      onBack: () => controller.dispatch(const CancelFlowEvent()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space16),
            InfoBanner(
              message: l10n.loginNotice,
              type: BannerType.info,
            ),
            const SizedBox(height: AppDimensions.space16),

            // Method 1: Telegram on same phone (RECOMMENDED)
            _AuthOptionCard(
              title: 'ورود مستقیم با تلگرام همین گوشی',
              subtitle: 'تلگرام روی همین دستگاه باز شده و ورود با یک لمس تایید می‌شود (بدون نیاز به گوشی دوم یا اسکن).',
              badgeText: 'توصیه شده',
              icon: Icons.send_rounded,
              iconColor: const Color(AppColors.telegramBlue),
              isRecommended: true,
              onTap: () {
                controller.chooseAuthMethod(AuthMethod.qr);
              },
            ),

            const SizedBox(height: AppDimensions.space12),

            // Method 2: Phone number & OTP
            _AuthOptionCard(
              title: l10n.loginPhone,
              subtitle: 'شماره خود را وارد کرده و کد ارسال‌شده به تلگرام یا پیامک را ثبت کنید.',
              icon: Icons.phone_android_rounded,
              iconColor: theme.colorScheme.primary,
              onTap: () {
                controller.chooseAuthMethod(AuthMethod.phone);
              },
            ),

            const SizedBox(height: AppDimensions.space12),

            // Method 3: QR scan with 2nd device
            _AuthOptionCard(
              title: l10n.loginQr,
              subtitle: 'اگر تلگرام روی دستگاه دیگری باز است، با دوربین آن دستگاه بارکد را اسکن کنید.',
              icon: Icons.qr_code_scanner_rounded,
              iconColor: Colors.deepPurple,
              onTap: () {
                controller.chooseAuthMethod(AuthMethod.qr);
              },
            ),

            const SizedBox(height: AppDimensions.space24),

            // Instant Test Mode Bypass
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.science_outlined, color: Colors.amber.shade800, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'نمی‌خواهید وارد اکانت تلگرام شوید؟',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.startDemoMode();
                    },
                    child: Text(
                      'حالت تست',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }
}

class _AuthOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badgeText;
  final IconData icon;
  final Color iconColor;
  final bool isRecommended;
  final VoidCallback onTap;

  const _AuthOptionCard({
    required this.title,
    required this.subtitle,
    this.badgeText,
    required this.icon,
    required this.iconColor,
    this.isRecommended = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRecommended
                ? const Color(AppColors.telegramBlue).withValues(alpha: 0.8)
                : theme.colorScheme.outline.withValues(alpha: 0.6),
            width: isRecommended ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isRecommended
                  ? const Color(AppColors.telegramBlue).withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (badgeText != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(AppColors.telegramBlue),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badgeText!,
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 12,
                      height: 1.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_left_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
