import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de armazenamento local (SharedPreferences) para preferências do app.
class StorageService {
  static const String _favoritosKey = 'favoritos';
  static const String _categoriasOrdemKey = 'categorias_ordem';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('StorageService não inicializado. Chame init() primeiro.');
    }
    return _prefs!;
  }

  /// Retorna os IDs dos itens favoritos.
  List<String> getFavoritos() {
    return prefs.getStringList(_favoritosKey) ?? [];
  }

  /// Salva a lista de IDs favoritos.
  Future<void> salvarFavoritos(List<String> ids) async {
    await prefs.setStringList(_favoritosKey, ids);
  }

  /// Adiciona ou remove um item dos favoritos.
  Future<void> toggleFavorito(String id) async {
    final favoritos = getFavoritos();
    if (favoritos.contains(id)) {
      favoritos.remove(id);
    } else {
      favoritos.add(id);
    }
    await salvarFavoritos(favoritos);
  }

  /// Verifica se um item é favorito.
  bool isFavorito(String id) {
    return getFavoritos().contains(id);
  }

  /// Retorna a ordem customizada das categorias (IDs).
  List<String> getCategoriasOrdem() {
    return prefs.getStringList(_categoriasOrdemKey) ?? [];
  }

  /// Salva a ordem customizada das categorias.
  Future<void> salvarCategoriasOrdem(List<String> ids) async {
    await prefs.setStringList(_categoriasOrdemKey, ids);
  }
}
