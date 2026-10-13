import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'fast22a_r14_mission_overlay_test.dart' as flow;
import 'fast22a_r15_navigation_question_test.dart' as fixture;

void main() {
  for (final size in [
    const Size(1364, 900),
    const Size(1280, 900),
    const Size(844, 390),
    const Size(600, 390),
  ]) {
    testWidgets('window follows reference proportions and stays inside $size', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = await fixture.controller(false);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Zone1MapScreen(controller: c),
        ),
      );
      await tester.pumpAndSettle();
      // R22 changes the map fit, while the approved dialog dimensions stay.
      final referenceWidth = (size.width - 24).clamp(0.0, 1600.0);
      final referenceLeft = (size.width - referenceWidth) / 2;
      await flow.tap(
        tester,
        find.byKey(const Key('zone1-visual-mission-Z1_M01')),
      );
      final frame = tester.getRect(
        find.byKey(const Key('zone1-mission-frame')),
      );
      expect(frame.left, greaterThanOrEqualTo(0));
      expect(frame.top, greaterThanOrEqualTo(0));
      expect(frame.right, lessThanOrEqualTo(size.width));
      expect(frame.bottom, lessThanOrEqualTo(size.height));
      expect(frame.width / frame.height, closeTo(206 / 110, .001));
      if (size.width >= 1200) {
        expect(frame.width / referenceWidth, closeTo(206 / 656, .001));
        expect(
          frame.height / (referenceWidth / 1.5),
          closeTo((206 / 656) * 1.5 / (206 / 110), .005),
        );
        expect(
          frame.center.dx,
          closeTo(referenceLeft + referenceWidth * .37, 1),
        );
      } else if (size.width <= 844) {
        expect(frame.width, closeTo(360, .001));
      }
      final initial = frame;
      await flow.tap(tester, find.text('INICIAR'));
      expect(
        tester.getRect(find.byKey(const Key('zone1-mission-frame'))),
        initial,
      );
      final close = find.byKey(const Key('zone1-close-mission'));
      expect(tester.getSize(close).width, greaterThanOrEqualTo(48));
      expect(tester.getSize(close).height, greaterThanOrEqualTo(48));
      await flow.tap(tester, close);
      expect(c.progress.completedMissions, isEmpty);
      expect(tester.takeException(), isNull);
    });
  }
}
