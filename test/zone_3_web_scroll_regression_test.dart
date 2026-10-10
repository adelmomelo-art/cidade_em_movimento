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
      missionId: 'FAST9_R5_SCROLL',
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
  testWidgets('Zona 3 rola atraves da cena visual sem capturar ponteiro', (
    tester,
  ) async {
    final controller = await _controller();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Zone3MapScreen(controller: controller),
      ),
    );
    await tester.pumpAndSettle();

    final sceneTitle = find.text('Orla em Transforma\u00e7\u00e3o');
    expect(sceneTitle, findsOneWidget);

    final scrollable = find.byType(Scrollable).first;
    final before = tester.state<ScrollableState>(scrollable).position.pixels;

    final sceneCenter = tester.getCenter(sceneTitle);
    final gesture = await tester.startGesture(sceneCenter);
    await gesture.moveBy(const Offset(0, -500));
    await gesture.up();
    await tester.pumpAndSettle();

    final after = tester.state<ScrollableState>(scrollable).position.pixels;
    expect(after, greaterThan(before));

    for (
      var step = 0;
      step < 24 && find.text('Miss\u00f5es da Zona 3').evaluate().isEmpty;
      step++
    ) {
      await tester.drag(scrollable, const Offset(0, -260));
      await tester.pumpAndSettle();
    }

    expect(find.text('Miss\u00f5es da Zona 3'), findsOneWidget);
  });
}
