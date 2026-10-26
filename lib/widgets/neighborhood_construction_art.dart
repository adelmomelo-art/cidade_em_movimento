import 'package:flutter/material.dart';
import '../data/upgrades/upgrade_catalog.dart';
import 'neighborhood_construction_data.dart';

/// All replacements are clipped in the original 1672 x 941 artwork. The new
/// initial plates are never used as full-scene replacements: landmarks stay
/// byte-for-byte in the existing backdrop outside the intervention footprints.
class NeighborhoodConstructionArt extends StatelessWidget {
  const NeighborhoodConstructionArt({super.key, required this.zoneId,
    required this.purchased, this.previewId, this.night = false,
    this.mapArtwork});
  final String zoneId;
  final Set<String> purchased;
  final String? previewId;
  final bool night;
  final String? mapArtwork;

  @override
  Widget build(BuildContext context) {
    final zone = constructionZones[zoneId]!;
    final map = mapArtwork != null;
    final foreground = [...zone.sceneForeground, if (map) ...zone.mapForeground];
    Widget patch(String asset, List<List<Offset>> polygons) => ClipPath(
      clipper: ConstructionPatchClipper(polygons,
        foreground: map ? zone.mapForeground : const []),
      child: Stack(fit: StackFit.expand, children: [
        Image.asset(asset, fit: BoxFit.fill, excludeFromSemantics: true),
        if (night) ColoredBox(color: map
          ? const Color(0x880A164C) : const Color(0x88051C44)),
      ]),
    );
    return IgnorePointer(child: ClipRect(child: Stack(
      fit: StackFit.expand, children: [
        for (final piece in zone.pieces)
          if (piece.patches.isNotEmpty)
            Positioned.fill(child: patch(zone.initial, piece.patches)),
        for (final piece in zone.pieces)
          if (purchased.contains(piece.id) || previewId == piece.id)
            Positioned.fill(child: Semantics(
              key: Key('r43-scene-${piece.id}'),
              label: '${findUpgradeById(piece.id)?.title ?? "Melhoria urbana"}: ${purchased.contains(piece.id) ? "construído" : "prévia"}',
              child: Stack(fit: StackFit.expand, children: [
                if (piece.patches.isNotEmpty && piece.kind != 'lamp')
                  patch(zone.original, piece.patches),
                ClipPath(
                  clipper: ConstructionForegroundClipper(
                    foreground),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(night
                      ? const Color(0x880A164C) : Colors.transparent,
                      BlendMode.srcATop),
                    child: CustomPaint(
                    key: Key('r43-construction-${piece.id}'),
                    painter: ConstructionDetailPainter(piece,
                      preview: !purchased.contains(piece.id),
                      night: night),
                    ),
                  ),
                ),
                if (piece.kind == 'rack' || piece.kind == 'lamp')
                  ClipPath(
                    clipper: ConstructionForegroundClipper(
                      foreground),
                    child: _Furniture(piece: piece,
                      preview: !purchased.contains(piece.id),
                      night: night),
                  ),
              ]),
            )),
        Positioned.fill(child: patch(zone.original, [
          for (final rect in zone.sceneForeground)
            [rect.topLeft, rect.topRight, rect.bottomRight, rect.bottomLeft],
        ])),
        // Road-facing doors stay closed in every purchase state. This safety
        // repair cannot be undone by a purchase or preview cancellation.
        if (zone.permanent.isNotEmpty)
          Positioned.fill(child: patch(zone.initial, zone.permanent)),


      ],
    )));
  }
}

Path constructionPolygon(List<Offset> points) => Path()..addPolygon(points, true);

class ConstructionPatchClipper extends CustomClipper<Path> {
  const ConstructionPatchClipper(this.polygons, {this.foreground = const []});
  final List<List<Offset>> polygons;
  final List<Rect> foreground;
  @override
  Path getClip(Size size) {
    var p = Path();
    for (final polygon in polygons) {
      p = Path.combine(PathOperation.union, p, constructionPolygon(polygon));
    }
    for (final rect in foreground) {
      p = Path.combine(PathOperation.difference, p, Path()..addRect(rect));
    }
    return p.transform(Matrix4.diagonal3Values(
      size.width / 1672, size.height / 941, 1).storage);
  }
  @override
  bool shouldReclip(covariant ConstructionPatchClipper oldClipper) =>
    oldClipper.polygons != polygons || oldClipper.foreground != foreground;
}

class ConstructionForegroundClipper extends CustomClipper<Path> {
  const ConstructionForegroundClipper(this.foreground);
  final List<Rect> foreground;
  @override
  Path getClip(Size size) {
    var p = Path()..addRect(Offset.zero & size);
    for (final rect in foreground) {
      final scaled = Rect.fromLTRB(rect.left * size.width / 1672,
        rect.top * size.height / 941, rect.right * size.width / 1672,
        rect.bottom * size.height / 941);
      p = Path.combine(PathOperation.difference, p, Path()..addRect(scaled));
    }
    return p;
  }
  @override
  bool shouldReclip(covariant ConstructionForegroundClipper oldClipper) =>
    oldClipper.foreground != foreground;
}

class _Furniture extends StatelessWidget {
  const _Furniture({required this.piece, required this.preview, required this.night});
  final ConstructionPiece piece;
  final bool preview;
  final bool night;
  @override
  Widget build(BuildContext context) => FittedBox(fit: BoxFit.fill,
    child: SizedBox(width: 1672, height: 941, child: Stack(children: [
      if (piece.kind == 'rack')
        _sprite('bicicletario', const Rect.fromLTRB(187, 80, 1419, 957),
          const Size(1536, 1024), piece.object!),
      if (piece.kind == 'lamp')
        for (final foot in piece.posts)
          _sprite('poste', const Rect.fromLTRB(368, 114, 657, 1411),
            const Size(1024, 1536),
            Rect.fromLTWH(foot.dx - 8, foot.dy - 77, 17, 77)),
    ])),
  );
  Widget _sprite(String name, Rect source, Size imageSize, Rect target) {
    Widget sprite = ClipRect(child: FittedBox(fit: BoxFit.fill,
      child: SizedBox(width: source.width, height: source.height,
        child: Stack(children: [Positioned(left: -source.left, top: -source.top,
          width: imageSize.width, height: imageSize.height,
          child: Image.asset('assets/build_neighborhood/r43_5/$name.png',
            fit: BoxFit.fill, excludeFromSemantics: true),
        )]),
      ),
    ));
    if (preview || night) {
      sprite = ColorFiltered(colorFilter: ColorFilter.mode(
        preview ? const Color(0xA619DFFF) : const Color(0x55051C44),
        BlendMode.srcATop), child: sprite);
    }
    return Positioned.fromRect(rect: target, child: sprite);
  }
}

class ConstructionDetailPainter extends CustomPainter {
  const ConstructionDetailPainter(this.piece, {required this.preview, required this.night});
  final ConstructionPiece piece;
  final bool preview;
  final bool night;
  Offset _p(double u, double v) {
    final a = Offset.lerp(piece.ground[0], piece.ground[1], u)!;
    final b = Offset.lerp(piece.ground[3], piece.ground[2], u)!;
    return Offset.lerp(a, b, v)!;
  }
  void _quad(Canvas c, double u0, double v0, double u1, double v1, Color color) =>
    c.drawPath(constructionPolygon([_p(u0,v0),_p(u1,v0),_p(u1,v1),_p(u0,v1)]),
      Paint()..color = color);
  void _line(Canvas c, Offset a, Offset b, Color color, double width) =>
    c.drawLine(a,b,Paint()..color=color..strokeWidth=width..strokeCap=StrokeCap.round);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 1672, size.height / 941);
    final white = preview ? const Color(0xFFBCFAFF) : const Color(0xFFF8F6ED);
    final blue = preview ? const Color(0xFF19DFFF) : const Color(0xFF073D87);
    if (preview && piece.kind == 'lamp') {
      for (final p in piece.posts) {
        canvas.drawOval(Rect.fromCenter(center:p,width:22,height:9),
          Paint()..color=const Color(0x7719DFFF));
      }
    }
    if (preview && piece.kind != 'lamp') {
      canvas.drawPath(constructionPolygon(piece.ground),
        Paint()..color=const Color(0x4419DFFF));
      canvas.drawPath(constructionPolygon(piece.ground),
        Paint()..color=const Color(0xFF19DFFF)..style=PaintingStyle.stroke..strokeWidth=2);
    }
    if (piece.kind == 'shared') {
      // White bicycle and double chevron in a gray mixed-traffic street;
      // never paint a red exclusive lane for ROTA_COMPARTILHADA.
      for (final u in [.22,.65]) {
        final center = _p(u,.55);
        canvas.save();
        canvas.translate(center.dx,center.dy);
        canvas.transform(Matrix4.fromList(<double>[
          .85,.40,0,0, -.4,.5,0,0, 0,0,1,0, 0,0,0,1]).storage);
        final stroke=Paint()..color=white..style=PaintingStyle.stroke..strokeWidth=1.6;
        canvas.drawCircle(const Offset(-5,2),3.7,stroke);
        canvas.drawCircle(const Offset(6,2),3.7,stroke);
        canvas.drawPath(Path()..moveTo(-5,2)..lineTo(-1,-5)..lineTo(3,2)
          ..close()..moveTo(-1,-5)..lineTo(5,-5)..lineTo(6,2)
          ..moveTo(3,-8)..lineTo(7,-8),stroke);
        for (final y in [-12.0,-16.0]) {
          canvas.drawPath(Path()..moveTo(-6,y+3)..lineTo(0,y)..lineTo(6,y+3),stroke);
        }
        canvas.restore();
      }
    }
    if (piece.kind == 'ramp' || piece.kind == 'paving') {
      _quad(canvas,0,0,1,1, preview ? const Color(0xFFABE9EA) : const Color(0xFFD9D5CB));
      for (var i=1;i<7;i++) {
        _line(canvas,_p(i/7,0),_p(i/7,1),const Color(0xFFB6B0A4),.6);
      }
      _quad(canvas,.12,.30,.88,.65, const Color(0xFFE4BA40));
      for(var col=0;col<9;col++) {
        for(var row=0;row<3;row++) {
          canvas.drawCircle(_p(.18+col*.08,.36+row*.09),.5,
            Paint()..color=const Color(0xAA927322));
        }
      }
    }
    if (piece.kind == 'bay') {
      for(var i=0;i<8;i++) {
        _line(canvas,_p(i/8,.03),_p((i+.55)/8,.03),white,1.5);
        _line(canvas,_p(i/8,.97),_p((i+.55)/8,.97),white,1.5);
      }
      _line(canvas,_p(0,0),_p(0,1),white,1.5);
      _line(canvas,_p(1,0),_p(1,1),white,1.5);
    }
    if (piece.kind == 'corridor') {
      // A guardrail on the sidewalk edge, not a zebra crossing in the road.
      for(final u in [.1,.9]) {
        _line(canvas,_p(u,0)+const Offset(0,-22),
          _p(u,1)+const Offset(0,-22),const Color(0xFF263A47),2);
      }
      for(var i=0;i<=7;i++) {
        final a=_p(.5,i/7);
        _line(canvas,a,a+const Offset(0,-24),const Color(0xFF263A47),1.5);
      }
    }
    if (piece.kind == 'lamp' && night) {
      for(final p in piece.posts) {
        canvas.drawOval(Rect.fromCenter(center:p,width:90,height:30),
          Paint()..color=const Color(0x77FFE79F)
            ..maskFilter=const MaskFilter.blur(BlurStyle.normal,12));
      }
    }
    if (piece.object != null && piece.kind != 'rack') {
      final r=piece.object!;
      _line(canvas,r.bottomCenter,r.topCenter+Offset(0,r.height*.3),
        const Color(0xFF263A47),2);
      final sign=Rect.fromLTWH(r.left,r.top,r.width,r.height*.62);
      canvas.drawRRect(RRect.fromRectAndRadius(sign,const Radius.circular(2)),
        Paint()..color=(piece.kind == 'restore' ? const Color(0xFFEB9C2E) : blue));
      canvas.drawRRect(RRect.fromRectAndRadius(sign.deflate(1),const Radius.circular(2)),
        Paint()..color=white..style=PaintingStyle.stroke..strokeWidth=.8);
      final icon = piece.kind=='corridor' ? Icons.directions_walk
        : piece.kind=='restore' ? Icons.arrow_forward : Icons.directions_car;
      final tp=TextPainter(text:TextSpan(text:String.fromCharCode(icon.codePoint),
        style:TextStyle(fontFamily:icon.fontFamily,package:icon.fontPackage,
          fontSize:r.width*.70,color:white)),textDirection:TextDirection.ltr)..layout();
      tp.paint(canvas,Offset(sign.center.dx-tp.width/2,sign.center.dy-tp.height/2));
      tp.dispose();
    }
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant ConstructionDetailPainter oldDelegate) =>
    oldDelegate.piece != piece || oldDelegate.preview != preview || oldDelegate.night != night;
}
