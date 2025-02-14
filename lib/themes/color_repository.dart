import 'package:flutter/material.dart';

enum ColorName {
  white,
  primaryColor,
  secondaryColor,
  textColor,
  secondaryTextColor,
  specialColor,
  transpSpecialColor,
  brownTextColor,
  barColor,
}

class ColorRepository {
  static final _lightColors = {
    ColorName.white: const Color(0xFFFFFFFF),
    ColorName.primaryColor: const Color(0xFFFEF5EF),
    ColorName.secondaryColor: const Color.fromARGB(255, 255, 248, 229),
    ColorName.textColor: const Color(0xFF595959),
    ColorName.secondaryTextColor: const Color(0xFF919190),
    ColorName.specialColor: const Color(0xFFFF8370),
    ColorName.transpSpecialColor: const Color.fromARGB(50, 255, 131, 112),
    ColorName.brownTextColor: const Color(0xFFA52A2A),
    ColorName.barColor: const Color(0xFFEAE1DB),
  };

  static final _darkColors = {
    ColorName.white: const Color(0xFF474747),
    ColorName.primaryColor: const Color(0xFF212121),
    ColorName.secondaryColor: const Color(0xFF303030),
    ColorName.textColor: const Color(0xFFEEEEEE),
    ColorName.secondaryTextColor: const Color(0xFFBDBDBD),
    ColorName.specialColor: const Color(0xFFC85329),
    ColorName.transpSpecialColor: const Color.fromARGB(50, 200, 83, 41),
    ColorName.brownTextColor: const Color(0xFF8B4513),
    ColorName.barColor: const Color(0xFF3C3C3C),
  };

  static Color getColor(ColorName colorName, ThemeMode themeMode) {
    final selectedTheme =
        themeMode == ThemeMode.light ? _lightColors : _darkColors;
    return selectedTheme[colorName] ?? Colors.transparent;
  }

  static Color getOppositeColor(ColorName colorName, ThemeMode themeMode) {
    final oppositeTheme =
        themeMode == ThemeMode.light ? _darkColors : _lightColors;
    return oppositeTheme[colorName] ?? Colors.transparent;
  }
}
