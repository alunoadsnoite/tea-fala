import 'package:flutter/material.dart';
import 'package:tea_fala/core/language/language_service.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/core/theme/theme_service.dart';
import 'package:tea_fala/data/repositories/contact_repository.dart';

/// Tela de Configurações do TEA Fala.
class SettingsScreen extends StatefulWidget {
  final ThemeService theme;
  final LanguageService language;
  final TranslationService tr;
  final bool imagesOnly;
  final ValueChanged<bool> onImagesOnlyChanged;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.tr,
    required this.imagesOnly,
    required this.onImagesOnlyChanged,
    required this.onLanguageChanged,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

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
              value: widget.imagesOnly,
              onChanged: (value) {
                widget.onImagesOnlyChanged(value);
                if (mounted) setState(() {});
              },
            ),
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
