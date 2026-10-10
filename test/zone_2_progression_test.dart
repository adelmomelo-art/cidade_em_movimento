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

Future<PlayerController> _controllerWithZone2Unlocked() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();

  await controller.completeMission(
    result: _result('Z1_SPECIAL', citizenship: 50, knowledge: 30, coins: 50),
  );

  return controller;
}

Future<void> _completeZone2Regular(PlayerController controller) async {
  await controller.completeMission(
    result: _result('Z2_M01', citizenship: 20, knowledge: 15, coins: 20),
    nextMissionId: 'Z2_M02',
  );
  await controller.completeMission(
    result: _result('Z2_M02', citizenship: 20, knowledge: 15, coins: 20),
    nextMissionId: 'Z2_M03',
  );
  await controller.completeMission(
    result: _result('Z2_M03', citizenship: 25, knowledge: 20, coins: 25),
    nextMissionId: 'Z2_M04',
  );
  await controller.completeMission(
    result: _result('Z2_M04', citizenship: 25, knowledge: 20, coins: 25),
    nextMissionId: 'Z2_M05',
  );
  await controller.completeMission(
    result: _result('Z2_M05', citizenship: 30, knowledge: 25, coins: 30),
  );
}

void main() {
  test('missoes Zona 2 desbloqueiam em sequencia', () async {
    final controller = await _controllerWithZone2Unlocked();

    expect(controller.progress.unlockedMissions, contains('Z2_M01'));
    expect(controller.progress.unlockedMissions, isNot(contains('Z2_M02')));

    await controller.completeMission(
      result: _result('Z2_M01', citizenship: 20, knowledge: 15, coins: 20),
      nextMissionId: 'Z2_M02',
    );

    expect(controller.progress.unlockedMissions, contains('Z2_M02'));
  });

  test('especial exige cinco regulares e nove estrelas', () async {
    final controller = await _controllerWithZone2Unlocked();

    final data = [
      ('Z2_M01', 20, 15, 20, 'Z2_M02'),
      ('Z2_M02', 20, 15, 20, 'Z2_M03'),
      ('Z2_M03', 25, 20, 25, 'Z2_M04'),
      ('Z2_M04', 25, 20, 25, 'Z2_M05'),
      ('Z2_M05', 30, 25, 30, null),
    ];

    for (final item in data) {
      await controller.completeMission(
        result: _result(
          item.$1,
          citizenship: item.$2,
          knowledge: item.$3,
          coins: item.$4,
          stars: 1,
        ),
        nextMissionId: item.$5,
      );
    }

    expect(controller.progress.unlockedMissions, isNot(contains('Z2_SPECIAL')));

    await controller.completeMission(
      result: _result(
        'Z2_M01',
        citizenship: 20,
        knowledge: 15,
        coins: 20,
        stars: 3,
      ),
    );

    await controller.completeMission(
      result: _result(
        'Z2_M02',
        citizenship: 20,
        knowledge: 15,
        coins: 20,
        stars: 3,
      ),
    );

    expect(controller.progress.unlockedMissions, contains('Z2_SPECIAL'));
  });

  test('fechar Zona 2 concede medalha e bonus uma unica vez', () async {
    final controller = await _controllerWithZone2Unlocked();

    final coinsBefore = controller.progress.coins;

    await _completeZone2Regular(controller);

    await controller.completeMission(
      result: _result('Z2_SPECIAL', citizenship: 50, knowledge: 35, coins: 60),
    );

    expect(controller.progress.completedZones, contains('ZONE_2'));
    expect(controller.progress.medals, contains('GUARDIAO_DO_CENTRO'));
    expect(
      controller.progress.claimedZoneCompletionBonuses,
      contains('ZONE_2'),
    );

    expect(controller.progress.coins - coinsBefore, 240);

    final afterFirst = controller.progress.coins;

    await controller.completeMission(
      result: _result('Z2_SPECIAL', citizenship: 50, knowledge: 35, coins: 60),
    );

    expect(controller.progress.coins, afterFirst);
  });
}
