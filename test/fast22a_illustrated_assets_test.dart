import 'dart:ui' as ui;

import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/widgets/zone_1_art.dart';
import 'package:cidade_em_movimento/widgets/zone_1_evolving_scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'illustrated assets decode from the bundle and Melo has real alpha',
    () async {
      final background = await rootBundle.load(
        'assets/zone_1/bairro_escola_base_r7.png',
      );
      final backgroundCodec = await ui.instantiateImageCodec(
        background.buffer.asUint8List(),
      );
      final scene = await backgroundCodec.getNextFrame();
      expect(scene.image.width / scene.image.height, closeTo(1.5, .001));
      scene.image.dispose();
      backgroundCodec.dispose();

      final bytes = await rootBundle.load('assets/zone_1/melo_mentor_r7.png');
      final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      final rgba = await frame.image.toByteData(
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
        expect(rgba!.getUint8(index * 4 + 3), 0);
      }
      expect(
        rgba!.getUint8(((height ~/ 2) * width + width ~/ 2) * 4 + 3),
        greaterThan(240),
      );
      frame.image.dispose();
      codec.dispose();
    },
  );

  const ids = ['FAIXA_SEGURA', 'ILUMINACAO_ESCOLAR', 'TRECHO_CICLOVIARIO'];
  for (var mask = 0; mask < 8; mask++) {
    testWidgets(
      'before/after reflects each purchased upgrade combination $mask',
      (tester) async {
        tester.view.physicalSize = const Size(390, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final purchased = <String>{
          for (var i = 0; i < ids.length; i++)
            if (mask & (1 << i) != 0) ids[i],
        };
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: SingleChildScrollView(
                child: Zone1EvolvingScene(purchasedUpgrades: purchased),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final layers = tester
            .widgetList<CustomPaint>(
              find.byKey(const Key('zone1-live-upgrade-layer')),
            )
            .map((widget) => widget.painter! as Zone1IllustratedUpgradePainter)
            .toList();
        expect(layers.length, 2);
        expect(
          [
            layers.first.crosswalk,
            layers.first.lighting,
            layers.first.cyclePath,
          ],
          [false, false, false],
        );
        expect(
          [layers.last.crosswalk, layers.last.lighting, layers.last.cyclePath],
          [for (final id in ids) purchased.contains(id)],
        );
        expect(
          find.byKey(const Key('zone1-illustrated-background')),
          findsNWidgets(2),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
