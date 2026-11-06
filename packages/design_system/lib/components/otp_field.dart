import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';

class PersianToEnglishDigitsFormatter extends TextInputFormatter {
  final int? maxLength;
  const PersianToEnglishDigitsFormatter({this.maxLength});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    const pDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const aDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String text = newValue.text;
    for (int i = 0; i < 10; i++) {
      text = text.replaceAll(pDigits[i], '$i').replaceAll(aDigits[i], '$i');
    }
    String filtered = text.replaceAll(RegExp(r'\D'), '');
    if (maxLength != null && filtered.length > maxLength!) {
      filtered = filtered.substring(0, maxLength!);
    }
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

class OtpField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final int length;
  final bool initialObscure;

  const OtpField({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    this.length = 5,
    this.initialObscure = true,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.initialObscure;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLength: widget.length,
      autofocus: true,
      obscureText: _obscured,
      obscuringCharacter: '•',
      cursorColor: theme.colorScheme.primary,
      style: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.displaySize,
        letterSpacing: 14.0,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
      inputFormatters: [
        PersianToEnglishDigitsFormatter(maxLength: widget.length),
      ],
      decoration: InputDecoration(
        counterText: '',
        hintText: '•' * widget.length,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.black26,
          letterSpacing: 14.0,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        suffixIcon: IconButton(
          icon: Icon(
            _obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 22,
          ),
          tooltip: _obscured ? 'نمایش کد' : 'مخفی کردن کد',
          onPressed: () {
            setState(() {
              _obscured = !_obscured;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
      onSubmitted: widget.onSubmitted,
      onChanged: (val) {
        widget.onChanged?.call(val);
        if (val.length == widget.length && widget.onSubmitted != null) {
          widget.onSubmitted!(val);
        }
      },
    );
  }
}
