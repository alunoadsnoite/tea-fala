import 'package:flutter/material.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/core/theme/tts_service.dart';
import 'package:tea_fala/core/theme/audio_record_service.dart';
import 'package:tea_fala/data/models/communication_item.dart';
import 'package:tea_fala/data/repositories/communication_repository.dart';
import 'package:tea_fala/presentation/widgets/communication_button.dart';

/// Tela de uma categoria: grade de ícones de comunicação.
class CategoriaScreen extends StatefulWidget {
  final CommunicationCategory categoria;
  final TtsService tts;
  final AudioRecordService audioRecord;
  final TranslationService tr;
  final bool imagesOnly;
  final ValueChanged<bool> onImagesOnlyChanged;

  const CategoriaScreen({
    super.key,
    required this.categoria,
    required this.tts,
    required this.audioRecord,
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
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Frase: ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                                '${item.emoji} ${widget.imagesOnly ? '' : item.label}',
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
                            final texto = _frase.map((i) => i.ttsText).join(', ');
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
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
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
                  onAdicionarFrase: () => _adicionarFrase(item),
                  audioRecord: widget.audioRecord,
                  tr: widget.tr,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _frase.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () async {
                final texto = _frase.map((i) => i.ttsText).join(', ');
                await widget.tts.speak(texto);
              },
              icon: const Icon(Icons.volume_up),
              label: Text(widget.tr.t('readPhrase')),
            )
          : null,
    );
  }
}
