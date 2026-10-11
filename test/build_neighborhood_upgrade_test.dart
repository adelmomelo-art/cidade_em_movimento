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
      missionId: 'FAST15_COINS_$coins',
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
  test('compra tres melhorias do bairro com 180 moedas', () async {
    final state = await _controllerWithCoins(180);

    expect(
      await state.controller.purchaseUpgrade('BAIRRO_CALCADA_ACESSIVEL'),
      isTrue,
    );
    expect(
      await state.controller.purchaseUpgrade('BAIRRO_PRACA_CONVIVENCIA'),
      isTrue,
    );
    expect(
      await state.controller.purchaseUpgrade('BAIRRO_BICICLETARIO'),
      isTrue,
    );

    expect(state.controller.progress.coins, 0);
    expect(
      state.controller.progress.purchasedUpgrades,
      containsAll(<String>[
        'BAIRRO_CALCADA_ACESSIVEL',
        'BAIRRO_PRACA_CONVIVENCIA',
        'BAIRRO_BICICLETARIO',
      ]),
    );
  });

  test('melhorias do bairro persistem apos reinicializacao', () async {
    final state = await _controllerWithCoins(180);

    await state.controller.purchaseUpgrade('BAIRRO_CALCADA_ACESSIVEL');
    await state.controller.purchaseUpgrade('BAIRRO_PRACA_CONVIVENCIA');
    await state.controller.purchaseUpgrade('BAIRRO_BICICLETARIO');

    final restored = PlayerController(state.storage);
    await restored.initialize();

    expect(restored.progress.coins, 0);
    expect(
      restored.progress.purchasedUpgrades,
      containsAll(<String>[
        'BAIRRO_CALCADA_ACESSIVEL',
        'BAIRRO_PRACA_CONVIVENCIA',
        'BAIRRO_BICICLETARIO',
      ]),
    );
  });

  test('recompra e saldo insuficiente permanecem bloqueados', () async {
    final state = await _controllerWithCoins(40);

    expect(
      await state.controller.purchaseUpgrade('BAIRRO_CALCADA_ACESSIVEL'),
      isTrue,
    );
    expect(
      await state.controller.purchaseUpgrade('BAIRRO_CALCADA_ACESSIVEL'),
      isFalse,
    );
    expect(
      await state.controller.purchaseUpgrade('BAIRRO_PRACA_CONVIVENCIA'),
      isFalse,
    );
    expect(state.controller.progress.coins, 0);
  });
}
