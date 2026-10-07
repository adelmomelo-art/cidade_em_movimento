import 'package:flutter/foundation.dart';

import '../core/enums/player_type.dart';
import '../data/zone_1/upgrade_data.dart';
import '../data/zones/zone_catalog.dart';
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

    for (final zone in zoneCatalog) {
      if (zone.canUnlockSpecial(
        completedMissions: completedMissions,
        missionStars: missionStars,
      )) {
        unlockedMissions.add(zone.specialMissionId);
      }
    }

    final medals = Set<String>.from(_progress.medals);
    final completedZones = Set<String>.from(_progress.completedZones);

    final missionZone = findZoneByMission(result.missionId);

    if (missionZone != null &&
        result.missionId == missionZone.specialMissionId) {
      medals.add(missionZone.medalId);
      completedZones.add(missionZone.id);
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
      completedZones: completedZones,
    );

    await _storage.saveProgress(_progress);
    notifyListeners();
  }

  Future<bool> purchaseUpgrade(String upgradeId) async {
    Zone1Upgrade? selected;

    for (final upgrade in zone1Upgrades) {
      if (upgrade.id == upgradeId) {
        selected = upgrade;
        break;
      }
    }

    if (selected == null) {
      return false;
    }

    if (_progress.purchasedUpgrades.contains(selected.id)) {
      return false;
    }

    if (_progress.coins < selected.cost) {
      return false;
    }

    final purchasedUpgrades = Set<String>.from(_progress.purchasedUpgrades)
      ..add(selected.id);

    _progress = GameProgress(
      citizenshipXp: _progress.citizenshipXp,
      knowledge: _progress.knowledge,
      coins: _progress.coins - selected.cost,
      completedMissions: Set<String>.from(_progress.completedMissions),
      missionStars: Map<String, int>.from(_progress.missionStars),
      unlockedMissions: Set<String>.from(_progress.unlockedMissions),
      purchasedUpgrades: purchasedUpgrades,
      medals: Set<String>.from(_progress.medals),
      completedZones: Set<String>.from(_progress.completedZones),
    );

    await _storage.saveProgress(_progress);
    notifyListeners();

    return true;
  }
}
