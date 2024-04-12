import 'package:flutter/material.dart';

enum ColorName {
  white,
  primaryColor,
  secondaryColor,
  textColor,
  secondaryTextColor,
  specialColor,
  brownTextColor,
}

class ColorRepository {
  static final _lightColors = {
    ColorName.white: const Color(0xFFFFFFFF),
    ColorName.primaryColor: const Color(0xFFFEF5EF),
    ColorName.secondaryColor: const Color(0x00FFF8E5),
    ColorName.textColor: const Color(0xFF595959),
    ColorName.secondaryTextColor: const Color(0xFF919190),
    ColorName.specialColor: const Color(0xFFFF8370),
    ColorName.brownTextColor: const Color(0xFFA52A2A)
  };

  static final _darkColors = {
    ColorName.white: const Color(0xFF474747),
    ColorName.primaryColor: const Color(0xFF212121),
    ColorName.secondaryColor: const Color(0xFF303030),
    ColorName.textColor: const Color(0xFFEEEEEE),
    ColorName.secondaryTextColor: const Color(0xFFBDBDBD),
    ColorName.specialColor: const Color(0xFFC85329),
    ColorName.brownTextColor: const Color(0xFF8B4513)
  };

  static Color getColor(ColorName colorName, ThemeMode themeMode) {
    final selectedTheme = themeMode == ThemeMode.light ? _lightColors : _darkColors;
    return selectedTheme[colorName] ?? Colors.transparent;
  }
}
