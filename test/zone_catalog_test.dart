import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo possui Zona 1 e Zona 2 oficiais', () {
    expect(zoneCatalog.length, 2);
    expect(zone1Definition.id, 'ZONE_1');
    expect(zone2Definition.id, 'ZONE_2');
    expect(zone2Definition.title, 'Centro Hist\u00f3rico');
  });

  test('Zona 1 preserva cinco missoes regulares e especial', () {
    expect(zone1Definition.regularMissionIds.length, 5);
    expect(zone1Definition.regularMissionIds.contains('Z1_M01'), isTrue);
    expect(zone1Definition.regularMissionIds.contains('Z1_M05'), isTrue);
    expect(zone1Definition.specialMissionId, 'Z1_SPECIAL');
    expect(zone1Definition.specialMinimumStars, 9);
    expect(zone1Definition.medalId, 'PROTETOR_DA_ESCOLA');
    expect(zone1Definition.completionBonusCoins, 60);
  });

  test('Zona 2 possui estrutura oficial aprovada', () {
    expect(zone2Definition.regularMissionIds.length, 5);
    expect(zone2Definition.regularMissionIds.contains('Z2_M01'), isTrue);
    expect(zone2Definition.regularMissionIds.contains('Z2_M05'), isTrue);
    expect(zone2Definition.specialMissionId, 'Z2_SPECIAL');
    expect(zone2Definition.specialMinimumStars, 9);
    expect(zone2Definition.medalId, 'GUARDIAO_DO_CENTRO');
    expect(zone2Definition.completionBonusCoins, 60);
    expect(zone2Definition.prerequisiteZoneId, 'ZONE_1');
    expect(zone2Definition.prerequisiteMedalId, 'PROTETOR_DA_ESCOLA');
  });

  test('localiza zonas por missao e por id', () {
    expect(findZoneByMission('Z1_M03')?.id, 'ZONE_1');
    expect(findZoneByMission('Z2_M03')?.id, 'ZONE_2');
    expect(findZoneByMission('Z2_SPECIAL')?.id, 'ZONE_2');
    expect(findZoneByMission('INEXISTENTE'), isNull);
    expect(findZoneById('ZONE_1')?.title, 'Bairro / Escola');
    expect(findZoneById('ZONE_2')?.title, 'Centro Hist\u00f3rico');
    expect(findZoneById('ZONE_X'), isNull);
  });
}
