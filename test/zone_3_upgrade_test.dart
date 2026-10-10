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
      missionId: 'FAST6_COINS_$coins',
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
  test('compra as tres melhorias Zona 3 com exatamente 240 moedas', () async {
    final state = await _controllerWithCoins(240);

    expect(
      await state.controller.purchaseUpgrade('TRAVESSIA_ORLA_SEGURA'),
      isTrue,
    );
    expect(
      await state.controller.purchaseUpgrade('CICLOVIA_CONECTADA'),
      isTrue,
    );
    expect(
      await state.controller.purchaseUpgrade('EMBARQUE_ORGANIZADO'),
      isTrue,
    );

    expect(state.controller.progress.coins, 0);
    expect(
      state.controller.progress.purchasedUpgrades,
      containsAll(<String>[
        'TRAVESSIA_ORLA_SEGURA',
        'CICLOVIA_CONECTADA',
        'EMBARQUE_ORGANIZADO',
      ]),
    );
  });

  test('melhorias Zona 3 persistem apos reinicializacao', () async {
    final state = await _controllerWithCoins(240);

    await state.controller.purchaseUpgrade('TRAVESSIA_ORLA_SEGURA');
    await state.controller.purchaseUpgrade('CICLOVIA_CONECTADA');
    await state.controller.purchaseUpgrade('EMBARQUE_ORGANIZADO');

    final restored = PlayerController(state.storage);
    await restored.initialize();

    expect(restored.progress.coins, 0);
    expect(
      restored.progress.purchasedUpgrades,
      containsAll(<String>[
        'TRAVESSIA_ORLA_SEGURA',
        'CICLOVIA_CONECTADA',
        'EMBARQUE_ORGANIZADO',
      ]),
    );
  });

  test('nao compra melhoria Zona 3 sem saldo suficiente', () async {
    final state = await _controllerWithCoins(59);

    final purchased = await state.controller.purchaseUpgrade(
      'TRAVESSIA_ORLA_SEGURA',
    );

    expect(purchased, isFalse);
    expect(state.controller.progress.coins, 59);
  });

  test('nao cobra duas vezes a mesma melhoria Zona 3', () async {
    final state = await _controllerWithCoins(160);

    final first = await state.controller.purchaseUpgrade('CICLOVIA_CONECTADA');
    final coinsAfterFirst = state.controller.progress.coins;
    final second = await state.controller.purchaseUpgrade('CICLOVIA_CONECTADA');

    expect(first, isTrue);
    expect(second, isFalse);
    expect(state.controller.progress.coins, coinsAfterFirst);
  });
}
