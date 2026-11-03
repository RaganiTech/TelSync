import 'package:flutter/material.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';

class ContactTile extends StatelessWidget {
  final String displayName;
  final String phoneNumber;
  final String? badgeText;
  final Color? badgeColor;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectedChanged;
  final VoidCallback? onEditName;
  final bool isMissingName;
  final String? subtitle;

  const ContactTile({
    super.key,
    required this.displayName,
    required this.phoneNumber,
    this.badgeText,
    this.badgeColor,
    required this.isSelected,
    this.onSelectedChanged,
    this.onEditName,
    this.isMissingName = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space12,
          vertical: AppDimensions.space8,
        ),
        child: Row(
          children: [
            if (onSelectedChanged != null)
              Checkbox(
                value: isSelected,
                onChanged: onSelectedChanged,
                activeColor: theme.colorScheme.primary,
              ),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          isMissingName ? '(بدون نام)' : displayName,
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: AppTypography.bodySize,
                            fontWeight: FontWeight.w600,
                            color: isMissingName
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onEditName != null) ...[
                        const SizedBox(width: AppDimensions.space4),
                        InkWell(
                          onTap: onEditName,
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppTypography.captionSize,
                      color: theme.colorScheme.onSurface.withOpacity(0.65),
                      fontFeatures: const [],
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: AppTypography.captionSize,
                        color: theme.colorScheme.onSurface.withOpacity(0.55),
                      ),
                    ),
                  ],
                  if (badgeText != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (badgeColor ?? theme.colorScheme.primary)
                            .withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusPill),
                        border: Border.all(
                          color: (badgeColor ?? theme.colorScheme.primary)
                              .withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        badgeText!,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: badgeColor ?? theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
