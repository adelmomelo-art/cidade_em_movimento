import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Zona 4 cadastrada com estrutura oficial', () {
    expect(zoneCatalog.length, greaterThanOrEqualTo(4));
    expect(zone4Definition.id, 'ZONE_4');
    expect(zone4Definition.title, 'Cultura / Eventos');
    expect(zone4Definition.regularMissionIds.length, 5);
    expect(zone4Definition.specialMissionId, 'Z4_SPECIAL');
    expect(zone4Definition.specialMinimumStars, 9);
    expect(zone4Definition.medalId, 'GUARDIAO_DA_CULTURA');
    expect(zone4Definition.completionBonusCoins, 60);
    expect(zone4Definition.prerequisiteZoneId, 'ZONE_3');
    expect(zone4Definition.prerequisiteMedalId, 'GUARDIAO_DA_ORLA');
  });

  test('economia de melhorias Zona 4 fecha em 240 moedas', () {
    final upgrades = upgradesForZone('ZONE_4');

    expect(upgrades.length, 3);
    expect(upgrades.fold<int>(0, (sum, upgrade) => sum + upgrade.cost), 240);
  });
}
