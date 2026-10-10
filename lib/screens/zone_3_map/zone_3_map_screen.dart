import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../data/zone_3/upgrade_data.dart';

class Zone3MapScreen extends StatelessWidget {
  const Zone3MapScreen({super.key, required this.controller});

  final PlayerController controller;

  static const _missions = [
    ('Z3_M01', 'Travessia na Beira-Mar'),
    ('Z3_M02', 'Ciclovia Compartilhada'),
    ('Z3_M03', 'Desembarque na Orla'),
    ('Z3_M04', 'Olhos na Orla'),
    ('Z3_M05', 'Fluxo da Praia'),
    ('Z3_SPECIAL', 'Orla em Equil\u00edbrio'),
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
            title: const Text('Orla / Praia de Iracema'),
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
                SliverToBoxAdapter(
                  child: _ScoreBar(
                    citizenship: progress.citizenshipXp,
                    knowledge: progress.knowledge,
                    coins: progress.coins,
                    stars: totalStars,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (progress.isZoneCompleted('ZONE_3')) ...[
                        const _ZoneCompletedCard(),
                        const SizedBox(height: 16),
                      ],
                      const _OrlaCard(),
                      const SizedBox(height: 16),
                      const _UpgradePreview(),
                      const SizedBox(height: 20),
                      Text(
                        'Miss\u00f5es da Zona 3',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Complete as cinco miss\u00f5es, alcance pelo menos '
                        '9 estrelas e libere o desafio final.',
                      ),
                      const SizedBox(height: 12),
                      for (var index = 0; index < _missions.length; index++)
                        _MissionTile(
                          number: index + 1,
                          id: _missions[index].$1,
                          title: _missions[index].$2,
                          unlocked: progress.unlockedMissions.contains(
                            _missions[index].$1,
                          ),
                          stars:
                              progress.missionStars[_missions[index].$1] ?? 0,
                          special: _missions[index].$1 == 'Z3_SPECIAL',
                        ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ZoneCompletedCard extends StatelessWidget {
  const _ZoneCompletedCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.emoji_events_rounded, size: 30),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zona 3 conclu\u00edda',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text('Medalha: Guardi\u00e3o da Orla'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrlaCard extends StatelessWidget {
  const _OrlaCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.beach_access_rounded, size: 72),
            const SizedBox(height: 12),
            Text('ZONA 3', style: Theme.of(context).textTheme.labelLarge),
            Text(
              'Orla / Praia de Iracema',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Mobilidade e Conviv\u00eancia na Orla',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Pedestres, ciclistas, passageiros e condutores aprendem a '
              'compartilhar um dos espa\u00e7os mais movimentados de Fortaleza.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpgradePreview extends StatelessWidget {
  const _UpgradePreview();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transforma\u00e7\u00f5es da orla',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'As melhorias j\u00e1 est\u00e3o definidas. A compra e a '
              'transforma\u00e7\u00e3o visual entram no pr\u00f3ximo pacote.',
            ),
            const SizedBox(height: 12),
            for (final upgrade in zone3Upgrades)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.add_road_rounded, size: 22),
                    const SizedBox(width: 10),
                    Expanded(child: Text(upgrade.title)),
                    Text('${upgrade.cost} moedas'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.citizenship,
    required this.knowledge,
    required this.coins,
    required this.stars,
  });

  final int citizenship;
  final int knowledge;
  final int coins;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            _ScoreItem(
              icon: Icons.workspace_premium_rounded,
              value: citizenship,
              label: 'Cidadania',
            ),
            _ScoreItem(
              icon: Icons.menu_book_rounded,
              value: knowledge,
              label: 'Conhecimento',
            ),
            _ScoreItem(
              icon: Icons.monetization_on_rounded,
              value: coins,
              label: 'Moedas',
            ),
            _ScoreItem(
              icon: Icons.star_rounded,
              value: stars,
              label: 'Estrelas',
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  const _ScoreItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 2),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _MissionTile extends StatelessWidget {
  const _MissionTile({
    required this.number,
    required this.id,
    required this.title,
    required this.unlocked,
    required this.stars,
    required this.special,
  });

  final int number;
  final String id;
  final String title;
  final bool unlocked;
  final int stars;
  final bool special;

  String? get _route {
    switch (id) {
      case 'Z3_M01':
        return AppRoutes.zone3Mission1;
      case 'Z3_M02':
        return AppRoutes.zone3Mission2;
      case 'Z3_M03':
        return AppRoutes.zone3Mission3;
      case 'Z3_M04':
        return AppRoutes.zone3Mission4;
      case 'Z3_M05':
        return AppRoutes.zone3Mission5;
      case 'Z3_SPECIAL':
        return AppRoutes.zone3SpecialMission;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = _route;
    final canOpen = unlocked && route != null;
    final subtitle = unlocked
        ? (stars == 0
              ? 'Dispon\u00edvel'
              : '${'\u2605' * stars}${'\u2606' * (3 - stars)}')
        : 'Bloqueada';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: canOpen
            ? () {
                Navigator.of(context).pushNamed(route);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              CircleAvatar(
                child: Icon(
                  unlocked
                      ? (special ? Icons.flag_rounded : Icons.lock_open_rounded)
                      : Icons.lock_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      special
                          ? 'Miss\u00e3o Especial \u2014 $title'
                          : '$number. $title',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(subtitle),
                  ],
                ),
              ),
              if (canOpen) ...[
                const SizedBox(width: 12),
                const Icon(Icons.play_circle_outline_rounded),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
