import 'dart:developer' as developer;
import 'package:flutter_tts/flutter_tts.dart';

/// Serviço de síntese de fala com inicialização defensiva.
/// Se o dispositivo não tiver TTS, o app continua funcionando sem fala.
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _available = false;

  bool get isAvailable => _available;

  /// Inicializa o TTS sem lançar exceção.
  /// Retorna true se conseguiu inicializar com sucesso.
  Future<bool> init() async {
    if (_initialized) return _available;
    _initialized = true;

    try {
      await _tts.setLanguage('pt-BR');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _available = true;
      developer.log('TTS inicializado com sucesso', name: 'TtsService');
    } catch (e, stack) {
      _available = false;
      developer.log('TTS não disponível: $e', name: 'TtsService', error: e, stackTrace: stack);
    }
    return _available;
  }

  /// Fala um texto. Se o TTS não estiver disponível, ignora silenciosamente.
  Future<void> speak(String text) async {
    if (!_available) return;
    try {
      await _tts.speak(text);
    } catch (e) {
      developer.log('Erro ao falar: $e', name: 'TtsService', error: e);
    }
  }

  /// Para qualquer fala em andamento.
  Future<void> stop() async {
    if (!_available) return;
    try {
      await _tts.stop();
    } catch (e) {
      developer.log('Erro ao parar TTS: $e', name: 'TtsService', error: e);
    }
  }

  Future<void> dispose() async {
    await stop();
  }
}
