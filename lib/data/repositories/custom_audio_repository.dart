import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

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

  /// Remove gravações do recurso antigo, inclusive arquivos sem cartão associado.
  Future<void> deleteLegacyRecordings() async {
    final directory = await getApplicationDocumentsDirectory();
    final recordingName = RegExp(r'^tea_fala_[0-9]+[.]m4a$');
    await for (final entry in directory.list(followLinks: false)) {
      final name = entry.uri.pathSegments.last;
      if (entry is File && recordingName.hasMatch(name)) {
        await entry.delete();
      }
    }
    final prefs = await _getPrefs();
    if (!await prefs.remove(_key)) {
      throw StateError('Não foi possível apagar as referências dos áudios.');
    }
  }

  /// Recupera o caminho associado ao cartão em versões anteriores do app.
  Future<String?> get(String itemId) async {
    final map = await _load();
    return map[itemId];
  }
}
