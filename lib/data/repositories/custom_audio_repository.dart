import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Repositório de áudios personalizados.
/// Guarda o mapeamento id do item -> caminho do arquivo de áudio gravado.
class CustomAudioRepository {
  CustomAudioRepository._();
  static final CustomAudioRepository instance = CustomAudioRepository._();

  static const String _key = 'custom_audio_paths';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Map<String, String>> _load() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  /// Recupera o caminho associado ao cartão em versões anteriores do app.
  Future<String?> get(String itemId) async {
    final map = await _load();
    return map[itemId];
  }
}
