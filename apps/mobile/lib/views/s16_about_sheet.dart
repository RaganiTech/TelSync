import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';

class S16AboutSheet extends StatelessWidget {
  const S16AboutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
            Text(
              'Contact Bridge (نسخه ۲.۰)',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.bodySize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              'این برنامه برای انتقال امن و هوشمند مخاطبین تلگرام به دفترچه تلفن طراحی شده است و پایبند به اصول زیر است:\n\n'
              '۱. پردازش ۱۰۰٪ محلی درون دستگاه بدون سرور واسط.\n'
              '۲. دفترچه تلفن اصل حقیقت است؛ هیچ مخاطبی هرگز حذف یا ویرایش نمی‌شود.\n'
              '۳. نشست تلگرام در پایان به‌صورت سروری Logout شده و تمام کلیدها و پایگاه داده محلی پاکسازی می‌شوند.\n'
              '۴. محدودیت فراخوانی توابع TDLib بر اساس Allowlist سخت‌گیرانه برای عدم دسترسی به پیام‌ها، گروه‌ها و کانال‌ها.',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.captionSize,
                height: AppTypography.bodyHeight,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              'توسعه داده شده بر پایه استاندارد SRS v2.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
          ],
        ),
      ),
    );
  }
}
