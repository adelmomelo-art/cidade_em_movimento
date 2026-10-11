import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/models/game_progress.dart';
import 'package:cidade_em_movimento/models/player_profile.dart';
import 'package:cidade_em_movimento/services/pedagogical_sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('fila mantem apenas snapshot mais recente', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = PedagogicalSyncService(prefs, baseUrl: '');
    const profile = PlayerProfile(
      type: PlayerType.adult,
      avatarId: 'adult_default',
    );
    await service.queueSnapshot(
      profile: profile,
      progress: GameProgress.initial(),
    );
    expect(service.pendingCount, 1);
    await service.queueSnapshot(
      profile: profile,
      progress: GameProgress(
        citizenshipXp: 10,
        knowledge: 20,
        coins: 30,
        completedMissions: const {'Z1_M01'},
        missionStars: const {'Z1_M01': 3},
        unlockedMissions: const {'Z1_M01'},
        purchasedUpgrades: const {},
        medals: const {},
      ),
    );
    expect(service.pendingCount, 1);
    expect(service.pendingSnapshot?.knowledge, 20);
    expect(service.pendingSnapshot?.totalStars, 3);
  });
}
