import 'package:flutter/material.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';

enum BannerType { info, warning, danger, success }

class InfoBanner extends StatelessWidget {
  final String message;
  final BannerType type;
  final Widget? trailing;

  const InfoBanner({
    super.key,
    required this.message,
    this.type = BannerType.info,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color bg;
    Color border;
    Color fg;
    IconData icon;

    switch (type) {
      case BannerType.warning:
        bg = Colors.amber.withOpacity(0.12);
        border = Colors.amber.shade700;
        fg = Colors.amber.shade900;
        icon = Icons.warning_amber_rounded;
        break;
      case BannerType.danger:
        bg = theme.colorScheme.error.withOpacity(0.12);
        border = theme.colorScheme.error;
        fg = theme.colorScheme.error;
        icon = Icons.error_outline_rounded;
        break;
      case BannerType.success:
        bg = Colors.green.withOpacity(0.12);
        border = Colors.green.shade700;
        fg = Colors.green.shade900;
        icon = Icons.check_circle_outline;
        break;
      case BannerType.info:
      default:
        bg = theme.colorScheme.primary.withOpacity(0.08);
        border = theme.colorScheme.primary.withOpacity(0.4);
        fg = theme.colorScheme.primary;
        icon = Icons.info_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.captionSize,
                height: AppTypography.bodyHeight,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
