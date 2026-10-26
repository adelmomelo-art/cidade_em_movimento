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

void main() {
  testWidgets('compra Calcada Acessivel atualiza tela e saldo', (tester) async {
    final controller = await _controllerWithCoins(40);

    await tester.pumpWidget(
      MaterialApp(
        home: BuildNeighborhoodScreen(
          controller: controller,
          initialZoneId: 'BUILD_NEIGHBORHOOD',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final button = find.byKey(const Key('r43-build'));

    expect(button.hitTestable(), findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(controller.progress.coins, 40);
    await tester.tap(find.byKey(const Key('r43-confirm')));
    await tester.pumpAndSettle();

    expect(controller.progress.coins, 0);
    expect(
      controller.progress.purchasedUpgrades,
      contains('BAIRRO_CALCADA_ACESSIVEL'),
    );

    final card = find.byKey(const Key('r43-select-BAIRRO_CALCADA_ACESSIVEL'));

    expect(
      find.descendant(of: card, matching: find.text('Construído')),
      findsOneWidget,
    );
  });
}
