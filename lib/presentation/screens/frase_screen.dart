import 'package:flutter/material.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/core/theme/tts_service.dart';
import 'package:tea_fala/data/repositories/phrase_history_service.dart';

/// Tela dedicada para montar e ler frases completas.
class FraseScreen extends StatefulWidget {
  final TtsService tts;
  final TranslationService tr;

  const FraseScreen({super.key, required this.tts, required this.tr});

  @override
  State<FraseScreen> createState() => _FraseScreenState();
}

class _FraseScreenState extends State<FraseScreen> {
  final _controller = TextEditingController();
  String _texto = '';
  List<PhraseHistoryItem> _historico = [];
  bool _carregandoHistorico = true;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _carregarHistorico() async {
    final historico = await PhraseHistoryService.instance.getHistory();
    if (mounted) {
      setState(() {
        _historico = historico;
        _carregandoHistorico = false;
      });
    }
  }

  Future<void> _salvarFrase() async {
    if (_texto.trim().isEmpty) return;
    await PhraseHistoryService.instance.addPhrase(_texto);
    await _carregarHistorico();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${widget.tr.t('save')}!')));
    }
  }

  Future<void> _usarFraseHistorico(PhraseHistoryItem item) async {
    setState(() {
      _texto = item.text;
      _controller.text = item.text;
    });
    await widget.tts.speak(item.text);
  }

  Future<void> _removerDoHistorico(String id) async {
    await PhraseHistoryService.instance.removePhrase(id);
    await _carregarHistorico();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tr.t('phrase')), centerTitle: true),
      body: Column(
        children: [
          // Campo de texto
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.tr.t('writeText'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: widget.tr.t('writeText'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                    ),
                    onChanged: (valor) => setState(() => _texto = valor),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.clear),
                        label: Text(widget.tr.t('clear')),
                        onPressed: _texto.isEmpty
                            ? null
                            : () => setState(() {
                                _texto = '';
                                _controller.clear();
                              }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.save),
                        label: Text(widget.tr.t('save')),
                        onPressed: _texto.isEmpty ? null : _salvarFrase,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.volume_up),
                        label: Text(widget.tr.t('listen')),
                        onPressed: _texto.isEmpty
                            ? null
                            : () => widget.tts.speak(_texto),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Histórico de frases
          if (_carregandoHistorico)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_historico.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  widget.tr.t('noSavedPhrases'),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _historico.length,
                itemBuilder: (context, index) {
                  final item = _historico[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      child: Text(
                        item.emoji.isNotEmpty ? item.emoji : '💬',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    title: Text(
                      item.text,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${widget.tr.t('useCount')}: ${item.useCount} • ${_formatDate(item.lastUsed)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.volume_up, size: 20),
                          tooltip: widget.tr.t('listen'),
                          onPressed: () => _usarFraseHistorico(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          tooltip: widget.tr.t('delete'),
                          onPressed: () => _removerDoHistorico(item.id),
                        ),
                      ],
                    ),
                    onTap: () => _usarFraseHistorico(item),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: _texto.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _salvarFrase,
              icon: const Icon(Icons.save),
              label: Text(widget.tr.t('save')),
            )
          : null,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
