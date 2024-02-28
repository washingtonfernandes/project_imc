import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_imc/home.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('Testes do Widget Home', () {
    testWidgets('Testar entrada e cálculo - Peso Ideal',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(MaterialApp(
        home: Home(),
        navigatorObservers: [mockObserver],
      ));

      await tester.pump(Duration(milliseconds: 300));

      await tester.enterText(find.byKey(Key('nomeTextField')), 'John Doe');
      await tester.enterText(find.byKey(Key('pesoTextField')), '70');
      await tester.enterText(find.byKey(Key('alturaTextField')), '170');

      await tester.pump(Duration(milliseconds: 300));

      await tester.tap(find.text('Calcular'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Peso ideal'), findsOneWidget);
    });

    testWidgets('Testar entrada e cálculo - Abaixo do Peso',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(MaterialApp(
        home: Home(),
        navigatorObservers: [mockObserver],
      ));

      await tester.pump(Duration(milliseconds: 300));

      await tester.enterText(find.byKey(Key('nomeTextField')), 'Jane Doe');
      await tester.enterText(find.byKey(Key('pesoTextField')), '50');
      await tester.enterText(find.byKey(Key('alturaTextField')), '165');

      await tester.pump(Duration(milliseconds: 300));

      await tester.tap(find.text('Calcular'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Abaixo do peso'), findsOneWidget);
    });

    testWidgets('Testar entrada e cálculo - Levemente acima do Peso',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(MaterialApp(
        home: Home(),
        navigatorObservers: [mockObserver],
      ));

      await tester.pump(Duration(milliseconds: 300));

      await tester.enterText(find.byKey(Key('nomeTextField')), 'Bob');
      await tester.enterText(find.byKey(Key('pesoTextField')), '80');
      await tester.enterText(find.byKey(Key('alturaTextField')), '175');

      await tester.pump(Duration(milliseconds: 300));

      await tester.tap(find.text('Calcular'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Levemente acima do peso'), findsOneWidget);
    });
  });
}
