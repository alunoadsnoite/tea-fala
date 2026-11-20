import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:tea_fala/core/language/language_service.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/core/theme/app_state_notifier.dart';
import 'package:tea_fala/core/theme/audio_record_service.dart';
import 'package:tea_fala/core/theme/theme_service.dart';
import 'package:tea_fala/data/repositories/contact_repository.dart';
import 'package:tea_fala/data/repositories/custom_audio_repository.dart';

/// Tela de Configurações do TEA Fala.
class SettingsScreen extends StatefulWidget {
  final ThemeService theme;
  final LanguageService language;
  final AppStateNotifier appState;
  final TranslationService tr;
  final AudioRecordService audioRecord;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.appState,
    required this.tr,
    required this.audioRecord,
    required this.onLanguageChanged,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isRecording = false;
  String? _recordedPath;

  Future<void> _deleteLegacyAudio() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.tr.t('deleteLegacyAudio')),
        content: Text(widget.tr.t('deleteLegacyAudioConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(widget.tr.t('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(widget.tr.t('delete')),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    var result = 'legacyAudioDeleted';
    try {
      await CustomAudioRepository.instance.deleteLegacyRecordings();
    } catch (_) {
      result = 'legacyAudioDeleteError';
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.tr.t(result))),
      );
    }
  }

  /// Abre o cliente de e-mail para contatar o desenvolvedor.
  Future<void> _contactDeveloper() async {
    final success = await ContactService.instance.contactDeveloper();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.tr.t('emailError')),
        ),
      );
    }
  }

  /// Alterna gravação de áudio.
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await widget.audioRecord.stop();
      if (path != null && mounted) {
        setState(() {
          _isRecording = false;
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
      try {
        final available = await widget.audioRecord.init();
        if (!available) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.tr.t('permissionMicrophone'))),
            );
          }
          return;
        }

        final path = await widget.audioRecord.start();
        if (path != null && mounted) {
          setState(() {
            _isRecording = true;
            _recordedPath = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.tr.t('recordStart')),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        developer.log('Erro na gravação: $e', name: 'SettingsScreen', error: e);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.tr.t('errorRecording'))),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tr.t('settings')),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Seção: Tema
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(widget.tr.t('theme')),
            subtitle: Text(
              widget.theme.mode == AppThemeMode.light
                  ? widget.tr.t('themeLight')
                  : widget.theme.mode == AppThemeMode.dark
                      ? widget.tr.t('themeDark')
                      : widget.tr.t('themeSystem'),
            ),
            trailing: DropdownButton<AppThemeMode>(
              value: widget.theme.mode,
              items: [
                DropdownMenuItem(value: AppThemeMode.light, child: Text(widget.tr.t('themeLight'))),
                DropdownMenuItem(value: AppThemeMode.dark, child: Text(widget.tr.t('themeDark'))),
                DropdownMenuItem(value: AppThemeMode.system, child: Text(widget.tr.t('themeSystem'))),
              ],
              onChanged: (value) async {
                if (value != null) {
                  await widget.theme.setMode(value);
                  widget.onThemeChanged(value);
                }
              },
            ),
          ),
          const Divider(),

          // Seção: Idioma
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(widget.tr.t('language')),
            subtitle: Text(widget.language.language.name),
            trailing: DropdownButton<AppLanguage>(
              value: widget.language.language,
              items: AppLanguage.values
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang.name),
                      ))
                  .toList(),
              onChanged: (lang) async {
                if (lang != null) {
                  await widget.language.setLanguage(lang);
                  widget.onLanguageChanged(lang);
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
              value: widget.appState.imagesOnly,
              onChanged: (value) async {
                await widget.appState.setImagesOnly(value);
              },
            ),
          ),
          const Divider(),

          // Seção: Gravação de áudio
          ListTile(
            leading: const Icon(Icons.mic),
            title: Text(widget.tr.t('recordAudio')),
            subtitle: Text(
              _isRecording
                  ? widget.tr.t('recordStop')
                  : widget.tr.t('recordStart'),
            ),
            trailing: ElevatedButton.icon(
              icon: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
              ),
              label: Text(
                _isRecording
                    ? widget.tr.t('recordStop')
                    : widget.tr.t('recordStart'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? Colors.red : Colors.green,
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

          // Seção: Privacidade
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(widget.tr.t('privacy')),
            subtitle: Text(widget.tr.t('privacyNotice')),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(widget.tr.t('deleteLegacyAudio')),
            onTap: _deleteLegacyAudio,
          ),
          const Divider(),

          // Seção: Contato com desenvolvedor
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: Text(widget.tr.t('contactDeveloper')),
            subtitle: Text(ContactService.developerEmail),
            trailing: const Icon(Icons.open_in_new),
            onTap: _contactDeveloper,
          ),
        ],
      ),
    );
  }
}
