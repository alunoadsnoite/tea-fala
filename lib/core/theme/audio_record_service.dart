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
  String? get currentPath => _currentPath;

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

  /// Gera um nome de arquivo único com extensão .m4a.
  Future<String> _newPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final name = 'tea_fala_${DateTime.now().millisecondsSinceEpoch}.m4a';
    return '${dir.path}/$name';
  }

  /// Inicia a gravação. Retorna o caminho do arquivo ou null se falhar.
  Future<String?> start() async {
    if (!_available) return null;
    if (await isRecording()) return _currentPath;

    try {
      final path = await _newPath();
      _currentPath = path;

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: path,
      );
      developer.log('Gravação iniciada em $path', name: 'AudioRecordService');
      return path;
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
      // Alguns dispositivos retornam null; usa o caminho gerado como fallback.
      _currentPath = path ?? _currentPath;
      developer.log('Gravação salva em $_currentPath', name: 'AudioRecordService');
      return _currentPath;
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
