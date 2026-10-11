import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';

class FortalezaMapScreen extends StatelessWidget {
  const FortalezaMapScreen({super.key, required this.controller});

  final PlayerController controller;

  static const _zones = <_FortalezaZone>[
    _FortalezaZone(
      id: 'ZONE_1',
      number: 1,
      title: 'Bairro / Escola',
      subtitle: 'Seguranca no caminho e convivencia no bairro',
      medal: 'Protetor da Escola',
      route: AppRoutes.zone1,
      icon: Icons.school_rounded,
    ),
    _FortalezaZone(
      id: 'ZONE_2',
      number: 2,
      title: 'Centro Historico',
      subtitle: 'Fluxos, calcadas, pontos e convivencia',
      medal: 'Guardiao do Centro',
      route: AppRoutes.zone2,
      icon: Icons.account_balance_rounded,
    ),
    _FortalezaZone(
      id: 'ZONE_3',
      number: 3,
      title: 'Orla / Praia de Iracema',
      subtitle: 'Mobilidade e convivencia na orla',
      medal: 'Guardiao da Orla',
      route: AppRoutes.zone3,
      icon: Icons.waves_rounded,
    ),
    _FortalezaZone(
      id: 'ZONE_4',
      number: 4,
      title: 'Cultura / Eventos',
      subtitle: 'Mobilidade em grandes encontros',
      medal: 'Guardiao da Cultura',
      route: AppRoutes.zone4,
      icon: Icons.celebration_rounded,
    ),
    _FortalezaZone(
      id: 'ZONE_5',
      number: 5,
      title: 'Grandes Vias',
      subtitle: 'Velocidade, distancia e previsibilidade',
      medal: 'Guardiao das Vias',
      route: AppRoutes.zone5,
      icon: Icons.alt_route_rounded,
    ),
    _FortalezaZone(
      id: 'ZONE_6',
      number: 6,
      title: 'Polo Castelao',
      subtitle: 'Mobilidade em dias de jogo',
      medal: 'Guardiao do Castelao',
      route: AppRoutes.zone6,
      icon: Icons.stadium_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = controller.progress;
        final completed = progress.completedZones.length.clamp(0, 6);
        final medals = progress.medals.length.clamp(0, 6);
        final totalStars = progress.missionStars.values.fold<int>(
          0,
          (sum, stars) => sum + stars,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mapa de Fortaleza'),
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
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _CityHeader(
                          completedZones: completed,
                          medals: medals,
                          totalStars: totalStars,
                        ),
                        const SizedBox(height: 18),
                        _SignDuelCard(controller: controller),
                        const SizedBox(height: 18),
                        for (var index = 0; index < _zones.length; index++) ...[
                          _ZoneCard(
                            zone: _zones[index],
                            unlocked: controller.isZoneUnlocked(
                              _zones[index].id,
                            ),
                            completed: progress.completedZones.contains(
                              _zones[index].id,
                            ),
                            medalEarned: progress.medals.contains(
                              _medalIdForZone(_zones[index].id),
                            ),
                          ),
                          if (index < _zones.length - 1)
                            const _RouteConnector(),
                        ],
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

  static String _medalIdForZone(String zoneId) {
    switch (zoneId) {
      case 'ZONE_1':
        return 'PROTETOR_DA_ESCOLA';
      case 'ZONE_2':
        return 'GUARDIAO_DO_CENTRO';
      case 'ZONE_3':
        return 'GUARDIAO_DA_ORLA';
      case 'ZONE_4':
        return 'GUARDIAO_DA_CULTURA';
      case 'ZONE_5':
        return 'GUARDIAO_DAS_VIAS';
      case 'ZONE_6':
        return 'GUARDIAO_DO_CASTELAO';
      default:
        return '';
    }
  }
}

class _CityHeader extends StatelessWidget {
  const _CityHeader({
    required this.completedZones,
    required this.medals,
    required this.totalStars,
  });

  final int completedZones;
  final int medals;
  final int totalStars;

  @override
  Widget build(BuildContext context) {
    final ratio = completedZones / 6;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.location_city_rounded, size: 64),
            const SizedBox(height: 12),
            Text(
              'Fortaleza em Movimento',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Percorra as seis zonas, tome boas decisoes e transforme a '
              'cidade ao longo da sua jornada.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            LinearProgressIndicator(
              key: const Key('fortaleza-global-progress'),
              value: ratio,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Text(
              '$completedZones de 6 zonas concluidas',
              key: const Key('fortaleza-zone-count'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    icon: Icons.emoji_events_rounded,
                    value: '$medals/6',
                    label: 'Medalhas',
                  ),
                ),
                Expanded(
                  child: _Metric(
                    icon: Icons.star_rounded,
                    value: '$totalStars',
                    label: 'Estrelas',
                  ),
                ),
                Expanded(
                  child: _Metric(
                    icon: Icons.map_rounded,
                    value: '$completedZones/6',
                    label: 'Zonas',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SignDuelCard extends StatelessWidget {
  const _SignDuelCard({required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final progress = controller.progress;

    return Card(
      key: const Key('fortaleza-sign-duel'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.signDuel);
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                child: Icon(Icons.signpost_rounded, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESAFIO EXTRA',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Duelo das Placas',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Teste seu conhecimento em seis rodadas de dificuldade progressiva.',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      progress.signDuelPlays == 0
                          ? 'Ainda nao jogado'
                          : 'Recorde: ${progress.signDuelBestScore} pontos - ${progress.signDuelBestCorrect}/6',
                      key: const Key('fortaleza-sign-duel-status'),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteConnector extends StatelessWidget {
  const _RouteConnector();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Center(
        child: Container(
          width: 3,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  const _ZoneCard({
    required this.zone,
    required this.unlocked,
    required this.completed,
    required this.medalEarned,
  });

  final _FortalezaZone zone;
  final bool unlocked;
  final bool completed;
  final bool medalEarned;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final status = completed
        ? 'CONCLUIDA'
        : unlocked
        ? 'DISPONIVEL'
        : 'BLOQUEADA';

    final statusIcon = completed
        ? Icons.check_circle_rounded
        : unlocked
        ? Icons.lock_open_rounded
        : Icons.lock_rounded;

    return Card(
      key: Key('fortaleza-zone-${zone.id}'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: unlocked
            ? () {
                Navigator.of(context).pushNamed(zone.route);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: completed
                    ? scheme.primaryContainer
                    : scheme.surfaceContainerHighest,
                child: Icon(
                  zone.icon,
                  color: completed
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ZONA ${zone.number}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      zone.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(zone.subtitle),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Chip(
                          key: Key('fortaleza-status-${zone.id}'),
                          avatar: Icon(statusIcon, size: 18),
                          label: Text(status),
                        ),
                        if (medalEarned)
                          Chip(
                            key: Key('fortaleza-medal-${zone.id}'),
                            avatar: const Icon(
                              Icons.workspace_premium_rounded,
                              size: 18,
                            ),
                            label: Text(zone.medal),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                unlocked ? Icons.chevron_right_rounded : Icons.block_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FortalezaZone {
  const _FortalezaZone({
    required this.id,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.medal,
    required this.route,
    required this.icon,
  });

  final String id;
  final int number;
  final String title;
  final String subtitle;
  final String medal;
  final String route;
  final IconData icon;
}
