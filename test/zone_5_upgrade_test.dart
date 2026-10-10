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
      missionId: 'FAST10_COINS_$coins',
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
  test('compra as tres melhorias Zona 5 com exatamente 240 moedas', () async {
    final state = await _controllerWithCoins(240);

    expect(
      await state.controller.purchaseUpgrade('TRAVESSIA_GRANDE_VIA'),
      isTrue,
    );
    expect(
      await state.controller.purchaseUpgrade('ILUMINACAO_CORREDOR'),
      isTrue,
    );
    expect(await state.controller.purchaseUpgrade('REFUGIO_PEDESTRE'), isTrue);

    expect(state.controller.progress.coins, 0);
    expect(
      state.controller.progress.purchasedUpgrades,
      containsAll(<String>[
        'TRAVESSIA_GRANDE_VIA',
        'ILUMINACAO_CORREDOR',
        'REFUGIO_PEDESTRE',
      ]),
    );
  });

  test('melhorias Zona 5 persistem apos reinicializacao', () async {
    final state = await _controllerWithCoins(240);

    await state.controller.purchaseUpgrade('TRAVESSIA_GRANDE_VIA');
    await state.controller.purchaseUpgrade('ILUMINACAO_CORREDOR');
    await state.controller.purchaseUpgrade('REFUGIO_PEDESTRE');

    final restored = PlayerController(state.storage);
    await restored.initialize();

    expect(restored.progress.coins, 0);
    expect(
      restored.progress.purchasedUpgrades,
      containsAll(<String>[
        'TRAVESSIA_GRANDE_VIA',
        'ILUMINACAO_CORREDOR',
        'REFUGIO_PEDESTRE',
      ]),
    );
  });

  test('nao compra melhoria Zona 5 sem saldo suficiente', () async {
    final state = await _controllerWithCoins(59);

    final purchased = await state.controller.purchaseUpgrade(
      'TRAVESSIA_GRANDE_VIA',
    );

    expect(purchased, isFalse);
    expect(state.controller.progress.coins, 59);
  });

  test('nao cobra duas vezes a mesma melhoria Zona 5', () async {
    final state = await _controllerWithCoins(160);

    final first = await state.controller.purchaseUpgrade('ILUMINACAO_CORREDOR');
    final coinsAfterFirst = state.controller.progress.coins;
    final second = await state.controller.purchaseUpgrade(
      'ILUMINACAO_CORREDOR',
    );

    expect(first, isTrue);
    expect(second, isFalse);
    expect(state.controller.progress.coins, coinsAfterFirst);
  });
}
