import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Zona 3 cadastrada com estrutura oficial', () {
    expect(zoneCatalog.length, 3);
    expect(zone3Definition.id, 'ZONE_3');
    expect(zone3Definition.title, 'Orla / Praia de Iracema');
    expect(zone3Definition.regularMissionIds.length, 5);
    expect(zone3Definition.specialMissionId, 'Z3_SPECIAL');
    expect(zone3Definition.specialMinimumStars, 9);
    expect(zone3Definition.medalId, 'GUARDIAO_DA_ORLA');
    expect(zone3Definition.completionBonusCoins, 60);
    expect(zone3Definition.prerequisiteZoneId, 'ZONE_2');
    expect(zone3Definition.prerequisiteMedalId, 'GUARDIAO_DO_CENTRO');
  });

  test('economia de melhorias Zona 3 fecha em 240 moedas', () {
    final upgrades = upgradesForZone('ZONE_3');

    expect(upgrades.length, 3);
    expect(upgrades.fold<int>(0, (sum, upgrade) => sum + upgrade.cost), 240);
  });
}
