import 'package:flutter/material.dart';

class AppColors {
  static dynamic of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? DarkColors : LightColors;
  }
}

class LightColors {
  static const Color background = Color(0xFFF7F4ED);
  static const Color primaryGreen = Color(0xFF8FA28A);
  static const Color appBarTitle = Color(0xFF51634E);
  static const Color sageLight = Color(0xFFC7D3C0);
  static const Color gold = Color(0xFFC8A96B);
  static const Color textSecondary = Color(0xFF444841);
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color border = Color(0xFFE4E1D8);
  static const Color card = Color(0xFFFFFFFF);
}

class DarkColors {
  static const Color background = Color(0xFF1B1D19);
  static const Color primaryGreen = Color(0xFF8FA28A);
  static const Color appBarTitle = Color(0xFFB8CCB2);
  static const Color sageLight = Color(0xFF3A3C35);
  static const Color gold = Color(0xFFC8A96B);
  static const Color textSecondary = Color(0xFFC4C8BF);
  static const Color textPrimary = Color(0xFFF2F0E8);
  static const Color border = Color(0xFF3A3C35);
  static const Color card = Color(0xFF2A2C26);
}
