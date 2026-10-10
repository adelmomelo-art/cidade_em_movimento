import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/zone_3_map/zone_3_map_screen.dart';
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
      missionId: 'FAST6_UI_COINS_$coins',
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
  required AxisDirection direction,
  int maxSteps = 24,
}) async {
  final scrollable = find.byType(Scrollable).first;

  for (var step = 0; step < maxSteps && finder.evaluate().isEmpty; step++) {
    final offset = switch (direction) {
      AxisDirection.down => const Offset(0, -260),
      AxisDirection.up => const Offset(0, 260),
      AxisDirection.left => const Offset(260, 0),
      AxisDirection.right => const Offset(-260, 0),
    };

    await tester.drag(scrollable, offset);
    await tester.pumpAndSettle();
  }

  expect(finder, findsWidgets);

  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('compra Travessia da Orla atualiza tela imediatamente', (
    tester,
  ) async {
    final controller = await _controllerWithCoins(60);

    await tester.pumpWidget(
      MaterialApp(home: Zone3MapScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    final button = find.byKey(const Key('zone3-install-TRAVESSIA_ORLA_SEGURA'));

    await _materialize(tester, button, direction: AxisDirection.down);

    final beforeCoins = controller.progress.coins;

    await tester.tap(button);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(
      controller.progress.purchasedUpgrades,
      contains('TRAVESSIA_ORLA_SEGURA'),
    );
    expect(controller.progress.coins, beforeCoins - 60);

    final card = find.byKey(const Key('zone3-upgrade-TRAVESSIA_ORLA_SEGURA'));

    expect(card, findsOneWidget);
    expect(
      find.descendant(of: card, matching: find.text('INSTALADA')),
      findsWidgets,
    );

    final legend = find.byKey(const Key('zone3-legend-crossing'));

    await _materialize(tester, legend, direction: AxisDirection.up);

    expect(
      find.descendant(
        of: legend,
        matching: find.text('Travessia da Orla \u2014 instalada'),
      ),
      findsOneWidget,
    );
  });
}
