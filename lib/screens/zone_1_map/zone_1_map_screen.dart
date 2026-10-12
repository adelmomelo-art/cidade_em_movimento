import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../data/zone_1/upgrade_data.dart';
import '../../models/upgrade_definition.dart';
import '../../ui/visual_system.dart';
import '../../widgets/zone_1_evolving_scene.dart';
import '../../widgets/zone_1_visual_scene.dart';

class Zone1MapScreen extends StatelessWidget {
  const Zone1MapScreen({super.key, required this.controller});

  final PlayerController controller;

  static const _missions = [
    ('Z1_M01', 1, 'Travessia Segura', Icons.directions_walk_rounded),
    ('Z1_M02', 2, 'Embarque Seguro', Icons.directions_bus_rounded),
    ('Z1_M03', 3, 'Bicicleta na Rota Escolar', Icons.pedal_bike_rounded),
    ('Z1_M04', 4, 'Só um Minutinho', Icons.no_crash_rounded),
    ('Z1_M05', 5, 'Caminho Seguro', Icons.accessible_forward_rounded),
    ('Z1_SPECIAL', 6, 'Saída da Escola', Icons.flag_rounded),
  ];

  static const _missionColors = <Color>[
    GameColors.red,
    GameColors.orange,
    GameColors.green,
    GameColors.blue,
    GameColors.purple,
    GameColors.navy,
  ];

  static const _missionAlignments = <Alignment>[
    Alignment(-0.82, 0.58),
    Alignment(-0.35, 0.03),
    Alignment(0.04, 0.72),
    Alignment(0.72, -0.10),
    Alignment(0.78, 0.15),
    Alignment(0.82, 0.90),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = controller.progress;
        final totalStars = progress.missionStars.values.fold<int>(
          0,
          (total, value) => total + value,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Zona 1 - Bairro / Escola'),
            actions: [
              IconButton(
                tooltip: 'Meu Progresso',
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.playerProgress);
                },
                icon: const Icon(Icons.insights_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: GameBackground(
              padding: EdgeInsets.zero,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 26),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: GameVisual.pageMaxWidth,
                              ),
                              child: Column(
                                children: [
                                  GameHeroPanel(
                                    eyebrow: 'Zona 1',
                                    title: 'Bairro / Escola',
                                    subtitle:
                                        'Seu ponto de partida para uma cidade mais segura e acolhedora. Explore o entorno escolar e avance pelas missoes.',
                                    icon: Icons.location_on_rounded,
                                    trailing: _ZoneStatusLine(
                                      completed: progress.zone1Completed,
                                      missionCount: progress.completedMissions
                                          .where((id) => id.startsWith('Z1_'))
                                          .length,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Zone1VisualScene(
                                    upgradePanel: _UpgradeSection(
                                      controller: controller,
                                    ),
                                    scoreHud: _ScoreHud(
                                      citizenship: progress.citizenshipXp,
                                      knowledge: progress.knowledge,
                                      coins: progress.coins,
                                      stars: totalStars,
                                      medalEarned: progress.medals.contains(
                                        'PROTETOR_DA_ESCOLA',
                                      ),
                                    ),
                                    missions: _buildVisualMissions(
                                      progress.unlockedMissions,
                                      progress.missionStars,
                                    ),
                                    purchasedUpgrades:
                                        progress.purchasedUpgrades,
                                    onMissionTap: (missionId) {
                                      final route = _routeForMission(missionId);
                                      if (route != null) {
                                        Navigator.of(context).pushNamed(route);
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  if (progress.zone1Completed) ...[
                                    const _ZoneCompletedCard(),
                                    const SizedBox(height: 12),
                                    FilledButton.icon(
                                      onPressed:
                                          controller.isZoneUnlocked('ZONE_2')
                                          ? () {
                                              Navigator.of(
                                                context,
                                              ).pushNamed(AppRoutes.zone2);
                                            }
                                          : null,
                                      icon: const Icon(
                                        Icons.location_city_rounded,
                                      ),
                                      label: const Text(
                                        'AVANCAR PARA O CENTRO HISTORICO',
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                  ],
                                  Zone1EvolvingScene(
                                    purchasedUpgrades:
                                        progress.purchasedUpgrades,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static List<Zone1VisualMission> _buildVisualMissions(
    Set<String> unlockedMissions,
    Map<String, int> missionStars,
  ) {
    return [
      for (var index = 0; index < _missions.length; index++)
        Zone1VisualMission(
          id: _missions[index].$1,
          number: _missions[index].$2,
          title: _missions[index].$3,
          icon: _missions[index].$4,
          color: _missionColors[index],
          alignment: _missionAlignments[index],
          unlocked: unlockedMissions.contains(_missions[index].$1),
          stars: missionStars[_missions[index].$1] ?? 0,
          special: _missions[index].$1 == 'Z1_SPECIAL',
        ),
    ];
  }

  static String? _routeForMission(String id) {
    switch (id) {
      case 'Z1_M01':
        return AppRoutes.mission1;
      case 'Z1_M02':
        return AppRoutes.mission2;
      case 'Z1_M03':
        return AppRoutes.mission3;
      case 'Z1_M04':
        return AppRoutes.mission4;
      case 'Z1_M05':
        return AppRoutes.mission5;
      case 'Z1_SPECIAL':
        return AppRoutes.specialMission;
      default:
        return null;
    }
  }
}

class _ScoreHud extends StatelessWidget {
  const _ScoreHud({
    required this.citizenship,
    required this.knowledge,
    required this.coins,
    required this.stars,
    required this.medalEarned,
  });

  final bool medalEarned;
  final int citizenship;
  final int knowledge;
  final int coins;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;
        return Container(
          key: const Key('zone1-score-hud'),
          decoration: BoxDecoration(
            color: GameColors.navy.withValues(alpha: .94),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: .55)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 6 : 12,
            vertical: 6,
          ),
          child: Row(
            children: [
              Expanded(
                child: _HudMetric(
                  icon: Icons.workspace_premium_rounded,
                  value: citizenship,
                  label: 'Cidadania',
                  color: GameColors.green,
                  compact: compact,
                ),
              ),
              Expanded(
                child: _HudMetric(
                  icon: Icons.menu_book_rounded,
                  value: knowledge,
                  label: 'Conhecimento',
                  color: GameColors.purple,
                  compact: compact,
                ),
              ),
              Expanded(
                child: _HudMetric(
                  icon: Icons.monetization_on_rounded,
                  value: coins,
                  label: 'Moedas',
                  color: GameColors.orange,
                  compact: compact,
                ),
              ),
              Expanded(
                child: _HudMetric(
                  icon: Icons.star_rounded,
                  value: stars,
                  label: 'Estrelas',
                  color: GameColors.yellow,
                  compact: compact,
                  hasMedal: medalEarned,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HudMetric extends StatelessWidget {
  const _HudMetric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.compact,
    this.hasMedal = false,
  });
  final IconData icon;
  final int value;
  final String label;
  final Color color;
  final bool compact;
  final bool hasMedal;
  @override
  Widget build(BuildContext context) {
    final number = Text(
      '$value',
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        fontSize: compact ? 12 : 15,
      ),
    );
    final caption = Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white.withValues(alpha: .85),
        fontSize: compact ? 8 : 10,
      ),
    );
    return Tooltip(
      message: '$label: $value',
      child: Semantics(
        label:
            '$label: $value${hasMedal ? '. Medalha Protetor da Escola conquistada' : ''}',
        excludeSemantics: true,
        child: compact
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 17, color: color),
                      const SizedBox(width: 4),
                      Flexible(child: number),
                      if (hasMedal) ...[
                        const SizedBox(width: 3),
                        const _EarnedZoneMedal(size: 19),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  caption,
                ],
              )
            : Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: color,
                    child: Icon(icon, size: 20, color: GameColors.navy),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [number, caption],
                    ),
                  ),
                  if (hasMedal) ...[
                    const SizedBox(width: 4),
                    const _EarnedZoneMedal(size: 25),
                  ],
                ],
              ),
      ),
    );
  }
}

class _EarnedZoneMedal extends StatelessWidget {
  const _EarnedZoneMedal({required this.size});
  final double size;
  @override
  Widget build(BuildContext context) => Tooltip(
    message: 'Medalha conquistada: Protetor da Escola',
    child: Icon(
      Icons.military_tech_rounded,
      key: const Key('zone1-earned-medal'),
      size: size,
      color: GameColors.yellow,
    ),
  );
}

class _ZoneStatusLine extends StatelessWidget {
  const _ZoneStatusLine({required this.completed, required this.missionCount});

  final bool completed;
  final int missionCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        GameStatusPill(
          label: completed ? 'ZONA CONCLUIDA' : '$missionCount/6 MISSOES',
          icon: completed ? Icons.emoji_events_rounded : Icons.route_rounded,
          foreground: GameColors.navy,
          background: Colors.white.withValues(alpha: 0.88),
        ),
      ],
    );
  }
}

class _ZoneCompletedCard extends StatelessWidget {
  const _ZoneCompletedCard();

  @override
  Widget build(BuildContext context) {
    return const GameSectionCard(
      backgroundColor: Color(0xFFFFF3CD),
      child: Row(
        children: [
          GameIllustrationBadge(
            icon: Icons.emoji_events_rounded,
            size: 62,
            color: GameColors.yellow,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zona 1 concluida',
                  style: TextStyle(
                    color: GameColors.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 3),
                Text('Medalha conquistada: Protetor da Escola'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UpgradeSection extends StatelessWidget {
  const _UpgradeSection({required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final progress = controller.progress;

    return Column(
      key: const Key('zone1-upgrades-window'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'MELHORIAS DA ZONA 1',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            shadows: [Shadow(color: GameColors.navy, blurRadius: 4)],
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < zone1Upgrades.length; i++) ...[
          _UpgradeCard(
            upgrade: zone1Upgrades[i],
            purchased: progress.purchasedUpgrades.contains(zone1Upgrades[i].id),
            canAfford: progress.coins >= zone1Upgrades[i].cost,
            onPurchase: () => _purchase(context, zone1Upgrades[i]),
          ),
          if (i < zone1Upgrades.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  Future<void> _purchase(
    BuildContext context,
    UpgradeDefinition upgrade,
  ) async {
    final purchased = await controller.purchaseUpgrade(upgrade.id);

    if (!context.mounted) {
      return;
    }

    final message = purchased
        ? '${upgrade.title} instalada com sucesso.'
        : 'Moedas insuficientes ou melhoria ja instalada.';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({
    required this.upgrade,
    required this.purchased,
    required this.canAfford,
    required this.onPurchase,
  });

  final UpgradeDefinition upgrade;
  final bool purchased;
  final bool canAfford;
  final Future<void> Function() onPurchase;

  IconData get _icon {
    switch (upgrade.id) {
      case 'FAIXA_SEGURA':
        return Icons.signpost_rounded;
      case 'ILUMINACAO_ESCOLAR':
        return Icons.lightbulb_rounded;
      case 'TRECHO_CICLOVIARIO':
        return Icons.pedal_bike_rounded;
      default:
        return Icons.location_city_rounded;
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final small = constraints.maxWidth < 180;
      return CustomPaint(
        key: Key('zone1-upgrade-${upgrade.id}'),
        painter: _UpgradeBubblePainter(purchased: purchased),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    purchased ? Icons.check_circle_rounded : _icon,
                    size: small ? 18 : 24,
                    color: purchased ? GameColors.green : GameColors.blue,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      upgrade.title,
                      style: TextStyle(
                        color: GameColors.navy,
                        fontSize: small ? 11 : 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Tooltip(
                message: upgrade.description,
                child: Text(
                  upgrade.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: GameColors.navy,
                    fontSize: small ? 9 : 11,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              FilledButton(
                onPressed: purchased || !canAfford
                    ? null
                    : () {
                        onPurchase();
                      },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        purchased
                            ? Icons.verified_rounded
                            : Icons.monetization_on_rounded,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        purchased ? 'INSTALADA' : '${upgrade.cost} MOEDAS',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
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
    },
  );
}

class _UpgradeBubblePainter extends CustomPainter {
  const _UpgradeBubblePainter({required this.purchased});
  final bool purchased;
  @override
  void paint(Canvas canvas, Size size) {
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 0, size.width - 8, size.height),
      const Radius.circular(16),
    );
    final tail = Path()
      ..moveTo(9, 16)
      ..lineTo(0, 27)
      ..lineTo(9, 39)
      ..close();
    canvas.drawShadow(Path()..addRRect(body), const Color(0x55000000), 4, true);
    canvas.drawRRect(body, Paint()..color = Colors.white);
    canvas.drawPath(tail, Paint()..color = Colors.white);
    canvas.drawRRect(
      body,
      Paint()
        ..color = purchased ? const Color(0xFF79B997) : const Color(0xFFC9D5DF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_UpgradeBubblePainter oldDelegate) =>
      purchased != oldDelegate.purchased;
}
