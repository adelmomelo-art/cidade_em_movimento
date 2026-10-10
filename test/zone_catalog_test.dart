import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo possui seis zonas oficiais', () {
    expect(zoneCatalog.length, 6);
    expect(zone6Definition.id, 'ZONE_6');
  });
  test('Zona 6 possui estrutura oficial aprovada', () {
    expect(zone6Definition.regularMissionIds.length, 5);
    expect(zone6Definition.specialMissionId, 'Z6_SPECIAL');
    expect(zone6Definition.specialMinimumStars, 9);
    expect(zone6Definition.medalId, 'GUARDIAO_DO_CASTELAO');
    expect(zone6Definition.completionBonusCoins, 60);
    expect(zone6Definition.prerequisiteZoneId, 'ZONE_5');
    expect(zone6Definition.prerequisiteMedalId, 'GUARDIAO_DAS_VIAS');
  });
  test('localiza Zona 6 por missao e id', () {
    expect(findZoneByMission('Z6_M03')?.id, 'ZONE_6');
    expect(findZoneByMission('Z6_SPECIAL')?.id, 'ZONE_6');
    expect(findZoneById('ZONE_6')?.title, 'Polo Castelao');
  });
}
