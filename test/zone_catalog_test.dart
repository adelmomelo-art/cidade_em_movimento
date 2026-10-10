import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo possui Zonas 1, 2 e 3 oficiais', () {
    expect(zoneCatalog.length, 3);
    expect(zone1Definition.id, 'ZONE_1');
    expect(zone2Definition.id, 'ZONE_2');
    expect(zone3Definition.id, 'ZONE_3');
    expect(zone2Definition.title, 'Centro Hist\u00f3rico');
    expect(zone3Definition.title, 'Orla / Praia de Iracema');
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

  test('Zona 3 possui estrutura oficial aprovada', () {
    expect(zone3Definition.regularMissionIds.length, 5);
    expect(zone3Definition.regularMissionIds.contains('Z3_M01'), isTrue);
    expect(zone3Definition.regularMissionIds.contains('Z3_M05'), isTrue);
    expect(zone3Definition.specialMissionId, 'Z3_SPECIAL');
    expect(zone3Definition.specialMinimumStars, 9);
    expect(zone3Definition.medalId, 'GUARDIAO_DA_ORLA');
    expect(zone3Definition.completionBonusCoins, 60);
    expect(zone3Definition.prerequisiteZoneId, 'ZONE_2');
    expect(zone3Definition.prerequisiteMedalId, 'GUARDIAO_DO_CENTRO');
  });

  test('localiza zonas por missao e por id', () {
    expect(findZoneByMission('Z1_M03')?.id, 'ZONE_1');
    expect(findZoneByMission('Z2_M03')?.id, 'ZONE_2');
    expect(findZoneByMission('Z2_SPECIAL')?.id, 'ZONE_2');
    expect(findZoneByMission('Z3_M03')?.id, 'ZONE_3');
    expect(findZoneByMission('Z3_SPECIAL')?.id, 'ZONE_3');
    expect(findZoneByMission('INEXISTENTE'), isNull);

    expect(findZoneById('ZONE_1')?.title, 'Bairro / Escola');
    expect(findZoneById('ZONE_2')?.title, 'Centro Hist\u00f3rico');
    expect(findZoneById('ZONE_3')?.title, 'Orla / Praia de Iracema');
    expect(findZoneById('ZONE_X'), isNull);
  });
}
