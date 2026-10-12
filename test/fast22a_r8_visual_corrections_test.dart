import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/widgets/zone_1_art.dart';
import 'package:cidade_em_movimento/widgets/zone_1_evolving_scene.dart';
import 'package:cidade_em_movimento/widgets/zone_1_visual_scene.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('R8 bust is bundled with transparent corners', () async {
    final data = await rootBundle.load('assets/zone_1/melo_guia_busto_r8.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    final pixels = await frame.image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    final width = frame.image.width;
    final height = frame.image.height;
    for (final index in [
      0,
      width - 1,
      width * (height - 1),
      width * height - 1,
    ]) {
      expect(pixels!.getUint8(index * 4 + 3), 0);
    }
    expect(
      pixels!.getUint8(((height ~/ 2) * width + width ~/ 2) * 4 + 3),
      greaterThan(240),
    );
    frame.image.dispose();
    codec.dispose();
  });
  for (final width in [390.0, 800.0, 1280.0]) {
    testWidgets('mentor stays inside map without speech bubble at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: Zone1VisualScene(
                missions: [],
                purchasedUpgrades: {},
                onMissionTap: _ignore,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final mentor = tester.getRect(
        find.byKey(const Key('zone1-mentor-panel')),
      );
      final map = tester.getRect(find.byKey(const Key('zone1-map-canvas')));
      final bust = tester.getRect(
        find.byKey(const Key('zone1-illustrated-melo')),
      );
      expect(map.contains(mentor.topLeft), isTrue);
      expect(map.contains(mentor.bottomRight), isTrue);
      expect(find.byKey(const Key('zone1-melo-speech-bubble')), findsNothing);
      expect(mentor.contains(bust.center), isTrue);
      expect(tester.takeException(), isNull);
    });
  }
  for (final lighting in [false, true]) {
    testWidgets('night comparison follows purchased lighting: $lighting', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Zone1EvolvingScene(
                purchasedUpgrades: lighting ? {'ILUMINACAO_ESCOLAR'} : {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final layers = tester
          .widgetList<CustomPaint>(
            find.byKey(const Key('zone1-night-upgrade-layer')),
          )
          .map((w) => w.painter! as Zone1IllustratedUpgradePainter)
          .toList();
      expect(layers.length, 2);
      expect(layers.every((p) => p.nightPreview), isTrue);
      expect(layers.first.lighting, isFalse);
      expect(layers.last.lighting, lighting);
      expect(
        find.text(lighting ? 'ILUMINAÇÃO INSTALADA' : 'AINDA SEM ILUMINAÇÃO'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }
  test('lighting repaints when comparison mode changes', () {
    const day = Zone1IllustratedUpgradePainter(
      crosswalk: false,
      lighting: true,
      cyclePath: false,
    );
    const night = Zone1IllustratedUpgradePainter(
      crosswalk: false,
      lighting: true,
      cyclePath: false,
      nightPreview: true,
    );
    expect(night.shouldRepaint(day), isTrue);
  });
}

void _ignore(String _) {}
