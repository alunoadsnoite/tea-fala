/// Modelo de uma categoria de comunicação.
class Categoria {
  final String id;
  final String nome;
  final String emoji;
  final int ordem;

  Categoria({
    required this.id,
    required this.nome,
    required this.emoji,
    this.ordem = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'emoji': emoji,
      'ordem': ordem,
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'] as String,
      nome: map['nome'] as String,
      emoji: map['emoji'] as String,
      ordem: map['ordem'] as int,
    );
  }
}
