class PedagogicalSnapshot {
  const PedagogicalSnapshot({
    required this.schemaVersion,
    required this.playerId,
    required this.profileType,
    required this.avatarId,
    required this.citizenshipXp,
    required this.knowledge,
    required this.coins,
    required this.completedMissions,
    required this.totalStars,
    required this.completedZones,
    required this.medals,
    required this.purchasedUpgrades,
    required this.signDuelBestScore,
    required this.signDuelBestCorrect,
    required this.signDuelPlays,
    required this.updatedAt,
  });

  static const currentSchemaVersion = 1;

  final int schemaVersion;
  final String playerId;
  final String profileType;
  final String avatarId;
  final int citizenshipXp;
  final int knowledge;
  final int coins;
  final int completedMissions;
  final int totalStars;
  final int completedZones;
  final int medals;
  final int purchasedUpgrades;
  final int signDuelBestScore;
  final int signDuelBestCorrect;
  final int signDuelPlays;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': schemaVersion,
    'playerId': playerId,
    'profileType': profileType,
    'avatarId': avatarId,
    'citizenshipXp': citizenshipXp,
    'knowledge': knowledge,
    'coins': coins,
    'completedMissions': completedMissions,
    'totalStars': totalStars,
    'completedZones': completedZones,
    'medals': medals,
    'purchasedUpgrades': purchasedUpgrades,
    'signDuelBestScore': signDuelBestScore,
    'signDuelBestCorrect': signDuelBestCorrect,
    'signDuelPlays': signDuelPlays,
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };

  factory PedagogicalSnapshot.fromJson(Map<String, dynamic> json) {
    return PedagogicalSnapshot(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      playerId: json['playerId'] as String? ?? '',
      profileType: json['profileType'] as String? ?? 'unknown',
      avatarId: json['avatarId'] as String? ?? '',
      citizenshipXp: (json['citizenshipXp'] as num?)?.toInt() ?? 0,
      knowledge: (json['knowledge'] as num?)?.toInt() ?? 0,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      completedMissions: (json['completedMissions'] as num?)?.toInt() ?? 0,
      totalStars: (json['totalStars'] as num?)?.toInt() ?? 0,
      completedZones: (json['completedZones'] as num?)?.toInt() ?? 0,
      medals: (json['medals'] as num?)?.toInt() ?? 0,
      purchasedUpgrades: (json['purchasedUpgrades'] as num?)?.toInt() ?? 0,
      signDuelBestScore: (json['signDuelBestScore'] as num?)?.toInt() ?? 0,
      signDuelBestCorrect: (json['signDuelBestCorrect'] as num?)?.toInt() ?? 0,
      signDuelPlays: (json['signDuelPlays'] as num?)?.toInt() ?? 0,
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}
