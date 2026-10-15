import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Zona 1 visual mestre abre com HUD e primeira missao', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final controller = PlayerController(StorageService(preferences));

    await controller.initialize();
    await controller.createProfile(
      type: PlayerType.child,
      avatarId: 'child_default',
    );

    await tester.pumpWidget(
      MaterialApp(home: Zone1MapScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Zona 1 - Bairro / Escola'), findsNothing);
    expect(find.byKey(const Key('zone1-back-to-fortaleza')), findsOneWidget);
    expect(find.byKey(const Key('zone1-score-hud')), findsOneWidget);
    expect(
      find.byKey(const Key('zone1-visual-mission-Z1_M01')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('zone1-mentor-panel')), findsOneWidget);
    expect(find.byKey(const Key('zone1-map-artwork')), findsOneWidget);
  });
}
