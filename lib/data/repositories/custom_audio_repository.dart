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

  /// Salva/atualiza o áudio personalizado de um item.
  Future<void> save(String itemId, String path) async {
    final map = await _load();
    map[itemId] = path;
    final prefs = await _getPrefs();
    await prefs.setString(_key, jsonEncode(map));
  }

  /// Remove o áudio personalizado de um item.
  Future<void> remove(String itemId) async {
    final map = await _load();
    if (map.remove(itemId) != null) {
      final prefs = await _getPrefs();
      await prefs.setString(_key, jsonEncode(map));
    }
  }

  /// Retorna o caminho do áudio personalizado (ou null).
  Future<String?> get(String itemId) async {
    final map = await _load();
    return map[itemId];
  }

  /// Verifica se o item tem áudio personalizado.
  Future<bool> has(String itemId) async {
    final map = await _load();
    return map.containsKey(itemId);
  }
}
