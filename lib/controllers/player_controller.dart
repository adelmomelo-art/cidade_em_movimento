import 'package:flutter/foundation.dart';

import '../core/enums/player_type.dart';
import '../models/game_progress.dart';
import '../models/mission_result.dart';
import '../models/player_profile.dart';
import '../services/storage_service.dart';

class PlayerController extends ChangeNotifier {
  PlayerController(this._storage);

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
      medals: Set<String>.from(_progress.medals),
      zone1Completed: _progress.zone1Completed,
    );

    await _storage.saveProgress(_progress);
    notifyListeners();
  }
}
