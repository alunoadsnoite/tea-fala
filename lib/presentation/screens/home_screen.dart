import 'package:flutter/material.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/core/theme/tts_service.dart';
import 'package:tea_fala/data/repositories/communication_repository.dart';
import 'package:tea_fala/presentation/screens/categoria_screen.dart';
import 'package:tea_fala/presentation/screens/frase_screen.dart';

/// Tela inicial: grid de categorias de comunicação.
class HomeScreen extends StatelessWidget {
  final TtsService tts;
  final TranslationService tr;
  final bool imagesOnly;
  final ValueChanged<bool> onImagesOnlyChanged;

  const HomeScreen({
    super.key,
    required this.tts,
    required this.tr,
    required this.imagesOnly,
    required this.onImagesOnlyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final repo = CommunicationRepository.instance;
    final categories = repo.categories;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.t('appTitle')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: tr.t('settings'),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
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
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _CategoriaCard(
            emoji: cat.emoji,
            nome: tr.t(cat.nameKey),
            total: '${repo.itemsByCategory(cat.id).length} ícones',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoriaScreen(
                    categoria: cat,
                    tts: tts,
                    tr: tr,
                    imagesOnly: imagesOnly,
                    onImagesOnlyChanged: onImagesOnlyChanged,
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
              builder: (_) => FraseScreen(tts: tts, tr: tr),
            ),
          );
        },
        icon: const Icon(Icons.chat_bubble_outline),
        label: Text(tr.t('phrase')),
      ),
    );
  }
}

/// Card de categoria na tela inicial.
class _CategoriaCard extends StatelessWidget {
  final String emoji;
  final String nome;
  final String total;
  final VoidCallback onTap;

  const _CategoriaCard({
    required this.emoji,
    required this.nome,
    required this.total,
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
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              total,
              style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodySmall?.color),
            ),
          ],
        ),
      ),
    );
  }
}
