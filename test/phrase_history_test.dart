import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tea_fala/data/repositories/phrase_history_service.dart';

void main() {
  group('PhraseHistoryService', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await PhraseHistoryService.instance.clearHistory();
    });

    test('deve iniciar com histórico vazio', () async {
      final historico = await PhraseHistoryService.instance.getHistory();
      expect(historico, isEmpty);
    });

    test('deve adicionar uma frase ao histórico', () async {
      await PhraseHistoryService.instance.addPhrase('Tenho fome');
      final historico = await PhraseHistoryService.instance.getHistory();
      expect(historico.length, 1);
      expect(historico[0].text, 'Tenho fome');
      expect(historico[0].useCount, 1);
    });

    test('deve incrementar contador quando frase repetida', () async {
      await PhraseHistoryService.instance.addPhrase('Tenho fome');
      await PhraseHistoryService.instance.addPhrase('Tenho fome');
      final historico = await PhraseHistoryService.instance.getHistory();
      expect(historico.length, 1);
      expect(historico[0].useCount, 2);
    });

    test('deve ordenar por uso decrescente', () async {
      await PhraseHistoryService.instance.addPhrase('Frase A');
      await PhraseHistoryService.instance.addPhrase('Frase B');
      await PhraseHistoryService.instance.addPhrase('Frase B');
      await PhraseHistoryService.instance.addPhrase('Frase C');
      await PhraseHistoryService.instance.addPhrase('Frase C');
      await PhraseHistoryService.instance.addPhrase('Frase C');

      final historico = await PhraseHistoryService.instance.getHistory();
      expect(historico.length, 3);
      expect(historico[0].text, 'Frase C');
      expect(historico[0].useCount, 3);
      expect(historico[1].text, 'Frase B');
      expect(historico[1].useCount, 2);
      expect(historico[2].text, 'Frase A');
      expect(historico[2].useCount, 1);
    });

    test('deve limpar o histórico', () async {
      await PhraseHistoryService.instance.addPhrase('Frase 1');
      await PhraseHistoryService.instance.addPhrase('Frase 2');
      expect((await PhraseHistoryService.instance.getHistory()).length, 2);

      await PhraseHistoryService.instance.clearHistory();
      expect((await PhraseHistoryService.instance.getHistory()).length, 0);
    });

    test('deve remover frase específica', () async {
      await PhraseHistoryService.instance.addPhrase('Frase 1');
      await PhraseHistoryService.instance.addPhrase('Frase 2');
      final historico = await PhraseHistoryService.instance.getHistory();
      await PhraseHistoryService.instance.removePhrase(historico[0].id);
      expect((await PhraseHistoryService.instance.getHistory()).length, 1);
      expect((await PhraseHistoryService.instance.getHistory())[0].text, 'Frase 2');
    });

    test('não deve adicionar frase vazia', () async {
      await PhraseHistoryService.instance.addPhrase('');
      await PhraseHistoryService.instance.addPhrase('   ');
      final historico = await PhraseHistoryService.instance.getHistory();
      expect(historico, isEmpty);
    });
  });
}
