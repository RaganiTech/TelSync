import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: Color(AppColors.primaryLight),
      onPrimary: Color(AppColors.onPrimaryLight),
      secondary: Color(AppColors.accentLight),
      surface: Color(AppColors.surfaceLight),
      error: Color(AppColors.dangerLight),
      outline: Color(AppColors.borderLight),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Color(AppColors.bgLight),
      fontFamily: AppTypography.fontFamily,
      cardTheme: CardThemeData(
        color: Color(AppColors.surfaceLight),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Color(AppColors.borderLight).withValues(alpha: 0.8),
            width: 1,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(AppColors.bgLight),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(AppColors.textLight)),
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: AppTypography.titleSize,
          fontWeight: FontWeight.w700,
          color: Color(AppColors.textLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(AppColors.borderLight)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(AppColors.borderLight)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(AppColors.primaryLight), width: 1.5),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: Color(AppColors.primaryDark),
      onPrimary: Color(AppColors.onPrimaryDark),
      secondary: Color(AppColors.accentDark),
      surface: Color(AppColors.surfaceDark),
      error: Color(AppColors.dangerDark),
      outline: Color(AppColors.borderDark),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Color(AppColors.bgDark),
      fontFamily: AppTypography.fontFamily,
      cardTheme: CardThemeData(
        color: Color(AppColors.surfaceDark),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Color(AppColors.borderDark),
            width: 1,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(AppColors.bgDark),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(AppColors.textDark)),
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: AppTypography.titleSize,
          fontWeight: FontWeight.w700,
          color: Color(AppColors.textDark),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(AppColors.surfaceAltDark),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(AppColors.borderDark)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(AppColors.borderDark)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(AppColors.primaryDark), width: 1.5),
        ),
      ),
    );
  }

  const AppTheme._();
}
