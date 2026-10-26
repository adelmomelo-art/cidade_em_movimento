import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';
import '../../data/zone_1/mission_01_data.dart';
import '../../data/zone_1/mission_02_data.dart';
import '../../data/zone_1/mission_03_data.dart';
import '../../data/zone_1/mission_04_data.dart';
import '../../data/zone_1/mission_05_data.dart';
import '../../data/zone_1/special_mission_data.dart';
import '../build_neighborhood/build_neighborhood_screen.dart';
import '../../widgets/neighborhood_upgrade_layer.dart';
import '../../models/mission.dart';
import '../../widgets/approved_artwork_page.dart';
import '../../widgets/fortaleza_map_avatar.dart';
import '../../widgets/zone_1_approved_art.dart';
import '../../widgets/zone_1_mission_dialog.dart';

class Zone1MapScreen extends StatefulWidget {
  const Zone1MapScreen({super.key, required this.controller});
  final PlayerController controller;

  @override
  State<Zone1MapScreen> createState() => _Zone1MapScreenState();
}

class _Zone1MapScreenState extends State<Zone1MapScreen> {
  PlayerController get controller => widget.controller;
  bool _night = false;
  bool _openingMission = false;
  bool _openingUpgrades = false;

  static const _pins = [
    ('Z1_M01', 'Travessia Segura', Rect.fromLTWH(155, 599, 226, 111)),
    ('Z1_M02', 'Embarque Seguro', Rect.fromLTWH(572, 445, 205, 111)),
    ('Z1_M03', 'Bicicleta na Rota Escolar', Rect.fromLTWH(752, 626, 252, 109)),
    ('Z1_M04', 'Só um Minutinho', Rect.fromLTWH(1001, 357, 212, 119)),
    ('Z1_M05', 'Caminho Seguro', Rect.fromLTWH(1360, 482, 229, 124)),
    ('Z1_SPECIAL', 'Saída da Escola', Rect.fromLTWH(1230, 697, 320, 162)),
  ];

  static Mission? _missionForId(String id, PlayerType type) => switch (id) {
    'Z1_M01' => buildZone1Mission01(type),
    'Z1_M02' => buildZone1Mission02(type),
    'Z1_M03' => buildZone1Mission03(type),
    'Z1_M04' => buildZone1Mission04(type),
    'Z1_M05' => buildZone1Mission05(type),
    'Z1_SPECIAL' => buildZone1SpecialMission(type),
    _ => null,
  };

  Future<void> _openMission(String id) async {
    if (_openingMission || !controller.progress.unlockedMissions.contains(id)) {
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
        key: const Key('zone1-map-canvas'),
        child: Zone1ArtworkBoard(
          asset: zone1MapArtwork,
          captureKey: const Key('zone1-map-artwork'),
          children: [
            Positioned.fill(
              child: Zone1NightLayer(
                key: const Key('zone1-map-night'),
                night: _night,
                lighting: controller.progress.purchasedUpgrades.contains(
                  'ILUMINACAO_ESCOLAR',
                ),
              ),
            ),
            Positioned.fill(
              child: NeighborhoodUpgradeLayer(
                zoneId: 'ZONE_1',
                mapArtwork: zone1MapArtwork,
                purchased: controller.progress.purchasedUpgrades,
                night: _night,
              ),
            ),
            Positioned(
              left: 0,
              top: 218,
              width: 424,
              height: 380,
              child: IgnorePointer(
                child: Semantics(
                  key: const Key('zone1-mentor-panel'),
                  label:
                      'Melo: Vamos explorar o bairro? Escolha uma missão e aprenda comigo!',
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned(
              left: 1176,
              top: 43,
              width: 480,
              height: 96,
              child: Zone1LiveHud(
                key: const Key('zone1-score-hud'),
                player: controller,
              ),
            ),
            Positioned(
              left: 176,
              top: 696,
              width: 95,
              height: 150,
              child: IgnorePointer(
                child: FortalezaMapAvatar(profile: controller.profile),
              ),
            ),
            Positioned.fill(
              child: Stack(
                key: const Key('zone1-mission-window'),
                children: [for (final pin in _pins) _pin(pin)],
              ),
            ),
            Positioned(
              left: 16,
              top: 22,
              width: 68,
              height: 70,
              child: ArtworkAction(
                key: const Key('zone1-back-to-fortaleza'),
                label: 'Voltar ao mapa de Fortaleza',
                hint: 'Mapa de Fortaleza',
                onPressed: _back,
              ),
            ),
            Positioned(
              left: 430,
              top: 870,
              width: 755,
              height: 65,
              child: _navigation(),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _pin((String, String, Rect) pin) {
    final unlocked = controller.progress.unlockedMissions.contains(pin.$1);
    final stars = controller.progress.missionStars[pin.$1] ?? 0;
    final special = pin.$1 == 'Z1_SPECIAL';
    return Positioned.fromRect(
      rect: pin.$3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (special && unlocked) ...[
            const Positioned(
              left: 24,
              top: 26,
              width: 50,
              height: 48,
              child: ColoredBox(
                color: Color(0xFF112D48),
                child: Icon(Icons.flag_rounded, color: zone1Gold, size: 45),
              ),
            ),
            Positioned(
              left: 108,
              top: 82,
              width: 204,
              height: 49,
              child: ColoredBox(
                color: const Color(0xFFDCE7FC),
                child: Zone1ArtText(
                  stars > 0 ? 'Missão concluída' : 'Toque para jogar',
                  color: zone1Ink,
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
                  color: zone1Ink,
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
                  color: zone1Ink,
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
                        color: zone1Gold,
                      ),
                  ],
                ),
              ),
            ),
          ArtworkAction(
            key: Key('zone1-visual-mission-${pin.$1}'),
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
    key: const Key('zone1-navigation-window'),
    decoration: BoxDecoration(
      color: zone1Ink,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: zone1Cyan, width: 2),
    ),
    child: Row(
      children: [
        _navButton(
          'zone1-toggle-night',
          _night ? 'Dia' : 'Noite',
          _night ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          () => setState(() => _night = !_night),
        ),
        _navButton(
          'zone1-open-progress',
          'Progresso',
          Icons.insights_rounded,
          () => Navigator.of(context).pushNamed(AppRoutes.playerProgress),
        ),
        _navButton(
          'zone1-open-upgrades',
          'Melhorias',
          Icons.construction_rounded,
          _showUpgrades,
        ),
        if (controller.isZoneUnlocked('ZONE_2'))
          _navButton(
            'zone1-advance-zone2',
            'Próxima zona',
            Icons.arrow_forward_rounded,
            () => Navigator.of(context).pushNamed(AppRoutes.zone2),
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
        child: Zone1ArtText(text, fontSize: 24, maxLines: 1),
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
            initialZoneId: 'ZONE_1',
          ),
        ),
      );
    } finally {
      _openingUpgrades = false;
    }
  }
}
