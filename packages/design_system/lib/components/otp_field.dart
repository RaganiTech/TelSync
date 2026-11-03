import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';

class OtpField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final int length;

  const OtpField({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    this.length = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLength: length,
      style: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.displaySize,
        letterSpacing: 12.0,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        counterText: '',
        hintText: '•' * length,
        hintStyle: TextStyle(
          color: theme.colorScheme.outline,
          letterSpacing: 12.0,
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
      onSubmitted: onSubmitted,
      onChanged: onChanged,
    );
  }
}
