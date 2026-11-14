import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';

/// Serviço de reprodução de áudios gravados.
class AudioPlayerService {
  AudioPlayerService._();
  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _player = AudioPlayer();
  bool _playing = false;

  bool get isPlaying => _playing;

  /// Toca um arquivo de áudio local.
  Future<void> play(String filePath) async {
    try {
      await stop();
      await _player.play(DeviceFileSource(filePath));
      _playing = true;
      _player.onPlayerComplete.listen((_) {
        _playing = false;
      });
    } catch (e) {
      developer.log('Erro ao reproduzir áudio: $e', name: 'AudioPlayerService', error: e);
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _playing = false;
    } catch (e) {
      developer.log('Erro ao parar áudio: $e', name: 'AudioPlayerService', error: e);
    }
  }

  Future<void> dispose() async {
    await stop();
    await _player.dispose();
  }
}
