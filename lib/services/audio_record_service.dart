import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Serviço de gravação de áudio próprio do usuário.
class AudioRecordService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _currentPath;

  Future<void> init() async {
    // Inicialização leve
  }

  /// Verifica se o microfone tem permissão.
  Future<bool> hasPermission() async {
    return await _audioRecorder.hasPermission(request: true);
  }

  /// Verifica se está gravando (assíncrono).
  Future<bool> get isRecording async {
    return await _audioRecorder.isRecording();
  }

  /// Inicia a gravação e retorna o caminho do arquivo.
  Future<String?> start() async {
    if (await isRecording) return _currentPath;

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'tea_fala_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _currentPath = '${dir.path}/$fileName';

    await _audioRecorder.start(
      const RecordConfig(),
      path: _currentPath!,
    );

    return _currentPath;
  }

  /// Para a gravação e retorna o caminho do arquivo gravado.
  Future<String?> stop() async {
    if (!(await isRecording)) return null;
    final path = await _audioRecorder.stop();
    _currentPath = path;
    return path;
  }

  /// Libera recursos.
  Future<void> dispose() async {
    if (await isRecording) {
      await _audioRecorder.stop();
    }
    await _audioRecorder.dispose();
  }
}
