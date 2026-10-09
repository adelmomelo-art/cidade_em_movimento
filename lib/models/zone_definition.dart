class ZoneDefinition {
  const ZoneDefinition({
    required this.id,
    required this.title,
    required this.regularMissionIds,
    required this.specialMissionId,
    required this.specialMinimumStars,
    required this.medalId,
    required this.completionBonusCoins,
    this.initialMissionId,
    this.prerequisiteZoneId,
    this.prerequisiteMedalId,
  });

  final String id;
  final String title;
  final Set<String> regularMissionIds;
  final String specialMissionId;
  final int specialMinimumStars;
  final String medalId;
  final int completionBonusCoins;
  final String? initialMissionId;
  final String? prerequisiteZoneId;
  final String? prerequisiteMedalId;

  String get effectiveInitialMissionId =>
      initialMissionId ?? regularMissionIds.first;

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

  bool canUnlockZone({
    required Set<String> completedZones,
    required Set<String> medals,
  }) {
    final requiredZone = prerequisiteZoneId;
    if (requiredZone != null && !completedZones.contains(requiredZone)) {
      return false;
    }

    final requiredMedal = prerequisiteMedalId;
    if (requiredMedal != null && !medals.contains(requiredMedal)) {
      return false;
    }

    return true;
  }
}
