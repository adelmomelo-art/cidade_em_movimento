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

Future<PlayerController> _controllerWithZone3Unlocked() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();

  await controller.completeMission(
    result: _result('Z1_SPECIAL', citizenship: 50, knowledge: 30, coins: 50),
  );

  await controller.completeMission(
    result: _result('Z2_SPECIAL', citizenship: 50, knowledge: 35, coins: 60),
  );

  return controller;
}

void main() {
  test('Zona 3 desbloqueia somente apos Zona 2 e medalha', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final controller = PlayerController(StorageService(preferences));
    await controller.initialize();

    expect(controller.isZoneUnlocked('ZONE_3'), isFalse);

    await controller.completeMission(
      result: _result('Z1_SPECIAL', citizenship: 50, knowledge: 30, coins: 50),
    );

    expect(controller.isZoneUnlocked('ZONE_3'), isFalse);

    await controller.completeMission(
      result: _result('Z2_SPECIAL', citizenship: 50, knowledge: 35, coins: 60),
    );

    expect(controller.isZoneUnlocked('ZONE_3'), isTrue);
    expect(controller.progress.unlockedMissions, contains('Z3_M01'));
  });

  test('Zona 3 progride M01 ate M05 e libera especial', () async {
    final controller = await _controllerWithZone3Unlocked();

    final rows = [
      ('Z3_M01', 20, 15, 20, 'Z3_M02'),
      ('Z3_M02', 20, 15, 20, 'Z3_M03'),
      ('Z3_M03', 25, 20, 25, 'Z3_M04'),
      ('Z3_M04', 25, 20, 25, 'Z3_M05'),
      ('Z3_M05', 30, 25, 30, null),
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

    expect(controller.progress.unlockedMissions, contains('Z3_SPECIAL'));
  });

  test('Zona 3 fecha com medalha e bonus unico', () async {
    final controller = await _controllerWithZone3Unlocked();
    final before = controller.progress.coins;

    final rows = [
      ('Z3_M01', 20, 15, 20, 'Z3_M02'),
      ('Z3_M02', 20, 15, 20, 'Z3_M03'),
      ('Z3_M03', 25, 20, 25, 'Z3_M04'),
      ('Z3_M04', 25, 20, 25, 'Z3_M05'),
      ('Z3_M05', 30, 25, 30, null),
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
      result: _result('Z3_SPECIAL', citizenship: 50, knowledge: 35, coins: 60),
    );

    expect(controller.progress.completedZones, contains('ZONE_3'));
    expect(controller.progress.medals, contains('GUARDIAO_DA_ORLA'));
    expect(
      controller.progress.claimedZoneCompletionBonuses,
      contains('ZONE_3'),
    );
    expect(controller.progress.coins - before, 240);

    final afterFirst = controller.progress.coins;

    await controller.completeMission(
      result: _result('Z3_SPECIAL', citizenship: 50, knowledge: 35, coins: 60),
    );

    expect(controller.progress.coins, afterFirst);
  });
}
