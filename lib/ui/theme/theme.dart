import 'package:flutter/material.dart';

const _primaryColor = Color(0xFFF82B10);

final lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: _primaryColor,
  scaffoldBackgroundColor: const Color(0xFFEFF1F3),
  textTheme: _textTheme,
  dividerTheme: DividerThemeData(
    color: Colors.grey.withOpacity(0.1),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primaryColor,
    brightness: Brightness.light,
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  primaryColor: _primaryColor,
  scaffoldBackgroundColor: Colors.black,
  textTheme: _textTheme,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primaryColor,
    brightness: Brightness.dark,
  ),
);

const _textTheme = TextTheme(
  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
);
