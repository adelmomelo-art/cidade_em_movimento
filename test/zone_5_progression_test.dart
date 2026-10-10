import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

MissionResult _r(String id, int c, int k, int coins, {int stars = 3}) {
  return MissionResult(
    missionId: id,
    stars: stars,
    score: stars == 3 ? 100 : 80,
    citizenship: c,
    knowledge: k,
    coins: coins,
    errors: 3 - stars,
  );
}

Future<PlayerController> _unlocked() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(prefs));
  await controller.initialize();

  for (final row in [
    ('Z1_SPECIAL', 50, 30, 50),
    ('Z2_SPECIAL', 50, 35, 60),
    ('Z3_SPECIAL', 50, 35, 60),
    ('Z4_SPECIAL', 50, 35, 60),
  ]) {
    await controller.completeMission(
      result: _r(row.$1, row.$2, row.$3, row.$4),
    );
  }
  return controller;
}

void main() {
  test('Zona 5 desbloqueia apos Zona 4 e medalha', () async {
    final controller = await _unlocked();
    expect(controller.isZoneUnlocked('ZONE_5'), isTrue);
    expect(controller.progress.unlockedMissions, contains('Z5_M01'));
  });

  test('Zona 5 progride M01 ate M05 e libera especial', () async {
    final controller = await _unlocked();
    final rows = [
      ('Z5_M01', 20, 15, 20, 'Z5_M02'),
      ('Z5_M02', 20, 15, 20, 'Z5_M03'),
      ('Z5_M03', 25, 20, 25, 'Z5_M04'),
      ('Z5_M04', 25, 20, 25, 'Z5_M05'),
      ('Z5_M05', 30, 25, 30, null),
    ];

    for (final row in rows) {
      await controller.completeMission(
        result: _r(row.$1, row.$2, row.$3, row.$4),
        nextMissionId: row.$5,
      );
    }
    expect(controller.progress.unlockedMissions, contains('Z5_SPECIAL'));
  });

  test('Zona 5 fecha com medalha e bonus unico', () async {
    final controller = await _unlocked();
    final before = controller.progress.coins;

    final rows = [
      ('Z5_M01', 20, 15, 20, 'Z5_M02'),
      ('Z5_M02', 20, 15, 20, 'Z5_M03'),
      ('Z5_M03', 25, 20, 25, 'Z5_M04'),
      ('Z5_M04', 25, 20, 25, 'Z5_M05'),
      ('Z5_M05', 30, 25, 30, null),
    ];
    for (final row in rows) {
      await controller.completeMission(
        result: _r(row.$1, row.$2, row.$3, row.$4),
        nextMissionId: row.$5,
      );
    }
    await controller.completeMission(result: _r('Z5_SPECIAL', 50, 35, 60));

    expect(controller.progress.completedZones, contains('ZONE_5'));
    expect(controller.progress.medals, contains('GUARDIAO_DAS_VIAS'));
    expect(controller.progress.coins - before, 240);

    final after = controller.progress.coins;
    await controller.completeMission(result: _r('Z5_SPECIAL', 50, 35, 60));
    expect(controller.progress.coins, after);
  });
}
