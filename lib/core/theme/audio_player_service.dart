import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';

/// Serviço de reprodução de áudios gravados.
class AudioPlayerService {
  AudioPlayerService._();
  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _player = AudioPlayer();

  Future<bool> play(String filePath) => _play(DeviceFileSource(filePath));

  Future<bool> playAsset(String path) => _play(AssetSource(path));

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (error) {
      developer.log('Erro ao parar áudio: $error', name: 'AudioPlayerService');
    }
  }

  Future<bool> _play(Source source) async {
    try {
      await _player.stop();
      await _player.play(source);
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
