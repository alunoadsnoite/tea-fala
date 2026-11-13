import 'package:flutter/material.dart';
import 'services/tts_service.dart';
import 'services/storage_service.dart';
import 'services/theme_service.dart';
import 'services/language_service.dart';
import 'services/translation_service.dart';
import 'services/audio_record_service.dart';
import 'screens/home.dart';
import 'screens/settings.dart';

void main() {
  runApp(const TeaFalaApp());
}

class TeaFalaApp extends StatefulWidget {
  const TeaFalaApp({super.key});

  @override
  State<TeaFalaApp> createState() => _TeaFalaAppState();
}

class _TeaFalaAppState extends State<TeaFalaApp> {
  final TtsService _tts = TtsService();
  final StorageService _storage = StorageService();
  final ThemeService _theme = ThemeService();
  final LanguageService _language = LanguageService();
  final AudioRecordService _audioRecord = AudioRecordService();

  TranslationService? _tr;
  bool _inicializado = false;
  String? _erroInicializacao;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    try {
      await _tts.init();
    } catch (e) {
      debugPrint('Erro ao iniciar TTS: $e');
    }

    try {
      await _storage.init();
    } catch (e) {
      debugPrint('Erro ao iniciar Storage: $e');
    }

    try {
      await _theme.init();
    } catch (e) {
      debugPrint('Erro ao iniciar Theme: $e');
    }

    try {
      await _language.init();
    } catch (e) {
      debugPrint('Erro ao iniciar Language: $e');
    }

    try {
      await _audioRecord.init();
    } catch (e) {
      debugPrint('Erro ao iniciar AudioRecord: $e');
    }

    if (mounted) {
      setState(() {
        _tr = TranslationService(_language);
        _inicializado = true;
      });
    }
  }

  @override
  void dispose() {
    _tts.dispose();
    _audioRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_inicializado || _tr == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: _tr!.t('appTitle'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B61FF),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B61FF),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _theme.themeMode,
      localizationsDelegates: const [],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      locale: _language.locale,
      home: HomeScreen(
        tts: _tts,
        storage: _storage,
        theme: _theme,
        language: _language,
        tr: _tr!,
        audioRecord: _audioRecord,
      ),
      routes: {
        '/settings': (_) => SettingsScreen(
              theme: _theme,
              language: _language,
              tr: _tr!,
              audioRecord: _audioRecord,
            ),
      },
    );
  }
}
