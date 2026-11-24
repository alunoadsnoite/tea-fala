import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Modelo de uma frase usada no histórico.
class PhraseHistoryItem {
  final String id;
  final String text;
  final int useCount;
  final DateTime lastUsed;
  final String emoji;

  const PhraseHistoryItem({
    required this.id,
    required this.text,
    required this.useCount,
    required this.lastUsed,
    this.emoji = '💬',
  });

  PhraseHistoryItem copyWith({
    String? id,
    String? text,
    int? useCount,
    DateTime? lastUsed,
    String? emoji,
  }) {
    return PhraseHistoryItem(
      id: id ?? this.id,
      text: text ?? this.text,
      useCount: useCount ?? this.useCount,
      lastUsed: lastUsed ?? this.lastUsed,
      emoji: emoji ?? this.emoji,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'useCount': useCount,
      'lastUsed': lastUsed.millisecondsSinceEpoch,
      'emoji': emoji,
    };
  }

  factory PhraseHistoryItem.fromMap(Map<String, dynamic> map) {
    return PhraseHistoryItem(
      id: map['id'] as String,
      text: map['text'] as String,
      useCount: map['useCount'] as int,
      lastUsed: DateTime.fromMillisecondsSinceEpoch(map['lastUsed'] as int),
      emoji: map['emoji'] as String? ?? '💬',
    );
  }
}

/// Serviço de histórico de frases usadas.
/// Salva as frases que o usuário lê em voz alta para acesso rápido.
class PhraseHistoryService {
  PhraseHistoryService._();
  static final PhraseHistoryService instance = PhraseHistoryService._();

  static const String _key = 'phrase_history';
  static const int _maxItems = 50;

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Carrega todas as frases do histórico, ordenadas por uso.
  Future<List<PhraseHistoryItem>> getHistory() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (item) => PhraseHistoryItem.fromMap(item as Map<String, dynamic>),
          )
          .toList()
        ..sort((a, b) => b.useCount.compareTo(a.useCount));
    } catch (_) {
      return [];
    }
  }

  /// Adiciona ou atualiza uma frase no histórico.
  Future<void> addPhrase(String text, {String emoji = '💬'}) async {
    if (text.trim().isEmpty) return;
    final prefs = await _getPrefs();
    final history = await getHistory();

    final existingIndex = history.indexWhere((item) => item.text == text);
    final now = DateTime.now();

    if (existingIndex != -1) {
      // Atualizar frase existente
      final existing = history[existingIndex];
      history[existingIndex] = existing.copyWith(
        useCount: existing.useCount + 1,
        lastUsed: now,
        emoji: emoji,
      );
    } else {
      var candidate = now.microsecondsSinceEpoch;
      final usedIds = history.map((item) => item.id).toSet();
      while (usedIds.contains(candidate.toString())) {
        candidate++;
      }
      history.add(
        PhraseHistoryItem(
          id: candidate.toString(),
          text: text,
          useCount: 1,
          lastUsed: now,
          emoji: emoji,
        ),
      );

      // Manter apenas os _maxItems mais usados
      if (history.length > _maxItems) {
        history.sort((a, b) => b.useCount.compareTo(a.useCount));
        history.removeRange(_maxItems, history.length);
      }
    }

    await prefs.setString(
      _key,
      jsonEncode(history.map((i) => i.toMap()).toList()),
    );
  }

  /// Limpa todo o histórico.
  Future<void> clearHistory() async {
    final prefs = await _getPrefs();
    await prefs.remove(_key);
  }

  /// Remove uma frase específica do histórico.
  Future<void> removePhrase(String id) async {
    final history = await getHistory();
    history.removeWhere((item) => item.id == id);
    final prefs = await _getPrefs();
    await prefs.setString(
      _key,
      jsonEncode(history.map((i) => i.toMap()).toList()),
    );
  }
}
