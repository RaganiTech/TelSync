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
    final initialChar = displayName.trim().isNotEmpty ? displayName.trim().characters.first : '؟';
    final activeColor = badgeColor ?? theme.colorScheme.primary;

    return Card(
      elevation: isSelected ? 2 : 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? activeColor.withValues(alpha: 0.8)
              : theme.colorScheme.outline.withValues(alpha: 0.5),
          width: isSelected ? 1.6 : 1.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onSelectedChanged != null ? () => onSelectedChanged!(!isSelected) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Contact Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: isSelected
                    ? activeColor.withValues(alpha: 0.15)
                    : theme.colorScheme.surfaceContainerHighest ?? Colors.grey.shade200,
                child: Text(
                  initialChar,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? activeColor : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Contact Name & Phone
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
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isMissingName
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (onEditName != null) ...[
                          const SizedBox(width: 4),
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
                    const SizedBox(height: 4),
                    Text(
                      phoneNumber,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                    if (badgeText != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: activeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: activeColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          badgeText!,
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: activeColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Selection Checkbox
              if (onSelectedChanged != null)
                Transform.scale(
                  scale: 1.1,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onSelectedChanged,
                    activeColor: activeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
