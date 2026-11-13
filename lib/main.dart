import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tea_fala/core/theme/app_theme.dart';
import 'package:tea_fala/core/theme/theme_service.dart';
import 'package:tea_fala/core/theme/tts_service.dart';
import 'package:tea_fala/core/theme/audio_record_service.dart';
import 'package:tea_fala/core/language/language_service.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/presentation/screens/home_screen.dart';
import 'package:tea_fala/presentation/screens/settings_screen.dart';

void main() {
  // Captura erros não tratados para não travar silenciosamente.
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
  // Serviços singleton (inicialização lazy)
  final ThemeService _theme = ThemeService.instance;
  final LanguageService _language = LanguageService.instance;
  final TtsService _tts = TtsService.instance;
  final AudioRecordService _audioRecord = AudioRecordService.instance;

  TranslationService? _tr;

  // Estado compartilhado para o modo "somente imagens"
  bool _imagesOnly = false;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    // Inicialização mínima e segura - nunca trava a abertura do app.
    await _theme.init();
    await _language.init();
    // TTS e áudio são inicializados lazy (sob demanda)
    if (mounted) {
      setState(() {
        _tr = TranslationService(_language);
      });
    }
  }

  // Callback para atualizar o estado compartilhado
  void _onImagesOnlyChanged(bool value) {
    setState(() {
      _imagesOnly = value;
    });
  }

  @override
  void dispose() {
    _tts.dispose();
    _audioRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = _tr ?? TranslationService(_language);

    return MaterialApp(
      title: tr.t('appTitle'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: _theme.flutterThemeMode,
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      locale: _language.language.locale,
      home: HomeScreen(
        tts: _tts,
        audioRecord: _audioRecord,
        tr: tr,
        imagesOnly: _imagesOnly,
        onImagesOnlyChanged: _onImagesOnlyChanged,
      ),
      routes: {
        '/settings': (_) => SettingsScreen(
              theme: _theme,
              language: _language,
              tr: tr,
              audioRecord: _audioRecord,
              imagesOnly: _imagesOnly,
              onImagesOnlyChanged: _onImagesOnlyChanged,
            ),
      },
    );
  }
}
