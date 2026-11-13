import 'dart:developer' as developer;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Serviço de gravação de áudio com inicialização defensiva.
/// Se o microfone não estiver disponível, o app continua funcionando.
class AudioRecordService {
  AudioRecordService._();
  static final AudioRecordService instance = AudioRecordService._();

  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;
  bool _available = false;

  bool get isAvailable => _available;

  /// Inicializa e solicita permissão do microfone.
  /// Retorna true se o microfone está disponível.
  Future<bool> init() async {
    try {
      _available = await _recorder.hasPermission(request: true);
      developer.log('Áudio disponível: $_available', name: 'AudioRecordService');
    } catch (e, stack) {
      _available = false;
      developer.log('Áudio não disponível: $e', name: 'AudioRecordService', error: e, stackTrace: stack);
    }
    return _available;
  }

  /// Verifica se está gravando (assíncrono).
  Future<bool> isRecording() async {
    if (!_available) return false;
    try {
      return await _recorder.isRecording();
    } catch (e) {
      return false;
    }
  }

  /// Inicia a gravação. Retorna o caminho do arquivo ou null se falhar.
  Future<String?> start() async {
    if (!_available) return null;
    if (await isRecording()) return _currentPath;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'tea_fala_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _currentPath = '${dir.path}/$fileName';

      await _recorder.start(
        const RecordConfig(),
        path: _currentPath ?? '',
      );
      return _currentPath;
    } catch (e) {
      developer.log('Erro ao iniciar gravação: $e', name: 'AudioRecordService', error: e);
      return null;
    }
  }

  /// Para a gravação e retorna o caminho do arquivo.
  Future<String?> stop() async {
    if (!(await isRecording())) return null;
    try {
      final path = await _recorder.stop();
      _currentPath = path;
      return path;
    } catch (e) {
      developer.log('Erro ao parar gravação: $e', name: 'AudioRecordService', error: e);
      return null;
    }
  }

  Future<void> dispose() async {
    if (await isRecording()) {
      await _recorder.stop();
    }
    await _recorder.dispose();
  }
}
