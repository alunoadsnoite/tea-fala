import 'dart:io';
import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/item_comunicacao.dart';
import '../services/storage_service.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/translation_service.dart';
import '../services/tts_service.dart';
import '../services/audio_record_service.dart';
import '../widgets/item_botao.dart';

/// Tela de uma categoria: grade de ícones de comunicação.
class CategoriaScreen extends StatefulWidget {
  final Categoria categoria;
  final List<ItemComunicacao> itens;
  final TtsService tts;
  final StorageService storage;
  final ThemeService theme;
  final LanguageService language;
  final TranslationService tr;
  final AudioRecordService audioRecord;

  const CategoriaScreen({
    super.key,
    required this.categoria,
    required this.itens,
    required this.tts,
    required this.storage,
    required this.theme,
    required this.language,
    required this.tr,
    required this.audioRecord,
  });

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final List<ItemComunicacao> _frase = [];
  bool _imagesOnly = false;

  @override
  void initState() {
    super.initState();
    widget.storage.init();
  }

  void _adicionarFrase(ItemComunicacao item) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria.nome),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // Barra da frase montada
          if (_frase.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
                            final index = entry.key;
                            final item = entry.value;
                            return Chip(
                              label: Text('${item.emoji} ${_imagesOnly ? '' : item.rotulo}'),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () => _removerDaFrase(index),
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
                            final texto = _frase.map((i) => i.rotulo).join(', ');
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
              itemCount: widget.itens.length,
              itemBuilder: (context, index) {
                final item = widget.itens[index];
                return ItemBotao(
                  item: item,
                  tts: widget.tts,
                  imagesOnly: _imagesOnly,
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
                final texto = _frase.map((i) => i.rotulo).join(', ');
                await widget.tts.speak(texto);
              },
              icon: const Icon(Icons.volume_up),
              label: Text(widget.tr.t('readPhrase')),
            )
          : null,
    );
  }

}
