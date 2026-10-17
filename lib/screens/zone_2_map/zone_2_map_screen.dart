import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';
import '../../data/zone_2/mission_01_data.dart';
import '../../data/zone_2/mission_02_data.dart';
import '../../data/zone_2/mission_03_data.dart';
import '../../data/zone_2/mission_04_data.dart';
import '../../data/zone_2/mission_05_data.dart';
import '../../data/zone_2/special_mission_data.dart';
import '../../data/zone_2/upgrade_data.dart';
import '../../models/mission.dart';
import '../../widgets/approved_artwork_page.dart';
import '../../widgets/fortaleza_map_avatar.dart';
import '../../widgets/zone_2_approved_art.dart';
import '../../widgets/zone_2_mission_dialog.dart';

class Zone2MapScreen extends StatefulWidget {
  const Zone2MapScreen({super.key, required this.controller});
  final PlayerController controller;

  @override
  State<Zone2MapScreen> createState() => _Zone2MapScreenState();
}

class _Zone2MapScreenState extends State<Zone2MapScreen> {
  PlayerController get controller => widget.controller;
  bool _night = false;
  bool _openingUpgrades = false;
  bool _openingMission = false;

  static const _pins = [
    ('Z2_M01', 'Cruzamento em Movimento', Rect.fromLTWH(710, 624, 245, 116)),
    ('Z2_M02', 'Ponto Certo', Rect.fromLTWH(425, 448, 208, 96)),
    ('Z2_M03', 'Calçada é de Todos', Rect.fromLTWH(648, 323, 255, 111)),
    ('Z2_M04', 'Só Vou Parar Aqui', Rect.fromLTWH(1356, 355, 252, 112)),
    ('Z2_M05', 'Rotas que se Encontram', Rect.fromLTWH(1244, 549, 278, 109)),
    ('Z2_SPECIAL', 'Centro em Harmonia', Rect.fromLTWH(1325, 727, 286, 129)),
  ];

  static Mission? _missionForId(String id, PlayerType type) => switch (id) {
    'Z2_M01' => buildZone2Mission01(type),
    'Z2_M02' => buildZone2Mission02(type),
    'Z2_M03' => buildZone2Mission03(type),
    'Z2_M04' => buildZone2Mission04(type),
    'Z2_M05' => buildZone2Mission05(type),
    'Z2_SPECIAL' => buildZone2SpecialMission(type),
    _ => null,
  };

  Future<void> _openMission(String id) async {
    if (_openingMission ||
        !controller.isZoneUnlocked('ZONE_2') ||
        !controller.progress.unlockedMissions.contains(id)) {
      return;
    }
    final type = controller.profile?.type;
    if (type == null) return;
    final mission = _missionForId(id, type);
    if (mission == null) return;
    _openingMission = true;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        routeSettings: RouteSettings(name: '/zone-2/dialog/$id'),
        builder: (_) => Zone2MissionDialog(
          mission: mission,
          player: controller,
          nightPreview: _night,
          nextMissionId: switch (id) {
            'Z2_M01' => 'Z2_M02',
            'Z2_M02' => 'Z2_M03',
            'Z2_M03' => 'Z2_M04',
            'Z2_M04' => 'Z2_M05',
            _ => null,
          },
        ),
      );
    } finally {
      _openingMission = false;
    }
  }

  void _back() {
    final nav = Navigator.of(context);
    var found = false;
    nav.popUntil((route) {
      found = route.settings.name == AppRoutes.fortalezaMap;
      return found || route.isFirst;
    });
    if (!found) nav.pushReplacementNamed(AppRoutes.fortalezaMap);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => Scaffold(
      body: ClipRRect(
        key: const Key('zone2-map-canvas'),
        child: Zone2ArtworkBoard(
          asset: zone2MapArtwork,
          captureKey: const Key('zone2-map-artwork'),
          children: [
            Positioned.fill(
              child: Zone2NightLayer(
                key: const Key('zone2-map-night'),
                night: _night,
                lighting: false,
              ),
            ),
            Positioned(
              left: 0,
              top: 240,
              width: 420,
              height: 404,
              child: IgnorePointer(
                child: Semantics(
                  key: const Key('zone2-mentor-panel'),
                  label:
                      'Melo: Vamos explorar o Centro? Observe os caminhos e escolha sua missão!',
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned(
              left: 1144,
              top: 15,
              width: 520,
              height: 103,
              child: Zone2LiveHud(
                key: const Key('zone2-score-hud'),
                player: controller,
              ),
            ),
            Positioned(
              left: 510,
              top: 695,
              width: 93,
              height: 155,
              child: IgnorePointer(
                child: FortalezaMapAvatar(profile: controller.profile),
              ),
            ),
            Positioned.fill(
              child: Stack(
                key: const Key('zone2-mission-window'),
                children: [for (final pin in _pins) _pin(pin)],
              ),
            ),
            Positioned(
              left: 14,
              top: 28,
              width: 68,
              height: 70,
              child: ArtworkAction(
                key: const Key('zone2-back-to-fortaleza'),
                label: 'Voltar ao mapa de Fortaleza',
                hint: 'Mapa de Fortaleza',
                onPressed: _back,
              ),
            ),
            if (!controller.isZoneUnlocked('ZONE_2'))
              const Positioned(
                left: 720,
                top: 122,
                width: 700,
                height: 66,
                child: ColoredBox(
                  color: zone2Ink,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Zone2ArtText(
                      'Conclua a Zona 1 para explorar o Centro.',
                      fontSize: 29,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 430,
              top: 846,
              width: 755,
              height: 89,
              child: _navigation(),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _pin((String, String, Rect) pin) {
    final unlocked =
        controller.isZoneUnlocked('ZONE_2') &&
        controller.progress.unlockedMissions.contains(pin.$1);
    final stars = controller.progress.missionStars[pin.$1] ?? 0;
    final special = pin.$1 == 'Z2_SPECIAL';
    return Positioned.fromRect(
      rect: pin.$3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (special && unlocked) ...[
            const Positioned(
              left: 16,
              top: 20,
              width: 50,
              height: 48,
              child: ColoredBox(
                color: Color(0xFF112D48),
                child: Icon(Icons.flag_rounded, color: zone2Gold, size: 45),
              ),
            ),
            Positioned(
              left: 87,
              top: 72,
              width: 192,
              height: 40,
              child: ColoredBox(
                color: const Color(0xFFDCE7FC),
                child: Zone2ArtText(
                  stars > 0 ? 'Missão concluída' : 'Toque para jogar',
                  color: zone2Ink,
                  fontSize: 23,
                ),
              ),
            ),
          ],
          if (!unlocked && !special)
            Positioned(
              right: 0,
              top: 0,
              width: 48,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: zone2Ink,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          if (stars > 0)
            Positioned(
              right: 4,
              bottom: 0,
              width: 112,
              height: 30,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: zone2Ink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Icon(
                        i < stars
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 28,
                        color: zone2Gold,
                      ),
                  ],
                ),
              ),
            ),
          ArtworkAction(
            key: Key('zone2-visual-mission-${pin.$1}'),
            label: pin.$2,
            hint: unlocked
                ? '${pin.$2}. $stars de 3 estrelas. Toque para jogar.'
                : '${pin.$2}. Conclua a missão anterior para desbloquear.',
            onPressed: unlocked ? () => _openMission(pin.$1) : null,
          ),
        ],
      ),
    );
  }

  Widget _navigation() => DecoratedBox(
    key: const Key('zone2-navigation-window'),
    decoration: BoxDecoration(
      color: zone2Ink,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: zone2Cyan, width: 2),
    ),
    child: Row(
      children: [
        _navButton(
          'zone2-toggle-night',
          _night ? 'Dia' : 'Noite',
          _night ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          () => setState(() => _night = !_night),
        ),
        _navButton(
          'zone2-open-progress',
          'Progresso',
          Icons.insights_rounded,
          () => Navigator.of(context).pushNamed(AppRoutes.playerProgress),
        ),
        _navButton(
          'zone2-open-upgrades',
          'Melhorias',
          Icons.construction_rounded,
          _showUpgrades,
        ),
        if (controller.isZoneUnlocked('ZONE_3'))
          _navButton(
            'zone2-advance-zone3',
            'Próxima zona',
            Icons.arrow_forward_rounded,
            () => Navigator.of(context).pushNamed(AppRoutes.zone3),
          ),
      ],
    ),
  );

  Widget _navButton(
    String key,
    String text,
    IconData icon,
    VoidCallback action,
  ) => Expanded(
    child: TextButton.icon(
      key: Key(key),
      onPressed: action,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 60),
      ),
      icon: Icon(icon, size: 28),
      label: SizedBox(
        width: 107,
        height: 42,
        child: Zone2ArtText(text, fontSize: 24, maxLines: 1),
      ),
    ),
  );

  Future<void> _showUpgrades() async {
    if (_openingUpgrades) return;
    _openingUpgrades = true;
    try {
      await showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: zone2Ink,
          child: SizedBox(
            width: 760,
            height: 480,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 760,
                height: 480,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      key: const Key('zone2-upgrades-window'),
                      children: [
                        const SizedBox(
                          height: 45,
                          child: Zone2ArtText('MELHORIAS DA ZONA 2'),
                        ),
                        const SizedBox(height: 12),
                        for (final upgrade in zone2Upgrades)
                          Expanded(
                            child: Card(
                              key: Key('zone2-upgrade-${upgrade.id}'),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: Zone2ArtText(
                                              upgrade.title,
                                              color: zone2Ink,
                                              fontSize: 26,
                                              align: TextAlign.left,
                                            ),
                                          ),
                                          Expanded(
                                            child: Zone2ArtText(
                                              upgrade.description,
                                              color: zone2Ink,
                                              fontSize: 19,
                                              align: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    SizedBox(
                                      width: 170,
                                      height: 60,
                                      child: FilledButton(
                                        key: Key('zone2-install-${upgrade.id}'),
                                        onPressed:
                                            controller
                                                    .progress
                                                    .purchasedUpgrades
                                                    .contains(upgrade.id) ||
                                                controller.progress.coins <
                                                    upgrade.cost
                                            ? null
                                            : () async {
                                                try {
                                                  await controller
                                                      .purchaseUpgrade(
                                                        upgrade.id,
                                                      );
                                                } catch (_) {
                                                  if (mounted &&
                                                      context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      this.context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Não foi possível salvar a melhoria. Tente novamente.',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                        child: Zone2ArtText(
                                          controller.progress.purchasedUpgrades
                                                  .contains(upgrade.id)
                                              ? 'INSTALADA'
                                              : '${upgrade.cost} MOEDAS',
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 60,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'VOLTAR AO CENTRO',
                              style: TextStyle(color: zone2Gold, fontSize: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } finally {
      _openingUpgrades = false;
    }
  }
}
