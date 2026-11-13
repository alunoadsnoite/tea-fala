/// Item de comunicação (ícone + rótulo + texto para TTS).
class CommunicationItem {
  final String id;
  final String label;
  final String emoji;
  final String ttsText;
  final String categoryId;
  final bool isFavorite;
  final int order;

  const CommunicationItem({
    required this.id,
    required this.label,
    required this.emoji,
    required this.ttsText,
    required this.categoryId,
    this.isFavorite = false,
    this.order = 0,
  });

  CommunicationItem copyWith({
    String? id,
    String? label,
    String? emoji,
    String? ttsText,
    String? categoryId,
    bool? isFavorite,
    int? order,
  }) {
    return CommunicationItem(
      id: id ?? this.id,
      label: label ?? this.label,
      emoji: emoji ?? this.emoji,
      ttsText: ttsText ?? this.ttsText,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'emoji': emoji,
      'ttsText': ttsText,
      'categoryId': categoryId,
      'isFavorite': isFavorite ? 1 : 0,
      'order': order,
    };
  }

  factory CommunicationItem.fromMap(Map<String, dynamic> map) {
    return CommunicationItem(
      id: map['id'] as String,
      label: map['label'] as String,
      emoji: map['emoji'] as String,
      ttsText: map['ttsText'] as String,
      categoryId: map['categoryId'] as String,
      isFavorite: (map['isFavorite'] as int) == 1,
      order: map['order'] as int,
    );
  }
}

/// Categoria de comunicação.
class CommunicationCategory {
  final String id;
  final String nameKey; // chave de tradução
  final String emoji;
  final int order;

  const CommunicationCategory({
    required this.id,
    required this.nameKey,
    required this.emoji,
    this.order = 0,
  });
}
