import 'package:flutter/material.dart';
import 'package:path_app/core/theme/app_color.dart';
import 'package:path_app/core/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: LightColors.background,
    primaryColor: LightColors.primaryGreen,
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.heading1(Colors.black),
      bodyMedium: AppTextStyles.body(Colors.black),
    ),
    cardTheme: CardThemeData(
      color: LightColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: LightColors.border),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightColors.primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: LightColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: LightColors.textPrimary),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: DarkColors.background,
    primaryColor: DarkColors.primaryGreen,
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.heading1(Colors.white),
      bodyMedium: AppTextStyles.body(Colors.white),
    ),
    cardTheme: CardThemeData(
      color: DarkColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: DarkColors.border),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkColors.primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: DarkColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: DarkColors.textPrimary),
    ),
  );
}
