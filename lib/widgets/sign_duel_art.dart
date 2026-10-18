import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'zone_1_approved_art.dart';

const duelArtwork = 'assets/sign_duel/r42/duelo_base.png';
const duelInk = Color(0xFF061C54);

class DuelPanel extends StatelessWidget {
  const DuelPanel({super.key, required this.child, this.color = Colors.white});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFF13BDF0), width: 2),
    ),
    child: Padding(padding: const EdgeInsets.all(10), child: child),
  );
}

class DuelButton extends StatelessWidget {
  const DuelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.prefix,
    this.icon,
    this.selected = false,
    this.light = false,
    this.green = false,
    this.fontSize = 34,
  });
  final String label;
  final VoidCallback? onPressed;
  final String? prefix;
  final IconData? icon;
  final bool selected;
  final bool light;
  final bool green;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final colors = light
        ? const [Colors.white, Color(0xFFEAF5FF)]
        : green
        ? const [Color(0xFF26DB32), Color(0xFF009C12)]
        : const [Color(0xFF029EFF), Color(0xFF0057B8)];
    return Semantics(
      button: true,
      selected: selected,
      enabled: onPressed != null,
      label: label,
      onTap: onPressed,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(38),
            border: Border.all(
              color: selected
                  ? const Color(0xFF00ECFF)
                  : green
                  ? const Color(0xFF009519)
                  : const Color(0xFF0089DF),
              width: selected ? 5 : 3,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0xAA00E5FF),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(38),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                children: [
                  if (icon != null)
                    Expanded(child: Icon(icon, size: 65, color: Colors.white)),
                  if (prefix != null) ...[
                    Container(
                      width: 54,
                      height: 54,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0057B8),
                        shape: BoxShape.circle,
                      ),
                      child: Zone1ArtText(prefix!, fontSize: 34, maxLines: 1),
                    ),
                    const SizedBox(width: 14),
                  ],
                  if (icon == null)
                    Expanded(
                      child: Zone1ArtText(
                        label,
                        fontSize: fontSize,
                        color: light ? duelInk : Colors.white,
                        maxLines: prefix == null ? 1 : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Native vector artwork: no answer is baked into the scene background.
/// R-19 deliberately displays 40, matching the existing question catalogue.
class DuelSign extends StatelessWidget {
  const DuelSign({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: 'Placa $code',
    child: CustomPaint(
      painter: _SignPainter(code),
      child: const SizedBox.expand(),
    ),
  );
}

class _SignPainter extends CustomPainter {
  const _SignPainter(this.code);
  final String code;
  static const red = Color(0xFFD91620);
  static const yellow = Color(0xFFFFD428);

  Path _polygon(int sides, double radius, {double angle = -math.pi / 2}) {
    final path = Path();
    for (var i = 0; i < sides; i++) {
      final a = angle + i * 2 * math.pi / sides;
      final x = 180 + radius * math.cos(a);
      final y = 180 + radius * math.sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path..close();
  }

  void _label(
    Canvas canvas,
    String text,
    double size,
    Color color,
    double top,
  ) {
    final p = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: FontWeight.w900,
          fontFamily: 'Arial',
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 350);
    p.paint(canvas, Offset((360 - p.width) / 2, top));
    p.dispose();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 360, size.height / 360);
    final paint = Paint()..isAntiAlias = true;
    if (code == 'R-1') {
      final outline = _polygon(8, 173, angle: math.pi / 8);
      canvas.drawShadow(outline, Colors.black54, 5, true);
      canvas.drawPath(outline, paint..color = red);
      canvas.drawPath(
        _polygon(8, 160, angle: math.pi / 8),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7,
      );
      _label(canvas, 'PARE', 87, Colors.white, 131);
    } else if (code == 'R-2') {
      final triangle = Path()
        ..moveTo(10, 30)
        ..lineTo(350, 30)
        ..lineTo(180, 335)
        ..close();
      canvas.drawShadow(triangle, Colors.black54, 5, true);
      canvas.drawPath(triangle, paint..color = red);
      canvas.drawPath(
        Path()
          ..moveTo(58, 58)
          ..lineTo(302, 58)
          ..lineTo(180, 278)
          ..close(),
        paint..color = Colors.white,
      );
    } else if (code == 'R-6a' || code == 'R-19') {
      canvas.drawShadow(
        Path()..addOval(const Rect.fromLTWH(6, 6, 348, 348)),
        Colors.black54,
        5,
        true,
      );
      canvas.drawCircle(const Offset(180, 180), 174, paint..color = red);
      canvas.drawCircle(
        const Offset(180, 180),
        146,
        paint..color = Colors.white,
      );
      if (code == 'R-19') {
        _label(canvas, '40', 158, Colors.black, 72);
        _label(canvas, 'km/h', 39, Colors.black, 244);
      } else {
        _label(canvas, 'E', 220, Colors.black, 67);
        canvas.drawLine(
          const Offset(76, 76),
          const Offset(284, 284),
          Paint()
            ..color = red
            ..strokeWidth = 28,
        );
      }
    } else {
      final diamond = _polygon(4, 174);
      canvas.drawShadow(diamond, Colors.black54, 5, true);
      canvas.drawPath(diamond, paint..color = yellow);
      canvas.drawPath(
        _polygon(4, 161),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7,
      );
      if (code == 'A-18') {
        canvas.drawPath(
          Path()
            ..moveTo(74, 227)
            ..lineTo(103, 227)
            ..cubicTo(133, 227, 134, 169, 180, 169)
            ..cubicTo(226, 169, 227, 227, 257, 227)
            ..lineTo(286, 227)
            ..lineTo(286, 240)
            ..lineTo(74, 240)
            ..close(),
          paint..color = Colors.black,
        );
      } else {
        // Pedestrian above a marked crossing (A-32b).
        paint.color = Colors.black;
        canvas.drawCircle(const Offset(194, 99), 17, paint);
        final stroke = Paint()
          ..color = Colors.black
          ..strokeWidth = 19
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;
        canvas.drawPath(
          Path()
            ..moveTo(188, 124)
            ..lineTo(169, 171)
            ..lineTo(199, 197)
            ..lineTo(216, 230),
          stroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(174, 166)
            ..lineTo(154, 205)
            ..lineTo(133, 230),
          stroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(187, 130)
            ..lineTo(214, 158)
            ..lineTo(237, 165),
          stroke..strokeWidth = 13,
        );
        canvas.drawPath(
          Path()
            ..moveTo(183, 130)
            ..lineTo(154, 145)
            ..lineTo(137, 166),
          stroke,
        );
        for (var i = 0; i < 4; i++) {
          final x = 107.0 + i * 36;
          canvas.drawPath(
            Path()
              ..moveTo(x, 247)
              ..lineTo(x + 23, 247)
              ..lineTo(x + 12, 267)
              ..lineTo(x - 11, 267)
              ..close(),
            paint,
          );
        }
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SignPainter oldDelegate) => oldDelegate.code != code;
}
