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
    testWidgets('approved map exposes upgrades and real purchases at $width', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 1100);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = await _controller(completed: true);
      addTearDown(c.dispose);
      final coins = c.progress.coins;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Zone1MapScreen(controller: c),
        ),
      );
      await tester.pumpAndSettle();
      final frame = tester.getRect(find.byKey(const Key('zone1-map-canvas')));
      for (final id in _ids) {
        final pin = tester.getRect(find.byKey(Key('zone1-visual-mission-$id')));
        expect(frame.contains(pin.topLeft), isTrue);
        expect(frame.contains(pin.bottomRight), isTrue);
      }
      await tester.tap(find.byKey(const Key('zone1-open-upgrades')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('zone1-upgrades-window')), findsOneWidget);
      for (final upgrade in zone1Upgrades) {
        expect(find.byKey(Key('zone1-upgrade-${upgrade.id}')), findsOneWidget);
      }
      final balloon = find.byKey(const Key('zone1-upgrade-FAIXA_SEGURA'));
      final purchase = find.descendant(
        of: balloon,
        matching: find.byType(FilledButton),
      );
      await tester.ensureVisible(purchase);
      await tester.pumpAndSettle();
      await tester.tap(purchase);
      await tester.pumpAndSettle();
      expect(c.progress.purchasedUpgrades.contains('FAIXA_SEGURA'), isTrue);
      expect(c.progress.coins, coins - zone1Upgrades.first.cost);
      expect(
        find.descendant(of: balloon, matching: find.text('INSTALADA')),
        findsOneWidget,
      );
      expect(tester.widget<FilledButton>(purchase).onPressed, isNull);
      expect(tester.takeException(), isNull);
    });
  }
  test(
    'removed lateral crossing leaves its former paint location empty',
    () async {
      final recorder = ui.PictureRecorder();
      const painter = Zone1IllustratedUpgradePainter(
        crosswalk: true,
        lighting: false,
        cyclePath: false,
      );
      painter.paint(Canvas(recorder), const Size(1536, 1024));
      final picture = recorder.endRecording();
      final image = await picture.toImage(1536, 1024);
      final pixels = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      expect(pixels!.getUint8((630 * 1536 + 1325) * 4 + 3), 0);
      expect(pixels.buffer.asUint8List().any((value) => value > 0), isTrue);
      image.dispose();
      picture.dispose();
    },
  );
}
