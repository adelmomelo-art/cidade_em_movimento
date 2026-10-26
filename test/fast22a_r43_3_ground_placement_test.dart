import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/widgets/neighborhood_scene_geometry.dart';
import 'package:cidade_em_movimento/widgets/neighborhood_upgrade_layer.dart';
import 'package:cidade_em_movimento/widgets/zone_1_construction_art.dart';

Future<int> paintedPixels(
  NeighborhoodSurface surface,
  Size size,
  Rect area,
) async {
  final recorder = ui.PictureRecorder();
  NeighborhoodSurfacePainter(
    surface: surface,
    preview: false,
    night: false,
  ).paint(Canvas(recorder), size);
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  try {
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    var count = 0;
    for (var y = area.top.ceil(); y < area.bottom.floor(); y++) {
      for (var x = area.left.ceil(); x < area.right.floor(); x++) {
        if (bytes.getUint8((y * image.width + x) * 4 + 3) > 0) {
          count++;
        }
      }
    }
    return count;
  } finally {
    image.dispose();
    picture.dispose();
  }
}

void main() {
  test('todas as 33 melhorias possuem superfície própria dentro da arte', () {
    final registered = <String>{};
    for (final entry in neighborhoodSurfaces.entries) {
      for (final id in entry.value.keys) {
        expect(registered.add(id), isTrue, reason: id);
        expect(findUpgradeById(id)?.zoneId, entry.key);
        final s = entry.value[id]!;
        for (final p in [s.a, s.b, s.c, s.d]) {
          expect(p.dx, inInclusiveRange(0, neighborhoodArtworkSize.width));
          expect(p.dy, inInclusiveRange(0, neighborhoodArtworkSize.height));
        }
        expect(s.path.contains(s.point(.5, .5)), isTrue, reason: id);
      }
    }
    expect(registered, allUpgradeCatalog.map((u) => u.id).toSet());
  });

  for (final scale in [1.0, .5]) {
    test(
      'faixa da escola fica em A e não em B em escala $scale',
      () async {
        final s = neighborhoodSurfaces['ZONE_1']!['FAIXA_SEGURA']!;
        final size = neighborhoodArtworkSize * scale;
        final oldBadge = Rect.fromLTWH(
          650 * scale,
          550 * scale,
          160 * scale,
          115 * scale,
        );
        final crossing = Rect.fromLTWH(
          160 * scale,
          615 * scale,
          180 * scale,
          100 * scale,
        );
        final rejectedB = Rect.fromLTWH(
          145 * scale, 750 * scale, 375 * scale, 180 * scale,
        );
        expect(await paintedPixels(s, size, oldBadge), 0);
        expect(await paintedPixels(s, size, crossing), greaterThan(0));
        expect(await paintedPixels(s, size, rejectedB), 0);
        expect(s.path.contains(const Offset(730, 600)), isFalse);
        expect(s.path.contains(const Offset(332, 841)), isFalse);
        expect(s.path.contains(const Offset(249, 660)), isTrue);
      },
    );
  }

  testWidgets('prévia e compra usam a mesma superfície e não alteram o save', (
    tester,
  ) async {
    final purchased = <String>{};
    Future<void> render(String? preview) => tester.pumpWidget(
      MaterialApp(
        home: SizedBox.expand(
          child: NeighborhoodUpgradeLayer(
            zoneId: 'ZONE_1',
            purchased: purchased,
            previewId: preview,
          ),
        ),
      ),
    );
    await render(null);
    final key = find.byKey(const Key('r43-scene-FAIXA_SEGURA'));
    expect(key, findsNothing);
    await render('FAIXA_SEGURA');
    expect(key, findsOneWidget);
    final previewArt = tester.widget<Zone1ConstructionArt>(
      find.byType(Zone1ConstructionArt),
    );
    expect(previewArt.previewId, 'FAIXA_SEGURA');
    expect(purchased, isEmpty);
    purchased.add('FAIXA_SEGURA');
    await render(null);
    final builtArt = tester.widget<Zone1ConstructionArt>(
      find.byType(Zone1ConstructionArt),
    );
    expect(builtArt.previewId, isNull);
    expect(key, findsOneWidget);
    expect(purchased, {'FAIXA_SEGURA'});
    expect(tester.takeException(), isNull);
  });
}
