import 'package:flutter_tts/flutter_tts.dart';

/// Serviço de síntese de fala usando o motor TTS do dispositivo (offline).
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  /// Inicializa o TTS com português do Brasil.
  Future<void> init() async {
    if (_initialized) return;
    await _tts.setLanguage('pt-BR');
    await _tts.setSpeechRate(0.5); // fala mais devagar, melhor para TEA
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  /// Fala um texto.
  Future<void> speak(String texto) async {
    if (!_initialized) await init();
    await _tts.speak(texto);
  }

  /// Para qualquer fala em andamento.
  Future<void> stop() async {
    await _tts.stop();
  }

  /// Libera recursos.
  Future<void> dispose() async {
    await _tts.stop();
  }
}
