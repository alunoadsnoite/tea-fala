import 'package:shared_preferences/shared_preferences.dart';
import 'package:tea_fala/domain/entities/communication_entities.dart';

/// Use case para obter todas as categorias de comunicação.
class GetCategoriesUseCase {
  GetCategoriesUseCase(this._repository);

  final CommunicationRepository _repository;

  Future<List<CommunicationCategoryEntity>> call() async {
    // Converter do data model para domain entity
    final items = await _repository.getCategories();
    return items
        .map((item) => CommunicationCategoryEntity(
              id: item.id,
              labelKey: item.nameKey,
              emoji: item.emoji,
              order: item.order,
            ))
        .toList();
  }
}

/// Use case para obter itens de uma categoria específica.
class GetItemsByCategoryUseCase {
  GetItemsByCategoryUseCase(this._repository);

  final CommunicationRepository _repository;

  Future<List<CommunicationItemEntity>> call(String categoryId) async {
    final items = await _repository.getItemsByCategory(categoryId);
    return items
        .map((item) => CommunicationItemEntity(
              id: item.id,
              labelKey: item.id, // o id é usado como chave de tradução
              emoji: item.emoji,
              categoryId: item.categoryId,
              isFavorite: item.isFavorite,
              order: item.order,
            ))
        .toList();
  }
}

/// Use case para salvar um áudio personalizado para um item.
class SaveCustomAudioUseCase {
  SaveCustomAudioUseCase(this._repository);

  final CustomAudioRepository _repository;

  Future<void> call(String itemId, String filePath) async {
    await _repository.save(itemId, filePath);
  }
}

/// Use case para recuperar o caminho de um áudio personalizado.
class GetCustomAudioUseCase {
  GetCustomAudioUseCase(this._repository);

  final CustomAudioRepository _repository;

  Future<String?> call(String itemId) async {
    return await _repository.get(itemId);
  }
}

/// Use case para excluir um áudio personalizado.
class DeleteCustomAudioUseCase {
  DeleteCustomAudioUseCase(this._repository);

  final CustomAudioRepository _repository;

  Future<void> call(String itemId) async {
    await _repository.remove(itemId);
  }
}

/// Use case para excluir gravações legadas.
class DeleteLegacyRecordingsUseCase {
  DeleteLegacyRecordingsUseCase(this._repository);

  final CustomAudioRepository _repository;

  Future<void> call() async {
    await _repository.deleteLegacyRecordings();
  }
}

/// Use case para contatar o desenvolvedor via e-mail.
class ContactDeveloperUseCase {
  ContactDeveloperUseCase(this._repository);

  final ContactRepository _repository;

  Future<bool> call() async {
    return await _repository.contactDeveloper();
  }
}

/// Use case para alternar o modo somente imagens.
class ToggleImagesOnlyModeUseCase {
  ToggleImagesOnlyModeUseCase(this._prefs);

  final SharedPreferences _prefs;

  static const String _key = 'images_only_mode';

  Future<bool> call(bool currentValue) async {
    final newValue = !currentValue;
    await _prefs.setBool(_key, newValue);
    return newValue;
  }
}

/// Use case para obter o modo somente imagens salvo.
class GetImagesOnlyModeUseCase {
  GetImagesOnlyModeUseCase(this._prefs);

  final SharedPreferences _prefs;

  static const String _key = 'images_only_mode';

  bool call() {
    return _prefs.getBool(_key) ?? false;
  }
}

/// Repositório abstrato para categorias e itens de comunicação.
abstract class CommunicationRepository {
  Future<List<CommunicationCategoryData>> getCategories();
  Future<List<CommunicationItemData>> getItemsByCategory(String categoryId);
}

/// Dados de categoria (data transfer object).
class CommunicationCategoryData {
  final String id;
  final String nameKey;
  final String emoji;
  final int order;

  CommunicationCategoryData({
    required this.id,
    required this.nameKey,
    required this.emoji,
    this.order = 0,
  });
}

/// Dados de item de comunicação (data transfer object).
class CommunicationItemData {
  final String id;
  final String label;
  final String emoji;
  final String ttsText;
  final String categoryId;
  final bool isFavorite;
  final int order;

  CommunicationItemData({
    required this.id,
    required this.label,
    required this.emoji,
    required this.ttsText,
    required this.categoryId,
    this.isFavorite = false,
    this.order = 0,
  });
}

/// Repositório abstrato para áudios personalizados.
abstract class CustomAudioRepository {
  Future<String?> get(String itemId);
  Future<void> save(String itemId, String filePath);
  Future<void> remove(String itemId);
  Future<void> deleteLegacyRecordings();
}

/// Repositório abstrato para contato com desenvolvedor.
abstract class ContactRepository {
  Future<bool> contactDeveloper();
}
