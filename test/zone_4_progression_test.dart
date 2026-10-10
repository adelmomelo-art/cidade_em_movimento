import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

MissionResult _result(
  String id, {
  required int citizenship,
  required int knowledge,
  required int coins,
  int stars = 3,
}) {
  return MissionResult(
    missionId: id,
    stars: stars,
    score: stars == 3 ? 100 : (stars == 2 ? 80 : 60),
    citizenship: citizenship,
    knowledge: knowledge,
    coins: coins,
    errors: 3 - stars,
  );
}

Future<PlayerController> _controllerWithZone4Unlocked() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();

  for (final row in [
    ('Z1_SPECIAL', 50, 30, 50),
    ('Z2_SPECIAL', 50, 35, 60),
    ('Z3_SPECIAL', 50, 35, 60),
  ]) {
    await controller.completeMission(
      result: _result(
        row.$1,
        citizenship: row.$2,
        knowledge: row.$3,
        coins: row.$4,
      ),
    );
  }

  return controller;
}

void main() {
  test('Zona 4 desbloqueia somente apos Zona 3 e medalha', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final controller = PlayerController(StorageService(preferences));
    await controller.initialize();

    expect(controller.isZoneUnlocked('ZONE_4'), isFalse);

    for (final row in [
      ('Z1_SPECIAL', 50, 30, 50),
      ('Z2_SPECIAL', 50, 35, 60),
    ]) {
      await controller.completeMission(
        result: _result(
          row.$1,
          citizenship: row.$2,
          knowledge: row.$3,
          coins: row.$4,
        ),
      );
    }

    expect(controller.isZoneUnlocked('ZONE_4'), isFalse);

    await controller.completeMission(
      result: _result('Z3_SPECIAL', citizenship: 50, knowledge: 35, coins: 60),
    );

    expect(controller.isZoneUnlocked('ZONE_4'), isTrue);
    expect(controller.progress.unlockedMissions, contains('Z4_M01'));
  });

  test('Zona 4 progride M01 ate M05 e libera especial', () async {
    final controller = await _controllerWithZone4Unlocked();

    final rows = [
      ('Z4_M01', 20, 15, 20, 'Z4_M02'),
      ('Z4_M02', 20, 15, 20, 'Z4_M03'),
      ('Z4_M03', 25, 20, 25, 'Z4_M04'),
      ('Z4_M04', 25, 20, 25, 'Z4_M05'),
      ('Z4_M05', 30, 25, 30, null),
    ];

    for (final row in rows) {
      await controller.completeMission(
        result: _result(
          row.$1,
          citizenship: row.$2,
          knowledge: row.$3,
          coins: row.$4,
        ),
        nextMissionId: row.$5,
      );
    }

    expect(controller.progress.unlockedMissions, contains('Z4_SPECIAL'));
  });

  test('Zona 4 fecha com medalha e bonus unico', () async {
    final controller = await _controllerWithZone4Unlocked();
    final before = controller.progress.coins;

    final rows = [
      ('Z4_M01', 20, 15, 20, 'Z4_M02'),
      ('Z4_M02', 20, 15, 20, 'Z4_M03'),
      ('Z4_M03', 25, 20, 25, 'Z4_M04'),
      ('Z4_M04', 25, 20, 25, 'Z4_M05'),
      ('Z4_M05', 30, 25, 30, null),
    ];

    for (final row in rows) {
      await controller.completeMission(
        result: _result(
          row.$1,
          citizenship: row.$2,
          knowledge: row.$3,
          coins: row.$4,
        ),
        nextMissionId: row.$5,
      );
    }

    await controller.completeMission(
      result: _result('Z4_SPECIAL', citizenship: 50, knowledge: 35, coins: 60),
    );

    expect(controller.progress.completedZones, contains('ZONE_4'));
    expect(controller.progress.medals, contains('GUARDIAO_DA_CULTURA'));
    expect(
      controller.progress.claimedZoneCompletionBonuses,
      contains('ZONE_4'),
    );
    expect(controller.progress.coins - before, 240);

    final afterFirst = controller.progress.coins;

    await controller.completeMission(
      result: _result('Z4_SPECIAL', citizenship: 50, knowledge: 35, coins: 60),
    );

    expect(controller.progress.coins, afterFirst);
  });
}
