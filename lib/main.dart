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
  // Captura erros não tratados para não travar silenciosamente
  FlutterError.onError = (details) {
    debugPrint('ERRO FLUTTER: ${details.exception}');
    debugPrint('Stack: ${details.stack}');
  };

  runApp(const TeaFalaApp());
}

class TeaFalaApp extends StatefulWidget {
  const TeaFalaApp({super.key});

  @override
  State<TeaFalaApp> createState() => _TeaFalaAppState();
}

class _TeaFalaAppState extends State<TeaFalaApp> {
  // Serviços instanciados mas inicializados sob demanda (lazy)
  final TtsService _tts = TtsService();
  final StorageService _storage = StorageService();
  final ThemeService _theme = ThemeService();
  final LanguageService _language = LanguageService();
  final AudioRecordService _audioRecord = AudioRecordService();

  bool _pronto = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    try {
      await _storage.init();
    } catch (e) {
      debugPrint('Storage falhou: $e');
    }

    try {
      await _theme.init();
    } catch (e) {
      debugPrint('Theme falhou: $e');
    }

    try {
      await _language.init();
    } catch (e) {
      debugPrint('Language falhou: $e');
    }

    if (mounted) {
      setState(() {
        _pronto = true;
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
    final tr = TranslationService(_language);

    return MaterialApp(
      title: tr.t('appTitle'),
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
      home: _pronto
          ? HomeScreen(
              tts: _tts,
              storage: _storage,
              theme: _theme,
              language: _language,
              tr: tr,
              audioRecord: _audioRecord,
            )
          : const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
      routes: {
        '/settings': (_) => SettingsScreen(
              theme: _theme,
              language: _language,
              tr: tr,
              audioRecord: _audioRecord,
            ),
      },
    );
  }
}
