import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_em_movimento/widgets/zone_1_art.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'crosswalk paint does not cover the former foliage overlap points',
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
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      for (final point in [const Offset(450, 800), const Offset(1200, 690)]) {
        expect(
          data!.getUint8((point.dy.toInt() * 1536 + point.dx.toInt()) * 4 + 3),
          0,
          reason: 'faixa não deve pintar a região de vegetação em $point',
        );
      }
      expect(data!.buffer.asUint8List().any((value) => value > 0), isTrue);
      image.dispose();
      picture.dispose();
    },
  );
}
