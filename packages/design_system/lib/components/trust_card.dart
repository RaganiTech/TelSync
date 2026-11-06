import 'package:flutter/material.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';

class TrustCard extends StatelessWidget {
  final String? title;
  final List<String> trustPoints;

  const TrustCard({
    super.key,
    this.title,
    required this.trustPoints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPersian = Localizations.localeOf(context).languageCode == 'fa';
    final resolvedTitle = title ??
        (isPersian
            ? 'تضمین امنیت و حریم خصوصی'
            : 'Security & Privacy Guaranteed');

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Text(
                    resolvedTitle,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppTypography.bodySize,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),
            ...trustPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.space8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green.shade600,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space8),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: AppTypography.captionSize + 1,
                            height: AppTypography.bodyHeight,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
