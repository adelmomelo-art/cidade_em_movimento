import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'progresso essencial sobrevive a reinicializacao totalmente local',
    () async {
      SharedPreferences.setMockInitialValues({});

      final preferences = await SharedPreferences.getInstance();
      final storage = StorageService(preferences);
      final controller = PlayerController(storage);

      await controller.initialize();
      await controller.createProfile(
        type: PlayerType.adult,
        avatarId: 'adult_default',
      );

      await controller.completeMission(
        result: const MissionResult(
          missionId: 'OFFLINE_TEST_MISSION',
          stars: 3,
          score: 100,
          citizenship: 10,
          knowledge: 5,
          coins: 200,
          errors: 0,
        ),
      );

      expect(
        await controller.purchaseUpgrade('BAIRRO_CALCADA_ACESSIVEL'),
        isTrue,
      );

      await controller.recordSignDuelResult(score: 400, correctAnswers: 4);

      final restored = PlayerController(storage);
      await restored.initialize();

      expect(restored.hasProfile, isTrue);
      expect(restored.progress.citizenshipXp, 10);
      expect(restored.progress.knowledge, 13);
      expect(restored.progress.coins, 160);
      expect(
        restored.progress.purchasedUpgrades,
        contains('BAIRRO_CALCADA_ACESSIVEL'),
      );
      expect(restored.progress.signDuelBestScore, 400);
      expect(restored.progress.signDuelBestCorrect, 4);
      expect(restored.progress.signDuelPlays, 1);
    },
  );
}
