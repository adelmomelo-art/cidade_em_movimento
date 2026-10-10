import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../data/zone_2/upgrade_data.dart';

class Zone2MapScreen extends StatelessWidget {
  const Zone2MapScreen({super.key, required this.controller});

  final PlayerController controller;

  static const _missions = [
    ('Z2_M01', 'Cruzamento em Movimento'),
    ('Z2_M02', 'Ponto Certo'),
    ('Z2_M03', 'Cal\u00e7ada \u00e9 de Todos'),
    ('Z2_M04', 'S\u00f3 Vou Parar Aqui'),
    ('Z2_M05', 'Rotas que se Encontram'),
    ('Z2_SPECIAL', 'Centro em Harmonia'),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = controller.progress;

        return Scaffold(
          appBar: AppBar(title: const Text('Centro Hist\u00f3rico')),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const _ZoneHeader(),
                      const SizedBox(height: 16),
                      _EconomyCard(coins: progress.coins),
                      const SizedBox(height: 16),
                      const _UpgradePreview(),
                      const SizedBox(height: 20),
                      Text(
                        'Miss\u00f5es da Zona 2',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Complete as miss\u00f5es, conquiste estrelas e '
                        'libere o desafio final.',
                      ),
                      const SizedBox(height: 12),
                      for (var index = 0; index < _missions.length; index++)
                        _MissionPreview(
                          number: index + 1,
                          id: _missions[index].$1,
                          title: _missions[index].$2,
                          unlocked: progress.unlockedMissions.contains(
                            _missions[index].$1,
                          ),
                          stars:
                              progress.missionStars[_missions[index].$1] ?? 0,
                          special: _missions[index].$1 == 'Z2_SPECIAL',
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

class _ZoneHeader extends StatelessWidget {
  const _ZoneHeader();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.location_city_rounded, size: 70),
            const SizedBox(height: 12),
            Text('ZONA 2', style: Theme.of(context).textTheme.labelLarge),
            Text(
              'Centro Hist\u00f3rico',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Fluxos e Conviv\u00eancia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            const Text(
              'Compartilhe o espa\u00e7o urbano com pedestres, ciclistas, '
              'transporte coletivo e ve\u00edculos.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EconomyCard extends StatelessWidget {
  const _EconomyCard({required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.monetization_on_rounded, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Saldo atual: $coins moedas\n'
                'Economia da Zona 2: 180 + 60 de b\u00f4nus = 240.',
              ),
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
              'Melhorias urbanas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            for (final upgrade in zone2Upgrades)
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
            const SizedBox(height: 4),
            const Text(
              'A compra e a transforma\u00e7\u00e3o visual ser\u00e3o '
              'homologadas no FAST-4.',
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionPreview extends StatelessWidget {
  const _MissionPreview({
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
      case 'Z2_M01':
        return AppRoutes.zone2Mission1;
      case 'Z2_M02':
        return AppRoutes.zone2Mission2;
      case 'Z2_M03':
        return AppRoutes.zone2Mission3;
      case 'Z2_M04':
        return AppRoutes.zone2Mission4;
      case 'Z2_M05':
        return AppRoutes.zone2Mission5;
      case 'Z2_SPECIAL':
        return AppRoutes.zone2SpecialMission;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = special
        ? 'Miss\u00e3o Especial \u2014 $title'
        : '$number. $title';

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
                      label,
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
