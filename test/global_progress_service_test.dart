import 'package:cidade_em_movimento/data/build_neighborhood/upgrade_data.dart';
import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:cidade_em_movimento/models/game_progress.dart';
import 'package:cidade_em_movimento/services/global_progress_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resumo inicial comeca em zero', () {
    final summary = const GlobalProgressService().summarize(
      GameProgress.initial(),
    );

    expect(summary.totalZones, 6);
    expect(summary.totalMedals, 6);
    expect(summary.totalMissions, 36);
    expect(summary.completedZones, 0);
    expect(summary.completedMissions, 0);
    expect(summary.completionPercent, 0);
    expect(summary.fortalezaComplete, isFalse);
  });

  test('jornada completa fecha Fortaleza em 100 por cento', () {
    final missions = <String>{
      for (final zone in zoneCatalog) ...zone.regularMissionIds,
      for (final zone in zoneCatalog) zone.specialMissionId,
    };

    final progress = GameProgress(
      citizenshipXp: 0,
      knowledge: 0,
      coins: 0,
      completedMissions: missions,
      missionStars: <String, int>{
        for (final missionId in missions) missionId: 3,
      },
      unlockedMissions: missions,
      purchasedUpgrades: <String>{
        for (final upgrade in buildNeighborhoodUpgrades) upgrade.id,
      },
      medals: <String>{for (final zone in zoneCatalog) zone.medalId},
      completedZones: <String>{for (final zone in zoneCatalog) zone.id},
      signDuelBestScore: 600,
      signDuelBestCorrect: 6,
      signDuelPlays: 2,
    );

    final summary = const GlobalProgressService().summarize(progress);

    expect(summary.completedZones, 6);
    expect(summary.medals, 6);
    expect(summary.completedMissions, 36);
    expect(summary.totalStars, 108);
    expect(summary.completionPercent, 100);
    expect(summary.fortalezaComplete, isTrue);
    expect(summary.signMasterAchievement, isTrue);
    expect(summary.neighborhoodBuilderAchievement, isTrue);
    expect(summary.fortalezaGuardianAchievement, isTrue);
  });
}
