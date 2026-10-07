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
      missionId: 'TEST_COINS_$coins',
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
  test('faixa segura custa 50 moedas e persiste', () async {
    final state = await _controllerWithCoins(80);

    final purchased = await state.controller.purchaseUpgrade('FAIXA_SEGURA');

    expect(purchased, isTrue);
    expect(state.controller.progress.coins, 30);
    expect(
      state.controller.progress.purchasedUpgrades.contains('FAIXA_SEGURA'),
      isTrue,
    );

    final secondController = PlayerController(state.storage);
    await secondController.initialize();

    expect(secondController.progress.coins, 30);
    expect(
      secondController.progress.purchasedUpgrades.contains('FAIXA_SEGURA'),
      isTrue,
    );
  });

  test('iluminacao escolar custa 70 moedas', () async {
    final state = await _controllerWithCoins(100);

    final purchased = await state.controller.purchaseUpgrade(
      'ILUMINACAO_ESCOLAR',
    );

    expect(purchased, isTrue);
    expect(state.controller.progress.coins, 30);
  });

  test('trecho cicloviario custa 100 moedas', () async {
    final state = await _controllerWithCoins(120);

    final purchased = await state.controller.purchaseUpgrade(
      'TRECHO_CICLOVIARIO',
    );

    expect(purchased, isTrue);
    expect(state.controller.progress.coins, 20);
  });

  test('nao compra melhoria sem moedas suficientes', () async {
    final state = await _controllerWithCoins(49);

    final purchased = await state.controller.purchaseUpgrade('FAIXA_SEGURA');

    expect(purchased, isFalse);
    expect(state.controller.progress.coins, 49);
    expect(state.controller.progress.purchasedUpgrades, isEmpty);
  });

  test('nao cobra duas vezes a mesma melhoria', () async {
    final state = await _controllerWithCoins(120);

    final firstPurchase = await state.controller.purchaseUpgrade(
      'FAIXA_SEGURA',
    );
    final coinsAfterFirstPurchase = state.controller.progress.coins;

    final secondPurchase = await state.controller.purchaseUpgrade(
      'FAIXA_SEGURA',
    );

    expect(firstPurchase, isTrue);
    expect(secondPurchase, isFalse);
    expect(state.controller.progress.coins, coinsAfterFirstPurchase);
    expect(state.controller.progress.purchasedUpgrades.length, 1);
  });

  test('rejeita melhoria fora do catalogo oficial', () async {
    final state = await _controllerWithCoins(160);

    final purchased = await state.controller.purchaseUpgrade(
      'MELHORIA_INEXISTENTE',
    );

    expect(purchased, isFalse);
    expect(state.controller.progress.coins, 160);
    expect(state.controller.progress.purchasedUpgrades, isEmpty);
  });
}
