import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';
import '../../data/zones/zone_catalog.dart';
import '../../services/global_progress_service.dart';
import '../../widgets/approved_artwork_page.dart';
import '../../widgets/fortaleza_map_avatar.dart';
import '../../widgets/fortaleza_boats.dart';
import '../../widgets/zone_1_approved_art.dart';

class FortalezaMapScreen extends StatelessWidget {
  const FortalezaMapScreen({super.key, required this.controller});

  final PlayerController controller;
  static const artworkAsset = 'assets/fortaleza/mapa_sem_barcos_r28.png';
  static const artworkSize = Size(1672, 941);
  static const _zones = [
    (
      id: 'ZONE_1',
      title: 'Bairro / Escola',
      route: AppRoutes.zone1,
      bounds: Rect.fromLTWH(28, 516, 316, 126),
      status: Rect.fromLTWH(275, 572, 70, 68),
    ),
    (
      id: 'ZONE_2',
      title: 'Centro Histórico',
      route: AppRoutes.zone2,
      bounds: Rect.fromLTWH(396, 439, 299, 116),
      status: Rect.fromLTWH(632, 479, 64, 64),
    ),
    (
      id: 'ZONE_3',
      title: 'Orla / Praia de Iracema',
      route: AppRoutes.zone3,
      bounds: Rect.fromLTWH(1314, 230, 288, 115),
      status: Rect.fromLTWH(1543, 279, 62, 64),
    ),
    (
      id: 'ZONE_4',
      title: 'Zona Cultural',
      route: AppRoutes.zone4,
      bounds: Rect.fromLTWH(847, 291, 298, 125),
      status: Rect.fromLTWH(1084, 340, 62, 61),
    ),
    (
      id: 'ZONE_5',
      title: 'Grandes Vias',
      route: AppRoutes.zone5,
      bounds: Rect.fromLTWH(784, 625, 295, 122),
      status: Rect.fromLTWH(1017, 673, 64, 62),
    ),
    (
      id: 'ZONE_6',
      title: 'Polo Castelão',
      route: AppRoutes.zone6,
      bounds: Rect.fromLTWH(1313, 657, 297, 125),
      status: Rect.fromLTWH(1550, 711, 63, 63),
    ),
  ];

  String _status(String id) => controller.progress.completedZones.contains(id)
      ? 'CONCLUIDA'
      : controller.isZoneUnlocked(id)
      ? 'DISPONIVEL'
      : 'BLOQUEADA';

  void _open(BuildContext context, String route) =>
      Navigator.of(context).pushNamed(route);

  void _menu(BuildContext context) {
    final progress = controller.progress;
    final summary = const GlobalProgressService().summarize(progress);
    final navigator = Navigator.of(context);
    void open(String route) {
      navigator.pop();
      navigator.pushNamed(route);
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mais opções'),
        content: SizedBox(
          width: 360,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  key: const Key('fortaleza-faixita'),
                  leading: const Icon(Icons.support_agent_rounded),
                  title: const Text('Faixita'),
                  onTap: () => open(AppRoutes.faixita),
                ),
                ListTile(
                  key: const Key('fortaleza-sign-duel'),
                  leading: const Icon(Icons.signpost_rounded),
                  title: const Text('Duelo das Placas'),
                  subtitle: Text(
                    progress.signDuelPlays == 0
                        ? 'Ainda nao jogado'
                        : 'Recorde: ${progress.signDuelBestScore} pontos - ${progress.signDuelBestCorrect}/6',
                    key: const Key('fortaleza-sign-duel-status'),
                  ),
                  onTap: () => open(AppRoutes.signDuel),
                ),
                ListTile(
                  leading: const Icon(Icons.insights_rounded),
                  title: const Text('Progressao Global'),
                  subtitle: Text(
                    '${summary.completionPercent}% - ${summary.completedMissions}/${summary.totalMissions} missoes',
                    key: const Key('fortaleza-global-summary-status'),
                  ),
                  onTap: () => open(AppRoutes.globalProgress),
                ),
                ListTile(
                  leading: const Icon(Icons.home_rounded),
                  title: const Text('Tela inicial'),
                  onTap: () {
                    navigator.pop();
                    if (navigator.canPop()) {
                      navigator.popUntil((route) => route.isFirst);
                    } else {
                      navigator.pushReplacementNamed(AppRoutes.home);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('FECHAR'),
          ),
        ],
      ),
    );
  }

  Widget _action(
    BuildContext context,
    Rect rect,
    String key,
    String label,
    String route,
  ) => Positioned.fromRect(
    rect: rect,
    child: ArtworkAction(
      key: Key(key),
      label: label,
      hint: 'Abrir $label',
      onPressed: () => _open(context, route),
    ),
  );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      final progress = controller.progress;
      final completed = zoneCatalog
          .where((zone) => progress.completedZones.contains(zone.id))
          .length;
      final currentZone = _zones.firstWhere(
        (zone) =>
            controller.isZoneUnlocked(zone.id) &&
            !progress.completedZones.contains(zone.id),
        orElse: () => _zones.first,
      );
      return ApprovedArtworkPage(
        asset: artworkAsset,
        backgroundKey: const Key('fortaleza-background-r28'),
        size: artworkSize,
        prefix: 'fortaleza',
        description:
            'Mapa de Fortaleza. Ponte dos Ingleses na Praia de Iracema, Farol do Mucuripe. Melo, seu guia. Seis zonas da cidade.',
        actions: [
          Positioned.fromRect(
            rect: FortalezaBoats.bounds,
            child: const FortalezaBoats(),
          ),
          // Only this small patch uses the edited image. All other scenery and
          // lettering come directly from the exact user-approved artwork.
          Positioned.fromRect(
            rect: const Rect.fromLTWH(327, 630, 112, 161),
            child: IgnorePointer(
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  minWidth: 1672,
                  maxWidth: 1672,
                  minHeight: 941,
                  maxHeight: 941,
                  child: Transform.translate(
                    offset: const Offset(-327, -630),
                    child: Image.asset(
                      'assets/fortaleza/mapa_sem_avatar_r27.png',
                      fit: BoxFit.fill,
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fromRect(
            rect: const Rect.fromLTWH(327, 629, 112, 161),
            child: Semantics(
              key: const Key('fortaleza-start-avatar'),
              image: true,
              label:
                  'INÍCIO. Personagem escolhido: ${controller.profile?.type.label ?? 'Criança'}.',
              child: IgnorePointer(
                child: FortalezaMapAvatar(profile: controller.profile),
              ),
            ),
          ),
          Positioned.fromRect(
            rect: const Rect.fromLTWH(1060, 25, 503, 74),
            child: DecoratedBox(
              key: const Key('fortaleza-standard-hud'),
              decoration: BoxDecoration(
                color: zone1Ink,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF42A9E3), width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 58,
                      height: 58,
                      child: Semantics(
                        image: true,
                        label: 'Seu personagem',
                        child: FortalezaMapAvatar(
                          profile: controller.profile,
                          portrait: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    for (final metric in [
                      (
                        key: 'citizenship',
                        label: 'Cidadania',
                        value: progress.citizenshipXp,
                        icon: Icons.shield_rounded,
                        color: Colors.lightGreenAccent,
                      ),
                      (
                        key: 'knowledge',
                        label: 'Conhecimento',
                        value: progress.knowledge,
                        icon: Icons.menu_book_rounded,
                        color: Colors.purpleAccent,
                      ),
                      (
                        key: 'coins',
                        label: 'Moedas',
                        value: progress.coins,
                        icon: Icons.monetization_on_rounded,
                        color: zone1Gold,
                      ),
                      (
                        key: 'stars',
                        label: 'Estrelas',
                        value: progress.missionStars.values.fold<int>(
                          0,
                          (total, stars) => total + stars,
                        ),
                        icon: Icons.star_rounded,
                        color: zone1Gold,
                      ),
                    ])
                      Expanded(
                        child: Tooltip(
                          message: '${metric.label}: ${metric.value}',
                          child: _Metric(
                            key: Key('fortaleza-${metric.key}'),
                            label: metric.label,
                            value: metric.value,
                            icon: metric.icon,
                            color: metric.color,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fromRect(
            rect: const Rect.fromLTWH(1568, 29, 76, 69),
            child: ArtworkAction(
              key: const Key('fortaleza-menu-button'),
              label: 'Mais opções',
              hint: 'Faixita, Duelo das Placas, progresso e tela inicial',
              onPressed: () => _menu(context),
            ),
          ),
          for (final zone in _zones) ...[
            Positioned.fromRect(
              rect: zone.status,
              child: IgnorePointer(
                child: _ZoneIndicator(
                  key: Key('fortaleza-status-${zone.id}'),
                  status: _status(zone.id),
                  square: zone.id == 'ZONE_1',
                ),
              ),
            ),
            if (progress.medals.contains(findZoneById(zone.id)!.medalId))
              Positioned(
                left: zone.bounds.left + 28,
                top: zone.bounds.top + 69,
                width: 28,
                height: 28,
                child: Tooltip(
                  key: Key('fortaleza-medal-${zone.id}'),
                  message: 'Medalha conquistada',
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFFFC107),
                    size: 28,
                    shadows: [Shadow(color: Colors.black87, blurRadius: 3)],
                  ),
                ),
              ),
            Positioned.fromRect(
              rect: zone.bounds,
              child: ArtworkAction(
                key: Key('fortaleza-zone-${zone.id}'),
                label: zone.title,
                hint: _status(zone.id),
                onPressed: controller.isZoneUnlocked(zone.id)
                    ? () => _open(context, zone.route)
                    : null,
              ),
            ),
          ],
          // The decorative secondary lock over Zone 4 must reflect its state.
          Positioned.fromRect(
            rect: const Rect.fromLTWH(1044, 262, 44, 44),
            child: IgnorePointer(
              child: _ZoneIndicator(status: _status('ZONE_4')),
            ),
          ),
          _action(
            context,
            const Rect.fromLTWH(28, 829, 268, 91),
            'fortaleza-missions-button',
            'MINHAS MISSÕES',
            currentZone.route,
          ),
          _action(
            context,
            const Rect.fromLTWH(304, 829, 284, 91),
            'fortaleza-build-neighborhood',
            'MINHA CIDADE',
            AppRoutes.buildNeighborhood,
          ),
          _action(
            context,
            const Rect.fromLTWH(598, 829, 278, 91),
            'fortaleza-medals-button',
            'MEDALHAS',
            AppRoutes.playerProgress,
          ),
          Positioned.fromRect(
            rect: const Rect.fromLTWH(889, 823, 755, 98),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF24C7EF), width: 1.5),
                gradient: const LinearGradient(
                  colors: [Color(0xFF003B5A), Color(0xFF061C36)],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: Column(
                children: [
                  Text(
                    'PROGRESSÃO DA CIDADE • $completed/6',
                    key: const Key('fortaleza-zone-count'),
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Expanded(
                    child: Row(
                      children: [
                        for (var i = 0; i < _zones.length; i++)
                          Expanded(
                            child: Semantics(
                              label:
                                  '${_zones[i].title}: ${_status(_zones[i].id)}',
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 38,
                                    height: 38,
                                    child: _ProgressNode(
                                      number: i + 1,
                                      status: _status(_zones[i].id),
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    [
                                      'Bairro / Escola',
                                      'Centro Histórico',
                                      'Orla / Iracema',
                                      'Zona Cultural',
                                      'Grandes Vias',
                                      'Castelão',
                                    ][i],
                                    textScaler: TextScaler.noScaling,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
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
          _action(
            context,
            const Rect.fromLTWH(889, 823, 755, 98),
            'fortaleza-global-summary',
            'Progressão da cidade',
            AppRoutes.globalProgress,
          ),
        ],
      );
    },
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: $value',
    child: Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: color),
              Expanded(
                child: Zone1ArtText('$value', fontSize: 26, maxLines: 1),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 24,
          child: Zone1ArtText(label, fontSize: 17, maxLines: 1),
        ),
      ],
    ),
  );
}

class _ZoneIndicator extends StatelessWidget {
  const _ZoneIndicator({super.key, required this.status, this.square = false});
  final String status;
  final bool square;

  @override
  Widget build(BuildContext context) {
    final available = status != 'BLOQUEADA';
    return Semantics(
      label: status,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: square ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: square ? BorderRadius.circular(18) : null,
          border: Border.all(color: Colors.white, width: 3),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: available
                ? const [Color(0xFF5AF02B), Color(0xFF008323)]
                : const [Color(0xFF51677B), Color(0xFF102438)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => Icon(
            status == 'CONCLUIDA'
                ? Icons.check_rounded
                : available
                ? Icons.play_arrow_rounded
                : Icons.lock_rounded,
            color: Colors.white,
            size: constraints.maxHeight * .63,
          ),
        ),
      ),
    );
  }
}

class _ProgressNode extends StatelessWidget {
  const _ProgressNode({required this.number, required this.status});
  final int number;
  final String status;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: status == 'CONCLUIDA'
          ? const Color(0xFFD29400)
          : status == 'DISPONIVEL'
          ? const Color(0xFF13872B)
          : const Color(0xFF596878),
      border: Border.all(color: Colors.white70, width: 2),
    ),
    alignment: Alignment.center,
    child: Text(
      '$number',
      textScaler: TextScaler.noScaling,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 23,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
