import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tea_fala/core/language/translation_service.dart';

class PrintBoardScreen extends StatefulWidget {
  const PrintBoardScreen({super.key, required this.tr});

  final TranslationService tr;

  @override
  State<PrintBoardScreen> createState() => _PrintBoardScreenState();
}

class _PrintBoardScreenState extends State<PrintBoardScreen> {
  static const _channel = MethodChannel('br.com.valdenor.teafala/print_board');
  static const _messages = [
    'sim',
    'nao',
    'parar',
    'ajuda',
    'descanso',
    'banheiro',
    'doenca',
  ];
  bool _sharing = false;

  Future<void> _share() async {
    final tr = widget.tr;
    setState(() => _sharing = true);
    try {
      final bytes = await _channel.invokeMethod<Uint8List>('createPdf', {
        'title': tr.t('printBoardFileTitle'),
        'labels': _messages.map(tr.t).toList(),
      });
      if (bytes == null) throw StateError('PDF unavailable');
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(bytes, mimeType: 'application/pdf')],
          fileNameOverrides: ['tea-fala-prancha-a4.pdf'],
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(tr.t('shareBoardError'))));
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = widget.tr;
    return Scaffold(
      appBar: AppBar(title: Text(tr.t('printBoard'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(tr.t('printBoardDescription')),
          const SizedBox(height: 16),
          for (final message in _messages)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(tr.t(message)),
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _sharing ? null : _share,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: Text(tr.t('shareBoardPdf')),
          ),
        ],
      ),
    );
  }
}
