import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Serviço para abrir o cliente de e-mail do dispositivo.
class ContactService {
  ContactService._();
  static final ContactService instance = ContactService._();

  static const String developerEmail = 'valdenor.sa@proton.me';

  /// Abre o cliente de e-mail pré-preenchido para contato com o desenvolvedor.
  /// Retorna true se conseguiu abrir.
  Future<bool> contactDeveloper() async {
    final email = developerEmail;
    final subject = Uri.encodeComponent('Contato - TEA Fala');
    final body = Uri.encodeComponent('Olá Valdenor,\n\n');
    final url = 'mailto:$email?subject=$subject&body=$body';
    final uri = Uri.parse(url);

    try {
      // Primeiro tenta verificar se há um handler para mailto.
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      // Alguns dispositivos reportam false mesmo com app instalado;
      // tenta abrir diretamente como fallback.
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } catch (e) {
      debugPrint('Erro ao abrir e-mail: $e');
      return false;
    }
  }
}
