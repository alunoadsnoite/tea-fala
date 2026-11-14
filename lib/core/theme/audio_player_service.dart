import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';

/// Serviço de reprodução de áudios gravados.
class AudioPlayerService {
  AudioPlayerService._();
  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _player = AudioPlayer();

  /// Reproduz um arquivo local de uma versão anterior.
  Future<bool> play(String filePath) async {
    try {
      await _player.stop();
      await _player.play(DeviceFileSource(filePath));
      return true;
    } catch (e) {
      developer.log(
        'Erro ao reproduzir áudio: $e',
        name: 'AudioPlayerService',
        error: e,
      );
      return false;
    }
  }
}
