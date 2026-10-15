import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
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
    testWidgets('approved scenic map and left-side mentor at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = await _controller(completed: true);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Zone1MapScreen(controller: c),
        ),
      );
      await tester.pumpAndSettle();
      final frame = tester.getRect(find.byKey(const Key('zone1-map-canvas')));
      final mentor = tester.getRect(
        find.byKey(const Key('zone1-mentor-panel')),
      );
      final hud = tester.getRect(find.byKey(const Key('zone1-score-hud')));
      expect(mentor.center.dx, lessThan(frame.center.dx));
      expect(frame.contains(mentor.topLeft), isTrue);
      expect(frame.contains(mentor.bottomRight), isTrue);
      expect(mentor.overlaps(hud), isFalse);
      for (final id in _ids) {
        final pin = tester.getRect(find.byKey(Key('zone1-visual-mission-$id')));
        expect(mentor.overlaps(pin), isFalse);
      }
      expect(tester.takeException(), isNull);
    });
  }
  test(
    'new presenter asset preserves transparency and original bust remains bundled',
    () async {
      for (final path in [
        'assets/zone_1/melo_apresentador_r13.png',
        'assets/zone_1/melo_guia_busto_r8.png',
      ]) {
        final data = await rootBundle.load(path);
        final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        final bytes = await frame.image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        expect(bytes!.getUint8(3), 0);
        expect(
          bytes.getUint8((frame.image.width * frame.image.height - 1) * 4 + 3),
          0,
        );
        expect(bytes.buffer.asUint8List().any((v) => v > 240), isTrue);
        frame.image.dispose();
        codec.dispose();
      }
    },
  );
}
