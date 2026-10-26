import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';
import '../../data/zone_4/mission_01_data.dart';
import '../../data/zone_4/mission_02_data.dart';
import '../../data/zone_4/mission_03_data.dart';
import '../../data/zone_4/mission_04_data.dart';
import '../../data/zone_4/mission_05_data.dart';
import '../../data/zone_4/special_mission_data.dart';
import '../build_neighborhood/build_neighborhood_screen.dart';
import '../../widgets/neighborhood_upgrade_layer.dart';
import '../../models/mission.dart';
import '../../widgets/approved_artwork_page.dart';
import '../../widgets/fortaleza_map_avatar.dart';
import '../../widgets/zone_4_approved_art.dart';
import '../../widgets/zone_4_mission_dialog.dart';

class Zone4MapScreen extends StatefulWidget {
  const Zone4MapScreen({super.key, required this.controller});
  final PlayerController controller;

  @override
  State<Zone4MapScreen> createState() => _Zone4MapScreenState();
}

class _Zone4MapScreenState extends State<Zone4MapScreen> {
  PlayerController get controller => widget.controller;
  bool _night = false;
  bool _openingUpgrades = false;
  bool _openingMission = false;

  static const _pins = [
    ('Z4_M01', 'Chegada ao Evento', Rect.fromLTWH(492, 570, 218, 120)),
    ('Z4_M02', 'Travessia com Multidão', Rect.fromLTWH(631, 359, 212, 111)),
    ('Z4_M03', 'Embarque Organizado', Rect.fromLTWH(936, 537, 205, 114)),
    ('Z4_M04', 'Área de Bloqueio', Rect.fromLTWH(1204, 273, 235, 115)),
    ('Z4_M05', 'Saída Segura', Rect.fromLTWH(1454, 433, 207, 114)),
    ('Z4_SPECIAL', 'Cidade em Festa', Rect.fromLTWH(1334, 649, 294, 146)),
  ];

  static Mission? _missionForId(String id, PlayerType type) => switch (id) {
    'Z4_M01' => buildZone4Mission01(type),
    'Z4_M02' => buildZone4Mission02(type),
    'Z4_M03' => buildZone4Mission03(type),
    'Z4_M04' => buildZone4Mission04(type),
    'Z4_M05' => buildZone4Mission05(type),
    'Z4_SPECIAL' => buildZone4SpecialMission(type),
    _ => null,
  };

  Future<void> _openMission(String id) async {
    if (_openingMission ||
        !controller.isZoneUnlocked('ZONE_4') ||
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
        routeSettings: RouteSettings(name: '/zone-4/dialog/$id'),
        builder: (_) => Zone4MissionDialog(
          mission: mission,
          player: controller,
          nightPreview: _night,
          nextMissionId: switch (id) {
            'Z4_M01' => 'Z4_M02',
            'Z4_M02' => 'Z4_M03',
            'Z4_M03' => 'Z4_M04',
            'Z4_M04' => 'Z4_M05',
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
        key: const Key('zone4-map-canvas'),
        child: Zone4ArtworkBoard(
          asset: zone4MapArtwork,
          captureKey: const Key('zone4-map-artwork'),
          children: [
            Positioned.fill(
              child: Zone4NightLayer(
                key: const Key('zone4-map-night'),
                night: _night,
                lighting: false,
              ),
            ),
            Positioned.fill(
              child: NeighborhoodUpgradeLayer(
                zoneId: 'ZONE_4',
                mapArtwork: zone4MapArtwork,
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
                  key: const Key('zone4-mentor-panel'),
                  label:
                      'Melo: Vamos ao evento? Observe os acessos e escolha sua missão!',
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned(
              left: 1061,
              top: 28,
              width: 590,
              height: 89,
              child: Zone4LiveHud(
                key: const Key('zone4-score-hud'),
                player: controller,
              ),
            ),
            Positioned(
              left: 333,
              top: 713,
              width: 88,
              height: 150,
              child: IgnorePointer(
                child: FortalezaMapAvatar(profile: controller.profile),
              ),
            ),
            Positioned.fill(
              child: Stack(
                key: const Key('zone4-mission-window'),
                children: [for (final pin in _pins) _pin(pin)],
              ),
            ),
            Positioned(
              left: 30,
              top: 33,
              width: 68,
              height: 70,
              child: ArtworkAction(
                key: const Key('zone4-back-to-fortaleza'),
                label: 'Voltar ao mapa de Fortaleza',
                hint: 'Mapa de Fortaleza',
                onPressed: _back,
              ),
            ),
            if (!controller.isZoneUnlocked('ZONE_4'))
              const Positioned(
                left: 720,
                top: 122,
                width: 700,
                height: 66,
                child: ColoredBox(
                  color: zone4Ink,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Zone4ArtText(
                      'Conclua a Zona 3 para explorar Cultura / Eventos.',
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
        controller.isZoneUnlocked('ZONE_4') &&
        controller.progress.unlockedMissions.contains(pin.$1);
    final stars = controller.progress.missionStars[pin.$1] ?? 0;
    final special = pin.$1 == 'Z4_SPECIAL';
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
                child: Icon(Icons.flag_rounded, color: zone4Gold, size: 45),
              ),
            ),
            Positioned(
              left: 87,
              top: 72,
              width: 192,
              height: 40,
              child: ColoredBox(
                color: const Color(0xFFDCE7FC),
                child: Zone4ArtText(
                  stars > 0 ? 'Missão concluída' : 'Toque para jogar',
                  color: zone4Ink,
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
                  color: zone4Ink,
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
                  color: zone4Ink,
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
                        color: zone4Gold,
                      ),
                  ],
                ),
              ),
            ),
          ArtworkAction(
            key: Key('zone4-visual-mission-${pin.$1}'),
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
    key: const Key('zone4-navigation-window'),
    decoration: BoxDecoration(
      color: zone4Ink,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: zone4Cyan, width: 2),
    ),
    child: Row(
      children: [
        _navButton(
          'zone4-toggle-night',
          _night ? 'Dia' : 'Noite',
          _night ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          () => setState(() => _night = !_night),
        ),
        _navButton(
          'zone4-open-progress',
          'Progresso',
          Icons.insights_rounded,
          () => Navigator.of(context).pushNamed(AppRoutes.playerProgress),
        ),
        _navButton(
          'zone4-open-upgrades',
          'Melhorias',
          Icons.construction_rounded,
          _showUpgrades,
        ),
        if (controller.isZoneUnlocked('ZONE_5'))
          _navButton(
            'zone4-advance-zone5',
            'Próxima zona',
            Icons.arrow_forward_rounded,
            () => Navigator.of(context).pushNamed(AppRoutes.zone5),
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
        child: Zone4ArtText(text, fontSize: 24, maxLines: 1),
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
            initialZoneId: 'ZONE_4',
          ),
        ),
      );
    } finally {
      _openingUpgrades = false;
    }
  }
}
