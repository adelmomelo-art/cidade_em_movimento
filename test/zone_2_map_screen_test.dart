import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/zone_2_map/zone_2_map_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _unlockedController() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();

  await controller.completeMission(
    result: const MissionResult(
      missionId: 'Z1_SPECIAL',
      stars: 3,
      score: 100,
      citizenship: 50,
      knowledge: 30,
      coins: 50,
      errors: 0,
    ),
  );

  return controller;
}

Future<void> _expectTextByScrolling(WidgetTester tester, String text) async {
  final finder = find.text(text);

  await tester.scrollUntilVisible(
    finder,
    260,
    scrollable: find.byType(Scrollable).first,
  );

  await tester.pumpAndSettle();
  expect(finder, findsOneWidget);
}

void main() {
  testWidgets('tela Zona 2 mostra conteudo jogavel completo', (tester) async {
    final controller = await _unlockedController();

    await tester.pumpWidget(
      MaterialApp(home: Zone2MapScreen(controller: controller)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Centro Hist\u00f3rico'), findsWidgets);
    expect(find.text('Fluxos e Conviv\u00eancia'), findsOneWidget);

    await _expectTextByScrolling(tester, '1. Cruzamento em Movimento');
    await _expectTextByScrolling(tester, '2. Ponto Certo');
    await _expectTextByScrolling(tester, '3. Cal\u00e7ada \u00e9 de Todos');
    await _expectTextByScrolling(tester, '4. S\u00f3 Vou Parar Aqui');
    await _expectTextByScrolling(tester, '5. Rotas que se Encontram');
    await _expectTextByScrolling(
      tester,
      'Miss\u00e3o Especial \u2014 Centro em Harmonia',
    );
  });

  testWidgets('primeira missao Zona 2 aparece disponivel', (tester) async {
    final controller = await _unlockedController();

    await tester.pumpWidget(
      MaterialApp(home: Zone2MapScreen(controller: controller)),
    );

    await tester.pumpAndSettle();

    await _expectTextByScrolling(tester, '1. Cruzamento em Movimento');
    expect(find.text('Dispon\u00edvel'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle_outline_rounded), findsOneWidget);
  });
}
