import '../core/enums/player_type.dart';

class PlayerProfile {
  const PlayerProfile({required this.type, required this.avatarId});

  final PlayerType type;
  final String avatarId;

  Map<String, dynamic> toJson() {
    return {'type': type.name, 'avatarId': avatarId};
  }

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String? ?? PlayerType.child.name;

    final type = PlayerType.values.firstWhere(
      (value) => value.name == typeName,
      orElse: () => PlayerType.child,
    );

    return PlayerProfile(
      type: type,
      avatarId: json['avatarId'] as String? ?? 'child_boy',
    );
  }
}
