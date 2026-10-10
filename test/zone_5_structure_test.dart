import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Zona 5 cadastrada com estrutura oficial', () {
    expect(zoneCatalog.length, greaterThanOrEqualTo(5));
    expect(zone5Definition.id, 'ZONE_5');
    expect(zone5Definition.title, 'Grandes Vias');
    expect(zone5Definition.regularMissionIds.length, 5);
    expect(zone5Definition.specialMissionId, 'Z5_SPECIAL');
    expect(zone5Definition.specialMinimumStars, 9);
    expect(zone5Definition.medalId, 'GUARDIAO_DAS_VIAS');
    expect(zone5Definition.completionBonusCoins, 60);
    expect(zone5Definition.prerequisiteZoneId, 'ZONE_4');
    expect(zone5Definition.prerequisiteMedalId, 'GUARDIAO_DA_CULTURA');
  });

  test('economia de melhorias Zona 5 fecha em 240 moedas', () {
    final upgrades = upgradesForZone('ZONE_5');
    expect(upgrades.length, 3);
    expect(upgrades.fold<int>(0, (s, u) => s + u.cost), 240);
  });
}
