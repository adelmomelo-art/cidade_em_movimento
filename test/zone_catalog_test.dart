import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo possui Zonas 1, 2, 3 e 4 oficiais', () {
    expect(zoneCatalog.length, 4);
    expect(zone1Definition.id, 'ZONE_1');
    expect(zone2Definition.id, 'ZONE_2');
    expect(zone3Definition.id, 'ZONE_3');
    expect(zone4Definition.id, 'ZONE_4');
    expect(zone4Definition.title, 'Cultura / Eventos');
  });

  test('Zona 1 preserva cinco missoes regulares e especial', () {
    expect(zone1Definition.regularMissionIds.length, 5);
    expect(zone1Definition.specialMissionId, 'Z1_SPECIAL');
    expect(zone1Definition.medalId, 'PROTETOR_DA_ESCOLA');
  });

  test('Zona 2 possui estrutura oficial aprovada', () {
    expect(zone2Definition.regularMissionIds.length, 5);
    expect(zone2Definition.specialMissionId, 'Z2_SPECIAL');
    expect(zone2Definition.medalId, 'GUARDIAO_DO_CENTRO');
  });

  test('Zona 3 possui estrutura oficial aprovada', () {
    expect(zone3Definition.regularMissionIds.length, 5);
    expect(zone3Definition.specialMissionId, 'Z3_SPECIAL');
    expect(zone3Definition.medalId, 'GUARDIAO_DA_ORLA');
  });

  test('Zona 4 possui estrutura oficial aprovada', () {
    expect(zone4Definition.regularMissionIds.length, 5);
    expect(zone4Definition.regularMissionIds.contains('Z4_M01'), isTrue);
    expect(zone4Definition.regularMissionIds.contains('Z4_M05'), isTrue);
    expect(zone4Definition.specialMissionId, 'Z4_SPECIAL');
    expect(zone4Definition.specialMinimumStars, 9);
    expect(zone4Definition.medalId, 'GUARDIAO_DA_CULTURA');
    expect(zone4Definition.completionBonusCoins, 60);
    expect(zone4Definition.prerequisiteZoneId, 'ZONE_3');
    expect(zone4Definition.prerequisiteMedalId, 'GUARDIAO_DA_ORLA');
  });

  test('localiza zonas por missao e por id', () {
    expect(findZoneByMission('Z1_M03')?.id, 'ZONE_1');
    expect(findZoneByMission('Z2_SPECIAL')?.id, 'ZONE_2');
    expect(findZoneByMission('Z3_SPECIAL')?.id, 'ZONE_3');
    expect(findZoneByMission('Z4_M03')?.id, 'ZONE_4');
    expect(findZoneByMission('Z4_SPECIAL')?.id, 'ZONE_4');
    expect(findZoneByMission('INEXISTENTE'), isNull);

    expect(findZoneById('ZONE_1')?.title, 'Bairro / Escola');
    expect(findZoneById('ZONE_2')?.title, 'Centro Hist\u00f3rico');
    expect(findZoneById('ZONE_3')?.title, 'Orla / Praia de Iracema');
    expect(findZoneById('ZONE_4')?.title, 'Cultura / Eventos');
    expect(findZoneById('ZONE_X'), isNull);
  });
}
