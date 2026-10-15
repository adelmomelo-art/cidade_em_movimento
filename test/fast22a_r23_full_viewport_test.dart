import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/widgets/zone_1_approved_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fast22a_r15_navigation_question_test.dart' as fixture;
import 'fast22a_r14_mission_overlay_test.dart' as flow;
import 'fast22a_r22_landscape_map_test.dart' as evidence;

void main() {
  for (final sample in [
    (const Size(800, 360), 1.0, const EdgeInsets.fromLTRB(28, 0, 24, 0)),
    (const Size(800, 360), 2.0, const EdgeInsets.fromLTRB(24, 0, 28, 0)),
    (const Size(1024, 768), 1.0, const EdgeInsets.only(top: 24, bottom: 20)),
    (const Size(1366, 768), 1.0, EdgeInsets.zero),
  ]) {
    testWidgets('scene fills every viewport edge with proportional art $sample', (
      tester,
    ) async {
      tester.view.devicePixelRatio = sample.$2;
      tester.view.physicalSize = sample.$1 * sample.$2;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final c = await fixture.controller(true);
      addTearDown(c.dispose);
      final before = c.progress.toJson();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(padding: sample.$3, viewPadding: sample.$3),
            child: child!,
          ),
          home: RepaintBoundary(
            key: const Key('zone1-r22-map-capture'),
            child: Zone1MapScreen(controller: c),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final canvas = find.byKey(const Key('zone1-map-canvas'));
      final frame = tester.getRect(canvas);
      final screen = Offset.zero & sample.$1;
      expect(frame.left, closeTo(screen.left, .01));
      expect(frame.top, closeTo(screen.top, .01));
      expect(frame.right, closeTo(screen.right, .01));
      expect(frame.bottom, closeTo(screen.bottom, .01));
      expect(tester.widget<ClipRRect>(canvas).borderRadius, BorderRadius.zero);
      expect(tester.getRect(find.byKey(const Key('zone1-ambient-art'))), frame);
      expect(find.byType(Scrollable), findsNothing);
      final safe = Rect.fromLTRB(
        sample.$3.left,
        sample.$3.top,
        sample.$1.width - sample.$3.right,
        sample.$1.height - sample.$3.bottom,
      );
      for (final key in [
        'zone1-score-hud',
        'zone1-navigation-window',
        'zone1-mentor-panel',
        'zone1-open-upgrades',
      ]) {
        final rect = tester.getRect(find.byKey(Key(key)));
        expect(safe.inflate(.01).contains(rect.topLeft), isTrue, reason: key);
        expect(
          safe.inflate(.01).contains(rect.bottomRight),
          isTrue,
          reason: key,
        );
      }
      for (final night in [false, true]) {
        if (night) {
          await flow.tap(tester, find.byKey(const Key('zone1-toggle-night')));
        }
        final board = tester.getRect(
          find.byKey(const Key('zone1-map-artwork')),
        );
        expect(board.width / board.height, closeTo(1672 / 941, .001));
        expect(safe.inflate(.01).contains(board.topLeft), isTrue);
        expect(safe.inflate(.01).contains(board.bottomRight), isTrue);
        final layer = tester.widget<Zone1NightLayer>(
          find.byKey(const Key('zone1-map-night')),
        );
        expect(layer.night, night);
        await evidence.captureMap(
          tester,
          'r23_${sample.$1.width.toInt()}x${sample.$1.height.toInt()}_dpr${sample.$2}_${night ? 'noite' : 'dia'}',
        );
      }
      expect(c.progress.toJson(), before);
      expect(tester.takeException(), isNull);
    });
  }
}
