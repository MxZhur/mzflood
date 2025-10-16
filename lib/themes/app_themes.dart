import 'package:flutter/material.dart';

abstract class AppThemes {
  static Color seedColor = Colors.teal;

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
  );
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ).copyWith(surface: Colors.black),
    brightness: Brightness.dark,
  );
}
