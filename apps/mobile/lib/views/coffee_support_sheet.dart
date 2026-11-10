import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';

/// Open-source developer support & Reymit / USDT widget
class SupportCoffeeCard extends StatelessWidget {
  final VoidCallback? onOtherWaysPressed;

  const SupportCoffeeCard({
    super.key,
    this.onOtherWaysPressed,
  });

  static const String reymitUrl = 'https://reymit.ir/raganitech';
  static const String tetherUsdtAddress = '0x9529b9c712E306Eaed6c852e93239499CEA973db';
  static const String githubRepoUrl = 'https://github.com/alireza00138300/TelSync';

  static Future<void> launchReymitUrl() async {
    final uri = Uri.parse(reymitUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> launchGithubUrl() async {
    final uri = Uri.parse(githubRepoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final cardBg = isDark ? const Color(0xFF261D12) : const Color(0xFFFFFBEB);
    final borderColor = isDark
        ? const Color(0xFFF59E0B).withValues(alpha: 0.35)
        : const Color(0xFFFDE68A);
    const accentAmber = Color(0xFFF59E0B);
    const darkAmber = Color(0xFFD97706);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accentAmber.withValues(alpha: isDark ? 0.08 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentAmber.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.coffee_rounded,
                  size: 24,
                  color: darkAmber,
                ),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.coffeeCardTitle,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: AppTypography.bodySize,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'RaganiTech · Open Source',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space12),
          Text(
            l10n.coffeeCardSubtitle,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppTypography.captionSize,
              height: 1.5,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          // Main Reymit Coffee Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5722),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.local_cafe_rounded, size: 20),
            label: Text(
              l10n.coffeeBuyAction,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: AppTypography.captionSize + 1,
              ),
            ),
            onPressed: launchReymitUrl,
          ),
          const SizedBox(height: AppDimensions.space8),
          // Secondary Options (USDT & GitHub)
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.amber.shade200 : darkAmber,
              side: BorderSide(
                color: accentAmber.withValues(alpha: 0.5),
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.favorite_outline_rounded, size: 18),
            label: Text(
              l10n.coffeeOtherWays,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: AppTypography.captionSize,
              ),
            ),
            onPressed: () {
              if (onOtherWaysPressed != null) {
                onOtherWaysPressed!();
              } else {
                CoffeeSupportSheet.show(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Modal Bottom Sheet offering multiple support options (Reymit, USDT Tether, GitHub Star)
class CoffeeSupportSheet extends StatelessWidget {
  final bool isExitPrompt;

  const CoffeeSupportSheet({
    super.key,
    this.isExitPrompt = false,
  });

  static Future<bool?> show(BuildContext context, {bool isExitPrompt = false}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CoffeeSupportSheet(isExitPrompt: isExitPrompt),
    );
  }

  static const String reymitUrl = SupportCoffeeCard.reymitUrl;
  static const String tetherAddress = SupportCoffeeCard.tetherUsdtAddress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusSheetTop),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space20,
        AppDimensions.space12,
        AppDimensions.space20,
        AppDimensions.space24,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.space16),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFD97706),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isExitPrompt ? l10n.coffeeExitPromptTitle : l10n.coffeeCardTitle,
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: AppTypography.titleSize,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'TelSync · RaganiTech',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space12),
              Text(
                isExitPrompt ? l10n.coffeeExitPromptBody : l10n.coffeeCardSubtitle,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppTypography.captionSize,
                  height: 1.6,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppDimensions.space20),
              // Option 1: Rial Payment via Reymit
              _buildOptionTile(
                context,
                icon: Icons.local_cafe_rounded,
                iconBg: const Color(0xFFFF5722).withValues(alpha: 0.15),
                iconColor: const Color(0xFFE64A19),
                title: l10n.isPersian ? 'پرداخت ریالی آنلاین (ریمیت / شتاب)' : 'Rial Online Payment (Reymit)',
                subtitle: 'reymit.ir/raganitech',
                trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                onTap: SupportCoffeeCard.launchReymitUrl,
              ),
              const SizedBox(height: AppDimensions.space12),
              // Option 2: Dollar / Crypto Payment (Tether USDT - Trust Wallet)
              _buildCryptoTetherTile(context),
              const SizedBox(height: AppDimensions.space12),
              // Option 3: GitHub Star
              _buildOptionTile(
                context,
                icon: Icons.star_rounded,
                iconBg: Colors.amber.withValues(alpha: 0.15),
                iconColor: Colors.amber.shade700,
                title: l10n.coffeeGitHubStar,
                subtitle: 'github.com/alireza00138300/TelSync',
                trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                onTap: SupportCoffeeCard.launchGithubUrl,
              ),
              const SizedBox(height: AppDimensions.space24),
              // Exit or Dismiss Button
              if (isExitPrompt)
                PrimaryButton(
                  text: l10n.coffeeExitDismiss,
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                )
              else
                SecondaryButton(
                  text: l10n.isPersian ? 'بستن' : 'Close',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppTypography.captionSize + 1,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoTetherTile(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    const tetherGreen = Color(0xFF26A17B);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C241F) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: tetherGreen.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tetherGreen.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.currency_exchange_rounded,
                  color: tetherGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.coffeeCardPaymentTitle,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: AppTypography.captionSize + 1,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.isPersian
                          ? 'تراست ولت · شبکه‌های BSC (BEP-20) / ERC-20 / Polygon'
                          : 'Trust Wallet · BSC (BEP-20) / ERC-20 / Polygon',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 11,
                        color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF166534),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF061411) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF134E48) : const Color(0xFFBBF7D0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    tetherAddress,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.coffeeCopyCardNumber,
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: tetherAddress));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.coffeeCardCopiedNotice),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
