import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';

const _ids = ['Z1_M01', 'Z1_M02', 'Z1_M03', 'Z1_M04', 'Z1_M05', 'Z1_SPECIAL'];

Future<PlayerController> _controller({
  required bool completed,
  bool earned = true,
}) async {
  SharedPreferences.setMockInitialValues(
    completed
        ? {
            'cidade_em_movimento.player_profile.v1': jsonEncode({
              'type': 'adult',
              'avatarId': 'adult',
            }),
            'cidade_em_movimento.game_progress.v1': jsonEncode({
              'coins': 240,
              'medals': earned ? ['PROTETOR_DA_ESCOLA'] : <String>[],
              'citizenshipXp': 350,
              'knowledge': 120,
              'completedMissions': _ids,
              'unlockedMissions': _ids,
              'missionStars': {for (final id in _ids) id: 3},
              'purchasedUpgrades': <String>[],
              'zone1Completed': true,
            }),
          }
        : <String, Object>{},
  );
  final controller = PlayerController(
    StorageService(await SharedPreferences.getInstance()),
  );
  await controller.initialize();
  return controller;
}

void main() {
  for (final width in [390.0, 800.0, 1280.0]) {
    testWidgets(
      'one mission window inside the main frame and earned medal beside stars at $width',
      (tester) async {
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = await _controller(completed: true);
        addTearDown(controller.dispose);
        final before = controller.progress.toJson();
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Zone1MapScreen(controller: controller),
          ),
        );
        await tester.pumpAndSettle();
        final art = find.byKey(const Key('zone1-map-canvas'));
        final panel = find.byKey(const Key('zone1-mission-window'));
        expect(panel, findsOneWidget);
        for (final id in _ids) {
          final mission = find.byKey(Key('zone1-visual-mission-$id'));
          expect(find.descendant(of: panel, matching: mission), findsOneWidget);
          expect(find.descendant(of: art, matching: mission), findsOneWidget);
        }
        final imageRect = tester.getRect(art);
        final panelRect = tester.getRect(panel);
        // R29's mission layer spans the approved board. Rect.contains excludes
        // the right and bottom edges, even when both rectangles end together.
        const precision = .01;
        expect(
          panelRect.left,
          greaterThanOrEqualTo(imageRect.left - precision),
        );
        expect(panelRect.top, greaterThanOrEqualTo(imageRect.top - precision));
        expect(panelRect.right, lessThanOrEqualTo(imageRect.right + precision));
        expect(
          panelRect.bottom,
          lessThanOrEqualTo(imageRect.bottom + precision),
        );
        expect(panelRect.center.dx, closeTo(imageRect.center.dx, .01));
        final medal = find.byKey(const Key('zone1-earned-medal'));
        expect(medal, findsOneWidget);
        expect(find.descendant(of: art, matching: medal), findsOneWidget);
        final starMetric = find.byTooltip('Estrelas: 18');
        expect(
          tester.getRect(starMetric).contains(tester.getRect(medal).center),
          isTrue,
        );
        final starIcon = find.descendant(
          of: starMetric,
          matching: find.byIcon(Icons.star_rounded),
        );
        expect(
          tester.getRect(starIcon).right,
          lessThan(tester.getRect(medal).left),
        );
        expect(controller.progress.toJson(), before);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final completed in [false, true]) {
    testWidgets(
      'no medal without the persisted reward, completed flag $completed',
      (tester) async {
        final controller = await _controller(
          completed: completed,
          earned: false,
        );
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Zone1MapScreen(controller: controller),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('zone1-earned-medal')), findsNothing);
        expect(controller.progress.medals, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
