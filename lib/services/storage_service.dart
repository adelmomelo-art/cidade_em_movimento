import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_progress.dart';
import '../models/player_profile.dart';

class StorageService {
  StorageService(this._preferences);

  static const _profileKey = 'cidade_em_movimento.player_profile.v1';
  static const _progressKey = 'cidade_em_movimento.game_progress.v1';

  final SharedPreferences _preferences;

  PlayerProfile? loadProfile() {
    final raw = _preferences.getString(_profileKey);

    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      return PlayerProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(PlayerProfile profile) async {
    await _preferences.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  GameProgress loadProgress() {
    final raw = _preferences.getString(_progressKey);

    if (raw == null || raw.isEmpty) {
      return GameProgress.initial();
    }

    try {
      return GameProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return GameProgress.initial();
    }
  }

  Future<void> saveProgress(GameProgress progress) async {
    await _preferences.setString(_progressKey, jsonEncode(progress.toJson()));
  }
}
