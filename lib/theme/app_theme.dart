import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1B9AAA);
  static const Color bg = Color(0xFFF6F7FB);
  static const Color dark = Color(0xFF0F172A);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.w800),
      titleLarge: TextStyle(fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}