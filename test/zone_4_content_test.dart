import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/data/zone_4/mission_01_data.dart';
import 'package:cidade_em_movimento/data/zone_4/mission_02_data.dart';
import 'package:cidade_em_movimento/data/zone_4/mission_03_data.dart';
import 'package:cidade_em_movimento/data/zone_4/mission_04_data.dart';
import 'package:cidade_em_movimento/data/zone_4/mission_05_data.dart';
import 'package:cidade_em_movimento/data/zone_4/special_mission_data.dart';
import 'package:cidade_em_movimento/models/mission.dart';
import 'package:flutter_test/flutter_test.dart';

void _validate(Mission mission, String id, int c, int k, int coins) {
  expect(mission.id, id);
  expect(mission.maxCitizenship, c);
  expect(mission.maxKnowledge, k);
  expect(mission.maxCoins, coins);
  expect(mission.options.length, 3);
  expect(mission.options.where((option) => option.isCorrect).length, 1);
}

void main() {
  for (final type in PlayerType.values) {
    test('conteudo completo Zona 4 para ${type.name}', () {
      _validate(buildZone4Mission01(type), 'Z4_M01', 20, 15, 20);
      _validate(buildZone4Mission02(type), 'Z4_M02', 20, 15, 20);
      _validate(buildZone4Mission03(type), 'Z4_M03', 25, 20, 25);
      _validate(buildZone4Mission04(type), 'Z4_M04', 25, 20, 25);
      _validate(buildZone4Mission05(type), 'Z4_M05', 30, 25, 30);
      _validate(buildZone4SpecialMission(type), 'Z4_SPECIAL', 50, 35, 60);
    });
  }

  test('economia maxima das missoes Zona 4 totaliza 170 130 180', () {
    final missions = <Mission>[
      buildZone4Mission01(PlayerType.adult),
      buildZone4Mission02(PlayerType.adult),
      buildZone4Mission03(PlayerType.adult),
      buildZone4Mission04(PlayerType.adult),
      buildZone4Mission05(PlayerType.adult),
      buildZone4SpecialMission(PlayerType.adult),
    ];

    expect(
      missions.fold<int>(0, (sum, mission) => sum + mission.maxCitizenship),
      170,
    );
    expect(
      missions.fold<int>(0, (sum, mission) => sum + mission.maxKnowledge),
      130,
    );
    expect(
      missions.fold<int>(0, (sum, mission) => sum + mission.maxCoins),
      180,
    );
  });
}
