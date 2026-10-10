import 'dart:convert';

import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/screens/zone_2_map/zone_2_map_screen.dart';
import 'package:cidade_em_movimento/screens/zone_3_map/zone_3_map_screen.dart';
import 'package:cidade_em_movimento/screens/zone_4_map/zone_4_map_screen.dart';
import 'package:cidade_em_movimento/screens/zone_5_map/zone_5_map_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _loadController(String state) async {
  final missions = <String>[
    for (final zone in zoneCatalog) ...[
      ...zone.regularMissionIds,
      zone.specialMissionId,
    ],
  ];
  SharedPreferences.setMockInitialValues(
    state == 'clean'
        ? <String, Object>{}
        : <String, Object>{
            'cidade_em_movimento.player_profile.v1': jsonEncode({
              'type': 'adult',
              'avatarId': 'adult',
            }),
            'cidade_em_movimento.game_progress.v1': jsonEncode({
              'citizenshipXp': 100,
              'knowledge': 100,
              'coins': 240,
              'completedMissions': missions,
              'missionStars': {for (final id in missions) id: 3},
              'unlockedMissions': missions,
              'purchasedUpgrades': state == 'installed'
                  ? [for (final upgrade in upgradeCatalog) upgrade.id]
                  : <String>[],
              'medals': [for (final zone in zoneCatalog) zone.medalId],
              'completedZones': [
                for (final zone in zoneCatalog)
                  if (zone.id != 'ZONE_1') zone.id,
              ],
              // Legacy Z1 representation; no claimed bonus field.
              'zone1Completed': true,
            }),
          },
  );
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();
  return controller;
}

Widget _map(int zone, PlayerController controller) => switch (zone) {
  1 => Zone1MapScreen(controller: controller),
  2 => Zone2MapScreen(controller: controller),
  3 => Zone3MapScreen(controller: controller),
  4 => Zone4MapScreen(controller: controller),
  5 => Zone5MapScreen(controller: controller),
  _ => throw ArgumentError.value(zone),
};

void main() {
  for (final zone in [1, 2, 3, 4, 5]) {
    for (final width in [390.0, 800.0, 1280.0]) {
      for (final state in ['clean', 'legacy', 'installed']) {
        testWidgets('Z$zone/theme/$width/$state layout and mouse scroll', (
          tester,
        ) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 900);
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final controller = await _loadController(state);
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            MaterialApp(theme: AppTheme.light, home: _map(zone, controller)),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          final scrollable = find.byType(Scrollable).first;
          final position = tester.state<ScrollableState>(scrollable).position;
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          final pointerPosition = Offset(width / 2, 450);
          await mouse.addPointer(location: pointerPosition);
          await tester.pump();
          await tester.sendEventToBinding(
            PointerScrollEvent(
              position: pointerPosition,
              scrollDelta: const Offset(0, 300),
              kind: PointerDeviceKind.mouse,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(position.pixels, greaterThan(0));

          for (var step = 0; step <= 4; step++) {
            position.jumpTo(position.maxScrollExtent * step / 4);
            await mouse.moveTo(Offset(width / 2, 430 + step * 10));
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          }
          if (zone == 3 || zone == 4) {
            final prefix = 'zone$zone-install-';
            final upgrades = upgradeCatalog.where(
              (upgrade) => upgrade.zoneId == 'ZONE_$zone',
            );
            for (final upgrade in upgrades) {
              expect(find.byKey(Key('$prefix${upgrade.id}')), findsOneWidget);
            }
          }
          for (final element in find.byType(FilledButton).evaluate()) {
            final box = element.findRenderObject()! as RenderBox;
            expect(box.hasSize, isTrue);
            expect(box.size.width.isFinite, isTrue);
            expect(box.size.height.isFinite, isTrue);
          }
          position.jumpTo(0);
          await tester.pumpAndSettle();
          await mouse.removePointer();
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        });
      }
    }
  }
}
