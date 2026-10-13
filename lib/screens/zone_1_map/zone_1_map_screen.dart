import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../data/zone_1/upgrade_data.dart';
import '../../models/upgrade_definition.dart';
import '../../models/mission.dart';
import '../../core/enums/player_type.dart';
import '../../data/zone_1/mission_01_data.dart';
import '../../data/zone_1/mission_02_data.dart';
import '../../data/zone_1/mission_03_data.dart';
import '../../data/zone_1/mission_04_data.dart';
import '../../data/zone_1/mission_05_data.dart';
import '../../data/zone_1/special_mission_data.dart';
import '../../ui/visual_system.dart';
import '../../widgets/zone_1_mission_dialog.dart';
import '../../widgets/zone_1_visual_scene.dart';

class Zone1MapScreen extends StatefulWidget {
  const Zone1MapScreen({super.key, required this.controller});

  final PlayerController controller;

  @override
  State<Zone1MapScreen> createState() => _Zone1MapScreenState();
}

class _Zone1MapScreenState extends State<Zone1MapScreen> {
  PlayerController get controller => widget.controller;
  final _sceneKey = GlobalKey();
  bool _night = false;
  bool _openingMission = false;

  Future<void> _openMission(String id) async {
    if (_openingMission || !controller.progress.unlockedMissions.contains(id)) {
      return;
    }
    final type = controller.profile?.type;
    if (type == null) return;
    final mission = _missionForId(id, type);
    if (mission == null) return;
    _openingMission = true;
    try {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color(0x660A263B),
        routeSettings: RouteSettings(name: '/zone-1/dialog/$id'),
        builder: (_) => Zone1MissionDialog(
          mission: mission,
          player: controller,
          nightPreview: _night,
          nextMissionId: switch (id) {
            'Z1_M01' => 'Z1_M02',
            'Z1_M02' => 'Z1_M03',
            'Z1_M03' => 'Z1_M04',
            'Z1_M04' => 'Z1_M05',
            _ => null,
          },
        ),
      );
    } finally {
      _openingMission = false;
    }
  }

  static Mission? _missionForId(String id, PlayerType type) => switch (id) {
    'Z1_M01' => buildZone1Mission01(type),
    'Z1_M02' => buildZone1Mission02(type),
    'Z1_M03' => buildZone1Mission03(type),
    'Z1_M04' => buildZone1Mission04(type),
    'Z1_M05' => buildZone1Mission05(type),
    'Z1_SPECIAL' => buildZone1SpecialMission(type),
    _ => null,
  };

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
          body: LayoutBuilder(
            builder: (context, viewport) {
              if (viewport.maxWidth <= 0 || viewport.maxHeight <= 0) {
                return const SizedBox.shrink();
              }
              const designWidth = 1360.0;
              final horizontal = viewport.maxWidth > viewport.maxHeight;
              final scale = viewport.maxWidth / designWidth;
              final designHeight = horizontal
                  ? viewport.maxHeight / scale
                  : designWidth / 1.5;
              final safe = MediaQuery.paddingOf(context);
              final contentInsets = horizontal
                  ? EdgeInsets.fromLTRB(
                      safe.left / scale,
                      safe.top / scale,
                      safe.right / scale,
                      safe.bottom / scale,
                    )
                  : EdgeInsets.zero;
              return SizedBox.expand(
                child: FittedBox(
                  key: const Key('zone1-fitted-map'),
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: designWidth,
                    height: designHeight,
                    child: Zone1VisualScene(
                      key: _sceneKey,
                      viewportHeight: horizontal ? designHeight : null,
                      contentInsets: contentInsets,
                      nightPreview: _night,
                      navigationPanel: _navigation(context),
                      upgradePanel: _UpgradeSection(controller: controller),
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
                      purchasedUpgrades: progress.purchasedUpgrades,
                      onMissionTap: _openMission,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _navigation(BuildContext context) => Container(
    key: const Key('zone1-navigation-window'),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .96),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFF277797)),
      boxShadow: const [BoxShadow(color: Color(0x330A263B), blurRadius: 8)],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          key: const Key('zone1-back-to-fortaleza'),
          tooltip: 'Mapa de Fortaleza',
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: const Icon(Icons.map_rounded, color: GameColors.navy),
          onPressed: () {
            final nav = Navigator.of(context);
            var found = false;
            nav.popUntil((route) {
              found = route.settings.name == AppRoutes.fortalezaMap;
              return found || route.isFirst;
            });
            if (!found) nav.pushReplacementNamed(AppRoutes.fortalezaMap);
          },
        ),
        IconButton(
          key: const Key('zone1-toggle-night'),
          tooltip: _night ? 'Ver bairro de dia' : 'Ver iluminação à noite',
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: Icon(
            _night ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: GameColors.navy,
          ),
          onPressed: () => setState(() => _night = !_night),
        ),
        IconButton(
          key: const Key('zone1-open-progress'),
          tooltip: 'Meu Progresso',
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: const Icon(Icons.insights_rounded, color: GameColors.navy),
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.playerProgress),
        ),
        if (controller.isZoneUnlocked('ZONE_2'))
          IconButton(
            key: const Key('zone1-advance-zone2'),
            tooltip: 'Avançar para o Centro Histórico',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(
              Icons.location_city_rounded,
              color: GameColors.navy,
            ),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.zone2),
          ),
      ],
    ),
  );

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
