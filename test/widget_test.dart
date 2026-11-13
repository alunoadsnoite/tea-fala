// Teste básico de inicialização do app.
import 'package:flutter_test/flutter_test.dart';

import 'package:tea_fala/main.dart';

void main() {
  testWidgets('App inicia e exibe tela inicial', (WidgetTester tester) async {
    await tester.pumpWidget(const TeaFalaApp());
    await tester.pumpAndSettle();

    expect(find.text('TEA Fala'), findsOneWidget);
    expect(find.text('Necessidades'), findsOneWidget);
  });
}
