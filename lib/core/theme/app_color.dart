import 'package:flutter/material.dart';

/// Typed theme extension providing semantic color access throughout the app.
///
/// Usage: `Theme.of(context).extension<AppColorScheme>()!`
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color background;
  final Color primaryGreen;
  final Color sageLight;
  final Color gold;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color card;
  final Color inputFill;
  final Color appBarBackground;
  final Color error;
  final Color success;
  final Color onPrimary;

  const AppColorScheme({
    required this.background,
    required this.primaryGreen,
    required this.sageLight,
    required this.gold,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.card,
    required this.inputFill,
    required this.appBarBackground,
    required this.error,
    required this.success,
    required this.onPrimary,
  });

  @override
  AppColorScheme copyWith({
    Color? background,
    Color? primaryGreen,
    Color? sageLight,
    Color? gold,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? card,
    Color? inputFill,
    Color? appBarBackground,
    Color? error,
    Color? success,
    Color? onPrimary,
  }) {
    return AppColorScheme(
      background: background ?? this.background,
      primaryGreen: primaryGreen ?? this.primaryGreen,
      sageLight: sageLight ?? this.sageLight,
      gold: gold ?? this.gold,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      card: card ?? this.card,
      inputFill: inputFill ?? this.inputFill,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      error: error ?? this.error,
      success: success ?? this.success,
      onPrimary: onPrimary ?? this.onPrimary,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      background: Color.lerp(background, other.background, t)!,
      primaryGreen: Color.lerp(primaryGreen, other.primaryGreen, t)!,
      sageLight: Color.lerp(sageLight, other.sageLight, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      card: Color.lerp(card, other.card, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      appBarBackground:
          Color.lerp(appBarBackground, other.appBarBackground, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
    );
  }

  /// Light color scheme instance.
  static const light = AppColorScheme(
    background: Color(0xFFF7F4ED),
    primaryGreen: Color(0xFF8FA28A),
    sageLight: Color(0xFFC7D3C0),
    gold: Color(0xFFC8A96B),
    textPrimary: Color(0xFF2C2C2C),
    textSecondary: Color(0xFF6E6E6E),
    border: Color(0xFFE4E1D8),
    card: Color(0xFFFFFFFF),
    inputFill: Color(0xFFEFEDE5),
    appBarBackground: Color(0xFFEDEAE0),
    error: Color(0xFFD84040),
    success: Color(0xFF4CAF50),
    onPrimary: Color(0xFFFFFFFF),
  );

  /// Dark color scheme instance.
  static const dark = AppColorScheme(
    background: Color(0xFF1B1D19),
    primaryGreen: Color(0xFF8FA28A),
    sageLight: Color(0xFF3A3C35),
    gold: Color(0xFFC8A96B),
    textPrimary: Color(0xFFF2F0E8),
    textSecondary: Color(0xFFA8A79E),
    border: Color(0xFF3A3C35),
    card: Color(0xFF2A2C26),
    inputFill: Color(0xFF1F211C),
    appBarBackground: Color(0xFF2A2C26),
    error: Color(0xFFEF5350),
    success: Color(0xFF66BB6A),
    onPrimary: Color(0xFFFFFFFF),
  );
}
