import 'package:flutter/material.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/core/theme/communication_speech.dart';
import 'package:tea_fala/core/theme/tts_service.dart';
import 'package:tea_fala/data/models/communication_item.dart';

/// Cartão com rótulo acessível também no modo somente imagens.
class CommunicationButton extends StatelessWidget {
  final CommunicationItem item;
  final TtsService tts;
  final bool selecionado;
  final bool imagesOnly;
  final VoidCallback? onAdicionarFrase;
  final TranslationService tr;

  const CommunicationButton({
    super.key,
    required this.item,
    required this.tts,
    this.selecionado = false,
    this.imagesOnly = false,
    this.onAdicionarFrase,
    required this.tr,
  });

  Future<void> _onTap() async {
    await speakCommunicationItem(item, tts, tr);
    onAdicionarFrase?.call();
  }

  @override
  Widget build(BuildContext context) {
    final cor = selecionado ? Theme.of(context).colorScheme.primary : null;
    final rotulo = tr.t(item.id);

    return Semantics(
      button: true,
      selected: selecionado,
      label: rotulo,
      excludeSemantics: true,
      onTap: _onTap,
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: cor?.withValues(alpha: 0.15) ?? Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cor ?? Theme.of(context).dividerColor,
              width: cor == null ? 1 : 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.emoji,
                style: const TextStyle(fontSize: 48, height: 1),
                textScaler: TextScaler.noScaling,
              ),
              if (!imagesOnly) ...[
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    rotulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
