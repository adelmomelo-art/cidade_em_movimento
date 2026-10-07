import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/data/zone_1/special_mission_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('missao especial possui recompensas oficiais', () {
    final mission = buildZone1SpecialMission(PlayerType.child);

    expect(mission.id, 'Z1_SPECIAL');
    expect(mission.maxCitizenship, 50);
    expect(mission.maxKnowledge, 30);
    expect(mission.maxCoins, 50);
  });

  test('missao especial possui uma alternativa correta por perfil', () {
    for (final type in PlayerType.values) {
      final mission = buildZone1SpecialMission(type);

      expect(mission.options.where((option) => option.isCorrect).length, 1);
      expect(mission.options.length, 3);
    }
  });
}
