class GameProgress {
  GameProgress({
    required this.citizenshipXp,
    required this.knowledge,
    required this.coins,
    required this.completedMissions,
    required this.missionStars,
    required this.unlockedMissions,
    required this.purchasedUpgrades,
    required this.medals,
    Set<String> completedZones = const <String>{},
    Set<String> claimedZoneCompletionBonuses = const <String>{},
    bool zone1Completed = false,
    this.claimedR43ZoneBonuses = const <String>{},
    this.signDuelBestScore = 0,
    this.signDuelBestCorrect = 0,
    this.signDuelPlays = 0,
  }) : completedZones = <String>{
         ...completedZones,
         if (zone1Completed) 'ZONE_1',
       },
       claimedZoneCompletionBonuses = Set<String>.from(
         claimedZoneCompletionBonuses,
       );

  final Set<String> claimedR43ZoneBonuses;

  final int citizenshipXp;
  final int knowledge;
  final int coins;

  final Set<String> completedMissions;
  final Map<String, int> missionStars;
  final Set<String> unlockedMissions;
  final Set<String> purchasedUpgrades;
  final Set<String> medals;
  final Set<String> completedZones;
  final Set<String> claimedZoneCompletionBonuses;

  final int signDuelBestScore;
  final int signDuelBestCorrect;
  final int signDuelPlays;

  bool get zone1Completed => completedZones.contains('ZONE_1');

  bool isZoneCompleted(String zoneId) {
    return completedZones.contains(zoneId);
  }

  bool hasClaimedZoneCompletionBonus(String zoneId) {
    return claimedZoneCompletionBonuses.contains(zoneId);
  }

  factory GameProgress.initial() {
    return GameProgress(
      citizenshipXp: 0,
      knowledge: 0,
      coins: 0,
      completedMissions: <String>{},
      missionStars: <String, int>{},
      unlockedMissions: <String>{'Z1_M01'},
      purchasedUpgrades: <String>{},
      medals: <String>{},
      completedZones: <String>{},
      claimedZoneCompletionBonuses: <String>{},
      signDuelBestScore: 0,
      signDuelBestCorrect: 0,
      signDuelPlays: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'claimedR43ZoneBonuses': claimedR43ZoneBonuses.toList(),
      'citizenshipXp': citizenshipXp,
      'knowledge': knowledge,
      'coins': coins,
      'completedMissions': completedMissions.toList(),
      'missionStars': missionStars,
      'unlockedMissions': unlockedMissions.toList(),
      'purchasedUpgrades': purchasedUpgrades.toList(),
      'medals': medals.toList(),
      'completedZones': completedZones.toList(),
      'claimedZoneCompletionBonuses': claimedZoneCompletionBonuses.toList(),
      'zone1Completed': zone1Completed,
      'signDuelBestScore': signDuelBestScore,
      'signDuelBestCorrect': signDuelBestCorrect,
      'signDuelPlays': signDuelPlays,
    };
  }

  factory GameProgress.fromJson(Map<String, dynamic> json) {
    final starsRaw =
        (json['missionStars'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    final completedZones = _stringSet(json['completedZones']);

    if (json['zone1Completed'] as bool? ?? false) {
      completedZones.add('ZONE_1');
    }

    return GameProgress(
      claimedR43ZoneBonuses: _stringSet(json['claimedR43ZoneBonuses']),
      citizenshipXp: (json['citizenshipXp'] as num?)?.toInt() ?? 0,
      knowledge: (json['knowledge'] as num?)?.toInt() ?? 0,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      completedMissions: _stringSet(json['completedMissions']),
      missionStars: starsRaw.map(
        (key, value) => MapEntry(key, (value as num).toInt()),
      ),
      unlockedMissions: _stringSet(
        json['unlockedMissions'],
        fallback: const <String>{'Z1_M01'},
      ),
      purchasedUpgrades: _stringSet(json['purchasedUpgrades']),
      medals: _stringSet(json['medals']),
      completedZones: completedZones,
      claimedZoneCompletionBonuses: _stringSet(
        json['claimedZoneCompletionBonuses'],
      ),
      signDuelBestScore: (json['signDuelBestScore'] as num?)?.toInt() ?? 0,
      signDuelBestCorrect: (json['signDuelBestCorrect'] as num?)?.toInt() ?? 0,
      signDuelPlays: (json['signDuelPlays'] as num?)?.toInt() ?? 0,
    );
  }

  static Set<String> _stringSet(
    dynamic value, {
    Set<String> fallback = const <String>{},
  }) {
    if (value is! List) {
      return Set<String>.from(fallback);
    }

    return value.whereType<String>().toSet();
  }
}
