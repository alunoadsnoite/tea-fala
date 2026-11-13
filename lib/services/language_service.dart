import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gerencia o idioma do aplicativo.
class LanguageService {
  static const String _languageCodeKey = 'app_language_code';

  // Idiomas suportados: código, nome exibido
  static const Map<String, String> supportedLanguages = {
    'pt': 'Português',
    'en': 'English',
    'es': 'Español',
  };

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('LanguageService não inicializado. Chame init() primeiro.');
    }
    return _prefs!;
  }

  /// Retorna o código do idioma salvo (padrão: pt).
  String get languageCode {
    return prefs.getString(_languageCodeKey) ?? 'pt';
  }

  /// Salva o código do idioma.
  Future<void> setLanguageCode(String code) async {
    await prefs.setString(_languageCodeKey, code);
  }

  /// Retorna o Locale atual baseado no código salvo.
  Locale get locale {
    switch (languageCode) {
      case 'en':
        return const Locale('en', 'US');
      case 'es':
        return const Locale('es', 'ES');
      case 'pt':
      default:
        return const Locale('pt', 'BR');
    }
  }

  /// Retorna o nome exibido do idioma atual.
  String get currentLanguageName {
    return supportedLanguages[languageCode] ?? 'Português';
  }
}
