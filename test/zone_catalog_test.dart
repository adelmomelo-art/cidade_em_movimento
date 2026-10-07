import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo inicial possui apenas a Zona 1 oficial', () {
    expect(zoneCatalog.length, 1);
    expect(zone1Definition.id, 'ZONE_1');
    expect(zone1Definition.title, 'Bairro / Escola');
  });

  test('Zona 1 preserva cinco missoes regulares e especial', () {
    expect(zone1Definition.regularMissionIds.length, 5);
    expect(zone1Definition.regularMissionIds.contains('Z1_M01'), isTrue);
    expect(zone1Definition.regularMissionIds.contains('Z1_M05'), isTrue);
    expect(zone1Definition.specialMissionId, 'Z1_SPECIAL');
    expect(zone1Definition.specialMinimumStars, 9);
    expect(zone1Definition.medalId, 'PROTETOR_DA_ESCOLA');
  });

  test('localiza zona por missao', () {
    expect(findZoneByMission('Z1_M03')?.id, 'ZONE_1');
    expect(findZoneByMission('Z1_SPECIAL')?.id, 'ZONE_1');
    expect(findZoneByMission('INEXISTENTE'), isNull);
  });
}
