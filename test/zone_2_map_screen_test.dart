import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/zone_2_map/zone_2_map_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _unlockedController({int extraCoins = 0}) async {
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

  if (extraCoins > 0) {
    await controller.completeMission(
      result: MissionResult(
        missionId: 'FAST4_UI_COINS',
        stars: 3,
        score: 100,
        citizenship: 0,
        knowledge: 0,
        coins: extraCoins,
        errors: 0,
      ),
    );
  }

  return controller;
}

Future<void> _materializeAndEnsureVisible(
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

  expect(
    finder,
    findsWidgets,
    reason: 'Widget alvo nao foi materializado no SliverList.',
  );

  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('tela Zona 2 exibe transformacao e conteudo jogavel', (
    tester,
  ) async {
    final controller = await _unlockedController();

    await tester.pumpWidget(
      MaterialApp(home: Zone2MapScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Centro Hist\u00f3rico'), findsWidgets);
    expect(find.text('Fluxos e Conviv\u00eancia'), findsOneWidget);

    for (final text in <String>[
      'Centro em Transforma\u00e7\u00e3o',
      'Transforme o Centro',
      '1. Cruzamento em Movimento',
      '5. Rotas que se Encontram',
      'Miss\u00e3o Especial \u2014 Centro em Harmonia',
    ]) {
      final finder = find.text(text);
      await _materializeAndEnsureVisible(
        tester,
        finder,
        direction: AxisDirection.down,
      );
      expect(finder, findsWidgets);
    }
  });

  testWidgets('compra Travessia Acessivel atualiza tela imediatamente', (
    tester,
  ) async {
    final controller = await _unlockedController(extraCoins: 20);

    await tester.pumpWidget(
      MaterialApp(home: Zone2MapScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    final installButton = find.byKey(
      const Key('zone2-install-TRAVESSIA_ACESSIVEL'),
    );

    await _materializeAndEnsureVisible(
      tester,
      installButton,
      direction: AxisDirection.down,
    );

    expect(installButton, findsOneWidget);

    final beforeCoins = controller.progress.coins;
    expect(beforeCoins, greaterThanOrEqualTo(60));
    expect(
      controller.progress.purchasedUpgrades,
      isNot(contains('TRAVESSIA_ACESSIVEL')),
    );

    await tester.tap(installButton);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(
      controller.progress.purchasedUpgrades,
      contains('TRAVESSIA_ACESSIVEL'),
    );
    expect(controller.progress.coins, beforeCoins - 60);

    final upgradeCard = find.byKey(
      const Key('zone2-upgrade-TRAVESSIA_ACESSIVEL'),
    );

    expect(upgradeCard, findsOneWidget);
    expect(
      find.descendant(of: upgradeCard, matching: find.text('INSTALADA')),
      findsWidgets,
    );

    final legend = find.byKey(const Key('zone2-legend-accessible-crossing'));

    await _materializeAndEnsureVisible(
      tester,
      legend,
      direction: AxisDirection.up,
    );

    expect(legend, findsOneWidget);
    expect(
      find.descendant(
        of: legend,
        matching: find.text('Travessia Acess\u00edvel \u2014 instalada'),
      ),
      findsOneWidget,
    );
  });
}
