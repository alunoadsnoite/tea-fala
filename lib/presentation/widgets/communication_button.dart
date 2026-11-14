import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/core/theme/audio_player_service.dart';
import 'package:tea_fala/core/theme/audio_record_service.dart';
import 'package:tea_fala/core/theme/tts_service.dart';
import 'package:tea_fala/data/models/communication_item.dart';
import 'package:tea_fala/data/repositories/custom_audio_repository.dart';

/// Botão de comunicação: ícone grande com rótulo e reprodução de áudio.
///
/// Se o item tiver um áudio personalizado gravado, ele é reproduzido;
/// caso contrário, usa TTS. Toque longo abre diálogo para gravar/
/// ouvir/excluir o áudio personalizado do item.
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
  final AudioPlayerService _player = AudioPlayerService.instance;
  String? _customAudioPath;
  bool _hasCustomAudio = false;
  bool _recording = false;
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _carregarAudioCustomizado();
  }

  Future<void> _carregarAudioCustomizado() async {
    final path = await CustomAudioRepository.instance.get(widget.item.id);
    if (path != null && mounted) {
      setState(() {
        _customAudioPath = path;
        _hasCustomAudio = true;
      });
    }
  }

  Future<void> _reproduzir() async {
    if (_hasCustomAudio && _customAudioPath != null) {
      await _player.play(_customAudioPath!);
    } else {
      await widget.tts.speak(widget.tr.t(widget.item.id));
    }
  }

  Future<void> _onTap() async {
    await _reproduzir();
    if (widget.onAdicionarFrase != null) {
      widget.onAdicionarFrase!();
    }
  }

  Future<void> _onLongPress() async {
    await _showAudioDialog();
  }

  Future<void> _showAudioDialog() async {
    final itemLabel = widget.tr.t(widget.item.id);
    return showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('${widget.tr.t('customAudioTitle')}: $itemLabel'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                if (_hasCustomAudio)
                  Text(widget.tr.t('customAudioExists'))
                else
                  Text(widget.tr.t('customAudioMissing')),
              ],
            ),
          ),
          actions: [
            if (_hasCustomAudio) ...[
              TextButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: Text(widget.tr.t('playAudio')),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await _player.play(_customAudioPath!);
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: Text(widget.tr.t('deleteAudio')),
                onPressed: () async {
                  await CustomAudioRepository.instance.remove(widget.item.id);
                  if (mounted) {
                    setState(() {
                      _hasCustomAudio = false;
                      _customAudioPath = null;
                    });
                  }
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
              ),
            ],
            TextButton.icon(
              icon: const Icon(Icons.mic),
              label: Text(widget.tr.t('recordAudio')),
              onPressed: () {
                Navigator.of(ctx).pop();
                _showRecordDialog();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRecordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(widget.tr.t('recordAudio')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _recording ? Icons.mic : Icons.mic_none,
                    size: 64,
                    color: _recording ? Colors.red : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _recording
                        ? '${widget.tr.t('recording')}: ${_seconds}s'
                        : widget.tr.t('customAudioReady'),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: Icon(_recording ? Icons.stop : Icons.mic, color: Colors.white),
                    label: Text(
                      _recording
                          ? widget.tr.t('recordStop')
                          : widget.tr.t('recordStart'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _recording ? Colors.red : Colors.green,
                    ),
                    onPressed: () async {
                      if (_recording) {
                        final path = await widget.audioRecord.stop();
                        _timer?.cancel();
                        if (path != null) {
                          await CustomAudioRepository.instance.save(widget.item.id, path);
                          if (mounted) {
                            setState(() {
                              _customAudioPath = path;
                              _hasCustomAudio = true;
                            });
                          }
                        }
                        setDialogState(() {
                          _recording = false;
                          _seconds = 0;
                        });
                      } else {
                        final available = await widget.audioRecord.init();
                        if (!available) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(widget.tr.t('permissionMicrophone'))),
                            );
                          }
                          return;
                        }
                        final path = await widget.audioRecord.start();
                        if (path == null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(widget.tr.t('errorRecording'))),
                            );
                          }
                          return;
                        }
                        setDialogState(() {
                          _recording = true;
                          _seconds = 0;
                        });
                        _timer = Timer.periodic(const Duration(seconds: 1), (t) {
                          if (mounted) {
                            setDialogState(() => _seconds++);
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      _timer?.cancel();
                      if (_recording) widget.audioRecord.stop();
                      Navigator.of(ctx).pop();
                    },
                    child: Text(widget.tr.t('cancel')),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
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
      onLongPress: _onLongPress,
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
                widget.tr.t(widget.item.id),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (_hasCustomAudio) ...[
              const SizedBox(height: 4),
              Icon(Icons.mic, size: 16, color: Theme.of(context).colorScheme.primary),
            ],
          ],
        ),
      ),
    );
  }
}
