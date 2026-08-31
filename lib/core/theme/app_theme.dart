import 'package:flutter/material.dart';
import 'package:path_app/core/theme/app_color.dart';
import 'package:path_app/core/theme/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    colors: AppColorScheme.light,
  );

  static ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    colors: AppColorScheme.dark,
  );

  /// Shared theme builder — eliminates duplication between light and dark.
  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppColorScheme colors,
  }) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      primaryColor: colors.primaryGreen,
      extensions: <ThemeExtension>[colors],

      // ── Typography ──
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.heading1(colors.textPrimary),
        headlineSmall: AppTextStyles.fieldLabel(colors.textPrimary),
        titleMedium: AppTextStyles.subtitle(colors.textSecondary),
        bodyMedium: AppTextStyles.body(colors.textPrimary),
        bodySmall: AppTextStyles.caption(colors.textSecondary),
        labelLarge: AppTextStyles.button(colors.onPrimary),
      ),

      // ── Cards ──
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.border),
        ),
      ),

      // ── Elevated Button ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryGreen,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.primaryGreen.withValues(alpha: 0.5),
          disabledForegroundColor: colors.onPrimary.withValues(alpha: 0.7),
          textStyle: AppTextStyles.button(colors.onPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),

      // ── Text Button (for "Log In" links etc.) ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryGreen,
          textStyle: AppTextStyles.body(colors.primaryGreen).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBarBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),

      // ── Input Fields ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputFill,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primaryGreen, width: 1.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        errorStyle: AppTextStyles.caption(colors.error),
        hintStyle: AppTextStyles.body(colors.textSecondary),
        prefixIconColor: colors.textSecondary,
      ),

      // ── Checkbox ──
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryGreen;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(colors.onPrimary),
        side: BorderSide(color: colors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── SnackBar ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.card,
        contentTextStyle: AppTextStyles.body(colors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.border),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // ── Divider ──
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
