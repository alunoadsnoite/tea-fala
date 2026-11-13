import 'package:flutter/material.dart';

/// Core services are initialized lazily and defensively.
/// If a native plugin fails, the app continues working.

final class AppTheme {
  AppTheme._();
  static const Color seedColor = Color(0xFF7B61FF);

  static ThemeData lightTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
      );

  static ThemeData darkTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      );
}
