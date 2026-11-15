import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tea_fala/core/language/language_service.dart';
import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/data/repositories/communication_repository.dart';
import 'package:tea_fala/main.dart';

void main() {
  testWidgets('Cartões mantêm rótulos acessíveis e falam no modo só imagens', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final spoken = <String>[];
    const ttsChannel = MethodChannel('flutter_tts');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(ttsChannel, (
      call,
    ) async {
      if (call.method == 'speak') {
        spoken.add(call.arguments as String);
      }
      return 1;
    });
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        ttsChannel,
        null,
      );
    });

    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const TeaFalaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.mic), findsNothing);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(Switch))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Necessidades'));
    await tester.pumpAndSettle();

    final card = find.descendant(
      of: find.byType(GridView),
      matching: find.bySemanticsLabel('Quero uma pausa'),
    );
    await tester.scrollUntilVisible(card.hitTestable(), 150);
    expect(find.text('Quero uma pausa'), findsNothing);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(spoken, ['Quero uma pausa']);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Ler a frase'));
    await tester.pumpAndSettle();
    expect(spoken, ['Quero uma pausa', 'Quero uma pausa']);

    // A long phrase must leave space to keep using the cards on a short screen.
    await tester.binding.setSurfaceSize(const Size(360, 320));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpAndSettle();
    for (var i = 0; i < 18; i++) {
      await tester.scrollUntilVisible(
        card.hitTestable(),
        80,
        scrollable: find.descendant(
          of: find.byType(GridView),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.tap(card.hitTestable());
      await tester.pumpAndSettle();
    }
    expect(spoken, hasLength(20));
    expect(tester.takeException(), isNull);

    semantics.dispose();
  });

  test(
    'Catálogo inclui traduções para todos os cartões em cada idioma',
    () async {
      final repo = CommunicationRepository.instance;
      final language = LanguageService.instance;
      final translation = TranslationService(language);
      final ids = <String>{};
      for (final category in repo.categories) {
        final cards = repo.itemsByCategory(category.id);
        expect(cards.length, greaterThanOrEqualTo(10));
        for (final card in cards) {
          expect(ids.add(card.id), isTrue);
          for (final locale in AppLanguage.values) {
            await language.setLanguage(locale);
            expect(translation.t(card.id), isNot(card.id));
          }
        }
      }
      expect(ids, hasLength(54));
      await language.setLanguage(AppLanguage.pt);
    },
  );
}
