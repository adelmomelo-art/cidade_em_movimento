import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/widgets/zone_1_art.dart';
import 'package:cidade_em_movimento/data/zone_1/upgrade_data.dart';

const _ids = ['Z1_M01', 'Z1_M02', 'Z1_M03', 'Z1_M04', 'Z1_M05', 'Z1_SPECIAL'];

Future<PlayerController> _controller({required bool completed}) async {
  SharedPreferences.setMockInitialValues(
    completed
        ? {
            'cidade_em_movimento.player_profile.v1': jsonEncode({
              'type': 'adult',
              'avatarId': 'adult',
            }),
            'cidade_em_movimento.game_progress.v1': jsonEncode({
              'coins': 240,
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
      'score lives inside map, updates and preserves mentor at $width',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 1000);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = await _controller(completed: true);
        addTearDown(controller.dispose);
        final originalCoins = controller.progress.coins;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Zone1MapScreen(controller: controller),
          ),
        );
        await tester.pumpAndSettle();
        final hudFinder = find.byKey(const Key('zone1-score-hud'));
        expect(hudFinder, findsOneWidget);
        final map = tester.getRect(find.byKey(const Key('zone1-map-canvas')));
        final hud = tester.getRect(hudFinder);
        expect(map.contains(hud.topLeft), isTrue);
        expect(map.contains(hud.bottomRight), isTrue);
        expect(
          hud.overlaps(
            tester.getRect(find.byKey(const Key('zone1-mentor-panel'))),
          ),
          isFalse,
        );
        for (final id in _ids) {
          expect(
            hud.overlaps(
              tester.getRect(find.byKey(Key('zone1-visual-mission-$id'))),
            ),
            isFalse,
          );
        }
        for (final value in ['350', '120', '$originalCoins', '18']) {
          expect(
            find.descendant(of: hudFinder, matching: find.text(value)),
            findsOneWidget,
          );
        }
        if (width >= 800) {
          final wheelchair = Rect.fromCenter(
            center: Offset(
              map.left + map.width * 1155 / 1536,
              map.top + map.height * 735 / 1024,
            ),
            width: map.width * 90 / 1536,
            height: map.height * 90 / 1024,
          );
          expect(
            tester
                .getRect(find.byKey(const Key('zone1-visual-mission-Z1_M05')))
                .overlaps(wheelchair),
            isFalse,
          );
        }
        final cost = zone1Upgrades
            .firstWhere((u) => u.id == 'FAIXA_SEGURA')
            .cost;
        expect(await controller.purchaseUpgrade('FAIXA_SEGURA'), isTrue);
        await tester.pumpAndSettle();
        expect(
          find.descendant(
            of: hudFinder,
            matching: find.text('${originalCoins - cost}'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
  test('crosswalk leaves the cycle lane pixels intact', () async {
    Future<ui.Image> render(bool crosswalk) async {
      final recorder = ui.PictureRecorder();
      Zone1IllustratedUpgradePainter(
        crosswalk: crosswalk,
        lighting: false,
        cyclePath: true,
      ).paint(Canvas(recorder), const Size(1536, 1024));
      final picture = recorder.endRecording();
      final image = await picture.toImage(1536, 1024);
      picture.dispose();
      return image;
    }

    final lane = await render(false);
    final crossing = await render(true);
    final before = await lane.toByteData(format: ui.ImageByteFormat.rawRgba);
    final after = await crossing.toByteData(format: ui.ImageByteFormat.rawRgba);
    for (final p in [
      const Offset(566, 678),
      const Offset(566, 689),
      const Offset(580, 695),
      const Offset(592, 702),
      const Offset(609, 710),
      const Offset(737, 768),
      const Offset(963, 876),
    ]) {
      final start = (p.dy.toInt() * 1536 + p.dx.toInt()) * 4;
      expect(
        after!.buffer.asUint8List(start, 4),
        before!.buffer.asUint8List(start, 4),
        reason: 'faixa não deve cobrir a ciclovia em $p',
      );
    }
    lane.dispose();
    crossing.dispose();
  });
}
