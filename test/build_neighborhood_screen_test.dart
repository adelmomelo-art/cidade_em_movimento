import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/build_neighborhood/build_neighborhood_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _controllerWithCoins(int coins) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();

  await controller.completeMission(
    result: MissionResult(
      missionId: 'FAST15_UI_COINS_$coins',
      stars: 3,
      score: 100,
      citizenship: 0,
      knowledge: 0,
      coins: coins,
      errors: 0,
    ),
  );

  return controller;
}

Future<void> _materialize(
  WidgetTester tester,
  Finder finder, {
  int maxSteps = 30,
}) async {
  final scrollable = find.byType(Scrollable).first;

  for (var step = 0; step < maxSteps && finder.evaluate().isEmpty; step++) {
    await tester.drag(scrollable, const Offset(0, -260));
    await tester.pumpAndSettle();
  }

  expect(finder, findsWidgets);
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('compra Calcada Acessivel atualiza tela e saldo', (tester) async {
    final controller = await _controllerWithCoins(40);

    await tester.pumpWidget(
      MaterialApp(home: BuildNeighborhoodScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    final button = find.byKey(
      const Key('build-install-BAIRRO_CALCADA_ACESSIVEL'),
    );

    await _materialize(tester, button);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(controller.progress.coins, 0);
    expect(
      controller.progress.purchasedUpgrades,
      contains('BAIRRO_CALCADA_ACESSIVEL'),
    );

    final card = find.byKey(
      const Key('build-upgrade-BAIRRO_CALCADA_ACESSIVEL'),
    );

    expect(
      find.descendant(of: card, matching: find.text('INSTALADA')),
      findsOneWidget,
    );
  });
}
