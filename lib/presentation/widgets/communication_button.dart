import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/core/theme/audio_player_service.dart';
import 'package:tea_fala/core/theme/audio_record_service.dart';
import 'package:tea_fala/core/theme/tts_service.dart';
import 'package:tea_fala/data/models/communication_item.dart';

/// Botão de comunicação: ícone grande com rótulo e reprodução de áudio.
class CommunicationButton extends StatefulWidget {
  final CommunicationItem item;
  final TtsService tts;
  final bool selecionado;
  final bool imagesOnly;
  final VoidCallback? onAdicionarFrase;
  final AudioRecordService audioRecord;
  final TranslationService tr;

  const CommunicationButton({
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
  State<CommunicationButton> createState() => _CommunicationButtonState();
}

class _CommunicationButtonState extends State<CommunicationButton> {
  final AudioPlayer _player = AudioPlayer();
  bool _hasCustomAudio = false;
  String? _customAudioPath;

  @override
  void initState() {
    super.initState();
    _verificarAudioCustomizado();
  }

  Future<void> _verificarAudioCustomizado() async {
    // Em uma versão futura, isso verificaria se existe um áudio gravado para este item.
    // Por enquanto, usa TTS por padrão.
    setState(() {
      _hasCustomAudio = false;
    });
  }

  Future<void> _onTap() async {
    if (_hasCustomAudio && _customAudioPath != null) {
      try {
        await AudioPlayerService.instance.play(_customAudioPath!);
      } catch (e) {
        developer.log('Erro ao tocar áudio customizado: $e', name: 'CommunicationButton', error: e);
      }
    } else {
      await widget.tts.speak(widget.item.ttsText);
    }

    if (widget.onAdicionarFrase != null) {
      widget.onAdicionarFrase!();
    }
  }

  @override
  void dispose() {
    _player.dispose();
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
          color: cor != null ? cor.withValues(alpha: 0.15) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: cor ?? Theme.of(context).dividerColor,
            width: cor == null ? 1 : 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.item.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            if (mostrarTexto)
              Text(
                widget.item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
