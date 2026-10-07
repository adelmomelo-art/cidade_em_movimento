import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _controller() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final storage = StorageService(preferences);
  final controller = PlayerController(storage);
  await controller.initialize();
  return controller;
}

MissionResult _result({
  required String missionId,
  required int stars,
  required int citizenship,
  required int knowledge,
  required int coins,
}) {
  return MissionResult(
    missionId: missionId,
    stars: stars,
    score: stars == 3 ? 100 : (stars == 2 ? 80 : 60),
    citizenship: citizenship,
    knowledge: knowledge,
    coins: coins,
    errors: 3 - stars,
  );
}

Future<void> _completeFirstFour(
  PlayerController controller, {
  required List<int> stars,
}) async {
  await controller.completeMission(
    result: _result(
      missionId: 'Z1_M01',
      stars: stars[0],
      citizenship: 20,
      knowledge: 10,
      coins: 15,
    ),
    nextMissionId: 'Z1_M02',
  );

  await controller.completeMission(
    result: _result(
      missionId: 'Z1_M02',
      stars: stars[1],
      citizenship: 20,
      knowledge: 15,
      coins: 20,
    ),
    nextMissionId: 'Z1_M03',
  );

  await controller.completeMission(
    result: _result(
      missionId: 'Z1_M03',
      stars: stars[2],
      citizenship: 25,
      knowledge: 15,
      coins: 20,
    ),
    nextMissionId: 'Z1_M04',
  );

  await controller.completeMission(
    result: _result(
      missionId: 'Z1_M04',
      stars: stars[3],
      citizenship: 25,
      knowledge: 15,
      coins: 25,
    ),
    nextMissionId: 'Z1_M05',
  );
}

void main() {
  test('concluir missao 5 persiste recompensas e conclusao', () async {
    final controller = await _controller();

    await _completeFirstFour(controller, stars: const [3, 3, 3, 3]);

    await controller.completeMission(
      result: _result(
        missionId: 'Z1_M05',
        stars: 3,
        citizenship: 30,
        knowledge: 20,
        coins: 30,
      ),
    );

    expect(controller.progress.completedMissions.contains('Z1_M05'), isTrue);
    expect(controller.progress.missionStars['Z1_M05'], 3);

    expect(controller.progress.citizenshipXp, 120);
    expect(controller.progress.knowledge, 75);
    expect(controller.progress.coins, 110);

    expect(controller.progress.unlockedMissions.contains('Z1_SPECIAL'), isTrue);
  });

  test(
    'missao especial nao desbloqueia com cinco missoes e menos de 9 estrelas',
    () async {
      final controller = await _controller();

      await _completeFirstFour(controller, stars: const [2, 2, 1, 1]);

      await controller.completeMission(
        result: _result(
          missionId: 'Z1_M05',
          stars: 2,
          citizenship: 30,
          knowledge: 20,
          coins: 30,
        ),
      );

      final totalStars = controller.progress.missionStars.values.fold<int>(
        0,
        (total, value) => total + value,
      );

      expect(totalStars, 8);
      expect(
        controller.progress.unlockedMissions.contains('Z1_SPECIAL'),
        isFalse,
      );
    },
  );

  test(
    'missao especial desbloqueia com cinco missoes e minimo de 9 estrelas',
    () async {
      final controller = await _controller();

      await _completeFirstFour(controller, stars: const [2, 2, 1, 1]);

      await controller.completeMission(
        result: _result(
          missionId: 'Z1_M05',
          stars: 3,
          citizenship: 30,
          knowledge: 20,
          coins: 30,
        ),
      );

      expect(
        controller.progress.unlockedMissions.contains('Z1_SPECIAL'),
        isTrue,
      );
    },
  );

  test('replay pode atingir 9 estrelas sem duplicar recompensas', () async {
    final controller = await _controller();

    await _completeFirstFour(controller, stars: const [2, 2, 1, 1]);

    await controller.completeMission(
      result: _result(
        missionId: 'Z1_M05',
        stars: 2,
        citizenship: 30,
        knowledge: 20,
        coins: 30,
      ),
    );

    expect(
      controller.progress.unlockedMissions.contains('Z1_SPECIAL'),
      isFalse,
    );

    final citizenshipBefore = controller.progress.citizenshipXp;
    final knowledgeBefore = controller.progress.knowledge;
    final coinsBefore = controller.progress.coins;

    await controller.completeMission(
      result: _result(
        missionId: 'Z1_M05',
        stars: 3,
        citizenship: 30,
        knowledge: 20,
        coins: 30,
      ),
    );

    expect(controller.progress.citizenshipXp, citizenshipBefore);
    expect(controller.progress.knowledge, knowledgeBefore);
    expect(controller.progress.coins, coinsBefore);
    expect(controller.progress.missionStars['Z1_M05'], 3);
    expect(controller.progress.unlockedMissions.contains('Z1_SPECIAL'), isTrue);
  });
}
