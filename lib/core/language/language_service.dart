import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Idiomas suportados: código, nome exibido e Locale.
enum AppLanguage { pt, en, es }

extension AppLanguageExtension on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.pt:
        return 'pt';
      case AppLanguage.en:
        return 'en';
      case AppLanguage.es:
        return 'es';
    }
  }

  String get name {
    switch (this) {
      case AppLanguage.pt:
        return 'Português';
      case AppLanguage.en:
        return 'English';
      case AppLanguage.es:
        return 'Español';
    }
  }

  Locale get locale {
    switch (this) {
      case AppLanguage.pt:
        return Locale('pt', 'BR');
      case AppLanguage.en:
        return Locale('en', 'US');
      case AppLanguage.es:
        return Locale('es', 'ES');
    }
  }
}

/// Serviço de idioma com persistência.
class LanguageService {
  LanguageService._();
  static final LanguageService instance = LanguageService._();

  SharedPreferences? _prefs;
  static const String _key = 'app_language_code';

  AppLanguage _language = AppLanguage.pt;

  AppLanguage get language => _language;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final value = _prefs!.getString(_key);
      if (value != null) {
        _language = AppLanguage.values.firstWhere(
          (e) => e.code == value,
          orElse: () => AppLanguage.pt,
        );
      }
    } catch (e) {
      debugPrint('LanguageService.init falhou (não crítico): $e');
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    try {
      await _prefs?.setString(_key, language.code);
    } catch (e) {
      debugPrint('LanguageService.setLanguage falhou: $e');
    }
  }
}
