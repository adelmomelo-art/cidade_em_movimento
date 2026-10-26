import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Zona 6 cadastrada com estrutura oficial', () {
    expect(zoneCatalog.length, greaterThanOrEqualTo(6));
    expect(zone6Definition.id, 'ZONE_6');
    expect(zone6Definition.title, 'Polo Castelao');
    expect(zone6Definition.regularMissionIds.length, 5);
    expect(zone6Definition.specialMissionId, 'Z6_SPECIAL');
    expect(zone6Definition.specialMinimumStars, 9);
    expect(zone6Definition.medalId, 'GUARDIAO_DO_CASTELAO');
    expect(zone6Definition.completionBonusCoins, 60);
    expect(zone6Definition.prerequisiteZoneId, 'ZONE_5');
    expect(zone6Definition.prerequisiteMedalId, 'GUARDIAO_DAS_VIAS');
  });
  test('economia de melhorias Zona 6 fecha em 340 moedas', () {
    final u = upgradesForZone('ZONE_6');
    expect(u.length, 5);
    expect(u.fold<int>(0, (s, x) => s + x.cost), 340);
  });
}
