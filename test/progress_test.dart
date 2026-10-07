import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('concluir missao 1 libera missao 2 e persiste progresso', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final storage = StorageService(preferences);
    final controller = PlayerController(storage);
    await controller.initialize();

    const result = MissionResult(
      missionId: 'Z1_M01',
      stars: 3,
      score: 100,
      citizenship: 20,
      knowledge: 10,
      coins: 15,
      errors: 0,
    );

    await controller.completeMission(result: result, nextMissionId: 'Z1_M02');

    expect(controller.progress.completedMissions.contains('Z1_M01'), isTrue);
    expect(controller.progress.unlockedMissions.contains('Z1_M02'), isTrue);
    expect(controller.progress.missionStars['Z1_M01'], 3);

    final secondController = PlayerController(storage);
    await secondController.initialize();
    expect(
      secondController.progress.unlockedMissions.contains('Z1_M02'),
      isTrue,
    );
    expect(secondController.progress.citizenshipXp, 20);
  });

  test('concluir missao 2 libera missao 3 e persiste progresso', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final storage = StorageService(preferences);
    final controller = PlayerController(storage);
    await controller.initialize();

    const result = MissionResult(
      missionId: 'Z1_M02',
      stars: 3,
      score: 100,
      citizenship: 20,
      knowledge: 15,
      coins: 20,
      errors: 0,
    );

    await controller.completeMission(result: result, nextMissionId: 'Z1_M03');

    expect(controller.progress.completedMissions.contains('Z1_M02'), isTrue);
    expect(controller.progress.unlockedMissions.contains('Z1_M03'), isTrue);
    expect(controller.progress.missionStars['Z1_M02'], 3);
    expect(controller.progress.citizenshipXp, 20);
    expect(controller.progress.knowledge, 15);
    expect(controller.progress.coins, 20);

    final secondController = PlayerController(storage);
    await secondController.initialize();
    expect(
      secondController.progress.unlockedMissions.contains('Z1_M03'),
      isTrue,
    );
    expect(secondController.progress.citizenshipXp, 20);
    expect(secondController.progress.knowledge, 15);
    expect(secondController.progress.coins, 20);
  });

  test('repetir missao concluida nao duplica recompensas', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final storage = StorageService(preferences);
    final controller = PlayerController(storage);
    await controller.initialize();

    const firstResult = MissionResult(
      missionId: 'Z1_M01',
      stars: 2,
      score: 80,
      citizenship: 20,
      knowledge: 10,
      coins: 15,
      errors: 1,
    );

    await controller.completeMission(
      result: firstResult,
      nextMissionId: 'Z1_M02',
    );

    const replayResult = MissionResult(
      missionId: 'Z1_M01',
      stars: 3,
      score: 100,
      citizenship: 20,
      knowledge: 10,
      coins: 15,
      errors: 0,
    );

    await controller.completeMission(
      result: replayResult,
      nextMissionId: 'Z1_M02',
    );

    expect(controller.progress.citizenshipXp, 20);
    expect(controller.progress.knowledge, 10);
    expect(controller.progress.coins, 15);
    expect(controller.progress.missionStars['Z1_M01'], 3);
  });
}
