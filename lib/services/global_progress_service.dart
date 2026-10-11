import '../data/build_neighborhood/upgrade_data.dart';
import '../data/zones/zone_catalog.dart';
import '../models/game_progress.dart';

class GlobalProgressSummary {
  const GlobalProgressSummary({
    required this.completedZones,
    required this.totalZones,
    required this.medals,
    required this.totalMedals,
    required this.completedMissions,
    required this.totalMissions,
    required this.totalStars,
    required this.signDuelBestCorrect,
    required this.signDuelPlays,
    required this.neighborhoodUpgrades,
    required this.totalNeighborhoodUpgrades,
  });

  final int completedZones;
  final int totalZones;
  final int medals;
  final int totalMedals;
  final int completedMissions;
  final int totalMissions;
  final int totalStars;
  final int signDuelBestCorrect;
  final int signDuelPlays;
  final int neighborhoodUpgrades;
  final int totalNeighborhoodUpgrades;

  bool get fortalezaComplete =>
      completedZones == totalZones &&
      medals == totalMedals &&
      completedMissions == totalMissions;

  double get completionRatio {
    if (totalMissions == 0) {
      return 0;
    }
    return (completedMissions / totalMissions).clamp(0.0, 1.0);
  }

  int get completionPercent => (completionRatio * 100).round();

  bool get firstZoneAchievement => completedZones >= 1;
  bool get halfwayAchievement => completedZones >= 3;
  bool get fortalezaGuardianAchievement => fortalezaComplete;
  bool get signMasterAchievement => signDuelBestCorrect >= 6;
  bool get neighborhoodBuilderAchievement =>
      neighborhoodUpgrades == totalNeighborhoodUpgrades;
}

class GlobalProgressService {
  const GlobalProgressService();

  GlobalProgressSummary summarize(GameProgress progress) {
    final zoneIds = zoneCatalog.map((zone) => zone.id).toSet();
    final medalIds = zoneCatalog.map((zone) => zone.medalId).toSet();

    final missionIds = <String>{
      for (final zone in zoneCatalog) ...zone.regularMissionIds,
      for (final zone in zoneCatalog) zone.specialMissionId,
    };

    final completedZones = progress.completedZones
        .where(zoneIds.contains)
        .length;

    final medals = progress.medals.where(medalIds.contains).length;

    final completedMissions = progress.completedMissions
        .where(missionIds.contains)
        .length;

    final totalStars = missionIds.fold<int>(
      0,
      (sum, missionId) => sum + (progress.missionStars[missionId] ?? 0),
    );

    final neighborhoodIds = buildNeighborhoodUpgrades
        .map((upgrade) => upgrade.id)
        .toSet();

    final neighborhoodUpgrades = progress.purchasedUpgrades
        .where(neighborhoodIds.contains)
        .length;

    return GlobalProgressSummary(
      completedZones: completedZones,
      totalZones: zoneCatalog.length,
      medals: medals,
      totalMedals: zoneCatalog.length,
      completedMissions: completedMissions,
      totalMissions: missionIds.length,
      totalStars: totalStars,
      signDuelBestCorrect: progress.signDuelBestCorrect,
      signDuelPlays: progress.signDuelPlays,
      neighborhoodUpgrades: neighborhoodUpgrades,
      totalNeighborhoodUpgrades: buildNeighborhoodUpgrades.length,
    );
  }
}
