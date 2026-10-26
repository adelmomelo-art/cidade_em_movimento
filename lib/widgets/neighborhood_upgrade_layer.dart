import 'package:flutter/material.dart';
import '../data/upgrades/upgrade_catalog.dart';
import 'neighborhood_scene_geometry.dart';
import 'zone_1_construction_art.dart';

/// Uses the source artwork's coordinate system inside its own fitted board.
/// No screen-center positioning, backing card, shadow or independent transform.
class NeighborhoodUpgradeLayer extends StatelessWidget {
  const NeighborhoodUpgradeLayer({
    super.key,
    required this.zoneId,
    required this.purchased,
    this.previewId,
    this.night = false,
    this.mapArtwork,
  });
  final String zoneId;
  final Set<String> purchased;
  final String? previewId;
  final bool night;
  final String? mapArtwork;

  @override
  Widget build(BuildContext context) {
    if (zoneId == 'ZONE_1') {
      return Zone1ConstructionArt(
        purchased: purchased,
        previewId: previewId,
        night: night,
        mapArtwork: mapArtwork,
      );
    }
    final surfaces =
        neighborhoodSurfaces[zoneId] ?? const <String, NeighborhoodSurface>{};
    return IgnorePointer(
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            for (final upgrade in upgradesForZone(zoneId))
              if ((purchased.contains(upgrade.id) || previewId == upgrade.id) &&
                  surfaces[upgrade.id] != null)
                Positioned.fill(
                  child: Semantics(
                    label:
                        '${upgrade.title}: ${purchased.contains(upgrade.id) ? "construído" : "prévia"}',
                    child: CustomPaint(
                      key: Key('r43-scene-${upgrade.id}'),
                      painter: NeighborhoodSurfacePainter(
                        surface: surfaces[upgrade.id]!,
                        preview: !purchased.contains(upgrade.id),
                        night: night,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class NeighborhoodSurfacePainter extends CustomPainter {
  const NeighborhoodSurfacePainter({
    required this.surface,
    required this.preview,
    required this.night,
  });
  final NeighborhoodSurface surface;
  final bool preview;
  final bool night;

  void _quad(
    Canvas canvas,
    double u0,
    double v0,
    double u1,
    double v1,
    Paint paint,
  ) {
    final a = surface.point(u0, v0);
    final b = surface.point(u1, v0);
    final c = surface.point(u1, v1);
    final d = surface.point(u0, v1);
    canvas.drawPath(
      Path()
        ..moveTo(a.dx, a.dy)
        ..lineTo(b.dx, b.dy)
        ..lineTo(c.dx, c.dy)
        ..lineTo(d.dx, d.dy)
        ..close(),
      paint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(
      size.width / neighborhoodArtworkSize.width,
      size.height / neighborhoodArtworkSize.height,
    );
    final accent = preview ? const Color(0xFF19DFFF) : const Color(0xFFFFCD38);
    final outline = Paint()
      ..color = accent.withValues(alpha: preview ? .9 : .7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = preview ? 2.4 : 1.8
      ..strokeJoin = StrokeJoin.round;
    // All highlighting follows the surveyed ground plane.
    if (preview && surface.kind != NeighborhoodSurfaceKind.lighting) {
      canvas.drawPath(
        surface.path,
        Paint()..color = accent.withValues(alpha: .055),
      );
      canvas.drawPath(surface.path, outline);
    }
    switch (surface.kind) {
      case NeighborhoodSurfaceKind.crosswalk:
        // Renew the existing crossing, retaining the illustrated foreground.
        // Soft-light does not paste opaque stripes over people or vehicles.
        final renewal = Paint()
          ..color = const Color(0xBFFFFFFF)
          ..blendMode = BlendMode.softLight;
        for (var i = 0; i < 9; i++) {
          _quad(canvas, .06, (i + .1) / 9, .94, (i + .63) / 9, renewal);
        }
        _edge(canvas, .02, .03, .02, .97, Colors.white, 2);
        _edge(canvas, .98, .03, .98, .97, Colors.white, 2);
        break;
      case NeighborhoodSurfaceKind.cycleLane:
        _quad(
          canvas, .02, .08, .98, .92,
          Paint()
            ..color = const Color(0x99E94C3D)
            ..blendMode = BlendMode.softLight,
        );
        _edge(canvas, .02, .08, .98, .08, Colors.white, 2);
        _edge(canvas, .02, .92, .98, .92, Colors.white, 2);
        for (var i = 0; i < 9; i++) {
          _quad(
            canvas,
            (i + .2) / 9,
            .46,
            (i + .65) / 9,
            .54,
            Paint()..color = Colors.white.withValues(alpha: .75),
          );
        }
        break;
      case NeighborhoodSurfaceKind.sidewalk:
        // Paving and a continuous tactile strip stay inside the sidewalk.
        _quad(canvas, .01, .05, .99, .95,
            Paint()..color = const Color(0x35EFD9B5));
        for (var i = 1; i < 10; i++) {
          _edge(canvas, i / 10, .05, i / 10, .95,
              const Color(0x88786550), .8);
        }
        _quad(canvas, .02, .3, .98, .7,
            Paint()..color = const Color(0xFFD9AE36));
        for (var i = 0; i < 12; i++) {
          _quad(
            canvas,
            (i + .2) / 12,
            .37,
            (i + .7) / 12,
            .63,
            Paint()..color = const Color(0xFFFFDB69),
          );
        }
        break;
      case NeighborhoodSurfaceKind.busBay:
        // Mark the existing bay rather than creating a stop in a traffic lane.
        for (var i = 0; i < 8; i++) {
          _quad(canvas, i / 8, 0, (i + .5) / 8, .09,
              Paint()..color = const Color(0xFFFFD34F));
          _quad(canvas, i / 8, .91, (i + .5) / 8, 1,
              Paint()..color = const Color(0xFFFFD34F));
        }
        _quad(canvas, .02, .12, .12, .88,
            Paint()..color = const Color(0xFFEFC44F));
        _quad(canvas, .88, .12, .98, .88,
            Paint()..color = const Color(0xFFEFC44F));
        break;
      case NeighborhoodSurfaceKind.refuge:
        _quad(
          canvas,
          .12,
          .12,
          .88,
          .88,
          Paint()..color = const Color(0x55E4C951),
        );
        _edge(canvas, .04, .06, .96, .06, const Color(0xFFF4E5A0), 3);
        _edge(canvas, .04, .94, .96, .94, const Color(0xFF9B8549), 3);
        for (var i = 0; i < 8; i++) {
          _quad(canvas, (i + .1) / 8, .35, (i + .65) / 8, .65,
              Paint()..color = const Color(0xFFFFCF45));
        }
        break;
      case NeighborhoodSurfaceKind.lighting:
        for (final u in [.08, .52, .92]) {
          final base = surface.point(u, .5);
          final light = base + const Offset(8, -65);
          if (night) {
            canvas.drawOval(
              Rect.fromCenter(center: base, width: 100, height: 30),
              Paint()
                ..color = const Color(0x60FFE79F)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
            );
            canvas.drawCircle(
              light,
              42,
              Paint()
                ..color = const Color(0x70FFF3AC)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
            );
          }
          canvas.drawLine(
            base,
            base + const Offset(0, -61),
            Paint()
              ..color = const Color(0xFF46566A)
              ..strokeWidth = 3,
          );
          canvas.drawLine(
            base + const Offset(0, -61),
            light,
            Paint()
              ..color = const Color(0xFF46566A)
              ..strokeWidth = 3,
          );
          canvas.drawOval(
            Rect.fromCenter(center: light, width: 16, height: 5),
            Paint()..color = const Color(0xFFFFE799),
          );
        }
        break;
      case NeighborhoodSurfaceKind.bicycleRack:
        _quad(canvas, .04, .1, .96, .9,
            Paint()..color = const Color(0x55727068));
        for (final u in [.22, .5, .78]) {
          final left = surface.point(u - .07, .3);
          final right = surface.point(u + .07, .7);
          final topLeft = left + const Offset(0, -21);
          final topRight = right + const Offset(0, -21);
          canvas.drawPath(
            Path()
              ..moveTo(left.dx, left.dy)
              ..lineTo(topLeft.dx, topLeft.dy)
              ..quadraticBezierTo(
                topLeft.dx,
                topLeft.dy - 5,
                topRight.dx,
                topRight.dy,
              )
              ..lineTo(right.dx, right.dy),
            Paint()
              ..color = const Color(0xFF25858E)
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round
              ..strokeWidth = 3,
          );
        }
        break;
      case NeighborhoodSurfaceKind.plaza:
        _quad(canvas, .02, .04, .98, .96,
            Paint()..color = const Color(0x44DABF91));
        // Slatted bench and legs, kept on the square's reserved footprint.
        for (var i = 0; i < 3; i++) {
          _quad(canvas, .12, .15 + i * .16, .88, .26 + i * .16,
              Paint()..color = const Color(0xFFAA744A));
        }
        _quad(
          canvas,
          .12,
          .08,
          .88,
          .18,
          Paint()..color = const Color(0xFF785035),
        );
        for (final u in [.2, .8]) {
          final p = surface.point(u, .6);
          canvas.drawLine(
            p,
            p + const Offset(0, 9),
            Paint()
              ..color = const Color(0xFF544A37)
              ..strokeWidth = 3,
          );
        }
        final planter = surface.point(.86, .82);
        canvas.drawOval(
          Rect.fromCenter(center: planter, width: 10, height: 5),
          Paint()..color = const Color(0xFF9E6D46),
        );
        canvas.drawCircle(planter + const Offset(0, -5), 5,
            Paint()..color = const Color(0xFF368557));
        break;
      case NeighborhoodSurfaceKind.trafficCones:
        for (final u in [.12, .5, .88]) {
          final p = surface.point(u, .5);
          canvas.drawOval(
            Rect.fromCenter(center: p, width: 17, height: 6),
            Paint()..color = const Color(0xFF4B5055),
          );
          canvas.drawPath(
            Path()
              ..moveTo(p.dx, p.dy - 17)
              ..lineTo(p.dx - 6, p.dy)
              ..lineTo(p.dx + 6, p.dy)
              ..close(),
            Paint()..color = const Color(0xFFF28123),
          );
          canvas.drawLine(
            p + const Offset(-3, -7),
            p + const Offset(3, -7),
            Paint()
              ..color = Colors.white
              ..strokeWidth = 2,
          );
        }
        break;
    }
    canvas.restore();
  }

  void _edge(Canvas canvas, double u0, double v0, double u1, double v1,
      Color color, double width) {
    canvas.drawLine(
      surface.point(u0, v0), surface.point(u1, v1),
      Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant NeighborhoodSurfacePainter oldDelegate) =>
      oldDelegate.surface != surface ||
      oldDelegate.preview != preview ||
      oldDelegate.night != night;
}
