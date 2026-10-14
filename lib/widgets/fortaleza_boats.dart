import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Decorative sea layer in the approved 1672 x 941 composition.
class FortalezaBoats extends StatefulWidget {
  const FortalezaBoats({super.key});

  static const bounds = Rect.fromLTWH(1100, 100, 572, 500);

  @override
  State<FortalezaBoats> createState() => _FortalezaBoatsState();
}

class _FortalezaBoatsState extends State<FortalezaBoats>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _clock;
  bool _foreground = true;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(seconds: FortalezaBoatsPainter.cycleSeconds),
      animationBehavior: AnimationBehavior.preserve,
    );
    _foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  void _syncMotion() {
    final enabled =
        _foreground &&
        TickerMode.valuesOf(context).enabled &&
        !MediaQuery.disableAnimationsOf(context);
    if (enabled && !_clock.isAnimating) {
      _clock.repeat();
    } else if (!enabled && _clock.isAnimating) {
      _clock.stop(canceled: false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _syncMotion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ExcludeSemantics(
      child: RepaintBoundary(
        key: const Key('fortaleza-boats-layer'),
        child: CustomPaint(
          key: const Key('fortaleza-boats-paint'),
          painter: FortalezaBoatsPainter(_clock),
          child: const SizedBox.expand(),
        ),
      ),
    ),
  );
}

class FortalezaBoatRoute {
  const FortalezaBoatRoute({
    required this.centerX,
    required this.radiusX,
    required this.y,
    required this.radiusY,
    required this.slope,
    required this.scale,
    required this.period,
    required this.offset,
  });

  final double centerX;
  final double radiusX;
  final double y;
  final double radiusY;
  final double slope;
  final double scale;
  final double period;
  final double offset;

  double phase(double seconds) =>
      ((seconds + offset) % period) / period * math.pi * 2;

  Offset position(double seconds) {
    final angle = phase(seconds);
    final x = centerX - radiusX * math.cos(angle);
    return Offset(x, y + slope * (x - centerX) - radiusY * math.sin(angle));
  }
}

class FortalezaBoatsPainter extends CustomPainter {
  FortalezaBoatsPainter(this.clock) : super(repaint: clock);

  final Animation<double> clock;
  // Common multiple of the three periods: the clock wraps without a jump.
  static const cycleSeconds = 11400;
  static const routes = [
    FortalezaBoatRoute(
      centerX: 1490,
      radiusX: 158,
      y: 139,
      radiusY: 4,
      slope: 0,
      scale: .48,
      period: 190,
      offset: 22,
    ),
    FortalezaBoatRoute(
      centerX: 1517,
      radiusX: 127,
      y: 207,
      radiusY: 5,
      slope: 0,
      scale: .8,
      period: 150,
      offset: 0,
    ),
    FortalezaBoatRoute(
      centerX: 1345,
      radiusX: 65,
      y: 456,
      radiusY: 4,
      slope: .25,
      scale: .92,
      period: 120,
      offset: 39,
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.scale(size.width / 572, size.height / 500);
    canvas.translate(-1100, -100);
    final seconds = 68 + clock.value * cycleSeconds;
    for (final route in routes) {
      _paintBoat(canvas, route, seconds);
    }
    canvas.restore();
  }

  void _paintBoat(Canvas canvas, FortalezaBoatRoute route, double seconds) {
    final position = route.position(seconds);
    final sine = math.sin(route.phase(seconds));
    final exp = math.exp(2 * sine * 18);
    final direction = (exp - 1) / (exp + 1);
    final heading = direction.abs() < .18
        ? (direction < 0 ? -.18 : .18)
        : direction;
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.scale(heading * route.scale, route.scale);
    final stroke = Paint()
      ..color = const Color(0x80DDFBFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    for (var i = 0.0; i < 3; i++) {
      canvas.drawPath(
        Path()
          ..moveTo(-10 - i * 7, 12 - i * 1.3)
          ..quadraticBezierTo(-27 - i * 6, 15, -44 - i * 6, 12 + i * 2),
        stroke,
      );
    }
    canvas.translate(0, math.sin(seconds * 1.2) * .65);
    canvas.rotate(math.sin(seconds * .9) * .018);
    canvas.drawOval(
      const Rect.fromLTWH(-23, 12, 46, 6),
      Paint()..color = const Color(0x3D00496E),
    );
    final sail = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFF9E2), Colors.white, Color(0xFFB5DEEB)],
        stops: [0, .65, 1],
      ).createShader(const Rect.fromLTWH(-13, -33, 26, 41));
    stroke
      ..color = const Color(0xFF427386)
      ..strokeWidth = .7;
    final leftSail = Path()
      ..moveTo(-1, -34)
      ..quadraticBezierTo(-7, -10, -19, 5)
      ..lineTo(-1, 4)
      ..close();
    final rightSail = Path()
      ..moveTo(2, -28)
      ..quadraticBezierTo(10, -9, 17, 3)
      ..lineTo(2, 3)
      ..close();
    for (final path in [leftSail, rightSail]) {
      canvas.drawPath(path, sail);
      canvas.drawPath(path, stroke);
    }
    canvas.drawLine(
      const Offset(0, -35),
      const Offset(0, 10),
      stroke
        ..color = const Color(0xFFF9F1D4)
        ..strokeWidth = 1.5,
    );
    canvas.drawPath(
      Path()
        ..moveTo(-22, 8)
        ..lineTo(23, 7)
        ..lineTo(15, 15)
        ..lineTo(-13, 16)
        ..close(),
      Paint()..color = const Color(0xFFEF7842),
    );
    canvas.drawLine(
      const Offset(-22, 8),
      const Offset(23, 7),
      stroke
        ..color = const Color(0xFFFFF6E6)
        ..strokeWidth = 2,
    );
    canvas.drawRect(
      const Rect.fromLTWH(-8, 5, 13, 3),
      Paint()..color = const Color(0xFF17546C),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(FortalezaBoatsPainter oldDelegate) =>
      oldDelegate.clock != clock;
}
