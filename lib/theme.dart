import 'package:flutter/material.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';

class AppTheme {
  static ThemeData buildTheme(ThemeMode mode) {
    final isLight = mode == ThemeMode.light;

    return ThemeData(
      brightness: isLight ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: ColorRepository.getColor(
        ColorName.primaryColor,
        mode,
      ),
      primaryColor: ColorRepository.getColor(
        ColorName.specialColor,
        mode,
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: ColorRepository.getColor(
            ColorName.textColor,
            mode,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: ColorRepository.getColor(
            ColorName.secondaryTextColor,
            mode,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorRepository.getColor(
              ColorName.brownTextColor,
              mode,
            ),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorRepository.getColor(
              ColorName.specialColor,
              mode,
            ),
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ColorRepository.getColor(
          ColorName.specialColor,
          mode,
        ),
        selectionColor: ColorRepository.getColor(
          ColorName.transpSpecialColor,
          mode,
        ),
        selectionHandleColor: ColorRepository.getColor(
          ColorName.specialColor,
          mode,
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: ColorRepository.getColor(
          ColorName.white,
          mode,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ColorRepository.getColor(
            ColorName.textColor,
            mode,
          ),
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          color: ColorRepository.getColor(
            ColorName.secondaryTextColor,
            mode,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (states) => ColorRepository.getColor(
              ColorName.transpSpecialColor,
              mode,
            ),
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) => ColorRepository.getColor(
              ColorName.textColor,
              mode,
            ),
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) => const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
