class ZoneDefinition {
  const ZoneDefinition({
    required this.id,
    required this.title,
    required this.regularMissionIds,
    required this.specialMissionId,
    required this.specialMinimumStars,
    required this.medalId,
  });

  final String id;
  final String title;
  final Set<String> regularMissionIds;
  final String specialMissionId;
  final int specialMinimumStars;
  final String medalId;

  bool containsMission(String missionId) {
    return regularMissionIds.contains(missionId) ||
        specialMissionId == missionId;
  }

  int regularStars(Map<String, int> missionStars) {
    return regularMissionIds.fold<int>(
      0,
      (total, missionId) => total + (missionStars[missionId] ?? 0),
    );
  }

  bool canUnlockSpecial({
    required Set<String> completedMissions,
    required Map<String, int> missionStars,
  }) {
    final completedAllRegular = regularMissionIds.every(
      completedMissions.contains,
    );

    return completedAllRegular &&
        regularStars(missionStars) >= specialMinimumStars;
  }
}
