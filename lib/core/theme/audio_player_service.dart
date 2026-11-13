import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';

/// Serviço de reprodução de áudios gravados.
class AudioPlayerService {
  AudioPlayerService._();
  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _player = AudioPlayer();

  /// Toca um arquivo de áudio local.
  Future<void> play(String filePath) async {
    try {
      await _player.play(DeviceFileSource(filePath));
    } catch (e) {
      developer.log('Erro ao reproduzir áudio: $e', name: 'AudioPlayerService', error: e);
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      developer.log('Erro ao parar áudio: $e', name: 'AudioPlayerService', error: e);
    }
  }

  Future<void> dispose() async {
    await stop();
    await _player.dispose();
  }
}
