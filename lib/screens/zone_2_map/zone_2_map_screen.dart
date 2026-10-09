import 'package:flutter/material.dart';

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
                        'A estrutura est\u00e1 pronta. O conte\u00fado jog\u00e1vel '
                        'ser\u00e1 implementado no FAST-3.',
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
                'Economia planejada da Zona 2: 180 + 60 de b\u00f4nus = 240.',
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
              'Compra e transforma\u00e7\u00e3o visual ser\u00e3o homologadas '
              'nos pr\u00f3ximos pacotes.',
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
    required this.special,
  });

  final int number;
  final String id;
  final String title;
  final bool unlocked;
  final bool special;

  @override
  Widget build(BuildContext context) {
    final label = special
        ? 'Miss\u00e3o Especial \u2014 $title'
        : '$number. $title';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
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
                  Text(
                    unlocked
                        ? 'Estrutura liberada \u2014 conte\u00fado no FAST-3'
                        : 'Aguardando progress\u00e3o da Zona 2',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
