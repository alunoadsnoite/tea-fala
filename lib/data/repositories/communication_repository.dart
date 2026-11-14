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
    CommunicationItem(
      id: 'descanso',
      label: "Quero uma pausa",
      emoji: '⏸️',
      ttsText: "Quero uma pausa",
      categoryId: 'necessidades',
      order: 8,
    ),
    CommunicationItem(
      id: 'silencio',
      label: "Quero silêncio",
      emoji: '🤫',
      ttsText: "Quero silêncio",
      categoryId: 'necessidades',
      order: 9,
    ),
    CommunicationItem(
      id: 'menos_luz',
      label: "Quero menos luz",
      emoji: '🔅',
      ttsText: "Quero menos luz",
      categoryId: 'necessidades',
      order: 10,
    ),
    CommunicationItem(
      id: 'espaco',
      label: "Preciso de espaço",
      emoji: '↔️',
      ttsText: "Preciso de espaço",
      categoryId: 'necessidades',
      order: 11,
    ),
    CommunicationItem(
      id: 'enjoo',
      label: "Estou com enjoo",
      emoji: '🤢',
      ttsText: "Estou com enjoo",
      categoryId: 'necessidades',
      order: 12,
    ),

    // Pessoas
    CommunicationItem(id: 'mae', label: 'Mãe', emoji: '👩', ttsText: 'Mãe', categoryId: 'pessoas', order: 1),
    CommunicationItem(id: 'pai', label: 'Pai', emoji: '👨', ttsText: 'Pai', categoryId: 'pessoas', order: 2),
    CommunicationItem(id: 'avo', label: 'Vovó', emoji: '👵', ttsText: 'Vovó', categoryId: 'pessoas', order: 3),
    CommunicationItem(id: 'professor', label: 'Professor', emoji: '👩‍🏫', ttsText: 'Professor', categoryId: 'pessoas', order: 4),
    CommunicationItem(id: 'amigo', label: 'Amigo', emoji: '👦', ttsText: 'Amigo', categoryId: 'pessoas', order: 5),
    CommunicationItem(
      id: 'avo_masculino',
      label: "Vovô",
      emoji: '👴',
      ttsText: "Vovô",
      categoryId: 'pessoas',
      order: 6,
    ),
    CommunicationItem(
      id: 'irmao',
      label: "Irmão",
      emoji: '🧑',
      ttsText: "Irmão",
      categoryId: 'pessoas',
      order: 7,
    ),
    CommunicationItem(
      id: 'irma',
      label: "Irmã",
      emoji: '👧',
      ttsText: "Irmã",
      categoryId: 'pessoas',
      order: 8,
    ),
    CommunicationItem(
      id: 'tia',
      label: "Tia",
      emoji: '👩‍🦱',
      ttsText: "Tia",
      categoryId: 'pessoas',
      order: 9,
    ),
    CommunicationItem(
      id: 'tio',
      label: "Tio",
      emoji: '👨‍🦱',
      ttsText: "Tio",
      categoryId: 'pessoas',
      order: 10,
    ),

    // Emoções
    CommunicationItem(id: 'feliz', label: 'Estou feliz', emoji: '😊', ttsText: 'Estou feliz', categoryId: 'emocoes', order: 1),
    CommunicationItem(id: 'triste', label: 'Estou triste', emoji: '😢', ttsText: 'Estou triste', categoryId: 'emocoes', order: 2),
    CommunicationItem(id: 'bravo', label: 'Estou bravo', emoji: '😠', ttsText: 'Estou bravo', categoryId: 'emocoes', order: 3),
    CommunicationItem(id: 'assustado', label: 'Estou assustado', emoji: '😨', ttsText: 'Estou assustado', categoryId: 'emocoes', order: 4),
    CommunicationItem(id: 'calmo', label: 'Estou calmo', emoji: '😌', ttsText: 'Estou calmo', categoryId: 'emocoes', order: 5),
    CommunicationItem(id: 'confuso', label: 'Estou confuso', emoji: '😕', ttsText: 'Estou confuso', categoryId: 'emocoes', order: 6),
    CommunicationItem(
      id: 'preocupacao',
      label: "Sinto preocupação",
      emoji: '😟',
      ttsText: "Sinto preocupação",
      categoryId: 'emocoes',
      order: 7,
    ),
    CommunicationItem(
      id: 'vergonha',
      label: "Sinto vergonha",
      emoji: '😳',
      ttsText: "Sinto vergonha",
      categoryId: 'emocoes',
      order: 8,
    ),
    CommunicationItem(
      id: 'surpresa',
      label: "Que surpresa!",
      emoji: '😮',
      ttsText: "Que surpresa!",
      categoryId: 'emocoes',
      order: 9,
    ),
    CommunicationItem(
      id: 'tedio',
      label: "Sinto tédio",
      emoji: '🥱',
      ttsText: "Sinto tédio",
      categoryId: 'emocoes',
      order: 10,
    ),
    CommunicationItem(
      id: 'frustracao',
      label: "Sinto frustração",
      emoji: '😤',
      ttsText: "Sinto frustração",
      categoryId: 'emocoes',
      order: 11,
    ),

    // Lugares
    CommunicationItem(id: 'casa', label: 'Casa', emoji: '🏠', ttsText: 'Casa', categoryId: 'lugares', order: 1),
    CommunicationItem(id: 'escola', label: 'Escola', emoji: '🏫', ttsText: 'Escola', categoryId: 'lugares', order: 2),
    CommunicationItem(id: 'medico', label: 'Médico', emoji: '🏥', ttsText: 'Médico', categoryId: 'lugares', order: 3),
    CommunicationItem(id: 'parque', label: 'Parque', emoji: '🌳', ttsText: 'Parque', categoryId: 'lugares', order: 4),
    CommunicationItem(id: 'loja', label: 'Loja', emoji: '🛒', ttsText: 'Loja', categoryId: 'lugares', order: 5),
    CommunicationItem(
      id: 'biblioteca',
      label: "Biblioteca",
      emoji: '📚',
      ttsText: "Biblioteca",
      categoryId: 'lugares',
      order: 6,
    ),
    CommunicationItem(
      id: 'farmacia',
      label: "Farmácia",
      emoji: '💊',
      ttsText: "Farmácia",
      categoryId: 'lugares',
      order: 7,
    ),
    CommunicationItem(
      id: 'praia',
      label: "Praia",
      emoji: '🏖️',
      ttsText: "Praia",
      categoryId: 'lugares',
      order: 8,
    ),
    CommunicationItem(
      id: 'piscina',
      label: "Piscina",
      emoji: '🏊',
      ttsText: "Piscina",
      categoryId: 'lugares',
      order: 9,
    ),
    CommunicationItem(
      id: 'restaurante',
      label: "Restaurante",
      emoji: '🍴',
      ttsText: "Restaurante",
      categoryId: 'lugares',
      order: 10,
    ),

    // Ações
    CommunicationItem(id: 'parar', label: 'Pare', emoji: '🛑', ttsText: 'Pare', categoryId: 'acoes', order: 1),
    CommunicationItem(id: 'ajuda', label: 'Quero ajuda', emoji: '🆘', ttsText: 'Quero ajuda', categoryId: 'acoes', order: 2),
    CommunicationItem(id: 'brincar', label: 'Quero brincar', emoji: '🧸', ttsText: 'Quero brincar', categoryId: 'acoes', order: 3),
    CommunicationItem(id: 'sentar', label: 'Quero sentar', emoji: '🪑', ttsText: 'Quero sentar', categoryId: 'acoes', order: 4),
    CommunicationItem(id: 'levante', label: 'Quero andar', emoji: '🚶', ttsText: 'Quero andar', categoryId: 'acoes', order: 5),
    CommunicationItem(id: 'terminou', label: 'Terminei', emoji: '✅', ttsText: 'Terminei', categoryId: 'acoes', order: 6),
    CommunicationItem(
      id: 'esperar',
      label: "Vou esperar",
      emoji: '⏳',
      ttsText: "Vou esperar",
      categoryId: 'acoes',
      order: 7,
    ),
    CommunicationItem(
      id: 'repetir',
      label: "Repita, por favor",
      emoji: '🔁',
      ttsText: "Repita, por favor",
      categoryId: 'acoes',
      order: 8,
    ),
    CommunicationItem(
      id: 'escolher',
      label: "Quero escolher",
      emoji: '👆',
      ttsText: "Quero escolher",
      categoryId: 'acoes',
      order: 9,
    ),
    CommunicationItem(
      id: 'lavar_maos',
      label: "Vou lavar as mãos",
      emoji: '🧼',
      ttsText: "Vou lavar as mãos",
      categoryId: 'acoes',
      order: 10,
    ),
    CommunicationItem(
      id: 'trocar_roupa',
      label: "Vou trocar de roupa",
      emoji: '👕',
      ttsText: "Vou trocar de roupa",
      categoryId: 'acoes',
      order: 11,
    ),
  ];

  List<CommunicationCategory> get categories =>
      List<CommunicationCategory>.from(_categories)
        ..sort((a, b) => a.order.compareTo(b.order));

  List<CommunicationItem> itemsByCategory(String categoryId) {
    return _items.where((i) => i.categoryId == categoryId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }
}
