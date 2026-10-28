import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../ui/visual_system.dart';

class Zone1NeighborhoodArt extends StatelessWidget {
  const Zone1NeighborhoodArt({
    super.key,
    required this.crosswalk,
    required this.lighting,
    required this.cyclePath,
    this.showVehicles = true,
    this.showPeople = true,
    this.nightPreview = false,
  });

  final bool crosswalk;
  final bool lighting;
  final bool cyclePath;
  final bool showVehicles;
  final bool showPeople;
  final bool nightPreview;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 1536,
            height: 1024,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/zone_1/bairro_escola_base_r7.webp',
                  key: Key(
                    nightPreview
                        ? 'zone1-night-background'
                        : 'zone1-illustrated-background',
                  ),
                  cacheWidth: 1536,
                  filterQuality: FilterQuality.medium,
                  excludeFromSemantics: true,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) => CustomPaint(
                    painter: _Zone1NeighborhoodPainter(
                      crosswalk: false,
                      lighting: false,
                      cyclePath: false,
                      showVehicles: showVehicles,
                      showPeople: showPeople,
                    ),
                  ),
                ),
                if (nightPreview)
                  const IgnorePointer(
                    child: ColoredBox(color: Color(0xC20B1E45)),
                  ),
                IgnorePointer(
                  child: CustomPaint(
                    key: Key(
                      nightPreview
                          ? 'zone1-night-upgrade-layer'
                          : 'zone1-live-upgrade-layer',
                    ),
                    painter: Zone1IllustratedUpgradePainter(
                      crosswalk: crosswalk,
                      lighting: lighting,
                      cyclePath: cyclePath,
                      nightPreview: nightPreview,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MeloMascot extends StatelessWidget {
  const MeloMascot({
    super.key,
    this.presenting = false,
    this.width = 150,
    this.height = 210,
    this.showSpeech = false,
  });

  final bool presenting;
  final double width;
  final double height;
  final bool showSpeech;

  @override
  Widget build(BuildContext context) {
    final mascot = SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        presenting
            ? 'assets/zone_1/melo_apresentador_r13.png'
            : 'assets/zone_1/melo_guia_busto_r8.png',
        key: const Key('zone1-illustrated-melo'),
        cacheWidth: 512,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        filterQuality: FilterQuality.medium,
        semanticLabel: 'Melo, agente de trânsito da AMC e mentor',
        errorBuilder: (context, error, stackTrace) =>
            CustomPaint(painter: const _MeloPainter()),
      ),
    );

    if (!showSpeech) {
      return mascot;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mascot,
        Container(
          constraints: const BoxConstraints(maxWidth: 190),
          margin: const EdgeInsets.only(top: 18),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: GameColors.blue.withValues(alpha: 0.28)),
            boxShadow: GameVisual.softShadow,
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Melo',
                style: TextStyle(
                  color: GameColors.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Explore o bairro, complete as missoes e transforme o entorno da escola.',
                style: TextStyle(color: GameColors.ink, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Zone1NeighborhoodPainter extends CustomPainter {
  const _Zone1NeighborhoodPainter({
    required this.crosswalk,
    required this.lighting,
    required this.cyclePath,
    required this.showVehicles,
    required this.showPeople,
  });

  final bool crosswalk;
  final bool lighting;
  final bool cyclePath;
  final bool showVehicles;
  final bool showPeople;

  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()..color = const Color(0xFF89D5FF);
    final ground = Paint()..color = const Color(0xFF8CCB78);
    final water = Paint()..color = const Color(0xFF5CC6E8);
    final road = Paint()..color = const Color(0xFF4F5963);
    final sidewalk = Paint()..color = const Color(0xFFD7D4C9);
    final white = Paint()..color = Colors.white;
    final green = Paint()..color = const Color(0xFF2E7D32);
    final orange = Paint()..color = const Color(0xFFF4A340);
    final navy = Paint()..color = GameColors.navy;

    canvas.drawRect(Offset.zero & size, sky);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF53BCE9), Color(0xFFEAF9FF)],
        ).createShader(Offset.zero & size),
    );
    for (final x in [0.12, 0.50, 0.82]) {
      final cloud = Offset(size.width * x, size.height * 0.045);
      canvas.drawOval(
        Rect.fromCenter(
          center: cloud,
          width: size.width * .11,
          height: size.height * .035,
        ),
        Paint()..color = Colors.white.withValues(alpha: .7),
      );
    }

    final skylineTop = size.height * 0.05;
    for (var index = 0; index < 10; index++) {
      final buildingWidth = size.width * 0.055;
      final left = size.width * (0.04 + index * 0.09);
      final height = size.height * (0.10 + ((index * 3) % 5) * 0.018);
      final rect = Rect.fromLTWH(
        left,
        skylineTop + size.height * 0.11 - height,
        buildingWidth,
        height,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        Paint()..color = Colors.white.withValues(alpha: 0.72),
      );

      for (var row = 0; row < 3; row++) {
        for (var col = 0; col < 2; col++) {
          final window = Rect.fromLTWH(
            rect.left + 6 + col * 13,
            rect.top + 8 + row * 13,
            6,
            7,
          );
          canvas.drawRect(
            window,
            Paint()..color = GameColors.blue.withValues(alpha: 0.25),
          );
        }
      }
    }

    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.18, size.width, size.height * 0.82),
      ground,
    );

    final waterRect = Rect.fromLTWH(
      size.width * 0.78,
      size.height * 0.18,
      size.width * 0.22,
      size.height * 0.30,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(waterRect, const Radius.circular(24)),
      water,
    );

    final horizontalRoad = Path()
      ..moveTo(-size.width * 0.03, size.height * 0.55)
      ..lineTo(size.width * 1.03, size.height * 0.42)
      ..lineTo(size.width * 1.03, size.height * 0.58)
      ..lineTo(-size.width * 0.03, size.height * 0.71)
      ..close();
    for (final path in [horizontalRoad]) {
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFC0BCAD)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.height * .055,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFF1E5CC)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.height * .042,
      );
    }
    canvas.drawPath(horizontalRoad, road);

    final diagonalRoad = Path()
      ..moveTo(size.width * 0.20, size.height * 0.22)
      ..lineTo(size.width * 0.28, size.height * 0.22)
      ..lineTo(size.width * 0.62, size.height)
      ..lineTo(size.width * 0.49, size.height)
      ..close();
    canvas.drawPath(
      diagonalRoad,
      Paint()
        ..color = const Color(0xFFF1E5CC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .024,
    );
    canvas.drawPath(diagonalRoad, road);

    final sideRoad = Path()
      ..moveTo(size.width * 0.68, size.height * 0.22)
      ..lineTo(size.width * 0.78, size.height * 0.30)
      ..lineTo(size.width * 0.46, size.height)
      ..lineTo(size.width * 0.34, size.height)
      ..close();
    canvas.drawPath(
      sideRoad,
      Paint()
        ..color = const Color(0xFFF1E5CC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .024,
    );
    canvas.drawPath(sideRoad, road);
    for (var i = 0; i < 18; i++) {
      final x = size.width * (i / 17);
      final y = size.height * (.63 - .13 * i / 17);
      canvas.drawLine(
        Offset(x, y),
        Offset(x + size.width * .022, y - size.height * .003),
        Paint()
          ..color = const Color(0xFFF6CE66)
          ..strokeWidth = size.height * .003,
      );
    }

    canvas.drawPath(
      horizontalRoad,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    _drawBlock(
      canvas,
      Rect.fromLTWH(
        size.width * 0.04,
        size.height * 0.25,
        size.width * 0.19,
        size.height * 0.21,
      ),
      const Color(0xFFFFC56D),
      const Color(0xFFD4741F),
    );

    _drawSchool(
      canvas,
      Offset(size.width * 0.46, size.height * 0.27),
      size.width * 0.24,
      size.height * 0.20,
    );

    _drawBlock(
      canvas,
      Rect.fromLTWH(
        size.width * 0.72,
        size.height * 0.57,
        size.width * 0.19,
        size.height * 0.16,
      ),
      const Color(0xFFF0D2A8),
      const Color(0xFFB77A3B),
    );

    _drawPlaza(
      canvas,
      Rect.fromLTWH(
        size.width * 0.70,
        size.height * 0.24,
        size.width * 0.19,
        size.height * 0.18,
      ),
    );

    for (final point in <Offset>[
      Offset(size.width * 0.08, size.height * 0.48),
      Offset(size.width * 0.18, size.height * 0.39),
      Offset(size.width * 0.24, size.height * 0.76),
      Offset(size.width * 0.65, size.height * 0.39),
      Offset(size.width * 0.82, size.height * 0.46),
      Offset(size.width * 0.92, size.height * 0.68),
      Offset(size.width * 0.12, size.height * 0.84),
    ]) {
      _drawTree(canvas, point, size.width * 0.016);
    }

    if (crosswalk) {
      final origin = Offset(size.width * 0.20, size.height * 0.61);
      for (var index = 0; index < 7; index++) {
        final stripe = Rect.fromCenter(
          center: Offset(
            origin.dx + index * size.width * 0.012,
            origin.dy - index * size.height * 0.002,
          ),
          width: size.width * 0.007,
          height: size.height * 0.08,
        );
        canvas.save();
        canvas.translate(stripe.center.dx, stripe.center.dy);
        canvas.rotate(-0.11);
        canvas.translate(-stripe.center.dx, -stripe.center.dy);
        canvas.drawRRect(
          RRect.fromRectAndRadius(stripe, const Radius.circular(2)),
          white,
        );
        canvas.restore();
      }
    }

    if (cyclePath) {
      final path = Path()
        ..moveTo(size.width * 0.05, size.height * 0.715)
        ..lineTo(size.width * 0.95, size.height * 0.605);
      canvas.drawPath(
        path,
        Paint()
          ..color = GameColors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.018
          ..strokeCap = StrokeCap.round,
      );
      _drawBikeSymbol(
        canvas,
        Offset(size.width * 0.48, size.height * 0.663),
        size.width * 0.012,
      );
    }

    if (lighting) {
      for (final point in <Offset>[
        Offset(size.width * 0.13, size.height * 0.57),
        Offset(size.width * 0.64, size.height * 0.50),
        Offset(size.width * 0.86, size.height * 0.57),
      ]) {
        _drawLamp(canvas, point, size.height * 0.11);
      }
    }

    if (showVehicles) {
      _drawBus(
        canvas,
        Offset(size.width * 0.39, size.height * 0.52),
        size.width * 0.10,
        size.height * 0.055,
      );
      _drawCar(
        canvas,
        Offset(size.width * 0.63, size.height * 0.55),
        size.width * 0.052,
        GameColors.red,
      );
      _drawCar(
        canvas,
        Offset(size.width * 0.78, size.height * 0.49),
        size.width * 0.045,
        GameColors.blue,
      );
    }

    if (showPeople) {
      for (final point in <Offset>[
        Offset(size.width * 0.30, size.height * 0.57),
        Offset(size.width * 0.34, size.height * 0.60),
        Offset(size.width * 0.57, size.height * 0.45),
        Offset(size.width * 0.75, size.height * 0.37),
        Offset(size.width * 0.84, size.height * 0.65),
      ]) {
        _drawPerson(canvas, point, size.height * 0.035);
      }
    }

    canvas.drawCircle(
      Offset(size.width * 0.96, size.height * 0.07),
      size.width * 0.018,
      Paint()..color = GameColors.yellow,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.035,
        size.height * 0.74,
        size.width * 0.17,
        size.height * 0.045,
      ),
      sidewalk,
    );

    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.34),
      size.width * 0.010,
      green,
    );
    canvas.drawCircle(
      Offset(size.width * 0.73, size.height * 0.34),
      size.width * 0.010,
      orange,
    );
    canvas.drawCircle(
      Offset(size.width * 0.74, size.height * 0.34),
      size.width * 0.010,
      navy,
    );
  }

  void _drawSchool(Canvas canvas, Offset center, double width, double height) {
    final rect = Rect.fromCenter(center: center, width: width, height: height);
    final depth = Offset(width * .12, -height * .16);
    final shadow = Rect.fromLTWH(
      rect.left + width * .04,
      rect.bottom - height * .10,
      width * 1.12,
      height * .25,
    );
    canvas.drawOval(shadow, Paint()..color = const Color(0x300B3042));
    canvas.drawRect(
      Rect.fromLTWH(
        rect.left - width * .10,
        rect.bottom,
        width * 1.24,
        height * .20,
      ),
      Paint()..color = const Color(0xFFECD4A9),
    );
    final side = Path()
      ..moveTo(rect.right, rect.top)
      ..lineTo(rect.right + depth.dx, rect.top + depth.dy)
      ..lineTo(rect.right + depth.dx, rect.bottom + depth.dy)
      ..lineTo(rect.right, rect.bottom)
      ..close();
    canvas.drawPath(side, Paint()..color = const Color(0xFFCF6B22));
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFC56A), Color(0xFFF5943D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );
    final roof = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.left + depth.dx, rect.top + depth.dy)
      ..lineTo(rect.right + depth.dx, rect.top + depth.dy)
      ..lineTo(rect.right, rect.top)
      ..close();
    canvas.drawPath(roof, Paint()..color = const Color(0xFFEC7431));
    canvas.drawPath(
      roof,
      Paint()
        ..color = const Color(0xFFFFE6A6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * .012,
    );
    for (var i = 0; i < 5; i++) {
      final x = rect.left + width * (.15 + i * .14);
      final panel = Path()
        ..moveTo(x, rect.top - height * .02)
        ..lineTo(x + depth.dx * .7, rect.top + depth.dy * .8)
        ..lineTo(x + width * .11 + depth.dx * .7, rect.top + depth.dy * .8)
        ..lineTo(x + width * .11, rect.top - height * .02)
        ..close();
      canvas.drawPath(panel, Paint()..color = const Color(0xFF284F75));
      canvas.drawPath(
        panel,
        Paint()
          ..color = const Color(0xFF90C8E3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * .004,
      );
    }
    for (var row = 0; row < 2; row++) {
      for (var col = 0; col < 4; col++) {
        final window = Rect.fromLTWH(
          rect.left + width * (.08 + col * .23),
          rect.top + height * (.30 + row * .27),
          width * .15,
          height * .18,
        );
        canvas.drawRect(
          window.inflate(width * .01),
          Paint()..color = const Color(0xFFFFEDC7),
        );
        canvas.drawRect(
          window,
          Paint()
            ..shader = const LinearGradient(
              colors: [Color(0xFF23567A), Color(0xFF7AC5E4)],
            ).createShader(window),
        );
        canvas.drawLine(
          window.topCenter,
          window.bottomCenter,
          Paint()
            ..color = const Color(0xFFD7EDF5)
            ..strokeWidth = width * .006,
        );
      }
    }
    final door = Rect.fromLTWH(
      rect.left + width * .43,
      rect.bottom - height * .27,
      width * .16,
      height * .27,
    );
    canvas.drawRect(
      door.inflate(width * .015),
      Paint()..color = const Color(0xFFFFE7AE),
    );
    canvas.drawRect(door, Paint()..color = const Color(0xFF224B6A));
    final signRect = Rect.fromLTWH(
      rect.left + width * .22,
      rect.top + height * .07,
      width * .57,
      height * .17,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(signRect, Radius.circular(width * .018)),
      Paint()..color = GameColors.blue,
    );
    final painter = TextPainter(
      text: TextSpan(
        text: 'ESCOLA',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: width * .065,
          fontFamily: 'Roboto',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      signRect.center - Offset(painter.width / 2, painter.height / 2),
    );
    painter.dispose();
    final fenceY = rect.bottom + height * .16;
    for (var i = 0; i < 20; i++) {
      if (i > 8 && i < 12) continue;
      final x = rect.left - width * .08 + i * width * .062;
      canvas.drawLine(
        Offset(x, fenceY),
        Offset(x, fenceY - height * .12),
        Paint()
          ..color = const Color(0xFF1C6A98)
          ..strokeWidth = width * .009,
      );
    }
    canvas.drawLine(
      Offset(rect.left - width * .08, fenceY - height * .10),
      Offset(rect.right + width * .10, fenceY - height * .10),
      Paint()
        ..color = const Color(0xFF1C6A98)
        ..strokeWidth = width * .009,
    );
  }

  void _drawBlock(Canvas canvas, Rect rect, Color wall, Color roof) {
    canvas.drawOval(
      Rect.fromLTWH(
        rect.left + rect.width * .08,
        rect.bottom - rect.height * .05,
        rect.width * 1.10,
        rect.height * .16,
      ),
      Paint()..color = const Color(0x240B3042),
    );
    final side = Path()
      ..moveTo(rect.right, rect.top)
      ..lineTo(rect.right + rect.width * .12, rect.top - rect.height * .10)
      ..lineTo(rect.right + rect.width * .12, rect.bottom - rect.height * .10)
      ..lineTo(rect.right, rect.bottom)
      ..close();
    canvas.drawPath(side, Paint()..color = roof);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      Paint()..color = wall,
    );

    final roofPath = Path()
      ..moveTo(rect.left - 5, rect.top + 4)
      ..lineTo(rect.center.dx, rect.top - rect.height * 0.18)
      ..lineTo(rect.right + 5, rect.top + 4)
      ..close();

    canvas.drawPath(roofPath, Paint()..color = roof);

    for (var index = 0; index < 3; index++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            rect.left + 8 + index * rect.width * 0.27,
            rect.top + rect.height * 0.32,
            rect.width * 0.16,
            rect.height * 0.22,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = const Color(0xFF88C4EA),
      );
    }
  }

  void _drawPlaza(Canvas canvas, Rect rect) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(14)),
      Paint()..color = const Color(0xFFB7E58B),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: rect.center,
        width: rect.width * 0.60,
        height: rect.height * 0.42,
      ),
      Paint()..color = const Color(0xFFE3D7B6),
    );

    for (final alignment in <Alignment>[
      const Alignment(-0.75, -0.55),
      const Alignment(0.70, -0.42),
      const Alignment(-0.55, 0.55),
      const Alignment(0.65, 0.55),
    ]) {
      _drawTree(
        canvas,
        Offset(
          rect.center.dx + alignment.x * rect.width * 0.42,
          rect.center.dy + alignment.y * rect.height * 0.42,
        ),
        rect.width * 0.08,
      );
    }
  }

  void _drawTree(Canvas canvas, Offset center, double radius) {
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(radius * .6, radius * 1.6),
        width: radius * 2.7,
        height: radius * .7,
      ),
      Paint()..color = const Color(0x230B3042),
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 1.1),
        width: radius * 0.36,
        height: radius * 1.6,
      ),
      Paint()..color = const Color(0xFF8D5A2A),
    );
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF2E8B3C));
    canvas.drawCircle(
      Offset(center.dx - radius * 0.55, center.dy + radius * 0.10),
      radius * 0.65,
      Paint()..color = const Color(0xFF43A64C),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.55, center.dy + radius * 0.12),
      radius * 0.62,
      Paint()..color = const Color(0xFF3B9A45),
    );
  }

  void _drawBus(Canvas canvas, Offset center, double width, double height) {
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(width * .08, height * .65),
        width: width * 1.2,
        height: height * .55,
      ),
      Paint()..color = const Color(0x400B3042),
    );
    final rect = Rect.fromCenter(center: center, width: width, height: height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(7)),
      Paint()..color = GameColors.yellow,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          rect.left + width * 0.08,
          rect.top + height * 0.14,
          width * 0.70,
          height * 0.32,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF4E88A7),
    );
    canvas.drawCircle(
      Offset(rect.left + width * 0.22, rect.bottom),
      height * 0.18,
      Paint()..color = Colors.black87,
    );
    canvas.drawCircle(
      Offset(rect.right - width * 0.20, rect.bottom),
      height * 0.18,
      Paint()..color = Colors.black87,
    );
  }

  void _drawCar(Canvas canvas, Offset center, double width, Color color) {
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(width * .08, width * .23),
        width: width * 1.2,
        height: width * .24,
      ),
      Paint()..color = const Color(0x300B3042),
    );
    final height = width * 0.42;
    final rect = Rect.fromCenter(center: center, width: width, height: height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(5)),
      Paint()..color = color,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          rect.left + width * 0.18,
          rect.top - height * 0.18,
          width * 0.52,
          height * 0.44,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = color,
    );
  }

  void _drawPerson(Canvas canvas, Offset center, double size) {
    canvas.drawCircle(
      Offset(center.dx, center.dy - size * 0.38),
      size * 0.19,
      Paint()..color = const Color(0xFFD99465),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: size * 0.36,
          height: size * 0.52,
        ),
        Radius.circular(size * 0.12),
      ),
      Paint()..color = GameColors.blue,
    );
  }

  void _drawLamp(Canvas canvas, Offset base, double height) {
    canvas.drawRect(
      Rect.fromLTWH(base.dx - 2, base.dy - height, 4, height),
      Paint()..color = GameColors.navy,
    );
    canvas.drawCircle(
      Offset(base.dx, base.dy - height),
      height * 0.10,
      Paint()..color = GameColors.yellow,
    );
    canvas.drawCircle(
      Offset(base.dx, base.dy - height),
      height * 0.18,
      Paint()..color = GameColors.yellow.withValues(alpha: 0.20),
    );
  }

  void _drawBikeSymbol(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, radius * 0.12);

    canvas.drawCircle(Offset(center.dx - radius, center.dy), radius, paint);
    canvas.drawCircle(Offset(center.dx + radius, center.dy), radius, paint);
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx, center.dy - radius * 0.8),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius * 0.8),
      Offset(center.dx + radius, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius * 0.15, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _Zone1NeighborhoodPainter oldDelegate) {
    return oldDelegate.crosswalk != crosswalk ||
        oldDelegate.lighting != lighting ||
        oldDelegate.cyclePath != cyclePath ||
        oldDelegate.showVehicles != showVehicles ||
        oldDelegate.showPeople != showPeople;
  }
}

class _MeloPainter extends CustomPainter {
  const _MeloPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 200, size.height / 300);
    Paint color(Color c) => Paint()..color = c;
    void rounded(Rect rect, double radius, Color c) => canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      color(c),
    );
    void line(Offset a, Offset b, Color c, double width) => canvas.drawLine(
      a,
      b,
      Paint()
        ..color = c
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
    const dark = Color(0xFF1D2935);
    const skin = Color(0xFFEAA875);
    const yellow = Color(0xFFFFD83D);
    canvas.drawOval(
      const Rect.fromLTWH(38, 281, 125, 14),
      color(const Color(0x280B3042)),
    );
    rounded(const Rect.fromLTWH(58, 238, 36, 48), 9, dark);
    rounded(const Rect.fromLTWH(105, 238, 36, 48), 9, dark);
    rounded(const Rect.fromLTWH(51, 274, 44, 17), 7, const Color(0xFF111C27));
    rounded(const Rect.fromLTWH(105, 274, 45, 17), 7, const Color(0xFF111C27));
    line(
      const Offset(59, 282),
      const Offset(84, 282),
      const Color(0xFF657281),
      2,
    );
    line(
      const Offset(113, 282),
      const Offset(140, 282),
      const Color(0xFF657281),
      2,
    );
    // Friendly raised arm and a hand with a distinct thumb.
    line(const Offset(149, 170), const Offset(170, 193), dark, 24);
    line(const Offset(170, 193), const Offset(176, 139), dark, 22);
    rounded(const Rect.fromLTWH(162, 117, 29, 30), 11, skin);
    rounded(const Rect.fromLTWH(166, 101, 10, 28), 5, skin);
    line(
      const Offset(176, 140),
      const Offset(184, 138),
      const Color(0xFFBF784E),
      1.6,
    );
    line(const Offset(168, 190), const Offset(171, 164), yellow, 8);
    line(const Offset(48, 173), const Offset(32, 207), dark, 24);
    rounded(const Rect.fromLTWH(22, 205, 22, 29), 9, skin);
    // Jacket: shaded body, shoulder seams, reflective bands, radio and belt.
    final jacket = const Rect.fromLTWH(47, 147, 108, 102);
    canvas.drawRRect(
      RRect.fromRectAndRadius(jacket, const Radius.circular(22)),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF374957), dark, Color(0xFF172330)],
        ).createShader(jacket),
    );
    final leftBand = Path()
      ..moveTo(53, 164)
      ..lineTo(73, 164)
      ..lineTo(94, 212)
      ..lineTo(82, 216)
      ..close();
    final rightBand = Path()
      ..moveTo(129, 164)
      ..lineTo(148, 164)
      ..lineTo(119, 217)
      ..lineTo(107, 210)
      ..close();
    canvas.drawPath(leftBand, color(yellow));
    canvas.drawPath(rightBand, color(yellow));
    rounded(const Rect.fromLTWH(48, 214, 105, 13), 2, yellow);
    line(
      const Offset(100, 168),
      const Offset(100, 239),
      const Color(0xFF6F8290),
      2,
    );
    line(const Offset(59, 181), const Offset(76, 214), Colors.white, 3);
    line(const Offset(140, 181), const Offset(122, 214), Colors.white, 3);
    rounded(const Rect.fromLTWH(56, 177, 18, 30), 4, const Color(0xFF10202C));
    line(const Offset(60, 177), const Offset(60, 162), dark, 3);
    for (var i = 0; i < 3; i++) {
      line(
        Offset(60, 184 + i * 5),
        Offset(70, 184 + i * 5),
        const Color(0xFF61788D),
        1.5,
      );
    }
    rounded(const Rect.fromLTWH(118, 184, 26, 15), 2, const Color(0xFF10202C));
    final badge = Path()
      ..moveTo(81, 179)
      ..lineTo(94, 179)
      ..lineTo(94, 190)
      ..lineTo(88, 196)
      ..lineTo(81, 190)
      ..close();
    canvas.drawPath(badge, color(yellow));
    rounded(const Rect.fromLTWH(45, 236, 112, 13), 3, const Color(0xFF101D27));
    rounded(const Rect.fromLTWH(90, 237, 19, 12), 2, const Color(0xFFBFC8CB));
    rounded(const Rect.fromLTWH(94, 240, 11, 6), 1, dark);
    rounded(const Rect.fromLTWH(53, 230, 19, 24), 3, const Color(0xFF10202C));
    rounded(const Rect.fromLTWH(133, 228, 17, 27), 4, const Color(0xFF10202C));
    // Neck, ears, face and cap retain adult mentor proportions.
    rounded(const Rect.fromLTWH(85, 132, 31, 31), 9, skin);
    canvas.drawOval(
      const Rect.fromLTWH(80, 151, 41, 16),
      color(const Color(0xFF111C27)),
    );
    canvas.drawOval(const Rect.fromLTWH(48, 84, 21, 34), color(skin));
    canvas.drawOval(const Rect.fromLTWH(134, 84, 21, 34), color(skin));
    final face = const Rect.fromLTWH(58, 43, 86, 107);
    canvas.drawOval(
      face,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFD3A3), skin, Color(0xFFD78C60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(face),
    );
    line(
      const Offset(70, 84),
      const Offset(86, 82),
      const Color(0xFF5C3527),
      4,
    );
    line(
      const Offset(114, 82),
      const Offset(130, 84),
      const Color(0xFF5C3527),
      4,
    );
    for (final x in [80.0, 120.0]) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, 97), width: 20, height: 23),
        color(Colors.white),
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x + 1, 99), width: 10, height: 15),
        color(const Color(0xFF573728)),
      );
      canvas.drawCircle(
        Offset(x + 2, 100),
        3.5,
        color(const Color(0xFF17232D)),
      );
      canvas.drawCircle(Offset(x - 1, 96), 2, color(Colors.white));
    }
    line(
      const Offset(98, 104),
      const Offset(94, 115),
      const Color(0xFFCD895B),
      2,
    );
    canvas.drawOval(
      const Rect.fromLTWH(68, 113, 15, 7),
      color(const Color(0x30C16A53)),
    );
    canvas.drawOval(
      const Rect.fromLTWH(120, 113, 15, 7),
      color(const Color(0x30C16A53)),
    );
    final smile = Path()
      ..moveTo(83, 122)
      ..quadraticBezierTo(101, 137, 120, 121)
      ..quadraticBezierTo(102, 145, 83, 122)
      ..close();
    canvas.drawPath(smile, color(const Color(0xFF6A392D)));
    final teeth = Path()
      ..moveTo(86, 124)
      ..quadraticBezierTo(101, 133, 117, 124)
      ..lineTo(114, 129)
      ..quadraticBezierTo(101, 136, 89, 129)
      ..close();
    canvas.drawPath(teeth, color(Colors.white));
    canvas.drawOval(const Rect.fromLTWH(52, 28, 97, 47), color(dark));
    canvas.drawOval(
      const Rect.fromLTWH(61, 25, 79, 43),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF3A5164), dark],
        ).createShader(const Rect.fromLTWH(61, 25, 79, 43)),
    );
    canvas.drawArc(
      const Rect.fromLTWH(58, 39, 86, 31),
      0,
      math.pi,
      false,
      Paint()
        ..color = yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    rounded(const Rect.fromLTWH(67, 65, 95, 12), 6, const Color(0xFF152737));
    final capBadge = Path()
      ..moveTo(91, 36)
      ..lineTo(112, 36)
      ..lineTo(112, 47)
      ..lineTo(101, 55)
      ..lineTo(91, 47)
      ..close();
    canvas.drawPath(capBadge, color(yellow));
    canvas.drawCircle(const Offset(101, 44), 4, color(GameColors.blue));
    _label(canvas, 'AMC', const Offset(101, 60), 7, Colors.white);
    _label(canvas, 'AGENTE', const Offset(131, 192), 5, Colors.white);
    canvas.restore();
  }

  void _label(
    Canvas canvas,
    String text,
    Offset center,
    double fontSize,
    Color color,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
    painter.dispose();
  }

  @override
  bool shouldRepaint(covariant _MeloPainter oldDelegate) => false;
}

/// Presentation-only infrastructure layers use the three purchased upgrade flags.
/// Image and overlays share this fixed world, so cropping never misaligns them.
class Zone1IllustratedUpgradePainter extends CustomPainter {
  const Zone1IllustratedUpgradePainter({
    required this.crosswalk,
    required this.lighting,
    required this.cyclePath,
    this.nightPreview = false,
  });
  final bool crosswalk;
  final bool lighting;
  final bool cyclePath;
  final bool nightPreview;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 1536, size.height / 1024);
    if (cyclePath) _drawCycleLane(canvas);
    if (crosswalk) _drawSafeCrosswalk(canvas);
    if (lighting) {
      _drawSchoolLamp(canvas, const Offset(847, 437), 148);
      _drawSchoolLamp(canvas, const Offset(1055, 662), 152);
      _drawSchoolLamp(canvas, const Offset(1336, 843), 164);
    }
    canvas.restore();
  }

  void _drawSafeCrosswalk(Canvas canvas) {
    canvas.save();
    // The cycle lane keeps its own space: crossings stop before its outer edge.
    final cyclePoints = <Offset>[
      const Offset(566, 689),
      const Offset(737, 768),
      const Offset(963, 876),
      const Offset(1249, 1014),
    ];
    var cycleCorridor = Path();
    for (final point in cyclePoints) {
      cycleCorridor = Path.combine(
        PathOperation.union,
        cycleCorridor,
        Path()..addOval(Rect.fromCircle(center: point, radius: 20)),
      );
    }
    for (var i = 1; i < cyclePoints.length; i++) {
      final a = cyclePoints[i - 1];
      final b = cyclePoints[i];
      final direction = b - a;
      final normal =
          Offset(-direction.dy, direction.dx) * (20 / direction.distance);
      final segment = Path()
        ..moveTo((a + normal).dx, (a + normal).dy)
        ..lineTo((b + normal).dx, (b + normal).dy)
        ..lineTo((b - normal).dx, (b - normal).dy)
        ..lineTo((a - normal).dx, (a - normal).dy)
        ..close();
      cycleCorridor = Path.combine(PathOperation.union, cycleCorridor, segment);
    }
    canvas.clipPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(const Rect.fromLTWH(0, 0, 1536, 1024)),
        cycleCorridor,
      ),
    );
    // Three crossings at the mouths of the streets, purchased as one upgrade.
    _drawCornerCrossing(
      canvas,
      const Offset(400, 651),
      const Offset(68, -26),
      const Offset(159, 68),
    );
    _drawCornerCrossing(
      canvas,
      const Offset(592, 713),
      const Offset(72, 34),
      const Offset(-128, 54),
    );
    // Lateral crossing removed: the flattened tree canopy cannot occlude it.
    canvas.restore();
  }

  void _drawCornerCrossing(
    Canvas canvas,
    Offset origin,
    Offset travel,
    Offset across,
  ) {
    for (var index = 0; index < 8; index++) {
      final start = origin + across * (index / 8);
      final width = across * .072;
      final stripe = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(start.dx + travel.dx, start.dy + travel.dy)
        ..lineTo(
          start.dx + travel.dx + width.dx,
          start.dy + travel.dy + width.dy,
        )
        ..lineTo(start.dx + width.dx, start.dy + width.dy)
        ..close();
      canvas.drawPath(
        stripe.shift(const Offset(0, 1.5)),
        Paint()..color = const Color(0x450A2737),
      );
      canvas.drawPath(stripe, Paint()..color = const Color(0xFFF6FAFC));
    }
  }

  void _drawCycleLane(Canvas canvas) {
    final lane = Path()
      ..moveTo(566, 689)
      ..lineTo(737, 768)
      ..lineTo(963, 876)
      ..lineTo(1249, 1014);
    canvas.drawPath(
      lane,
      Paint()
        ..color = const Color(0xFF9F272D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 31
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      lane,
      Paint()
        ..color = const Color(0xFFEA4548)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 25
        ..strokeCap = StrokeCap.round,
    );
    final separator = Path()
      ..moveTo(562, 673)
      ..lineTo(733, 752)
      ..lineTo(959, 860)
      ..lineTo(1245, 998);
    canvas.drawPath(
      separator,
      Paint()
        ..color = const Color(0xFFFBE7AB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    for (final point in [
      const Offset(716, 758),
      const Offset(951, 870),
      const Offset(1180, 980),
    ]) {
      _drawLaneBike(canvas, point);
    }
  }

  void _drawLaneBike(Canvas canvas, Offset center) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(.445);
    canvas.scale(1, .58);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(const Offset(-10, 1), 7, paint);
    canvas.drawCircle(const Offset(10, 1), 7, paint);
    final frame = Path()
      ..moveTo(-10, 1)
      ..lineTo(-3, -10)
      ..lineTo(4, 1)
      ..lineTo(-10, 1)
      ..moveTo(-3, -10)
      ..lineTo(6, -10)
      ..lineTo(10, 1)
      ..moveTo(6, -10)
      ..lineTo(4, -15)
      ..lineTo(10, -15);
    canvas.drawPath(frame, paint);
    canvas.restore();
  }

  void _drawSchoolLamp(Canvas canvas, Offset base, double height) {
    if (nightPreview) {
      final pool = Rect.fromCenter(
        center: base + const Offset(24, 8),
        width: 220,
        height: 104,
      );
      canvas.drawOval(
        pool,
        Paint()
          ..blendMode = BlendMode.screen
          ..shader = const RadialGradient(
            colors: [Color(0xDEFFD98A), Color(0x66FFD98A), Color(0x00FFD98A)],
            stops: [0, .5, 1],
          ).createShader(pool),
      );
      final cone = Path()
        ..moveTo(base.dx + 34, base.dy - height)
        ..lineTo(base.dx + 111, base.dy + 12)
        ..quadraticBezierTo(
          base.dx + 25,
          base.dy + 36,
          base.dx - 48,
          base.dy + 8,
        )
        ..close();
      canvas.drawPath(
        cone,
        Paint()
          ..shader =
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0x00FFDE90), const Color(0x35FFDE90)],
              ).createShader(
                Rect.fromLTWH(base.dx - 48, base.dy - height, 160, height + 40),
              ),
      );
    }
    canvas.drawOval(
      Rect.fromCenter(center: base + const Offset(12, 3), width: 38, height: 9),
      Paint()..color = const Color(0x38092838),
    );
    final pole = Rect.fromLTWH(base.dx - 4, base.dy - height, 8, height);
    canvas.drawRect(
      pole,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF23384A), Color(0xFFC4D4DC), Color(0xFF31485A)],
        ).createShader(pole),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(base.dx - 7, base.dy - 13, 14, 15),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF334B5D),
    );
    final arm = Path()
      ..moveTo(base.dx, base.dy - height)
      ..quadraticBezierTo(
        base.dx + 9,
        base.dy - height - 14,
        base.dx + 38,
        base.dy - height - 12,
      );
    canvas.drawPath(
      arm,
      Paint()
        ..color = const Color(0xFF31495C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    final light = Offset(base.dx + 38, base.dy - height - 8);
    canvas.drawOval(
      Rect.fromCenter(
        center: light,
        width: nightPreview ? 108 : 52,
        height: nightPreview ? 72 : 34,
      ),
      Paint()
        ..shader =
            const RadialGradient(
              colors: [Color(0xB8FFE9AC), Color(0x00FFD970)],
            ).createShader(
              Rect.fromCircle(center: light, radius: nightPreview ? 56 : 27),
            ),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: light, width: 36, height: 10),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF23394E),
    );
    canvas.drawOval(
      Rect.fromCenter(center: light + const Offset(0, 4), width: 30, height: 5),
      Paint()..color = const Color(0xFFFFF2BD),
    );
  }

  @override
  bool shouldRepaint(covariant Zone1IllustratedUpgradePainter oldDelegate) =>
      oldDelegate.crosswalk != crosswalk ||
      oldDelegate.lighting != lighting ||
      oldDelegate.cyclePath != cyclePath ||
      oldDelegate.nightPreview != nightPreview;
}
