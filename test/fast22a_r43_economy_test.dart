import 'dart:convert';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:cidade_em_movimento/models/game_progress.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'cidade_em_movimento.game_progress.v1';
Future<PlayerController> _load(Map<String, dynamic> json) async {
  SharedPreferences.setMockInitialValues({_key: jsonEncode(json)});
  final c = PlayerController(
    StorageService(await SharedPreferences.getInstance()),
  );
  await c.initialize();
  addTearDown(c.dispose);
  return c;
}

MissionResult _special(int zone) => MissionResult(
  missionId: 'Z${zone}_SPECIAL',
  stars: 3,
  score: 100,
  citizenship: 0,
  knowledge: 0,
  coins: 0,
  errors: 0,
);

class _FailingStorage extends StorageService {
  _FailingStorage(super.preferences);
  bool fail = false;
  @override
  Future<void> saveProgress(GameProgress progress) async {
    if (fail) {
      throw StateError('Falha simulada');
    }
    await super.saveProgress(progress);
  }
}

void main() {
  test('30 melhorias oficiais e 3 antigas: custo total 2200', () {
    expect(upgradeCatalog.length, 30);
    expect(allUpgradeCatalog.length, 33);
    expect(allUpgradeCatalog.map((u) => u.id).toSet().length, 33);
    expect(allUpgradeCatalog.fold<int>(0, (n, u) => n + u.cost), 2200);
    for (final zone in zoneCatalog) {
      final items = upgradesForZone(zone.id);
      expect(items.length, 5);
      expect(items.skip(3).map((u) => u.cost), [40, 60]);
    }
  });
  test(
    'save R42 com bônus antigo pago recebe só 130 por zona e preserva compras',
    () async {
      final old = GameProgress.initial().toJson()
        ..addAll({
          'coins': 17,
          'completedZones': ['ZONE_1', 'ZONE_3', 'INEXISTENTE'],
          'claimedZoneCompletionBonuses': ['ZONE_1', 'ZONE_3'],
          'purchasedUpgrades': ['FAIXA_SEGURA', 'BAIRRO_BICICLETARIO'],
          'signDuelBestScore': 600,
          'signDuelBestCorrect': 6,
          'signDuelPlays': 4,
        });
      old.remove('claimedR43ZoneBonuses');
      final c = await _load(old);
      expect(c.progress.coins, 277);
      expect(c.progress.claimedR43ZoneBonuses, {'ZONE_1', 'ZONE_3'});
      expect(c.progress.purchasedUpgrades, {
        'FAIXA_SEGURA',
        'BAIRRO_BICICLETARIO',
      });
      await c.recordSignDuelResult(score: 600, correctAnswers: 6);
      expect(c.progress.coins, 277);
      final restored = PlayerController(
        StorageService(await SharedPreferences.getInstance()),
      );
      addTearDown(restored.dispose);
      await restored.initialize();
      expect(restored.progress.coins, 277);
      expect(restored.progress.claimedR43ZoneBonuses, {'ZONE_1', 'ZONE_3'});
      expect(restored.progress.signDuelBestScore, 600);
      expect(restored.progress.signDuelPlays, 5);
    },
  );
  test(
    'novo jogador recebe adicional uma vez nas seis zonas, inclusive após replay',
    () async {
      final c = await _load(GameProgress.initial().toJson());
      for (var i = 1; i <= 6; i++) {
        final before = c.progress.coins;
        await c.completeMission(result: _special(i));
        expect(
          c.progress.coins,
          before + zoneCatalog[i - 1].completionBonusCoins + 130,
        );
        final after = c.progress.coins;
        await c.completeMission(result: _special(i));
        expect(c.progress.coins, after);
      }
      expect(c.progress.claimedR43ZoneBonuses.length, 6);
      expect(c.progress.claimedZoneCompletionBonuses.length, 6);
    },
  );
  test('migração parcial concede somente adicionais pendentes', () async {
    final c = await _load(
      GameProgress.initial().toJson()..addAll({
        'coins': 30,
        'completedZones': ['ZONE_1', 'ZONE_2'],
        'claimedZoneCompletionBonuses': ['ZONE_1', 'ZONE_2'],
        'claimedR43ZoneBonuses': ['ZONE_1'],
      }),
    );
    expect(c.progress.coins, 160);
    expect(c.progress.claimedR43ZoneBonuses, {'ZONE_1', 'ZONE_2'});
  });
  test(
    'compra simultânea não duplica desconto e reinício preserva bônus e compra',
    () async {
      final c = await _load(
        GameProgress.initial().toJson()..addAll({'coins': 100}),
      );
      final results = await Future.wait([
        c.purchaseUpgrade('CALCADA_ACESSIVEL_ESCOLAR'),
        c.purchaseUpgrade('CALCADA_ACESSIVEL_ESCOLAR'),
      ]);
      expect(results.where((ok) => ok).length, 1);
      expect(c.progress.coins, 60);
      expect(await c.purchaseUpgrade('INVALIDA'), isFalse);
      expect(await c.purchaseUpgrade('TRECHO_CICLOVIARIO'), isFalse);
      final restored = PlayerController(
        StorageService(await SharedPreferences.getInstance()),
      );
      addTearDown(restored.dispose);
      await restored.initialize();
      expect(restored.progress.coins, 60);
      expect(restored.progress.purchasedUpgrades, {
        'CALCADA_ACESSIVEL_ESCOLAR',
      });
    },
  );
  test(
    'falha ao salvar compra preserva saldo e permite nova tentativa',
    () async {
      SharedPreferences.setMockInitialValues({
        _key: jsonEncode(GameProgress.initial().toJson()..['coins'] = 100),
      });
      final storage = _FailingStorage(await SharedPreferences.getInstance());
      final c = PlayerController(storage);
      addTearDown(c.dispose);
      await c.initialize();
      storage.fail = true;
      await expectLater(
        c.purchaseUpgrade('CALCADA_ACESSIVEL_ESCOLAR'),
        throwsStateError,
      );
      expect(c.progress.coins, 100);
      expect(c.progress.purchasedUpgrades, isEmpty);
      storage.fail = false;
      expect(await c.purchaseUpgrade('CALCADA_ACESSIVEL_ESCOLAR'), isTrue);
      expect(c.progress.coins, 60);
    },
  );
}
