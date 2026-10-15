import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/zone_3_map/zone_3_map_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _controller() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();

  await controller.completeMission(
    result: const MissionResult(
      missionId: 'Z2_SPECIAL',
      stars: 3,
      score: 100,
      citizenship: 0,
      knowledge: 0,
      coins: 240,
      errors: 0,
    ),
  );

  return controller;
}

void main() {
  testWidgets('Zona 3 permanece inteira e fixa ao arrastar a cena', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1366, 768);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = await _controller();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Zone3MapScreen(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
    final board = find.byKey(const Key('zone3-map-artwork'));
    final before = tester.getRect(board);
    expect(find.byType(Scrollable), findsNothing);
    await tester.drag(board, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(tester.getRect(board), before);
    expect(before.left, greaterThanOrEqualTo(0));
    expect(before.top, greaterThanOrEqualTo(0));
    expect(before.right, lessThanOrEqualTo(1366));
    expect(before.bottom, lessThanOrEqualTo(768));
    for (final id in [
      'Z3_M01',
      'Z3_M02',
      'Z3_M03',
      'Z3_M04',
      'Z3_M05',
      'Z3_SPECIAL',
    ]) {
      expect(find.byKey(Key('zone3-visual-mission-$id')), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });
}
