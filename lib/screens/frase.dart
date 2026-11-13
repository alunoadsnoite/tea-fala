import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../services/translation_service.dart';

/// Tela dedicada para montar e ler frases completas.
class FraseScreen extends StatefulWidget {
  final TtsService tts;
  final TranslationService tr;

  const FraseScreen({
    super.key,
    required this.tts,
    required this.tr,
  });

  @override
  State<FraseScreen> createState() => _FraseScreenState();
}

class _FraseScreenState extends State<FraseScreen> {
  String _texto = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tr.t('phrase')),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              widget.tr.t('writeText'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Exemplo: Quero água, por favor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                onChanged: (valor) => setState(() => _texto = valor),
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.clear),
                    label: Text(widget.tr.t('clear')),
                    onPressed: _texto.isEmpty ? null : () => setState(() => _texto = ''),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.volume_up),
                    label: Text(widget.tr.t('listen')),
                    onPressed: _texto.isEmpty ? null : () => widget.tts.speak(_texto),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
