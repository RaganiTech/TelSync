import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class S16AboutSheet extends StatelessWidget {
  const S16AboutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusSheetTop),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.about,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppTypography.titleSize,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: AppDimensions.space12),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),
            Text(
              l10n.aboutAppTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.bodySize,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              l10n.aboutDescription,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.captionSize,
                height: AppTypography.bodyHeight,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              l10n.aboutFooter,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            // Privacy & Security Section
            Container(
              padding: const EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.privacy_tip_rounded,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppDimensions.space8),
                      Text(
                        l10n.isPersian ? 'حریم خصوصی و امنیت' : 'Privacy & Security',
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: AppTypography.bodySize,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  _buildPrivacyItem(
                    context,
                    icon: Icons.phonelink_off_rounded,
                    title: l10n.isPersian ? 'بدون ارسال داده به سرور' : 'No data sent to servers',
                    subtitle: l10n.isPersian
                        ? 'تمام عملیات روی گوشی شما انجام می‌شود'
                        : 'All operations run locally on your device',
                  ),
                  _buildPrivacyItem(
                    context,
                    icon: Icons.shield_rounded,
                    title: l10n.isPersian ? 'مخاطبین موجود تغییر نمی‌کنند' : 'Existing contacts unchanged',
                    subtitle: l10n.isPersian
                        ? 'فقط مخاطبین جدید اضافه می‌شوند، هیچ‌یک حذف یا ویرایش نمی‌شوند'
                        : 'Only new contacts are added, none are deleted or modified',
                  ),
                  _buildPrivacyItem(
                    context,
                    icon: Icons.logout_rounded,
                    title: l10n.isPersian ? 'خروج خودکار از تلگرام' : 'Auto logout from Telegram',
                    subtitle: l10n.isPersian
                        ? 'نشست تلگرام در پایان کار به‌طور خودکار بسته می‌شود'
                        : 'Telegram session is automatically closed when finished',
                  ),
                  _buildPrivacyItem(
                    context,
                    icon: Icons.visibility_rounded,
                    title: l10n.isPersian ? 'پیش‌نمایش و تأیید کامل' : 'Full preview & confirmation',
                    subtitle: l10n.isPersian
                        ? 'قبل از ذخیره، فهرست کامل را می‌بینی و تأیید می‌کنی'
                        : 'You review and confirm the complete list before saving',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            InkWell(
              onTap: () async {
                final uri = Uri.parse('https://buymeacoffee.com/alireza');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D2418) : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.coffee_rounded,
                        color: Color(0xFFD97706),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.isPersian ? 'خرید قهوه برای توسعه‌دهنده ☕' : 'Buy developer a coffee ☕',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.isPersian
                                ? 'حمایت اختیاری از توسعه و نگهداری رایگان برنامه'
                                : 'Optional support for free development & maintenance',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 11,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
