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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          side: BorderSide(
            color: Color(AppColors.borderLight),
            width: AppDimensions.hairlineBorder,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(AppColors.bgLight),
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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          side: BorderSide(
            color: Color(AppColors.borderDark),
            width: AppDimensions.hairlineBorder,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(AppColors.bgDark),
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
    );
  }

  const AppTheme._();
}
