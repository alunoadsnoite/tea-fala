import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/audio_record_service.dart';
import '../services/translation_service.dart';

/// Tela de Configurações do TEA Fala.
class SettingsScreen extends StatefulWidget {
  final ThemeService theme;
  final LanguageService language;
  final TranslationService tr;
  final AudioRecordService audioRecord;

  const SettingsScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.tr,
    required this.audioRecord,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _recordedPath;

  /// Abre o cliente de e-mail para contatar o desenvolvedor.
  Future<void> _contactDeveloper() async {
    final email = widget.tr.t('contactDeveloperEmail');
    final subject = Uri.encodeComponent('Contato - TEA Fala');
    final body = Uri.encodeComponent('Olá Valdenor,');
    final url = 'mailto:$email?subject=$subject&body=$body';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi possível abrir o e-mail: $email'),
          ),
        );
      }
    }
  }

  /// Alterna gravação de áudio.
  Future<void> _toggleRecording() async {
    final isRecording = await widget.audioRecord.isRecording;

    if (isRecording) {
      final path = await widget.audioRecord.stop();
      if (path != null && mounted) {
        setState(() {
          _recordedPath = path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.tr.t('audioRecorded')}\n$path'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      final hasPermission = await widget.audioRecord.hasPermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.tr.t('permissionMicrophone')),
            ),
          );
        }
        return;
      }

      final path = await widget.audioRecord.start();
      if (path != null && mounted) {
        setState(() {
          _recordedPath = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.tr.t('recordStart')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tr.t('settings')),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView(
        children: [
          // Seção: Tema
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(widget.tr.t('theme')),
            subtitle: Text(
              widget.theme.themeModeIndex == 0
                  ? widget.tr.t('themeLight')
                  : widget.theme.themeModeIndex == 1
                      ? widget.tr.t('themeDark')
                      : widget.tr.t('themeSystem'),
            ),
            trailing: DropdownButton<int>(
              value: widget.theme.themeModeIndex,
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text(widget.tr.t('themeLight')),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text(widget.tr.t('themeDark')),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text(widget.tr.t('themeSystem')),
                ),
              ],
              onChanged: (value) async {
                if (value != null) {
                  await widget.theme.setThemeMode(value);
                  if (mounted) setState(() {});
                }
              },
            ),
          ),
          const Divider(),

          // Seção: Idioma
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(widget.tr.t('language')),
            subtitle: Text(widget.language.currentLanguageName),
            trailing: DropdownButton<String>(
              value: widget.language.languageCode,
              items: LanguageService.supportedLanguages.entries
                  .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ))
                  .toList(),
              onChanged: (code) async {
                if (code != null) {
                  await widget.language.setLanguageCode(code);
                  if (mounted) setState(() {});
                }
              },
            ),
          ),
          const Divider(),

          // Seção: Modo somente imagens
          ListTile(
            leading: const Icon(Icons.image),
            title: Text(widget.tr.t('imagesOnlyMode')),
            subtitle: Text(widget.tr.t('imagesOnlyModeDescription')),
            trailing: Switch(
              value: false,
              onChanged: (_) {},
            ),
          ),
          const Divider(),

          // Seção: Gravação de áudio
          ListTile(
            leading: const Icon(Icons.mic),
            title: Text(widget.tr.t('recordAudio')),
            trailing: ElevatedButton.icon(
              icon: const Icon(Icons.mic, color: Colors.white),
              label: Text(widget.tr.t('recordStart')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: _toggleRecording,
            ),
          ),
          if (_recordedPath != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.tr.t('recordSaved')}\n$_recordedPath',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          const Divider(),

          // Seção: Contato com desenvolvedor
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: Text(widget.tr.t('contactDeveloper')),
            subtitle: Text(widget.tr.t('contactDeveloperEmail')),
            trailing: const Icon(Icons.open_in_new),
            onTap: _contactDeveloper,
          ),
        ],
      ),
    );
  }
}
