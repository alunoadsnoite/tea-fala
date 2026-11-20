/// Entidade de domínio: item de comunicação.
/// Representa um ícone clicável com rótulo e texto para síntese de fala.
class CommunicationItemEntity {
  final String id;
  final String labelKey; // chave de tradução
  final String emoji;
  final String categoryId;
  final bool isFavorite;
  final int order;

  const CommunicationItemEntity({
    required this.id,
    required this.labelKey,
    required this.emoji,
    required this.categoryId,
    this.isFavorite = false,
    this.order = 0,
  });

  CommunicationItemEntity copyWith({
    String? id,
    String? labelKey,
    String? emoji,
    String? categoryId,
    bool? isFavorite,
    int? order,
  }) {
    return CommunicationItemEntity(
      id: id ?? this.id,
      labelKey: labelKey ?? this.labelKey,
      emoji: emoji ?? this.emoji,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      order: order ?? this.order,
    );
  }
}

/// Entidade de domínio: categoria de comunicação.
class CommunicationCategoryEntity {
  final String id;
  final String labelKey;
  final String emoji;
  final int order;

  const CommunicationCategoryEntity({
    required this.id,
    required this.labelKey,
    required this.emoji,
    this.order = 0,
  });
}

/// Entidade de domínio: áudio personalizado gravado pelo usuário.
class CustomAudioEntity {
  final String itemId;
  final String filePath;
  final DateTime createdAt;

  const CustomAudioEntity({
    required this.itemId,
    required this.filePath,
    required this.createdAt,
  });
}

/// Resultado de operação de gravação de áudio.
enum AudioRecordResult { success, permissionDenied, unavailable, error }

/// Estado da gravação.
enum AudioRecordState { idle, recording, paused }
