import 'package:flutter/material.dart';

class GameColors {
  GameColors._();

  static const navy = Color(0xFF102A43);
  static const blue = Color(0xFF1565C0);
  static const sky = Color(0xFF3FA9F5);
  static const cyan = Color(0xFF4DD0E1);
  static const green = Color(0xFF2E7D32);
  static const lime = Color(0xFF9CCC65);
  static const yellow = Color(0xFFFFC107);
  static const orange = Color(0xFFF57C00);
  static const red = Color(0xFFD32F2F);
  static const purple = Color(0xFF6A5ACD);
  static const sand = Color(0xFFFFF3D6);
  static const cloud = Color(0xFFF5F9FF);
  static const white = Color(0xFFFFFFFF);
  static const ink = Color(0xFF17324D);
}

class GameVisual {
  GameVisual._();

  static const double pageMaxWidth = 1120;
  static const double contentMaxWidth = 760;
  static const double radiusSmall = 14;
  static const double radiusMedium = 20;
  static const double radiusLarge = 28;

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x1A102A43), blurRadius: 24, offset: Offset(0, 10)),
  ];
}

class GameBackground extends StatelessWidget {
  const GameBackground({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEAF6FF), Color(0xFFF8FBFF), Color(0xFFFFF8E8)],
        ),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class GameHeroPanel extends StatelessWidget {
  const GameHeroPanel({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GameVisual.radiusLarge),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, GameColors.sky],
        ),
        boxShadow: GameVisual.softShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: Colors.white, size: 38),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.35,
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(height: 16),
                  trailing!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GameSectionCard extends StatelessWidget {
  const GameSectionCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(GameVisual.radiusMedium),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: GameVisual.softShadow,
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GameVisual.radiusMedium),
        child: card,
      ),
    );
  }
}

class GameStatusPill extends StatelessWidget {
  const GameStatusPill({
    super.key,
    required this.label,
    required this.icon,
    required this.foreground,
    required this.background,
  });

  final String label;
  final IconData icon;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class GameMetricBadge extends StatelessWidget {
  const GameMetricBadge({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(GameVisual.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
              ),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class GameIllustrationBadge extends StatelessWidget {
  const GameIllustrationBadge({
    super.key,
    required this.icon,
    this.size = 72,
    this.color,
  });

  final IconData icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = color ?? Theme.of(context).colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [base.withValues(alpha: 0.18), base.withValues(alpha: 0.05)],
        ),
        border: Border.all(color: base.withValues(alpha: 0.22)),
      ),
      child: Icon(icon, size: size * 0.52, color: base),
    );
  }
}
