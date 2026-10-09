import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _controller() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();
  return controller;
}

void main() {
  test('Zona 1 concede bonus de 60 moedas ao concluir especial', () async {
    final controller = await _controller();

    await controller.completeMission(
      result: const MissionResult(
        missionId: 'Z1_SPECIAL',
        stars: 3,
        score: 100,
        citizenship: 50,
        knowledge: 30,
        coins: 50,
        errors: 0,
      ),
    );

    expect(controller.progress.completedZones, contains('ZONE_1'));
    expect(controller.progress.medals, contains('PROTETOR_DA_ESCOLA'));
    expect(controller.progress.coins, 110);
    expect(
      controller.progress.claimedZoneCompletionBonuses,
      contains('ZONE_1'),
    );
  });

  test('replay da especial nao duplica recompensa nem bonus', () async {
    final controller = await _controller();

    const result = MissionResult(
      missionId: 'Z1_SPECIAL',
      stars: 3,
      score: 100,
      citizenship: 50,
      knowledge: 30,
      coins: 50,
      errors: 0,
    );

    await controller.completeMission(result: result);
    final coinsAfterFirst = controller.progress.coins;

    await controller.completeMission(result: result);

    expect(coinsAfterFirst, 110);
    expect(controller.progress.coins, coinsAfterFirst);
    expect(controller.progress.claimedZoneCompletionBonuses.length, 1);
  });

  test('save legado concluido recebe bonus pendente uma unica vez', () async {
    SharedPreferences.setMockInitialValues({
      'cidade_em_movimento.game_progress.v1':
          '{"citizenshipXp":170,"knowledge":105,"coins":100,'
          '"completedMissions":["Z1_M01","Z1_M02","Z1_M03","Z1_M04",'
          '"Z1_M05","Z1_SPECIAL"],'
          '"missionStars":{"Z1_M01":3,"Z1_M02":3,"Z1_M03":3,"Z1_M04":3,'
          '"Z1_M05":3,"Z1_SPECIAL":3},'
          '"unlockedMissions":["Z1_M01","Z1_M02","Z1_M03","Z1_M04",'
          '"Z1_M05","Z1_SPECIAL"],'
          '"purchasedUpgrades":[],"medals":["PROTETOR_DA_ESCOLA"],'
          '"completedZones":["ZONE_1"],"zone1Completed":true}',
    });

    final preferences = await SharedPreferences.getInstance();
    final storage = StorageService(preferences);

    final firstController = PlayerController(storage);
    await firstController.initialize();

    expect(firstController.progress.coins, 160);
    expect(
      firstController.progress.claimedZoneCompletionBonuses,
      contains('ZONE_1'),
    );

    final secondController = PlayerController(storage);
    await secondController.initialize();

    expect(secondController.progress.coins, 160);
    expect(secondController.progress.claimedZoneCompletionBonuses.length, 1);
  });
}
