import 'package:cidade_em_movimento/models/game_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('progresso novo inicia sem zonas concluidas', () {
    final progress = GameProgress.initial();

    expect(progress.completedZones, isEmpty);
    expect(progress.zone1Completed, isFalse);
    expect(progress.isZoneCompleted('ZONE_1'), isFalse);
  });

  test('compatibilidade migra zone1Completed legado', () {
    final progress = GameProgress.fromJson({
      'citizenshipXp': 10,
      'knowledge': 20,
      'coins': 30,
      'completedMissions': <String>['Z1_SPECIAL'],
      'missionStars': <String, int>{'Z1_SPECIAL': 3},
      'unlockedMissions': <String>['Z1_M01', 'Z1_SPECIAL'],
      'purchasedUpgrades': <String>[],
      'medals': <String>['PROTETOR_DA_ESCOLA'],
      'zone1Completed': true,
    });

    expect(progress.zone1Completed, isTrue);
    expect(progress.completedZones.contains('ZONE_1'), isTrue);
  });

  test('serializacao grava completedZones e compatibilidade Zona 1', () {
    final progress = GameProgress(
      citizenshipXp: 0,
      knowledge: 0,
      coins: 0,
      completedMissions: <String>{},
      missionStars: <String, int>{},
      unlockedMissions: <String>{'Z1_M01'},
      purchasedUpgrades: <String>{},
      medals: <String>{},
      completedZones: <String>{'ZONE_1'},
    );

    final json = progress.toJson();

    expect(json['completedZones'], contains('ZONE_1'));
    expect(json['zone1Completed'], isTrue);
  });
}
