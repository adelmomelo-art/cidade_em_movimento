import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';
import '../../data/zone_3/mission_01_data.dart';
import '../../data/zone_3/mission_02_data.dart';
import '../../data/zone_3/mission_03_data.dart';
import '../../data/zone_3/mission_04_data.dart';
import '../../data/zone_3/mission_05_data.dart';
import '../../data/zone_3/special_mission_data.dart';
import '../build_neighborhood/build_neighborhood_screen.dart';
import '../../widgets/neighborhood_upgrade_layer.dart';
import '../../models/mission.dart';
import '../../widgets/approved_artwork_page.dart';
import '../../widgets/fortaleza_map_avatar.dart';
import '../../widgets/zone_3_approved_art.dart';
import '../../widgets/zone_3_mission_dialog.dart';

class Zone3MapScreen extends StatefulWidget {
  const Zone3MapScreen({super.key, required this.controller});
  final PlayerController controller;

  @override
  State<Zone3MapScreen> createState() => _Zone3MapScreenState();
}

class _Zone3MapScreenState extends State<Zone3MapScreen> {
  PlayerController get controller => widget.controller;
  bool _night = false;
  bool _openingUpgrades = false;
  bool _openingMission = false;

  static const _pins = [
    ('Z3_M01', 'Travessia na Beira-Mar', Rect.fromLTWH(471, 525, 229, 110)),
    ('Z3_M02', 'Ciclovia Compartilhada', Rect.fromLTWH(714, 372, 224, 108)),
    ('Z3_M03', 'Desembarque na Orla', Rect.fromLTWH(871, 549, 227, 110)),
    ('Z3_M04', 'Olhos na Orla', Rect.fromLTWH(996, 335, 224, 108)),
    ('Z3_M05', 'Fluxo da Praia', Rect.fromLTWH(1389, 444, 240, 114)),
    ('Z3_SPECIAL', 'Orla em Equilíbrio', Rect.fromLTWH(1307, 667, 290, 135)),
  ];

  static Mission? _missionForId(String id, PlayerType type) => switch (id) {
    'Z3_M01' => buildZone3Mission01(type),
    'Z3_M02' => buildZone3Mission02(type),
    'Z3_M03' => buildZone3Mission03(type),
    'Z3_M04' => buildZone3Mission04(type),
    'Z3_M05' => buildZone3Mission05(type),
    'Z3_SPECIAL' => buildZone3SpecialMission(type),
    _ => null,
  };

  Future<void> _openMission(String id) async {
    if (_openingMission ||
        !controller.isZoneUnlocked('ZONE_3') ||
        !controller.progress.unlockedMissions.contains(id)) {
      return;
    }
    final type = controller.profile?.type;
    if (type == null) {
      return;
    }
    final mission = _missionForId(id, type);
    if (mission == null) {
      return;
    }
    _openingMission = true;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        routeSettings: RouteSettings(name: '/zone-3/dialog/$id'),
        builder: (_) => Zone3MissionDialog(
          mission: mission,
          player: controller,
          nightPreview: _night,
          nextMissionId: switch (id) {
            'Z3_M01' => 'Z3_M02',
            'Z3_M02' => 'Z3_M03',
            'Z3_M03' => 'Z3_M04',
            'Z3_M04' => 'Z3_M05',
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
    if (!found) {
      nav.pushReplacementNamed(AppRoutes.fortalezaMap);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => Scaffold(
      body: ClipRRect(
        key: const Key('zone3-map-canvas'),
        child: Zone3ArtworkBoard(
          asset: zone3MapArtwork,
          captureKey: const Key('zone3-map-artwork'),
          children: [
            Positioned.fill(
              child: Zone3NightLayer(
                key: const Key('zone3-map-night'),
                night: _night,
                lighting: false,
              ),
            ),
            Positioned.fill(
              child: NeighborhoodUpgradeLayer(
                zoneId: 'ZONE_3',
                purchased: controller.progress.purchasedUpgrades,
                night: _night,
              ),
            ),
            Positioned(
              left: 0,
              top: 505,
              width: 386,
              height: 436,
              child: IgnorePointer(
                child: Semantics(
                  key: const Key('zone3-mentor-panel'),
                  label:
                      'Melo: Vamos explorar a orla? Observe os fluxos e escolha sua missão!',
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned(
              left: 1061,
              top: 28,
              width: 590,
              height: 89,
              child: Zone3LiveHud(
                key: const Key('zone3-score-hud'),
                player: controller,
              ),
            ),
            Positioned(
              left: 365,
              top: 634,
              width: 88,
              height: 150,
              child: IgnorePointer(
                child: FortalezaMapAvatar(profile: controller.profile),
              ),
            ),
            Positioned.fill(
              child: Stack(
                key: const Key('zone3-mission-window'),
                children: [for (final pin in _pins) _pin(pin)],
              ),
            ),
            Positioned(
              left: 30,
              top: 33,
              width: 68,
              height: 70,
              child: ArtworkAction(
                key: const Key('zone3-back-to-fortaleza'),
                label: 'Voltar ao mapa de Fortaleza',
                hint: 'Mapa de Fortaleza',
                onPressed: _back,
              ),
            ),
            if (!controller.isZoneUnlocked('ZONE_3'))
              const Positioned(
                left: 720,
                top: 122,
                width: 700,
                height: 66,
                child: ColoredBox(
                  color: zone3Ink,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Zone3ArtText(
                      'Conclua a Zona 2 para explorar a Orla.',
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
        controller.isZoneUnlocked('ZONE_3') &&
        controller.progress.unlockedMissions.contains(pin.$1);
    final stars = controller.progress.missionStars[pin.$1] ?? 0;
    final special = pin.$1 == 'Z3_SPECIAL';
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
                child: Icon(Icons.flag_rounded, color: zone3Gold, size: 45),
              ),
            ),
            Positioned(
              left: 87,
              top: 72,
              width: 192,
              height: 40,
              child: ColoredBox(
                color: const Color(0xFFDCE7FC),
                child: Zone3ArtText(
                  stars > 0 ? 'Missão concluída' : 'Toque para jogar',
                  color: zone3Ink,
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
                  color: zone3Ink,
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
                  color: zone3Ink,
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
                        color: zone3Gold,
                      ),
                  ],
                ),
              ),
            ),
          ArtworkAction(
            key: Key('zone3-visual-mission-${pin.$1}'),
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
    key: const Key('zone3-navigation-window'),
    decoration: BoxDecoration(
      color: zone3Ink,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: zone3Cyan, width: 2),
    ),
    child: Row(
      children: [
        _navButton(
          'zone3-toggle-night',
          _night ? 'Dia' : 'Noite',
          _night ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          () => setState(() => _night = !_night),
        ),
        _navButton(
          'zone3-open-progress',
          'Progresso',
          Icons.insights_rounded,
          () => Navigator.of(context).pushNamed(AppRoutes.playerProgress),
        ),
        _navButton(
          'zone3-open-upgrades',
          'Melhorias',
          Icons.construction_rounded,
          _showUpgrades,
        ),
        if (controller.isZoneUnlocked('ZONE_4'))
          _navButton(
            'zone3-advance-zone4',
            'Próxima zona',
            Icons.arrow_forward_rounded,
            () => Navigator.of(context).pushNamed(AppRoutes.zone4),
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
        child: Zone3ArtText(text, fontSize: 24, maxLines: 1),
      ),
    ),
  );

  Future<void> _showUpgrades() async {
    if (_openingUpgrades) {
      return;
    }
    _openingUpgrades = true;
    try {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => BuildNeighborhoodScreen(
            controller: controller,
            initialZoneId: 'ZONE_3',
          ),
        ),
      );
    } finally {
      _openingUpgrades = false;
    }
  }
}
