/// Modelo de um item de comunicação (ícone + rótulo + áudio).
class ItemComunicacao {
  final String id;
  final String rotulo;
  final String emoji;
  final String fraseAudio; // texto que será falado pelo TTS
  final String categoriaId;
  final bool favorito;
  final int ordem;

  ItemComunicacao({
    required this.id,
    required this.rotulo,
    required this.emoji,
    required this.fraseAudio,
    required this.categoriaId,
    this.favorito = false,
    this.ordem = 0,
  });

  /// Converte para mapa (armazenamento local).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rotulo': rotulo,
      'emoji': emoji,
      'fraseAudio': fraseAudio,
      'categoriaId': categoriaId,
      'favorito': favorito ? 1 : 0,
      'ordem': ordem,
    };
  }

  /// Cria a partir de um mapa.
  factory ItemComunicacao.fromMap(Map<String, dynamic> map) {
    return ItemComunicacao(
      id: map['id'] as String,
      rotulo: map['rotulo'] as String,
      emoji: map['emoji'] as String,
      fraseAudio: map['fraseAudio'] as String,
      categoriaId: map['categoriaId'] as String,
      favorito: (map['favorito'] as int) == 1,
      ordem: map['ordem'] as int,
    );
  }
}
