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

Future<void> _completeZoneRegular(PlayerController controller) async {
  await controller.completeMission(
    result: _result(
      missionId: 'Z1_M01',
      stars: 3,
      citizenship: 20,
      knowledge: 10,
      coins: 15,
    ),
    nextMissionId: 'Z1_M02',
  );

  await controller.completeMission(
    result: _result(
      missionId: 'Z1_M02',
      stars: 3,
      citizenship: 20,
      knowledge: 15,
      coins: 20,
    ),
    nextMissionId: 'Z1_M03',
  );

  await controller.completeMission(
    result: _result(
      missionId: 'Z1_M03',
      stars: 3,
      citizenship: 25,
      knowledge: 15,
      coins: 20,
    ),
    nextMissionId: 'Z1_M04',
  );

  await controller.completeMission(
    result: _result(
      missionId: 'Z1_M04',
      stars: 3,
      citizenship: 25,
      knowledge: 15,
      coins: 25,
    ),
    nextMissionId: 'Z1_M05',
  );

  await controller.completeMission(
    result: _result(
      missionId: 'Z1_M05',
      stars: 3,
      citizenship: 30,
      knowledge: 20,
      coins: 30,
    ),
  );
}

void main() {
  test(
    'missao especial continua protegida por 5 missoes e 9 estrelas',
    () async {
      final controller = await _controller();

      expect(
        controller.progress.unlockedMissions.contains('Z1_SPECIAL'),
        isFalse,
      );

      await _completeZoneRegular(controller);

      expect(
        controller.progress.unlockedMissions.contains('Z1_SPECIAL'),
        isTrue,
      );
    },
  );

  test('concluir especial fecha zona 1 e concede medalha', () async {
    final controller = await _controller();

    await _completeZoneRegular(controller);

    await controller.completeMission(
      result: _result(
        missionId: 'Z1_SPECIAL',
        stars: 3,
        citizenship: 50,
        knowledge: 30,
        coins: 50,
      ),
    );

    expect(
      controller.progress.completedMissions.contains('Z1_SPECIAL'),
      isTrue,
    );
    expect(controller.progress.missionStars['Z1_SPECIAL'], 3);
    expect(controller.progress.zone1Completed, isTrue);
    expect(controller.progress.medals.contains('PROTETOR_DA_ESCOLA'), isTrue);

    expect(controller.progress.citizenshipXp, 170);
    expect(controller.progress.knowledge, 105);
    expect(controller.progress.coins, 220);
  });

  test('replay da especial nao duplica recompensa nem medalha', () async {
    final controller = await _controller();

    await _completeZoneRegular(controller);

    await controller.completeMission(
      result: _result(
        missionId: 'Z1_SPECIAL',
        stars: 2,
        citizenship: 50,
        knowledge: 30,
        coins: 50,
      ),
    );

    final citizenshipBefore = controller.progress.citizenshipXp;
    final knowledgeBefore = controller.progress.knowledge;
    final coinsBefore = controller.progress.coins;

    await controller.completeMission(
      result: _result(
        missionId: 'Z1_SPECIAL',
        stars: 3,
        citizenship: 50,
        knowledge: 30,
        coins: 50,
      ),
    );

    expect(controller.progress.citizenshipXp, citizenshipBefore);
    expect(controller.progress.knowledge, knowledgeBefore);
    expect(controller.progress.coins, coinsBefore);
    expect(controller.progress.missionStars['Z1_SPECIAL'], 3);
    expect(controller.progress.medals.length, 1);
    expect(controller.progress.medals.contains('PROTETOR_DA_ESCOLA'), isTrue);
    expect(controller.progress.zone1Completed, isTrue);
  });

  test('fechamento da zona 1 persiste', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final storage = StorageService(preferences);

    final controller = PlayerController(storage);
    await controller.initialize();

    await _completeZoneRegular(controller);

    await controller.completeMission(
      result: _result(
        missionId: 'Z1_SPECIAL',
        stars: 3,
        citizenship: 50,
        knowledge: 30,
        coins: 50,
      ),
    );

    final secondController = PlayerController(storage);
    await secondController.initialize();

    expect(secondController.progress.zone1Completed, isTrue);
    expect(
      secondController.progress.medals.contains('PROTETOR_DA_ESCOLA'),
      isTrue,
    );
    expect(
      secondController.progress.completedMissions.contains('Z1_SPECIAL'),
      isTrue,
    );
  });
}
