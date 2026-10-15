import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';
import '../../data/zone_5/mission_01_data.dart';
import '../../data/zone_5/mission_02_data.dart';
import '../../data/zone_5/mission_03_data.dart';
import '../../data/zone_5/mission_04_data.dart';
import '../../data/zone_5/mission_05_data.dart';
import '../../data/zone_5/special_mission_data.dart';
import '../../data/zone_5/upgrade_data.dart';
import '../../models/mission.dart';
import '../../widgets/approved_artwork_page.dart';
import '../../widgets/fortaleza_map_avatar.dart';
import '../../widgets/zone_5_approved_art.dart';
import '../../widgets/zone_5_mission_dialog.dart';

class Zone5MapScreen extends StatefulWidget {
  const Zone5MapScreen({super.key, required this.controller});
  final PlayerController controller;

  @override
  State<Zone5MapScreen> createState() => _Zone5MapScreenState();
}

class _Zone5MapScreenState extends State<Zone5MapScreen> {
  PlayerController get controller => widget.controller;
  bool _night = false;
  bool _openingUpgrades = false;
  bool _openingMission = false;

  static const _pins = [
    (
      'Z5_M01',
      'Travessia de Grande Avenida',
      Rect.fromLTWH(562, 478, 244, 118),
    ),
    ('Z5_M02', 'Ponto Cego', Rect.fromLTWH(635, 247, 190, 116)),
    ('Z5_M03', 'Velocidade e Distância', Rect.fromLTWH(958, 213, 194, 113)),
    ('Z5_M04', 'Acesso e Conversão', Rect.fromLTWH(1281, 213, 211, 113)),
    ('Z5_M05', 'Fluxo Intenso', Rect.fromLTWH(1403, 383, 225, 116)),
    (
      'Z5_SPECIAL',
      'Corredor em Equilíbrio',
      Rect.fromLTWH(1344, 639, 300, 151),
    ),
  ];

  static Mission? _missionForId(String id, PlayerType type) => switch (id) {
    'Z5_M01' => buildZone5Mission01(type),
    'Z5_M02' => buildZone5Mission02(type),
    'Z5_M03' => buildZone5Mission03(type),
    'Z5_M04' => buildZone5Mission04(type),
    'Z5_M05' => buildZone5Mission05(type),
    'Z5_SPECIAL' => buildZone5SpecialMission(type),
    _ => null,
  };

  Future<void> _openMission(String id) async {
    if (_openingMission ||
        !controller.isZoneUnlocked('ZONE_5') ||
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
        routeSettings: RouteSettings(name: '/zone-5/dialog/$id'),
        builder: (_) => Zone5MissionDialog(
          mission: mission,
          player: controller,
          nightPreview: _night,
          nextMissionId: switch (id) {
            'Z5_M01' => 'Z5_M02',
            'Z5_M02' => 'Z5_M03',
            'Z5_M03' => 'Z5_M04',
            'Z5_M04' => 'Z5_M05',
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
        key: const Key('zone5-map-canvas'),
        child: Zone5ArtworkBoard(
          asset: zone5MapArtwork,
          captureKey: const Key('zone5-map-artwork'),
          children: [
            Positioned.fill(
              child: Zone5NightLayer(
                key: const Key('zone5-map-night'),
                night: _night,
                lighting: controller.progress.purchasedUpgrades.contains(
                  'ILUMINACAO_CORREDOR',
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 505,
              width: 386,
              height: 436,
              child: IgnorePointer(
                child: Semantics(
                  key: const Key('zone5-mentor-panel'),
                  label:
                      'Melo: Vamos às grandes vias? Observe os riscos e escolha sua missão!',
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned(
              left: 1061,
              top: 28,
              width: 590,
              height: 89,
              child: Zone5LiveHud(
                key: const Key('zone5-score-hud'),
                player: controller,
              ),
            ),
            Positioned(
              left: 342,
              top: 704,
              width: 88,
              height: 150,
              child: IgnorePointer(
                child: FortalezaMapAvatar(profile: controller.profile),
              ),
            ),
            Positioned.fill(
              child: Stack(
                key: const Key('zone5-mission-window'),
                children: [for (final pin in _pins) _pin(pin)],
              ),
            ),
            Positioned(
              left: 30,
              top: 33,
              width: 68,
              height: 70,
              child: ArtworkAction(
                key: const Key('zone5-back-to-fortaleza'),
                label: 'Voltar ao mapa de Fortaleza',
                hint: 'Mapa de Fortaleza',
                onPressed: _back,
              ),
            ),
            if (!controller.isZoneUnlocked('ZONE_5'))
              const Positioned(
                left: 720,
                top: 122,
                width: 700,
                height: 66,
                child: ColoredBox(
                  color: zone5Ink,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Zone5ArtText(
                      'Conclua a Zona 4 para explorar Grandes Vias.',
                      fontSize: 29,
                    ),
                  ),
                ),
              ),
            if (controller.isZoneUnlocked('ZONE_6'))
              Positioned(
                left: 1101,
                top: 861,
                width: 76,
                height: 70,
                child: IconButton.filled(
                  key: const Key('zone5-advance-zone6'),
                  tooltip: 'Avançar para Polo Castelão',
                  style: IconButton.styleFrom(
                    backgroundColor: zone5Ink,
                    foregroundColor: zone5Gold,
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.zone6),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 38),
                ),
              ),
            Positioned(
              left: 595,
              top: 861,
              width: 494,
              height: 69,
              child: _navigation(),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _pin((String, String, Rect) pin) {
    final unlocked =
        controller.isZoneUnlocked('ZONE_5') &&
        controller.progress.unlockedMissions.contains(pin.$1);
    final stars = controller.progress.missionStars[pin.$1] ?? 0;
    final special = pin.$1 == 'Z5_SPECIAL';
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
                child: Icon(Icons.flag_rounded, color: zone5Gold, size: 45),
              ),
            ),
            Positioned(
              left: 87,
              top: 72,
              width: 192,
              height: 40,
              child: ColoredBox(
                color: const Color(0xFFDCE7FC),
                child: Zone5ArtText(
                  stars > 0 ? 'Missão concluída' : 'Toque para jogar',
                  color: zone5Ink,
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
                  color: zone5Ink,
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
                  color: zone5Ink,
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
                        color: zone5Gold,
                      ),
                  ],
                ),
              ),
            ),
          ArtworkAction(
            key: Key('zone5-visual-mission-${pin.$1}'),
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
    key: const Key('zone5-navigation-window'),
    decoration: BoxDecoration(
      color: zone5Ink,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: zone5Cyan, width: 2),
    ),
    child: Row(
      children: [
        _navButton(
          'zone5-toggle-night',
          _night ? 'Dia' : 'Noite',
          _night ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          () => setState(() => _night = !_night),
        ),
        _navButton(
          'zone5-open-progress',
          'Progresso',
          Icons.insights_rounded,
          () => Navigator.of(context).pushNamed(AppRoutes.playerProgress),
        ),
        _navButton(
          'zone5-open-upgrades',
          'Melhorias',
          Icons.construction_rounded,
          _showUpgrades,
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
    child: TextButton(
      key: Key(key),
      onPressed: action,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        minimumSize: const Size(48, 72),
      ),
      child: Column(
        children: [
          Icon(icon, size: 33, color: zone5Gold),
          Expanded(child: Zone5ArtText(text, fontSize: 24)),
        ],
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
          backgroundColor: zone5Ink,
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
                      key: const Key('zone5-upgrades-window'),
                      children: [
                        const SizedBox(
                          height: 45,
                          child: Zone5ArtText('MELHORIAS DA ZONA 5'),
                        ),
                        const SizedBox(height: 12),
                        for (final upgrade in zone5Upgrades)
                          Expanded(
                            child: Card(
                              key: Key('zone5-upgrade-${upgrade.id}'),
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
                                            child: Zone5ArtText(
                                              upgrade.title,
                                              color: zone5Ink,
                                              fontSize: 26,
                                              align: TextAlign.left,
                                            ),
                                          ),
                                          Expanded(
                                            child: Zone5ArtText(
                                              upgrade.description,
                                              color: zone5Ink,
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
                                        key: Key('zone5-install-${upgrade.id}'),
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
                                        child: Zone5ArtText(
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
                              'VOLTAR ÀS GRANDES VIAS',
                              style: TextStyle(color: zone5Gold, fontSize: 24),
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
