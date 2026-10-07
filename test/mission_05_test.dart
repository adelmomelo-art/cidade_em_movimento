import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/data/zone_1/mission_05_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('missao 5 possui recompensas oficiais', () {
    final mission = buildZone1Mission05(PlayerType.child);

    expect(mission.id, 'Z1_M05');
    expect(mission.maxCitizenship, 30);
    expect(mission.maxKnowledge, 20);
    expect(mission.maxCoins, 30);
  });

  test('missao 5 possui uma alternativa correta por perfil', () {
    for (final type in PlayerType.values) {
      final mission = buildZone1Mission05(type);

      expect(mission.options.where((option) => option.isCorrect).length, 1);
      expect(mission.options.length, 3);
    }
  });
}
