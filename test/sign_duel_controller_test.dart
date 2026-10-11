import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'Duelo persiste recorde e concede Conhecimento apenas por novo melhor',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final storage = StorageService(preferences);
      final controller = PlayerController(storage);
      await controller.initialize();

      final firstGain = await controller.recordSignDuelResult(
        score: 400,
        correctAnswers: 4,
      );

      expect(firstGain, 8);
      expect(controller.progress.knowledge, 8);
      expect(controller.progress.signDuelBestScore, 400);
      expect(controller.progress.signDuelBestCorrect, 4);
      expect(controller.progress.signDuelPlays, 1);

      final repeatedGain = await controller.recordSignDuelResult(
        score: 300,
        correctAnswers: 3,
      );

      expect(repeatedGain, 0);
      expect(controller.progress.knowledge, 8);
      expect(controller.progress.signDuelBestScore, 400);
      expect(controller.progress.signDuelBestCorrect, 4);
      expect(controller.progress.signDuelPlays, 2);

      final improvedGain = await controller.recordSignDuelResult(
        score: 600,
        correctAnswers: 6,
      );

      expect(improvedGain, 4);
      expect(controller.progress.knowledge, 12);
      expect(controller.progress.signDuelBestScore, 600);
      expect(controller.progress.signDuelBestCorrect, 6);
      expect(controller.progress.signDuelPlays, 3);

      final restored = PlayerController(storage);
      await restored.initialize();

      expect(restored.progress.knowledge, 12);
      expect(restored.progress.signDuelBestScore, 600);
      expect(restored.progress.signDuelBestCorrect, 6);
      expect(restored.progress.signDuelPlays, 3);
    },
  );
}
