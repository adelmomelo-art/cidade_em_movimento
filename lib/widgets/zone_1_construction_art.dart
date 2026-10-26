import 'package:flutter/material.dart';
import 'neighborhood_scene_geometry.dart';

const zone1InitialConstructionArt =
    'assets/build_neighborhood/r43_5/escola_inicial.png';
const _completedRoadArt = 'assets/zone_1/r29/cenario_bairro.png';
const _artSize = Size(1672, 941);

/// Local replacements and alpha sprites, all registered to the original board.
/// Empty, preview and constructed states share one coordinate system.
class Zone1ConstructionArt extends StatelessWidget {
  const Zone1ConstructionArt({
    super.key,
    required this.purchased,
    this.previewId,
    this.night = false,
    this.mapArtwork,
  });
  final Set<String> purchased;
  final String? previewId;
  final bool night;
  final String? mapArtwork;

  static const ids = <String>[
    'FAIXA_SEGURA',
    'ILUMINACAO_ESCOLAR',
    'TRECHO_CICLOVIARIO',
    'CALCADA_ACESSIVEL_ESCOLAR',
    'BICICLETARIO_ESCOLAR',
  ];
  static const _titles = <String, String>{
    'FAIXA_SEGURA': 'Faixa Segura',
    'ILUMINACAO_ESCOLAR': 'Iluminação Escolar',
    'TRECHO_CICLOVIARIO': 'Trecho Cicloviário',
    'CALCADA_ACESSIVEL_ESCOLAR': 'Calçada acessível',
    'BICICLETARIO_ESCOLAR': 'Bicicletário escolar',
  };

  static List<Offset> get crossing => [
    zone1ApprovedCrossing.a, zone1ApprovedCrossing.b,
    zone1ApprovedCrossing.c, zone1ApprovedCrossing.d,
  ];
  // Always replace B with asphalt, independently of purchases and previews.
  static const removedCrossingB = <Offset>[
    Offset(393, 757), Offset(513, 823),
    Offset(272, 924), Offset(146, 853),
  ];
  static const cycleConnection = <Offset>[
    Offset(685, 786), Offset(1080, 626),
    Offset(1144, 680), Offset(745, 848),
  ];
  static const rackRect = Rect.fromLTWH(900, 338, 84, 60);
  static const lampRects = <Rect>[
    Rect.fromLTWH(638, 394, 23, 98),
    Rect.fromLTWH(1014, 331, 23, 98),
  ];

  bool _visible(String id) => purchased.contains(id) || previewId == id;
  bool _preview(String id) => previewId == id && !purchased.contains(id);

  Widget _road(String id, List<Offset> polygon) => ClipPath(
    clipper: _BoardPolygonClipper(polygon),
    child: Stack(fit: StackFit.expand, children: [
      Image.asset(_visible(id) ? _completedRoadArt : zone1InitialConstructionArt,
          fit: BoxFit.fill, excludeFromSemantics: true),
      if (night) const ColoredBox(color: Color(0x88051C44)),
      if (_preview(id)) const ColoredBox(color: Color(0x6619DFFF)),
    ]),
  );

  Widget _sprite(String id, String asset, Rect source, Size sourceSize,
      Rect target, {bool flipX = false}) {
    Widget sprite = ClipRect(
      child: FittedBox(fit: BoxFit.fill, child: SizedBox(
        width: source.width, height: source.height,
        child: Stack(children: [Positioned(
          left: -source.left, top: -source.top,
          width: sourceSize.width, height: sourceSize.height,
          child: Image.asset(asset, fit: BoxFit.fill,
              cacheWidth: asset.contains('/poste.') ? 128 : 256,
              excludeFromSemantics: true),
        )]),
      )),
    );
    if (flipX) {
      sprite = Transform.flip(flipX: true, child: sprite);
    }
    if (_preview(id)) {
      sprite = ColorFiltered(
        colorFilter: const ColorFilter.mode(Color(0xB319DFFF), BlendMode.srcATop),
        child: sprite,
      );
    }
    return Positioned.fromRect(rect: target, child: sprite);
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ClipRect(child: FittedBox(fit: BoxFit.fill, child: SizedBox(
      width: _artSize.width, height: _artSize.height,
      child: Stack(children: [
        Positioned.fill(child: Zone1GroundRepair(night: night)),
        Positioned.fill(child: _road(ids[2], cycleConnection)),
        for (final id in ids)
          if (_visible(id))
            Positioned.fill(child: Semantics(
              key: Key('r43-scene-$id'),
              label: '${_titles[id]}: ${_preview(id) ? "prévia" : "construído"}',
              child: Stack(children: [
                if (id == ids[0])
                  Positioned.fill(child: CustomPaint(
                    key: const Key('zone1-crosswalk-A'),
                    painter: Zone1CrosswalkPainter(
                      preview: _preview(id), night: night,
                    ),
                  )),
                if (id == ids[1]) ...[
                  if (night)
                    for (final rect in lampRects)
                      Positioned.fromRect(
                        rect: Rect.fromCenter(center: rect.bottomCenter,
                            width: 130, height: 55),
                        child: const DecoratedBox(decoration: BoxDecoration(
                          gradient: RadialGradient(colors: [
                            Color(0x99FFE8A6), Color(0x00FFE8A6),
                          ]),
                        )),
                      ),
                  for (final rect in lampRects)
                    _sprite(id, 'assets/build_neighborhood/r43_5/poste.png',
                        const Rect.fromLTRB(368, 114, 657, 1411),
                        const Size(1024, 1536), rect),
                ],
                if (id == ids[3])
                  Positioned.fill(child: CustomPaint(
                    key: const Key('zone1-ramp-A'),
                    painter: Zone1RampPainter(
                      preview: _preview(id), night: night,
                    ),
                  )),
                if (id == ids[4])
                  _sprite(id, 'assets/build_neighborhood/r43_5/bicicletario.png',
                      const Rect.fromLTRB(187, 80, 1419, 957),
                      const Size(1536, 1024), rackRect),
              ]),
            )),
        // Pins are part of the approved bitmap. Restore only their small
        // foreground areas after the ground replacements, retaining hit targets.
        if (mapArtwork != null)
          Positioned.fill(child: ClipPath(
            clipper: const _BoardPinClipper(),
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(mapArtwork!, fit: BoxFit.fill,
                  excludeFromSemantics: true),
              if (night) const ColoredBox(color: Color(0x88051C44)),
            ]),
          )),
      ]),
    ))),
  );
}

/// B is corrected before any optional intervention, including for old saves
/// which already contain FAIXA_SEGURA. No purchase or migration is performed.
class Zone1GroundRepair extends StatelessWidget {
  const Zone1GroundRepair({super.key, this.night = false, this.mapArtwork});
  final bool night;
  final String? mapArtwork;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Stack(fit: StackFit.expand, children: [
      ClipPath(
        clipper: const _BoardPolygonClipper(
          Zone1ConstructionArt.removedCrossingB,
        ),
        child: Stack(fit: StackFit.expand, children: [
          Image.asset(zone1InitialConstructionArt, fit: BoxFit.fill,
              excludeFromSemantics: true),
          if (night) const ColoredBox(color: Color(0x88051C44)),
        ]),
      ),
      if (mapArtwork != null)
        ClipPath(
          clipper: const _BoardPinClipper(),
          child: Stack(fit: StackFit.expand, children: [
            Image.asset(mapArtwork!, fit: BoxFit.fill,
                excludeFromSemantics: true),
            if (night) const ColoredBox(color: Color(0x88051C44)),
          ]),
        ),
    ]),
  );
}

/// Geometric road paint belongs to A. It never samples the old crossing bitmap.
class Zone1CrosswalkPainter extends CustomPainter {
  const Zone1CrosswalkPainter({required this.preview, required this.night});
  final bool preview;
  final bool night;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / _artSize.width, size.height / _artSize.height);
    final surface = zone1ApprovedCrossing;
    // The foreground signal stays in front of the paint at the left endpoint.
    final foreground = Path()..addRect(const Rect.fromLTWH(166, 628, 34, 88));
    canvas.clipPath(Path.combine(PathOperation.difference,
        surface.path, foreground));
    if (preview) {
      canvas.drawPath(surface.path, Paint()..color = const Color(0x5519DFFF));
    }
    final paint = Paint()..color = preview
        ? const Color(0xDDE2FCFF)
        : night ? const Color(0xFFB9BEC8) : const Color(0xFFF8F6ED);
    for (var stripe = 0; stripe < 8; stripe++) {
      final top = (stripe + .12) / 8;
      final bottom = (stripe + .70) / 8;
      canvas.drawPath(Path()..addPolygon([
        surface.point(.05, top), surface.point(.95, top),
        surface.point(.95, bottom), surface.point(.05, bottom),
      ], true), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant Zone1CrosswalkPainter oldDelegate) =>
      oldDelegate.preview != preview || oldDelegate.night != night;
}

/// A ground-plane inset covers the old curb locally; there is no elevated
/// sprite or drop shadow at the road-facing toe of the accessible route.
class Zone1RampPainter extends CustomPainter {
  const Zone1RampPainter({required this.preview, required this.night});
  final bool preview;
  final bool night;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / _artSize.width, size.height / _artSize.height);
    final s = zone1ApprovedRamp;
    canvas.drawPath(s.path, Paint()..color = preview
        ? const Color(0xFF94E9EB)
        : night ? const Color(0xFF9C9DA5) : const Color(0xFFD9D5CB));
    final tactile = Path()..addPolygon([
      s.point(.12, .2), s.point(.88, .2),
      s.point(.88, .55), s.point(.12, .55),
    ], true);
    canvas.drawPath(tactile, Paint()..color = preview
        ? const Color(0xFFC5F8F9)
        : night ? const Color(0xFFAE8E37) : const Color(0xFFE4BA40));
    for (var col = 0; col < 9; col++) {
      for (var row = 0; row < 3; row++) {
        canvas.drawCircle(s.point(.17 + col * .08, .26 + row * .1), .55,
            Paint()..color = const Color(0xAA927322));
      }
    }
    // The toe is the same road-side segment as A's sidewalk endpoint.
    canvas.drawLine(s.d, s.c, Paint()
      ..color = const Color(0xFFADAFAF)
      ..strokeWidth = .7);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant Zone1RampPainter oldDelegate) =>
      oldDelegate.preview != preview || oldDelegate.night != night;
}

class _BoardPolygonClipper extends CustomClipper<Path> {
  const _BoardPolygonClipper(this.points);
  final List<Offset> points;
  @override
  Path getClip(Size size) => Path()..addPolygon([
    for (final p in points)
      Offset(p.dx * size.width / _artSize.width,
          p.dy * size.height / _artSize.height),
  ], true);
  @override
  bool shouldReclip(covariant _BoardPolygonClipper oldClipper) =>
      oldClipper.points != points;
}

class _BoardPinClipper extends CustomClipper<Path> {
  const _BoardPinClipper();
  @override
  Path getClip(Size size) {
    final sx = size.width / _artSize.width;
    final sy = size.height / _artSize.height;
    return Path()
      ..addRect(Rect.fromLTWH(155 * sx, 599 * sy, 226 * sx, 111 * sy))
      ..addOval(Rect.fromLTWH(151 * sx, 791 * sy, 139 * sx, 82 * sy))
      ..addRect(Rect.fromLTWH(754 * sx, 633 * sy, 248 * sx, 99 * sy));
  }
  @override
  bool shouldReclip(covariant _BoardPinClipper oldClipper) => false;
}
