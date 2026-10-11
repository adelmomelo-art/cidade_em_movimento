import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_progress.dart';
import '../models/pedagogical_snapshot.dart';
import '../models/player_profile.dart';

enum PedagogicalSyncStatus {
  synced,
  nothingPending,
  backendNotConfigured,
  failed,
}

class PedagogicalSyncService {
  PedagogicalSyncService(
    this._preferences, {
    required String baseUrl,
    http.Client? client,
  }) : _baseUrl = baseUrl.trim().replaceAll(RegExp(r'/$'), ''),
       _client = client ?? http.Client();

  static const _playerIdKey = 'cidade_em_movimento.pedagogical_player_id.v1';
  static const _pendingKey =
      'cidade_em_movimento.pedagogical_pending_snapshot.v1';

  final SharedPreferences _preferences;
  final String _baseUrl;
  final http.Client _client;

  bool get backendConfigured => _baseUrl.isNotEmpty;
  int get pendingCount {
    final raw = _preferences.getString(_pendingKey);
    return raw == null || raw.isEmpty ? 0 : 1;
  }

  PedagogicalSnapshot? get pendingSnapshot {
    final raw = _preferences.getString(_pendingKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return PedagogicalSnapshot.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> queueSnapshot({
    required PlayerProfile profile,
    required GameProgress progress,
  }) async {
    final playerId = await _ensurePlayerId();
    final totalStars = progress.missionStars.values.fold<int>(
      0,
      (a, b) => a + b,
    );
    final value = PedagogicalSnapshot(
      schemaVersion: PedagogicalSnapshot.currentSchemaVersion,
      playerId: playerId,
      profileType: profile.type.name,
      avatarId: profile.avatarId,
      citizenshipXp: progress.citizenshipXp,
      knowledge: progress.knowledge,
      coins: progress.coins,
      completedMissions: progress.completedMissions.length,
      totalStars: totalStars,
      completedZones: progress.completedZones.length,
      medals: progress.medals.length,
      purchasedUpgrades: progress.purchasedUpgrades.length,
      signDuelBestScore: progress.signDuelBestScore,
      signDuelBestCorrect: progress.signDuelBestCorrect,
      signDuelPlays: progress.signDuelPlays,
      updatedAt: DateTime.now().toUtc(),
    );
    await _preferences.setString(_pendingKey, jsonEncode(value.toJson()));
  }

  Future<PedagogicalSyncStatus> syncPending() async {
    final value = pendingSnapshot;
    if (value == null) return PedagogicalSyncStatus.nothingPending;
    if (!backendConfigured) return PedagogicalSyncStatus.backendNotConfigured;
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/v1/pedagogical/snapshots'),
            headers: const {'content-type': 'application/json'},
            body: jsonEncode(value.toJson()),
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return PedagogicalSyncStatus.failed;
      }
      await _preferences.remove(_pendingKey);
      return PedagogicalSyncStatus.synced;
    } catch (_) {
      return PedagogicalSyncStatus.failed;
    }
  }

  Future<String> _ensurePlayerId() async {
    final existing = _preferences.getString(_playerIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final random = Random.secure();
    final entropy = List<int>.generate(
      4,
      (_) => random.nextInt(1 << 32),
    ).map((v) => v.toRadixString(16).padLeft(8, '0')).join();
    final value =
        'cem-${DateTime.now().toUtc().microsecondsSinceEpoch}-$entropy';
    await _preferences.setString(_playerIdKey, value);
    return value;
  }
}
