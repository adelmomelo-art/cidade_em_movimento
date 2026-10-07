import 'package:flutter/foundation.dart';

import '../core/enums/player_type.dart';
import '../models/game_progress.dart';
import '../models/mission_result.dart';
import '../models/player_profile.dart';
import '../services/storage_service.dart';

class PlayerController extends ChangeNotifier {
  PlayerController(this._storage);

  static const _zone1RegularMissionIds = <String>{
    'Z1_M01',
    'Z1_M02',
    'Z1_M03',
    'Z1_M04',
    'Z1_M05',
  };

  static const _zone1SpecialMissionId = 'Z1_SPECIAL';
  static const _zone1SpecialMinimumStars = 9;
  static const _zone1MedalId = 'PROTETOR_DA_ESCOLA';

  final StorageService _storage;

  PlayerProfile? _profile;
  GameProgress _progress = GameProgress.initial();

  PlayerProfile? get profile => _profile;
  GameProgress get progress => _progress;

  bool get hasProfile => _profile != null;

  Future<void> initialize() async {
    _profile = _storage.loadProfile();
    _progress = _storage.loadProgress();
  }

  Future<void> createProfile({
    required PlayerType type,
    required String avatarId,
  }) async {
    _profile = PlayerProfile(type: type, avatarId: avatarId);
    await _storage.saveProfile(_profile!);
    await _storage.saveProgress(_progress);
    notifyListeners();
  }

  Future<void> completeMission({
    required MissionResult result,
    String? nextMissionId,
  }) async {
    final wasAlreadyCompleted = _progress.completedMissions.contains(
      result.missionId,
    );

    final completedMissions = Set<String>.from(_progress.completedMissions)
      ..add(result.missionId);

    final missionStars = Map<String, int>.from(_progress.missionStars);
    final previousStars = missionStars[result.missionId] ?? 0;

    if (result.stars > previousStars) {
      missionStars[result.missionId] = result.stars;
    }

    final unlockedMissions = Set<String>.from(_progress.unlockedMissions);

    if (nextMissionId != null) {
      unlockedMissions.add(nextMissionId);
    }

    final completedAllRegularMissions = _zone1RegularMissionIds.every(
      completedMissions.contains,
    );

    final regularMissionStars = _zone1RegularMissionIds.fold<int>(
      0,
      (total, missionId) => total + (missionStars[missionId] ?? 0),
    );

    if (completedAllRegularMissions &&
        regularMissionStars >= _zone1SpecialMinimumStars) {
      unlockedMissions.add(_zone1SpecialMissionId);
    }

    final medals = Set<String>.from(_progress.medals);
    var zone1Completed = _progress.zone1Completed;

    if (result.missionId == _zone1SpecialMissionId) {
      medals.add(_zone1MedalId);
      zone1Completed = true;
    }

    _progress = GameProgress(
      citizenshipXp:
          _progress.citizenshipXp +
          (wasAlreadyCompleted ? 0 : result.citizenship),
      knowledge:
          _progress.knowledge + (wasAlreadyCompleted ? 0 : result.knowledge),
      coins: _progress.coins + (wasAlreadyCompleted ? 0 : result.coins),
      completedMissions: completedMissions,
      missionStars: missionStars,
      unlockedMissions: unlockedMissions,
      purchasedUpgrades: Set<String>.from(_progress.purchasedUpgrades),
      medals: medals,
      zone1Completed: zone1Completed,
    );

    await _storage.saveProgress(_progress);
    notifyListeners();
  }
}
