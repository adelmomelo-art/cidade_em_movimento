class GameProgress {
  const GameProgress({
    required this.citizenshipXp,
    required this.knowledge,
    required this.coins,
    required this.completedMissions,
    required this.missionStars,
    required this.unlockedMissions,
    required this.purchasedUpgrades,
    required this.medals,
    required this.zone1Completed,
  });

  final int citizenshipXp;
  final int knowledge;
  final int coins;

  final Set<String> completedMissions;
  final Map<String, int> missionStars;
  final Set<String> unlockedMissions;
  final Set<String> purchasedUpgrades;
  final Set<String> medals;

  final bool zone1Completed;

  factory GameProgress.initial() {
    return const GameProgress(
      citizenshipXp: 0,
      knowledge: 0,
      coins: 0,
      completedMissions: <String>{},
      missionStars: <String, int>{},
      unlockedMissions: <String>{'Z1_M01'},
      purchasedUpgrades: <String>{},
      medals: <String>{},
      zone1Completed: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'citizenshipXp': citizenshipXp,
      'knowledge': knowledge,
      'coins': coins,
      'completedMissions': completedMissions.toList(),
      'missionStars': missionStars,
      'unlockedMissions': unlockedMissions.toList(),
      'purchasedUpgrades': purchasedUpgrades.toList(),
      'medals': medals.toList(),
      'zone1Completed': zone1Completed,
    };
  }

  factory GameProgress.fromJson(Map<String, dynamic> json) {
    final starsRaw =
        (json['missionStars'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    return GameProgress(
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
      zone1Completed: json['zone1Completed'] as bool? ?? false,
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
