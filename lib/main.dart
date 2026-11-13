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
  // Serviços instanciados mas inicializados sob demanda (lazy)
  final TtsService _tts = TtsService();
  final StorageService _storage = StorageService();
  final ThemeService _theme = ThemeService();
  final LanguageService _language = LanguageService();
  final AudioRecordService _audioRecord = AudioRecordService();

  TranslationService? _tr;
  bool _pronto = false;

  @override
  void initState() {
    super.initState();
    _inicializarBasico();
  }

  /// Inicialização mínima e segura — nunca trava a abertura do app.
  Future<void> _inicializarBasico() async {
    try {
      // Storage é leve e sempre funciona
      await _storage.init();
    } catch (e) {
      debugPrint('Storage init falhou (não crítico): $e');
    }

    try {
      await _theme.init();
    } catch (e) {
      debugPrint('Theme init falhou (não crítico): $e');
    }

    try {
      await _language.init();
    } catch (e) {
      debugPrint('Language init falhou (não crítico): $e');
    }

    // TTS e AudioRecord são inicializados lazy (sob demanda) para não travar o app
    if (mounted) {
      setState(() {
        _tr = TranslationService(_language);
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
    // Sempre mostra a tela, mesmo se _pronto for false
    final tr = _tr ?? TranslationService(_language);
    final language = _language;

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
      locale: language.locale,
      home: HomeScreen(
        tts: _tts,
        storage: _storage,
        theme: _theme,
        language: language,
        tr: tr,
        audioRecord: _audioRecord,
      ),
      routes: {
        '/settings': (_) => SettingsScreen(
              theme: _theme,
              language: language,
              tr: tr,
              audioRecord: _audioRecord,
            ),
      },
    );
  }
}
