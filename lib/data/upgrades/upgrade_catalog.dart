import '../../models/upgrade_definition.dart';
import '../zone_1/upgrade_data.dart';
import '../zone_2/upgrade_data.dart';
import '../zone_3/upgrade_data.dart';
import '../zone_4/upgrade_data.dart';
import '../zone_5/upgrade_data.dart';

const upgradeCatalog = <UpgradeDefinition>[
  ...zone1Upgrades,
  ...zone2Upgrades,
  ...zone3Upgrades,
  ...zone4Upgrades,
  ...zone5Upgrades,
];

UpgradeDefinition? findUpgradeById(String upgradeId) {
  for (final upgrade in upgradeCatalog) {
    if (upgrade.id == upgradeId) return upgrade;
  }
  return null;
}

List<UpgradeDefinition> upgradesForZone(String zoneId) {
  return upgradeCatalog
      .where((upgrade) => upgrade.zoneId == zoneId)
      .toList(growable: false);
}
