import '../../models/zone_definition.dart';

const zone1Definition = ZoneDefinition(
  id: 'ZONE_1',
  title: 'Bairro / Escola',
  regularMissionIds: <String>{'Z1_M01', 'Z1_M02', 'Z1_M03', 'Z1_M04', 'Z1_M05'},
  specialMissionId: 'Z1_SPECIAL',
  specialMinimumStars: 9,
  medalId: 'PROTETOR_DA_ESCOLA',
);

const zoneCatalog = <ZoneDefinition>[zone1Definition];

ZoneDefinition? findZoneByMission(String missionId) {
  for (final zone in zoneCatalog) {
    if (zone.containsMission(missionId)) {
      return zone;
    }
  }

  return null;
}
