import 'dart:ui' as ui;
import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/widgets/neighborhood_scene_focus.dart';
import 'package:cidade_em_movimento/widgets/neighborhood_scene_geometry.dart';
import 'package:cidade_em_movimento/widgets/neighborhood_upgrade_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<List<int>> _pixels(NeighborhoodSurface surface, {
  bool preview = false,
  bool night = false,
}) async {
  final recorder = ui.PictureRecorder();
  NeighborhoodSurfacePainter(surface: surface, preview: preview, night: night)
      .paint(Canvas(recorder), neighborhoodArtworkSize);
  final picture = recorder.endRecording();
  final image = await picture.toImage(1672, 941);
  try {
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes)
        .toList();
  } finally {
    image.dispose();
    picture.dispose();
  }
}

void main() {
  for (final upgrade in allUpgradeCatalog) {
    final surface = neighborhoodSurfaces[upgrade.zoneId]![upgrade.id]!;
    test('foco contém a melhoria ${upgrade.id} sem sair da arte', () {
      final crop = NeighborhoodSceneFocus.cropFor(upgrade.zoneId, upgrade.id);
      final bounds = surface.path.getBounds();
      expect(crop.left, greaterThanOrEqualTo(0));
      expect(crop.top, greaterThanOrEqualTo(0));
      expect(crop.right, lessThanOrEqualTo(1672));
      expect(crop.bottom, lessThanOrEqualTo(941));
      expect(crop.contains(bounds.topLeft), isTrue);
      expect(crop.contains(bounds.bottomRight), isTrue);
      if (surface.kind == NeighborhoodSurfaceKind.lighting) {
        for (final u in [.08, .52, .92]) {
          expect(crop.contains(surface.point(u, .5) + const Offset(8, -65)),
              isTrue);
        }
      }
    });
  }

  // Every material must paint beyond the optional preview outline. These
  // raster checks complement, rather than replace, visual review on the map.
  for (final kind in NeighborhoodSurfaceKind.values) {
    test('material $kind pinta o chão, inclusive sem contorno de prévia', () async {
      final surface = neighborhoodSurfaces.values
          .expand((zone) => zone.values).firstWhere((s) => s.kind == kind);
      final pixels = await _pixels(surface);
      var painted = 0;
      for (var i = 3; i < pixels.length; i += 4) {
        if (pixels[i] != 0) painted++;
      }
      expect(painted, greaterThan(20));
      if (kind == NeighborhoodSurfaceKind.lighting) {
        expect(await _pixels(surface, night: true), isNot(equals(pixels)));
      } else {
        expect(await _pixels(surface, preview: true), isNot(equals(pixels)));
      }
    });
  }

  testWidgets('sem compra ou prévia não desenha uma melhoria', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox.expand(
      child: NeighborhoodUpgradeLayer(zoneId: 'ZONE_1', purchased: <String>{}),
    )));
    for (final upgrade in upgradesForZone('ZONE_1')) {
      expect(find.byKey(Key('r43-scene-${upgrade.id}')), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });
}
