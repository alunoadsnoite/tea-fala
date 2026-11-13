import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gerencia o tema do aplicativo (claro, escuro, automático).
class ThemeService {
  static const String _themeKey = 'app_theme_mode';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('ThemeService não inicializado. Chame init() primeiro.');
    }
    return _prefs!;
  }

  /// Retorna o modo de tema salvo (0=claro, 1=escuro, 2=automático).
  int get themeModeIndex {
    return prefs.getInt(_themeKey) ?? 0;
  }

  /// Salva o modo de tema.
  Future<void> setThemeMode(int index) async {
    await prefs.setInt(_themeKey, index);
  }

  /// Converte o índice para ThemeMode.
  ThemeMode get themeMode {
    switch (themeModeIndex) {
      case 1:
        return ThemeMode.dark;
      case 2:
        return ThemeMode.system;
      case 0:
      default:
        return ThemeMode.light;
    }
  }
}
