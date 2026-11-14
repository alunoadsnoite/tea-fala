import 'package:flutter/material.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/core/theme/tts_service.dart';
import 'package:tea_fala/data/models/communication_item.dart';
import 'package:tea_fala/data/repositories/communication_repository.dart';
import 'package:tea_fala/presentation/widgets/communication_button.dart';

/// Tela de uma categoria: grade de ícones de comunicação.
class CategoriaScreen extends StatefulWidget {
  final CommunicationCategory categoria;
  final TtsService tts;
  final TranslationService tr;
  final bool imagesOnly;
  final ValueChanged<bool> onImagesOnlyChanged;

  const CategoriaScreen({
    super.key,
    required this.categoria,
    required this.tts,
    required this.tr,
    required this.imagesOnly,
    required this.onImagesOnlyChanged,
  });

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final List<CommunicationItem> _frase = [];

  void _adicionarFrase(CommunicationItem item) {
    setState(() {
      _frase.add(item);
    });
  }

  void _removerDaFrase(int index) {
    setState(() {
      _frase.removeAt(index);
    });
  }

  void _limparFrase() {
    setState(() {
      _frase.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = CommunicationRepository.instance;
    final itens = repo.itemsByCategory(widget.categoria.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tr.t(widget.categoria.nameKey)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barra da frase montada
          if (_frase.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Frase: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _frase.asMap().entries.map((entry) {
                            final i = entry.key;
                            final item = entry.value;
                            return Chip(
                              label: Text(
                                '${item.emoji} ${widget.imagesOnly ? '' : widget.tr.t(item.id)}',
                              ),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () => _removerDaFrase(i),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: Text(widget.tr.t('clear')),
                          onPressed: _limparFrase,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.volume_up),
                          label: Text(widget.tr.t('readPhrase')),
                          onPressed: () async {
                            final texto = _frase
                                .map((i) => widget.tr.t(i.id))
                                .join(', ');
                            await widget.tts.speak(texto);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // Grade de ícones
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final fontSize = MediaQuery.textScalerOf(context).scale(16);
                final columns =
                    constraints.maxWidth < 320 ||
                        (!widget.imagesOnly && fontSize > 20)
                    ? 2
                    : 3;
                final tileWidth =
                    (constraints.maxWidth - 32 - (columns - 1) * 12) / columns;
                final minHeight = widget.imagesOnly
                    ? 80.0
                    : 82 + fontSize * 3.6;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisExtent: (tileWidth / 0.85).clamp(
                      minHeight,
                      double.infinity,
                    ),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: itens.length,
                  itemBuilder: (context, index) {
                    final item = itens[index];
                    return CommunicationButton(
                      item: item,
                      tts: widget.tts,
                      imagesOnly: widget.imagesOnly,
                      onAdicionarFrase: () {
                        if (mounted) _adicionarFrase(item);
                      },
                      tr: widget.tr,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _frase.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () async {
                final texto = _frase.map((i) => widget.tr.t(i.id)).join(', ');
                await widget.tts.speak(texto);
              },
              icon: const Icon(Icons.volume_up),
              label: Text(widget.tr.t('readPhrase')),
            )
          : null,
    );
  }
}
