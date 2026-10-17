import 'package:flutter/material.dart';

import '../controllers/player_controller.dart';
import 'fortaleza_map_avatar.dart';

const zone6ArtworkSize = Size(1672, 941);
const zone6MapArtwork = 'assets/zone_6/r34/mapa_aprovado.png';
const zone6MissionArtwork = 'assets/zone_6/r34/missao_template.png';
const zone6SceneryArtwork = 'assets/zone_6/r34/cenario_castelao.png';
const zone6Ink = Color(0xFF062565);
const zone6Gold = Color(0xFFFFD900);
const zone6Cyan = Color(0xFF27DBFF);

/// One transform for artwork and hit targets. The ambient scene fills the
/// viewport; the complete approved board remains inside the safe area.
class Zone6ArtworkBoard extends StatelessWidget {
  const Zone6ArtworkBoard({
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
        zone6SceneryArtwork,
        key: const Key('zone6-ambient-art'),
        fit: BoxFit.cover,
        excludeFromSemantics: true,
      ),
      const ColoredBox(color: Color(0x5506234F)),
      SafeArea(
        child: SizedBox.expand(
          child: FittedBox(
            key: const Key('zone6-fitted-map'),
            fit: BoxFit.contain,
            child: RepaintBoundary(
              key: captureKey,
              child: SizedBox(
                width: zone6ArtworkSize.width,
                height: zone6ArtworkSize.height,
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
class Zone6ArtText extends StatelessWidget {
  const Zone6ArtText(
    this.text, {
    super.key,
    this.fontSize = 32,
    this.color = Colors.white,
    this.align = TextAlign.center,
    this.weight = FontWeight.w800,
    this.textKey,
    this.maxLines,
  });
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign align;
  final FontWeight weight;
  final Key? textKey;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => Padding(
    // Keep glyph side bearings inside the allocated artwork slot.
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: LayoutBuilder(
      builder: (context, bounds) {
        final scaler = MediaQuery.textScalerOf(context);
        final direction = Directionality.of(context);
        final inherited = DefaultTextStyle.of(context);
        // Only an explicit limit may restrict this artwork text.
        final lineLimit = maxLines;
        final locale = Localizations.maybeLocaleOf(context);
        final base = inherited.style
            .merge(
              TextStyle(
                fontSize: fontSize,
                height: 1.12,
                color: color,
                fontWeight: weight,
              ),
            )
            .copyWith(inherit: false);
        var low = 1.0;
        var high = fontSize;
        for (var i = 0; i < 14; i++) {
          final size = (low + high) / 2;
          final painter =
              TextPainter(
                text: TextSpan(
                  text: text,
                  style: base.copyWith(fontSize: size),
                ),
                textDirection: direction,
                textAlign: align,
                textScaler: scaler,
                maxLines: lineLimit,
                locale: locale,
                textHeightBehavior: inherited.textHeightBehavior,
              )..layout(
                maxWidth: lineLimit == 1 ? double.infinity : bounds.maxWidth,
              );
          final fits =
              !painter.didExceedMaxLines &&
              painter.height <= bounds.maxHeight - 0.5 &&
              painter.width <=
                  bounds.maxWidth + (lineLimit == 1 ? -0.5 : 0.001);
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
          child: DefaultTextStyle(
            style: base,
            maxLines: lineLimit,
            softWrap: lineLimit != 1,
            child: Text(
              text,
              key: textKey,
              textAlign: align,
              maxLines: lineLimit,
              softWrap: lineLimit != 1,
              textScaler: scaler,
              locale: locale,
              textHeightBehavior: inherited.textHeightBehavior,
              style: base.copyWith(fontSize: low),
            ),
          ),
        );
      },
    ),
  );
}

class Zone6LiveHud extends StatelessWidget {
  const Zone6LiveHud({super.key, required this.player});
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
      (Icons.monetization_on_rounded, p.coins, 'Moedas', zone6Gold),
      (Icons.star_rounded, stars, 'Estrelas', zone6Gold),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: zone6Ink,
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
                              child: Zone6ArtText(
                                '${metric.$2}',
                                fontSize: 26,
                                maxLines: metric.$3 == 'Estrelas' ? 1 : null,
                              ),
                            ),
                            if (metric.$3 == 'Estrelas' &&
                                p.medals.contains('GUARDIAO_DO_CASTELAO'))
                              const Icon(
                                Icons.military_tech_rounded,
                                key: Key('zone6-earned-medal'),
                                color: zone6Gold,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                        child: Zone6ArtText(
                          metric.$3,
                          fontSize: 17,
                          maxLines: 1,
                        ),
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

class Zone6NightLayer extends StatelessWidget {
  const Zone6NightLayer({
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
            key: Key('zone6-night-lighting-glow'),
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

/// Crops are rendered at runtime from the clean approved stadium surroundings scenery.
/// No UI labels or selectable answers are baked into these scene closeups.
class Zone6MissionScene extends StatelessWidget {
  const Zone6MissionScene({super.key, required this.missionId});
  final String missionId;

  static Rect cropFor(String id) => switch (id) {
    'Z6_M01' => const Rect.fromLTWH(360, 430, 620, 510),
    'Z6_M02' => const Rect.fromLTWH(250, 230, 620, 530),
    'Z6_M03' => const Rect.fromLTWH(640, 260, 620, 530),
    'Z6_M04' => const Rect.fromLTWH(960, 160, 650, 560),
    'Z6_M05' => const Rect.fromLTWH(1030, 320, 620, 530),
    _ => const Rect.fromLTWH(430, 120, 1100, 800),
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
                  zone6SceneryArtwork,
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
