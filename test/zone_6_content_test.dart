import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/data/zone_6/mission_01_data.dart';
import 'package:cidade_em_movimento/data/zone_6/mission_02_data.dart';
import 'package:cidade_em_movimento/data/zone_6/mission_03_data.dart';
import 'package:cidade_em_movimento/data/zone_6/mission_04_data.dart';
import 'package:cidade_em_movimento/data/zone_6/mission_05_data.dart';
import 'package:cidade_em_movimento/data/zone_6/special_mission_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Zona 6 possui seis missoes validas para os tres perfis', () {
    for (final t in PlayerType.values) {
      final m = [
        buildZone6Mission01(t),
        buildZone6Mission02(t),
        buildZone6Mission03(t),
        buildZone6Mission04(t),
        buildZone6Mission05(t),
        buildZone6SpecialMission(t),
      ];
      expect(m.map((x) => x.id).toSet().length, 6);
      for (final x in m) {
        expect(x.options.length, 3);
        expect(x.options.where((o) => o.isCorrect).length, 1);
      }
    }
  });
  test('economia das missoes Zona 6 fecha em 170 130 180', () {
    final m = [
      buildZone6Mission01(PlayerType.adult),
      buildZone6Mission02(PlayerType.adult),
      buildZone6Mission03(PlayerType.adult),
      buildZone6Mission04(PlayerType.adult),
      buildZone6Mission05(PlayerType.adult),
      buildZone6SpecialMission(PlayerType.adult),
    ];
    expect(m.fold<int>(0, (s, x) => s + x.maxCitizenship), 170);
    expect(m.fold<int>(0, (s, x) => s + x.maxKnowledge), 130);
    expect(m.fold<int>(0, (s, x) => s + x.maxCoins), 180);
  });
}
