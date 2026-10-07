import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/data/zone_1/mission_02_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('missao 2 possui recompensas oficiais', () {
    final mission = buildZone1Mission02(PlayerType.child);
    expect(mission.id, 'Z1_M02');
    expect(mission.maxCitizenship, 20);
    expect(mission.maxKnowledge, 15);
    expect(mission.maxCoins, 20);
  });

  test('missao 2 possui uma alternativa correta por perfil', () {
    for (final type in PlayerType.values) {
      final mission = buildZone1Mission02(type);
      expect(mission.options.where((option) => option.isCorrect).length, 1);
      expect(mission.options.length, 3);
    }
  });
}
