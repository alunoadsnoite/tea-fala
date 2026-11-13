// Repositório de comunicação: dados estáticos de itens e categorias.
// Em uma versão futura, isso poderia vir de um banco local ou JSON.
import 'package:tea_fala/data/models/communication_item.dart';

class CommunicationRepository {
  CommunicationRepository._();
  static final CommunicationRepository instance = CommunicationRepository._();

  final List<CommunicationCategory> _categories = const [
    CommunicationCategory(id: 'necessidades', nameKey: 'needs', emoji: '🍽️', order: 1),
    CommunicationCategory(id: 'pessoas', nameKey: 'people', emoji: '👥', order: 2),
    CommunicationCategory(id: 'emocoes', nameKey: 'emotions', emoji: '❤️', order: 3),
    CommunicationCategory(id: 'lugares', nameKey: 'places', emoji: '📍', order: 4),
    CommunicationCategory(id: 'acoes', nameKey: 'actions', emoji: '🏃‍♂️', order: 5),
  ];

  final List<CommunicationItem> _items = const [
    // Necessidades
    CommunicationItem(id: 'fome', label: 'Tenho fome', emoji: '🍎', ttsText: 'Tenho fome', categoryId: 'necessidades', order: 1),
    CommunicationItem(id: 'sede', label: 'Tenho sede', emoji: '💧', ttsText: 'Tenho sede', categoryId: 'necessidades', order: 2),
    CommunicationItem(id: 'banheiro', label: 'Vou ao banheiro', emoji: '🚽', ttsText: 'Vou ao banheiro', categoryId: 'necessidades', order: 3),
    CommunicationItem(id: 'sono', label: 'Estou com sono', emoji: '😴', ttsText: 'Estou com sono', categoryId: 'necessidades', order: 4),
    CommunicationItem(id: 'doenca', label: 'Sinto dor', emoji: '🤕', ttsText: 'Sinto dor', categoryId: 'necessidades', order: 5),
    CommunicationItem(id: 'frio', label: 'Estou com frio', emoji: '🧣', ttsText: 'Estou com frio', categoryId: 'necessidades', order: 6),
    CommunicationItem(id: 'calor', label: 'Estou com calor', emoji: '☀️', ttsText: 'Estou com calor', categoryId: 'necessidades', order: 7),

    // Pessoas
    CommunicationItem(id: 'mae', label: 'Mãe', emoji: '👩', ttsText: 'Mãe', categoryId: 'pessoas', order: 1),
    CommunicationItem(id: 'pai', label: 'Pai', emoji: '👨', ttsText: 'Pai', categoryId: 'pessoas', order: 2),
    CommunicationItem(id: 'avo', label: 'Vovó', emoji: '👵', ttsText: 'Vovó', categoryId: 'pessoas', order: 3),
    CommunicationItem(id: 'professor', label: 'Professor', emoji: '👩‍🏫', ttsText: 'Professor', categoryId: 'pessoas', order: 4),
    CommunicationItem(id: 'amigo', label: 'Amigo', emoji: '👦', ttsText: 'Amigo', categoryId: 'pessoas', order: 5),

    // Emoções
    CommunicationItem(id: 'feliz', label: 'Estou feliz', emoji: '😊', ttsText: 'Estou feliz', categoryId: 'emocoes', order: 1),
    CommunicationItem(id: 'triste', label: 'Estou triste', emoji: '😢', ttsText: 'Estou triste', categoryId: 'emocoes', order: 2),
    CommunicationItem(id: 'bravo', label: 'Estou bravo', emoji: '😠', ttsText: 'Estou bravo', categoryId: 'emocoes', order: 3),
    CommunicationItem(id: 'assustado', label: 'Estou assustado', emoji: '😨', ttsText: 'Estou assustado', categoryId: 'emocoes', order: 4),
    CommunicationItem(id: 'calmo', label: 'Estou calmo', emoji: '😌', ttsText: 'Estou calmo', categoryId: 'emocoes', order: 5),
    CommunicationItem(id: 'confuso', label: 'Estou confuso', emoji: '😕', ttsText: 'Estou confuso', categoryId: 'emocoes', order: 6),

    // Lugares
    CommunicationItem(id: 'casa', label: 'Casa', emoji: '🏠', ttsText: 'Casa', categoryId: 'lugares', order: 1),
    CommunicationItem(id: 'escola', label: 'Escola', emoji: '🏫', ttsText: 'Escola', categoryId: 'lugares', order: 2),
    CommunicationItem(id: 'medico', label: 'Médico', emoji: '🏥', ttsText: 'Médico', categoryId: 'lugares', order: 3),
    CommunicationItem(id: 'parque', label: 'Parque', emoji: '🌳', ttsText: 'Parque', categoryId: 'lugares', order: 4),
    CommunicationItem(id: 'loja', label: 'Loja', emoji: '🛒', ttsText: 'Loja', categoryId: 'lugares', order: 5),

    // Ações
    CommunicationItem(id: 'parar', label: 'Pare', emoji: '🛑', ttsText: 'Pare', categoryId: 'acoes', order: 1),
    CommunicationItem(id: 'ajuda', label: 'Quero ajuda', emoji: '🆘', ttsText: 'Quero ajuda', categoryId: 'acoes', order: 2),
    CommunicationItem(id: 'brincar', label: 'Quero brincar', emoji: '🧸', ttsText: 'Quero brincar', categoryId: 'acoes', order: 3),
    CommunicationItem(id: 'sentar', label: 'Quero sentar', emoji: '🪑', ttsText: 'Quero sentar', categoryId: 'acoes', order: 4),
    CommunicationItem(id: 'levante', label: 'Quero andar', emoji: '🚶', ttsText: 'Quero andar', categoryId: 'acoes', order: 5),
    CommunicationItem(id: 'terminou', label: 'Terminei', emoji: '✅', ttsText: 'Terminei', categoryId: 'acoes', order: 6),
  ];

  List<CommunicationCategory> get categories =>
      List<CommunicationCategory>.from(_categories)
        ..sort((a, b) => a.order.compareTo(b.order));

  List<CommunicationItem> itemsByCategory(String categoryId) {
    return _items.where((i) => i.categoryId == categoryId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }
}
