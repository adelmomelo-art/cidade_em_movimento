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
  test('Zona 2 inicia bloqueada', () async {
    final controller = await _controller();

    expect(controller.isZoneUnlocked('ZONE_2'), isFalse);
    expect(controller.progress.unlockedMissions.contains('Z2_M01'), isFalse);
  });

  test(
    'conclusao da Zona 1 desbloqueia Zona 2 e sua primeira missao',
    () async {
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
      expect(controller.isZoneUnlocked('ZONE_2'), isTrue);
      expect(controller.progress.unlockedMissions, contains('Z2_M01'));
    },
  );

  test('Zona 2 exige simultaneamente zona anterior e medalha', () async {
    SharedPreferences.setMockInitialValues({
      'cidade_em_movimento.game_progress.v1':
          '{"citizenshipXp":0,"knowledge":0,"coins":0,'
          '"completedMissions":[],"missionStars":{},'
          '"unlockedMissions":["Z1_M01"],"purchasedUpgrades":[],'
          '"medals":[],"completedZones":["ZONE_1"],'
          '"claimedZoneCompletionBonuses":["ZONE_1"],'
          '"zone1Completed":true}',
    });

    final preferences = await SharedPreferences.getInstance();
    final controller = PlayerController(StorageService(preferences));
    await controller.initialize();

    expect(controller.isZoneUnlocked('ZONE_2'), isFalse);
  });
}
