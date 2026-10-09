import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo de zonas respeita invariantes de producao em escala', () {
    final zoneIds = <String>{};
    final missionIds = <String>{};
    final medalIds = <String>{};

    for (final zone in zoneCatalog) {
      expect(zone.id, isNotEmpty);
      expect(zone.title, isNotEmpty);
      expect(zoneIds.add(zone.id), isTrue, reason: 'Zone ID duplicado');
      expect(zone.regularMissionIds.length, 5);
      expect(zone.specialMissionId, isNotEmpty);
      expect(zone.specialMinimumStars, greaterThan(0));
      expect(
        zone.specialMinimumStars,
        lessThanOrEqualTo(zone.regularMissionIds.length * 3),
      );
      expect(zone.medalId, isNotEmpty);
      expect(medalIds.add(zone.medalId), isTrue, reason: 'Medalha duplicada');
      expect(zone.completionBonusCoins, greaterThanOrEqualTo(0));

      for (final missionId in zone.regularMissionIds) {
        expect(
          missionIds.add(missionId),
          isTrue,
          reason: 'Mission ID duplicado: $missionId',
        );
      }

      expect(
        missionIds.add(zone.specialMissionId),
        isTrue,
        reason: 'Mission ID duplicado: ${zone.specialMissionId}',
      );
    }
  });

  test('catalogo de melhorias respeita invariantes de producao em escala', () {
    final upgradeIds = <String>{};
    final validZoneIds = zoneCatalog.map((zone) => zone.id).toSet();

    for (final upgrade in upgradeCatalog) {
      expect(upgrade.id, isNotEmpty);
      expect(
        upgradeIds.add(upgrade.id),
        isTrue,
        reason: 'Upgrade ID duplicado: ${upgrade.id}',
      );
      expect(validZoneIds, contains(upgrade.zoneId));
      expect(upgrade.title, isNotEmpty);
      expect(upgrade.description, isNotEmpty);
      expect(upgrade.cost, greaterThan(0));
    }
  });

  test('economia homologada da Zona 1 fecha em 220 moedas', () {
    final zone1UpgradeCost = upgradesForZone(
      'ZONE_1',
    ).fold<int>(0, (sum, item) => sum + item.cost);

    expect(zone1UpgradeCost, 220);
    expect(zone1Definition.completionBonusCoins, 60);
  });
}
