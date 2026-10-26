import 'dart:ui' as ui;

import 'package:cidade_em_movimento/widgets/neighborhood_upgrade_layer.dart';
import 'package:cidade_em_movimento/widgets/zone_1_construction_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<int> _paintedIn(Rect area, double scale, {
  required bool preview,
  required bool night,
  bool ramp = false,
}) async {
  final recorder = ui.PictureRecorder();
  final CustomPainter painter = ramp
      ? Zone1RampPainter(preview: preview, night: night)
      : Zone1CrosswalkPainter(preview: preview, night: night);
  painter.paint(
    Canvas(recorder), Size(1672 * scale, 941 * scale),
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage((1672 * scale).ceil(), (941 * scale).ceil());
  try {
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    var count = 0;
    for (var y = (area.top * scale).ceil(); y < (area.bottom * scale).floor(); y++) {
      for (var x = (area.left * scale).ceil(); x < (area.right * scale).floor(); x++) {
        if (bytes.getUint8((y * image.width + x) * 4 + 3) != 0) count++;
      }
    }
    return count;
  } finally {
    image.dispose();
    picture.dispose();
  }
}

void main() {
  for (final scale in [1.0, .5]) {
    for (final preview in [false, true]) {
      for (final night in [false, true]) {
        test('pintura só em A: escala=$scale prévia=$preview noite=$night', () async {
          expect(await _paintedIn(const Rect.fromLTWH(160, 615, 180, 100), scale,
              preview: preview, night: night), greaterThan(0));
          expect(await _paintedIn(const Rect.fromLTWH(145, 750, 375, 180), scale,
              preview: preview, night: night), 0,
              reason: 'B nunca pode receber a faixa, inclusive em saves antigos');
        });
        test('acesso acompanha A: escala=$scale prévia=$preview noite=$night', () async {
          expect(await _paintedIn(const Rect.fromLTWH(270, 600, 80, 70), scale,
              preview: preview, night: night, ramp: true), greaterThan(0));
          expect(await _paintedIn(const Rect.fromLTWH(145, 750, 375, 180), scale,
              preview: preview, night: night, ramp: true), 0);
        });
      }
    }
  }

  for (var mask = 0; mask < 32; mask++) {
    testWidgets('remoção de B existe independentemente das compras: $mask', (tester) async {
      final purchased = <String>{
        for (var bit = 0; bit < Zone1ConstructionArt.ids.length; bit++)
          if ((mask & (1 << bit)) != 0) Zone1ConstructionArt.ids[bit],
      };
      final before = Set<String>.of(purchased);
      await tester.pumpWidget(MaterialApp(home: SizedBox.expand(
        child: NeighborhoodUpgradeLayer(zoneId: 'ZONE_1', purchased: purchased),
      )));
      await tester.pumpAndSettle();
      expect(find.byType(Zone1GroundRepair), findsOneWidget);
      expect(find.byKey(const Key('zone1-crosswalk-A')),
          purchased.contains('FAIXA_SEGURA') ? findsOneWidget : findsNothing);
      expect(purchased, before);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('cancelar prévia retira A e mantém a remoção de B', (tester) async {
    final purchased = <String>{};
    Future<void> render(String? preview) => tester.pumpWidget(MaterialApp(
      home: SizedBox.expand(child: NeighborhoodUpgradeLayer(
        zoneId: 'ZONE_1', purchased: purchased, previewId: preview,
      )),
    ));
    await render('FAIXA_SEGURA');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('zone1-crosswalk-A')), findsOneWidget);
    expect(find.byType(Zone1GroundRepair), findsOneWidget);
    await render(null);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('zone1-crosswalk-A')), findsNothing);
    expect(find.byType(Zone1GroundRepair), findsOneWidget);
    expect(purchased, isEmpty);
  });
}
