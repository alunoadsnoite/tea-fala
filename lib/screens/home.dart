import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/item_comunicacao.dart';
import '../services/storage_service.dart';
import '../services/theme_service.dart';
import '../services/tts_service.dart';
import '../services/language_service.dart';
import '../services/translation_service.dart';
import '../services/audio_record_service.dart';
import 'categoria.dart';
import 'frase.dart';
import 'settings.dart';

/// Tela inicial: lista de categorias de comunicação.
class HomeScreen extends StatefulWidget {
  final TtsService tts;
  final StorageService storage;
  final ThemeService theme;
  final LanguageService language;
  final TranslationService tr;
  final AudioRecordService audioRecord;

  const HomeScreen({
    super.key,
    required this.tts,
    required this.storage,
    required this.theme,
    required this.language,
    required this.tr,
    required this.audioRecord,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Categoria> _categorias;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    await widget.storage.init();
    setState(() {
      _categorias = _categoriasPadrao();
      _carregando = false;
    });
  }

  List<Categoria> _categoriasPadrao() {
    return [
      Categoria(id: 'necessidades', nome: widget.tr.t('needs'), emoji: '🍽️', ordem: 1),
      Categoria(id: 'pessoas', nome: widget.tr.t('people'), emoji: '👥', ordem: 2),
      Categoria(id: 'emocoes', nome: widget.tr.t('emotions'), emoji: '❤️', ordem: 3),
      Categoria(id: 'lugares', nome: widget.tr.t('places'), emoji: '📍', ordem: 4),
      Categoria(id: 'acoes', nome: widget.tr.t('actions'), emoji: '🏃‍♂️', ordem: 5),
    ]..sort((a, b) => a.ordem.compareTo(b.ordem));
  }

  List<ItemComunicacao> _itensDaCategoria(String categoriaId) {
    return _todosItens.where((i) => i.categoriaId == categoriaId).toList()
      ..sort((a, b) => a.ordem.compareTo(b.ordem));
  }

  List<ItemComunicacao> get _todosItens {
    return [
      // Necessidades
      ItemComunicacao(id: 'fome', rotulo: widget.tr.t('fome'), emoji: '🍎', fraseAudio: widget.tr.t('fome'), categoriaId: 'necessidades', ordem: 1),
      ItemComunicacao(id: 'sede', rotulo: widget.tr.t('sede'), emoji: '💧', fraseAudio: widget.tr.t('sede'), categoriaId: 'necessidades', ordem: 2),
      ItemComunicacao(id: 'banheiro', rotulo: widget.tr.t('banheiro'), emoji: '🚽', fraseAudio: widget.tr.t('banheiro'), categoriaId: 'necessidades', ordem: 3),
      ItemComunicacao(id: 'sono', rotulo: widget.tr.t('sono'), emoji: '😴', fraseAudio: widget.tr.t('sono'), categoriaId: 'necessidades', ordem: 4),
      ItemComunicacao(id: 'doenca', rotulo: widget.tr.t('doenca'), emoji: '🤕', fraseAudio: widget.tr.t('doenca'), categoriaId: 'necessidades', ordem: 5),
      ItemComunicacao(id: 'frio', rotulo: widget.tr.t('frio'), emoji: '🧣', fraseAudio: widget.tr.t('frio'), categoriaId: 'necessidades', ordem: 6),
      ItemComunicacao(id: 'calor', rotulo: widget.tr.t('calor'), emoji: '☀️', fraseAudio: widget.tr.t('calor'), categoriaId: 'necessidades', ordem: 7),

      // Pessoas
      ItemComunicacao(id: 'mae', rotulo: widget.tr.t('mae'), emoji: '👩', fraseAudio: widget.tr.t('mae'), categoriaId: 'pessoas', ordem: 1),
      ItemComunicacao(id: 'pai', rotulo: widget.tr.t('pai'), emoji: '👨', fraseAudio: widget.tr.t('pai'), categoriaId: 'pessoas', ordem: 2),
      ItemComunicacao(id: 'avo', rotulo: widget.tr.t('avo'), emoji: '👵', fraseAudio: widget.tr.t('avo'), categoriaId: 'pessoas', ordem: 3),
      ItemComunicacao(id: 'professor', rotulo: widget.tr.t('professor'), emoji: '👩‍🏫', fraseAudio: widget.tr.t('professor'), categoriaId: 'pessoas', ordem: 4),
      ItemComunicacao(id: 'amigo', rotulo: widget.tr.t('amigo'), emoji: '👦', fraseAudio: widget.tr.t('amigo'), categoriaId: 'pessoas', ordem: 5),

      // Emoções
      ItemComunicacao(id: 'feliz', rotulo: widget.tr.t('feliz'), emoji: '😊', fraseAudio: widget.tr.t('feliz'), categoriaId: 'emocoes', ordem: 1),
      ItemComunicacao(id: 'triste', rotulo: widget.tr.t('triste'), emoji: '😢', fraseAudio: widget.tr.t('triste'), categoriaId: 'emocoes', ordem: 2),
      ItemComunicacao(id: 'bravo', rotulo: widget.tr.t('bravo'), emoji: '😠', fraseAudio: widget.tr.t('bravo'), categoriaId: 'emocoes', ordem: 3),
      ItemComunicacao(id: 'assustado', rotulo: widget.tr.t('assustado'), emoji: '😨', fraseAudio: widget.tr.t('assustado'), categoriaId: 'emocoes', ordem: 4),
      ItemComunicacao(id: 'calmo', rotulo: widget.tr.t('calmo'), emoji: '😌', fraseAudio: widget.tr.t('calmo'), categoriaId: 'emocoes', ordem: 5),
      ItemComunicacao(id: 'confuso', rotulo: widget.tr.t('confuso'), emoji: '😕', fraseAudio: widget.tr.t('confuso'), categoriaId: 'emocoes', ordem: 6),

      // Lugares
      ItemComunicacao(id: 'casa', rotulo: widget.tr.t('casa'), emoji: '🏠', fraseAudio: widget.tr.t('casa'), categoriaId: 'lugares', ordem: 1),
      ItemComunicacao(id: 'escola', rotulo: widget.tr.t('escola'), emoji: '🏫', fraseAudio: widget.tr.t('escola'), categoriaId: 'lugares', ordem: 2),
      ItemComunicacao(id: 'medico', rotulo: widget.tr.t('medico'), emoji: '🏥', fraseAudio: widget.tr.t('medico'), categoriaId: 'lugares', ordem: 3),
      ItemComunicacao(id: 'parque', rotulo: widget.tr.t('parque'), emoji: '🌳', fraseAudio: widget.tr.t('parque'), categoriaId: 'lugares', ordem: 4),
      ItemComunicacao(id: 'loja', rotulo: widget.tr.t('loja'), emoji: '🛒', fraseAudio: widget.tr.t('loja'), categoriaId: 'lugares', ordem: 5),

      // Ações
      ItemComunicacao(id: 'parar', rotulo: widget.tr.t('parar'), emoji: '🛑', fraseAudio: widget.tr.t('parar'), categoriaId: 'acoes', ordem: 1),
      ItemComunicacao(id: 'ajuda', rotulo: widget.tr.t('ajuda'), emoji: '🆘', fraseAudio: widget.tr.t('ajuda'), categoriaId: 'acoes', ordem: 2),
      ItemComunicacao(id: 'brincar', rotulo: widget.tr.t('brincar'), emoji: '🧸', fraseAudio: widget.tr.t('brincar'), categoriaId: 'acoes', ordem: 3),
      ItemComunicacao(id: 'sentar', rotulo: widget.tr.t('sentar'), emoji: '🪑', fraseAudio: widget.tr.t('sentar'), categoriaId: 'acoes', ordem: 4),
      ItemComunicacao(id: 'levante', rotulo: widget.tr.t('levante'), emoji: '🚶', fraseAudio: widget.tr.t('levante'), categoriaId: 'acoes', ordem: 5),
      ItemComunicacao(id: 'terminou', rotulo: widget.tr.t('terminou'), emoji: '✅', fraseAudio: widget.tr.t('terminou'), categoriaId: 'acoes', ordem: 6),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tr.t('appTitle')),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final categoria = _categorias[index];
          return _CategoriaCard(
            categoria: categoria,
            totalItens: _itensDaCategoria(categoria.id).length,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoriaScreen(
                    categoria: categoria,
                    itens: _itensDaCategoria(categoria.id),
                    tts: widget.tts,
                    storage: widget.storage,
                    theme: widget.theme,
                    language: widget.language,
                    tr: widget.tr,
                    audioRecord: widget.audioRecord,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FraseScreen(
                tts: widget.tts,
                tr: widget.tr,
              ),
            ),
          );
        },
        icon: const Icon(Icons.chat_bubble_outline),
        label: Text(widget.tr.t('phrase')),
      ),
    );
  }
}

/// Card de categoria na tela inicial.
class _CategoriaCard extends StatelessWidget {
  final Categoria categoria;
  final int totalItens;
  final VoidCallback onTap;

  const _CategoriaCard({
    required this.categoria,
    required this.totalItens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(categoria.emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              categoria.nome,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$totalItens ícones',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
