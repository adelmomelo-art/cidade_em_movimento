import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<({PlayerController controller, StorageService storage})>
_controllerWithCoins(int coins) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final storage = StorageService(preferences);
  final controller = PlayerController(storage);
  await controller.initialize();

  await controller.completeMission(
    result: MissionResult(
      missionId: 'FAST4_COINS_$coins',
      stars: 3,
      score: 100,
      citizenship: 0,
      knowledge: 0,
      coins: coins,
      errors: 0,
    ),
  );

  return (controller: controller, storage: storage);
}

void main() {
  test('compra as tres melhorias Zona 2 com exatamente 240 moedas', () async {
    final state = await _controllerWithCoins(240);

    expect(
      await state.controller.purchaseUpgrade('TRAVESSIA_ACESSIVEL'),
      isTrue,
    );
    expect(await state.controller.purchaseUpgrade('PONTO_SEGURO'), isTrue);
    expect(
      await state.controller.purchaseUpgrade('ROTA_COMPARTILHADA'),
      isTrue,
    );

    expect(state.controller.progress.coins, 0);
    expect(
      state.controller.progress.purchasedUpgrades,
      containsAll(<String>[
        'TRAVESSIA_ACESSIVEL',
        'PONTO_SEGURO',
        'ROTA_COMPARTILHADA',
      ]),
    );
  });

  test('melhorias Zona 2 persistem apos reinicializacao', () async {
    final state = await _controllerWithCoins(240);

    await state.controller.purchaseUpgrade('TRAVESSIA_ACESSIVEL');
    await state.controller.purchaseUpgrade('PONTO_SEGURO');
    await state.controller.purchaseUpgrade('ROTA_COMPARTILHADA');

    final restored = PlayerController(state.storage);
    await restored.initialize();

    expect(restored.progress.coins, 0);
    expect(
      restored.progress.purchasedUpgrades,
      containsAll(<String>[
        'TRAVESSIA_ACESSIVEL',
        'PONTO_SEGURO',
        'ROTA_COMPARTILHADA',
      ]),
    );
  });

  test('nao compra melhoria Zona 2 sem saldo suficiente', () async {
    final state = await _controllerWithCoins(59);

    final purchased = await state.controller.purchaseUpgrade(
      'TRAVESSIA_ACESSIVEL',
    );

    expect(purchased, isFalse);
    expect(state.controller.progress.coins, 59);
    expect(
      state.controller.progress.purchasedUpgrades.contains(
        'TRAVESSIA_ACESSIVEL',
      ),
      isFalse,
    );
  });

  test('nao cobra duas vezes a mesma melhoria Zona 2', () async {
    final state = await _controllerWithCoins(160);

    final first = await state.controller.purchaseUpgrade('PONTO_SEGURO');
    final coinsAfterFirst = state.controller.progress.coins;
    final second = await state.controller.purchaseUpgrade('PONTO_SEGURO');

    expect(first, isTrue);
    expect(second, isFalse);
    expect(state.controller.progress.coins, coinsAfterFirst);
  });
}
