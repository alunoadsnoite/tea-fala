import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tema: claro, escuro ou automático (sistema).
enum AppThemeMode { light, dark, system }

/// Serviço de tema com persistência e inicialização defensiva.
class ThemeService {
  ThemeService._();
  static final ThemeService instance = ThemeService._();

  SharedPreferences? _prefs;
  static const String _key = 'app_theme_mode';

  AppThemeMode _mode = AppThemeMode.system;

  AppThemeMode get mode => _mode;

  /// Inicializa sem lançar exceção. Se falhar, mantém o padrão (sistema).
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final value = _prefs!.getInt(_key);
      if (value != null) {
        _mode = AppThemeMode.values.firstWhere(
          (e) => e.index == value,
          orElse: () => AppThemeMode.system,
        );
      }
    } catch (e) {
      debugPrint('ThemeService.init falhou (não crítico): $e');
    }
  }

  /// Salva o modo selecionado.
  Future<void> setMode(AppThemeMode mode) async {
    _mode = mode;
    try {
      await _prefs?.setInt(_key, mode.index);
    } catch (e) {
      debugPrint('ThemeService.setMode falhou: $e');
    }
  }

  /// Retorna o [ThemeMode] do Flutter com base no modo salvo.
  ThemeMode get flutterThemeMode {
    switch (_mode) {
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
