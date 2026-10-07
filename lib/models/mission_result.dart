class MissionResult {
  const MissionResult({
    required this.missionId,
    required this.stars,
    required this.score,
    required this.citizenship,
    required this.knowledge,
    required this.coins,
    required this.errors,
  });

  final String missionId;
  final int stars;
  final int score;
  final int citizenship;
  final int knowledge;
  final int coins;
  final int errors;
}
