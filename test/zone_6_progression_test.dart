import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _controller() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();
  return controller;
}

Future<void> _complete(
  PlayerController controller,
  String id, {
  int stars = 3,
  String? next,
}) async {
  await controller.completeMission(
    result: MissionResult(
      missionId: id,
      stars: stars,
      score: 100,
      citizenship: 0,
      knowledge: 0,
      coins: 0,
      errors: 0,
    ),
    nextMissionId: next,
  );
}

void main() {
  test('conclusao da Zona 5 libera Zona 6 e Z6_M01', () async {
    final controller = await _controller();

    for (final id in <String>[
      'Z1_SPECIAL',
      'Z2_SPECIAL',
      'Z3_SPECIAL',
      'Z4_SPECIAL',
      'Z5_SPECIAL',
    ]) {
      await _complete(controller, id);
    }

    expect(controller.isZoneUnlocked('ZONE_6'), isTrue);
    expect(controller.progress.unlockedMissions, contains('Z6_M01'));
  });

  test('cinco missoes e nove estrelas liberam Z6_SPECIAL', () async {
    final controller = await _controller();

    for (final id in <String>[
      'Z1_SPECIAL',
      'Z2_SPECIAL',
      'Z3_SPECIAL',
      'Z4_SPECIAL',
      'Z5_SPECIAL',
    ]) {
      await _complete(controller, id);
    }

    await _complete(controller, 'Z6_M01', stars: 2, next: 'Z6_M02');
    await _complete(controller, 'Z6_M02', stars: 2, next: 'Z6_M03');
    await _complete(controller, 'Z6_M03', stars: 2, next: 'Z6_M04');
    await _complete(controller, 'Z6_M04', stars: 2, next: 'Z6_M05');
    await _complete(controller, 'Z6_M05', stars: 1);

    expect(controller.progress.unlockedMissions, contains('Z6_SPECIAL'));
  });

  test('especial conclui Zona 6 e entrega Guardiao do Castelao', () async {
    final controller = await _controller();

    for (final id in <String>[
      'Z1_SPECIAL',
      'Z2_SPECIAL',
      'Z3_SPECIAL',
      'Z4_SPECIAL',
      'Z5_SPECIAL',
    ]) {
      await _complete(controller, id);
    }

    await _complete(controller, 'Z6_M01', stars: 2, next: 'Z6_M02');
    await _complete(controller, 'Z6_M02', stars: 2, next: 'Z6_M03');
    await _complete(controller, 'Z6_M03', stars: 2, next: 'Z6_M04');
    await _complete(controller, 'Z6_M04', stars: 2, next: 'Z6_M05');
    await _complete(controller, 'Z6_M05', stars: 1);
    await _complete(controller, 'Z6_SPECIAL');

    expect(controller.progress.completedZones, contains('ZONE_6'));
    expect(controller.progress.medals, contains('GUARDIAO_DO_CASTELAO'));
  });
}
