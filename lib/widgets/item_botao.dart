import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/item_comunicacao.dart';
import '../services/tts_service.dart';
import '../services/audio_record_service.dart';
import '../services/translation_service.dart';

/// Botão de comunicação: ícone grande com rótulo e reprodução de áudio.
class ItemBotao extends StatefulWidget {
  final ItemComunicacao item;
  final TtsService tts;
  final bool selecionado;
  final bool imagesOnly;
  final VoidCallback? onAdicionarFrase;
  final AudioRecordService audioRecord;
  final TranslationService tr;

  const ItemBotao({
    super.key,
    required this.item,
    required this.tts,
    this.selecionado = false,
    this.imagesOnly = false,
    this.onAdicionarFrase,
    required this.audioRecord,
    required this.tr,
  });

  @override
  State<ItemBotao> createState() => _ItemBotaoState();
}

class _ItemBotaoState extends State<ItemBotao> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasCustomAudio = false;
  String? _customAudioPath;

  @override
  void initState() {
    super.initState();
    _verificarAudioCustomizado();
  }

  Future<void> _verificarAudioCustomizado() async {
    // Em uma versão futura, isso verificaria se existe um áudio gravado para este item
    // Por enquanto, usa TTS por padrão
    setState(() {
      _hasCustomAudio = false;
    });
  }

  Future<void> _onTap() async {
    if (_hasCustomAudio && _customAudioPath != null) {
      await _audioPlayer.play(DeviceFileSource(_customAudioPath!));
    } else {
      await widget.tts.speak(widget.item.fraseAudio);
    }

    if (widget.onAdicionarFrase != null) {
      widget.onAdicionarFrase!();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cor = widget.selecionado
        ? Theme.of(context).colorScheme.primary
        : null;
    final mostrarTexto = !widget.imagesOnly;

    return InkWell(
      onTap: _onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cor != null
              ? cor.withValues(alpha: 0.15)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: cor ?? Theme.of(context).dividerColor,
            width: cor == null ? 1 : 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone / Emoji
            Text(
              widget.item.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            // Texto (oculto no modo somente imagens)
            if (mostrarTexto)
              Text(
                widget.item.rotulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
