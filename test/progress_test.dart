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
}
