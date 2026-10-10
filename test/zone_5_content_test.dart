import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/data/zone_5/mission_01_data.dart';
import 'package:cidade_em_movimento/data/zone_5/mission_02_data.dart';
import 'package:cidade_em_movimento/data/zone_5/mission_03_data.dart';
import 'package:cidade_em_movimento/data/zone_5/mission_04_data.dart';
import 'package:cidade_em_movimento/data/zone_5/mission_05_data.dart';
import 'package:cidade_em_movimento/data/zone_5/special_mission_data.dart';
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
    test('conteudo completo Zona 5 para ${type.name}', () {
      _validate(buildZone5Mission01(type), 'Z5_M01', 20, 15, 20);
      _validate(buildZone5Mission02(type), 'Z5_M02', 20, 15, 20);
      _validate(buildZone5Mission03(type), 'Z5_M03', 25, 20, 25);
      _validate(buildZone5Mission04(type), 'Z5_M04', 25, 20, 25);
      _validate(buildZone5Mission05(type), 'Z5_M05', 30, 25, 30);
      _validate(buildZone5SpecialMission(type), 'Z5_SPECIAL', 50, 35, 60);
    });
  }

  test('economia maxima Zona 5 totaliza 170 130 180', () {
    final missions = <Mission>[
      buildZone5Mission01(PlayerType.adult),
      buildZone5Mission02(PlayerType.adult),
      buildZone5Mission03(PlayerType.adult),
      buildZone5Mission04(PlayerType.adult),
      buildZone5Mission05(PlayerType.adult),
      buildZone5SpecialMission(PlayerType.adult),
    ];
    expect(missions.fold<int>(0, (s, m) => s + m.maxCitizenship), 170);
    expect(missions.fold<int>(0, (s, m) => s + m.maxKnowledge), 130);
    expect(missions.fold<int>(0, (s, m) => s + m.maxCoins), 180);
  });
}
