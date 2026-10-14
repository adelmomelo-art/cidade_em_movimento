import 'package:cidade_em_movimento/widgets/fortaleza_boats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget scene({bool reduced = false, bool enabled = true, VoidCallback? tap}) =>
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: TickerMode(
          enabled: enabled,
          child: Scaffold(
            body: SizedBox(
              width: 572,
              height: 500,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: tap,
                    child: const ColoredBox(color: Colors.blue),
                  ),
                  const FortalezaBoats(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

FortalezaBoatsPainter painter(WidgetTester tester) =>
    tester
            .widget<CustomPaint>(find.byKey(const Key('fortaleza-boats-paint')))
            .painter!
        as FortalezaBoatsPainter;

void main() {
  test('three separate continuous sea routes avoid labels and controls', () {
    expect(FortalezaBoatsPainter.routes.length, 3);
    const forbidden = [
      Rect.fromLTWH(1060, 20, 590, 80), // HUD.
      Rect.fromLTWH(1255, 181, 100, 34), // Beira-Mar.
      Rect.fromLTWH(1310, 228, 300, 115), // Zone 3.
      Rect.fromLTWH(1350, 372, 146, 40), // Pier label.
      Rect.fromLTWH(1516, 480, 140, 40), // Lighthouse label.
      Rect.fromLTWH(1450, 406, 222, 75), // Lighthouse rocks.
    ];
    for (var t = 0.0; t <= FortalezaBoatsPainter.cycleSeconds; t += .5) {
      final hulls = <Rect>[];
      for (final route in FortalezaBoatsPainter.routes) {
        final point = route.position(t);
        final hull = Rect.fromLTRB(
          point.dx - 25 * route.scale,
          point.dy - 37 * route.scale,
          point.dx + 25 * route.scale,
          point.dy + 20 * route.scale,
        );
        expect(FortalezaBoats.bounds.contains(hull.topLeft), isTrue);
        expect(FortalezaBoats.bounds.contains(hull.bottomRight), isTrue);
        for (final obstruction in forbidden) {
          expect(hull.overlaps(obstruction), isFalse);
        }
        for (final other in hulls) {
          expect(hull.overlaps(other), isFalse);
        }
        hulls.add(hull);
        expect((route.position(t + .01) - point).distance, lessThan(.1));
      }
    }
    for (final route in FortalezaBoatsPainter.routes) {
      expect(
        (route.position(0) - route.position(11400)).distance,
        lessThan(.000001),
      );
    }
  });

  testWidgets('motion advances and the decorative layer does not absorb taps', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(scene(tap: () => taps++));
    await tester.pump(const Duration(milliseconds: 16));
    final before = painter(tester).clock.value;
    await tester.pump(const Duration(seconds: 1));
    expect(painter(tester).clock.value, greaterThan(before));
    await tester.tapAt(tester.getCenter(find.byType(FortalezaBoats)));
    expect(taps, 1);
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion and inactive ticker stop without losing phase', (
    tester,
  ) async {
    await tester.pumpWidget(scene());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpWidget(scene(reduced: true));
    final reduced = painter(tester).clock.value;
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    expect(painter(tester).clock.value, reduced);
    await tester.pumpWidget(scene(enabled: false));
    final inactive = painter(tester).clock.value;
    await tester.pump(const Duration(seconds: 2));
    expect(painter(tester).clock.value, inactive);
    await tester.pumpWidget(scene());
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(seconds: 1));
    expect(painter(tester).clock.value, greaterThan(inactive));
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'backgrounding pauses boats and resume continues the same clock',
    (tester) async {
      await tester.pumpWidget(scene());
      await tester.pump(const Duration(seconds: 1));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      final stopped = painter(tester).clock.value;
      await tester.pump(const Duration(seconds: 5));
      expect(painter(tester).clock.value, stopped);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(seconds: 1));
      expect(painter(tester).clock.value, greaterThan(stopped));
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
}
