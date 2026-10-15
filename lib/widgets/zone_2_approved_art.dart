import 'package:flutter/material.dart';

import '../controllers/player_controller.dart';
import 'fortaleza_map_avatar.dart';

const zone2ArtworkSize = Size(1672, 941);
const zone2MapArtwork = 'assets/zone_2/r30/mapa_aprovado.png';
const zone2MissionArtwork = 'assets/zone_2/r30/missao_template.png';
const zone2SceneryArtwork = 'assets/zone_2/r30/cenario_centro.png';
const zone2Ink = Color(0xFF062565);
const zone2Gold = Color(0xFFFFD900);
const zone2Cyan = Color(0xFF27DBFF);

/// One transform for artwork and hit targets. The ambient scene fills the
/// viewport; the complete approved board remains inside the safe area.
class Zone2ArtworkBoard extends StatelessWidget {
  const Zone2ArtworkBoard({
    super.key,
    required this.asset,
    required this.children,
    required this.captureKey,
  });
  final String asset;
  final List<Widget> children;
  final Key captureKey;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(
        zone2SceneryArtwork,
        key: const Key('zone2-ambient-art'),
        fit: BoxFit.cover,
        excludeFromSemantics: true,
      ),
      const ColoredBox(color: Color(0x5506234F)),
      SafeArea(
        child: SizedBox.expand(
          child: FittedBox(
            key: const Key('zone2-fitted-map'),
            fit: BoxFit.contain,
            child: RepaintBoundary(
              key: captureKey,
              child: SizedBox(
                width: zone2ArtworkSize.width,
                height: zone2ArtworkSize.height,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        asset,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.medium,
                        excludeFromSemantics: true,
                      ),
                    ),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

/// Fits the complete text, including enlarged system text, without truncation.
/// All sizes are in the same native coordinates as the approved artwork.
class Zone2ArtText extends StatelessWidget {
  const Zone2ArtText(
    this.text, {
    super.key,
    this.fontSize = 32,
    this.color = Colors.white,
    this.align = TextAlign.center,
    this.weight = FontWeight.w800,
    this.textKey,
  });
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign align;
  final FontWeight weight;
  final Key? textKey;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) {
      final scaler = MediaQuery.textScalerOf(context);
      final direction = Directionality.of(context);
      final base = TextStyle(
        fontSize: fontSize,
        height: 1.12,
        color: color,
        fontWeight: weight,
      );
      var low = 1.0;
      var high = fontSize;
      for (var i = 0; i < 14; i++) {
        final size = (low + high) / 2;
        final painter = TextPainter(
          text: TextSpan(
            text: text,
            style: base.copyWith(fontSize: size),
          ),
          textDirection: direction,
          textAlign: align,
          textScaler: scaler,
        )..layout(maxWidth: bounds.maxWidth);
        final fits =
            painter.height <= bounds.maxHeight &&
            painter.width <= bounds.maxWidth;
        painter.dispose();
        if (fits) {
          low = size;
        } else {
          high = size;
        }
      }
      return Align(
        alignment: align == TextAlign.left
            ? Alignment.centerLeft
            : Alignment.center,
        child: Text(
          text,
          key: textKey,
          textAlign: align,
          style: base.copyWith(fontSize: low),
        ),
      );
    },
  );
}

class Zone2LiveHud extends StatelessWidget {
  const Zone2LiveHud({super.key, required this.player});
  final PlayerController player;

  @override
  Widget build(BuildContext context) {
    final p = player.progress;
    final stars = p.missionStars.values.fold<int>(0, (a, b) => a + b);
    final values = [
      (
        Icons.shield_rounded,
        p.citizenshipXp,
        'Cidadania',
        Colors.lightGreenAccent,
      ),
      (
        Icons.menu_book_rounded,
        p.knowledge,
        'Conhecimento',
        Colors.purpleAccent,
      ),
      (Icons.monetization_on_rounded, p.coins, 'Moedas', zone2Gold),
      (Icons.star_rounded, stars, 'Estrelas', zone2Gold),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: zone2Ink,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF42A9E3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: FortalezaMapAvatar(
                profile: player.profile,
                portrait: true,
              ),
            ),
            const SizedBox(width: 8),
            for (final metric in values)
              Expanded(
                child: Tooltip(
                  message: '${metric.$3}: ${metric.$2}',
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(metric.$1, size: 30, color: metric.$4),
                            Expanded(
                              child: Zone2ArtText('${metric.$2}', fontSize: 26),
                            ),
                            if (metric.$3 == 'Estrelas' &&
                                p.medals.contains('GUARDIAO_DO_CENTRO'))
                              const Icon(
                                Icons.military_tech_rounded,
                                key: Key('zone2-earned-medal'),
                                color: zone2Gold,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                        child: Zone2ArtText(metric.$3, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Zone2NightLayer extends StatelessWidget {
  const Zone2NightLayer({
    super.key,
    required this.night,
    required this.lighting,
  });
  final bool night;
  final bool lighting;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (night) const ColoredBox(color: Color(0x880A164C)),
        if (night && lighting)
          const DecoratedBox(
            key: Key('zone2-night-lighting-glow'),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(.05, .3),
                radius: .65,
                colors: [Color(0x66FFF1A6), Color(0x00FFF1A6)],
              ),
            ),
          ),
      ],
    ),
  );
}

/// Crops are rendered at runtime from the clean approved historic center scenery.
/// No UI labels or selectable answers are baked into these scene closeups.
class Zone2MissionScene extends StatelessWidget {
  const Zone2MissionScene({super.key, required this.missionId});
  final String missionId;

  static Rect cropFor(String id) => switch (id) {
    'Z2_M01' => const Rect.fromLTWH(440, 510, 620, 430),
    'Z2_M02' => const Rect.fromLTWH(205, 360, 620, 530),
    'Z2_M03' => const Rect.fromLTWH(525, 255, 620, 530),
    'Z2_M04' => const Rect.fromLTWH(1050, 285, 620, 530),
    'Z2_M05' => const Rect.fromLTWH(980, 410, 620, 530),
    _ => const Rect.fromLTWH(570, 160, 1040, 770),
  };

  @override
  Widget build(BuildContext context) {
    final crop = cropFor(missionId);
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: crop.width,
          height: crop.height,
          child: Stack(
            children: [
              Positioned(
                left: -crop.left,
                top: -crop.top,
                width: 1672,
                height: 941,
                child: Image.asset(
                  zone2SceneryArtwork,
                  fit: BoxFit.fill,
                  excludeFromSemantics: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
