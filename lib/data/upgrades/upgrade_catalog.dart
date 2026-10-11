import '../../models/upgrade_definition.dart';
import '../build_neighborhood/upgrade_data.dart';
import '../zone_1/upgrade_data.dart';
import '../zone_2/upgrade_data.dart';
import '../zone_3/upgrade_data.dart';
import '../zone_4/upgrade_data.dart';
import '../zone_5/upgrade_data.dart';
import '../zone_6/upgrade_data.dart';

/// Catalogo oficial das seis zonas do MVP.
/// Deve permanecer com 18 melhorias: 3 por zona.
const upgradeCatalog = <UpgradeDefinition>[
  ...zone1Upgrades,
  ...zone2Upgrades,
  ...zone3Upgrades,
  ...zone4Upgrades,
  ...zone5Upgrades,
  ...zone6Upgrades,
];

/// Catalogo expandido usado por mecanismos genericos de compra/progresso.
/// Inclui experiencias fora das seis zonas, sem criar uma Zona 7.
const allUpgradeCatalog = <UpgradeDefinition>[
  ...upgradeCatalog,
  ...buildNeighborhoodUpgrades,
];

UpgradeDefinition? findUpgradeById(String upgradeId) {
  for (final upgrade in allUpgradeCatalog) {
    if (upgrade.id == upgradeId) {
      return upgrade;
    }
  }
  return null;
}

List<UpgradeDefinition> upgradesForZone(String zoneId) {
  return allUpgradeCatalog
      .where((upgrade) => upgrade.zoneId == zoneId)
      .toList(growable: false);
}
