import '../models/mission.dart';
import '../models/mission_result.dart';

class ScoringService {
  const ScoringService();

  MissionResult calculate({required Mission mission, required int errors}) {
    final score = _scoreFromErrors(errors);
    final stars = _starsFromScore(score);

    return MissionResult(
      missionId: mission.id,
      stars: stars,
      score: score,
      citizenship: mission.maxCitizenship,
      knowledge: mission.maxKnowledge,
      coins: mission.maxCoins,
      errors: errors,
    );
  }

  int _scoreFromErrors(int errors) {
    if (errors <= 0) {
      return 100;
    }

    if (errors == 1) {
      return 80;
    }

    return 60;
  }

  int _starsFromScore(int score) {
    if (score >= 90) {
      return 3;
    }

    if (score >= 70) {
      return 2;
    }

    if (score >= 50) {
      return 1;
    }

    return 0;
  }
}
