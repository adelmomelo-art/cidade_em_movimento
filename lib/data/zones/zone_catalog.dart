import '../../models/zone_definition.dart';

const zone1Definition = ZoneDefinition(
  id: 'ZONE_1',
  title: 'Bairro / Escola',
  regularMissionIds: <String>{'Z1_M01', 'Z1_M02', 'Z1_M03', 'Z1_M04', 'Z1_M05'},
  specialMissionId: 'Z1_SPECIAL',
  specialMinimumStars: 9,
  medalId: 'PROTETOR_DA_ESCOLA',
  completionBonusCoins: 60,
  initialMissionId: 'Z1_M01',
);

const zone2Definition = ZoneDefinition(
  id: 'ZONE_2',
  title: 'Centro Hist\u00f3rico',
  regularMissionIds: <String>{'Z2_M01', 'Z2_M02', 'Z2_M03', 'Z2_M04', 'Z2_M05'},
  specialMissionId: 'Z2_SPECIAL',
  specialMinimumStars: 9,
  medalId: 'GUARDIAO_DO_CENTRO',
  completionBonusCoins: 60,
  initialMissionId: 'Z2_M01',
  prerequisiteZoneId: 'ZONE_1',
  prerequisiteMedalId: 'PROTETOR_DA_ESCOLA',
);

const zone3Definition = ZoneDefinition(
  id: 'ZONE_3',
  title: 'Orla / Praia de Iracema',
  regularMissionIds: <String>{'Z3_M01', 'Z3_M02', 'Z3_M03', 'Z3_M04', 'Z3_M05'},
  specialMissionId: 'Z3_SPECIAL',
  specialMinimumStars: 9,
  medalId: 'GUARDIAO_DA_ORLA',
  completionBonusCoins: 60,
  initialMissionId: 'Z3_M01',
  prerequisiteZoneId: 'ZONE_2',
  prerequisiteMedalId: 'GUARDIAO_DO_CENTRO',
);

const zoneCatalog = <ZoneDefinition>[
  zone1Definition,
  zone2Definition,
  zone3Definition,
];

ZoneDefinition? findZoneByMission(String missionId) {
  for (final zone in zoneCatalog) {
    if (zone.containsMission(missionId)) {
      return zone;
    }
  }

  return null;
}

ZoneDefinition? findZoneById(String zoneId) {
  for (final zone in zoneCatalog) {
    if (zone.id == zoneId) {
      return zone;
    }
  }

  return null;
}
