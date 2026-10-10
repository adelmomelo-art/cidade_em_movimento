import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../data/zone_2/upgrade_data.dart';
import '../../models/upgrade_definition.dart';
import '../../widgets/zone_2_evolving_scene.dart';

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

        final totalStars = progress.missionStars.values.fold<int>(
          0,
          (total, value) => total + value,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Centro Hist\u00f3rico'),
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
                      if (progress.isZoneCompleted('ZONE_2')) ...[
                        const _ZoneCompletedCard(),
                        const SizedBox(height: 16),
                      ],
                      _CenterCard(
                        purchasedUpgrades: progress.purchasedUpgrades,
                      ),
                      const SizedBox(height: 16),
                      Zone2EvolvingScene(
                        purchasedUpgrades: progress.purchasedUpgrades,
                      ),
                      const SizedBox(height: 16),
                      _UpgradeSection(controller: controller),
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
                    'Zona 2 conclu\u00edda',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text('Medalha: Guardi\u00e3o do Centro'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterCard extends StatelessWidget {
  const _CenterCard({required this.purchasedUpgrades});

  final Set<String> purchasedUpgrades;

  @override
  Widget build(BuildContext context) {
    final hasAccessibleCrossing = purchasedUpgrades.contains(
      'TRAVESSIA_ACESSIVEL',
    );
    final hasSafeStop = purchasedUpgrades.contains('PONTO_SEGURO');
    final hasSharedRoute = purchasedUpgrades.contains('ROTA_COMPARTILHADA');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.location_city_rounded, size: 72),
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
              'Aprenda, conquiste moedas e transforme os espa\u00e7os '
              'compartilhados do Centro.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _TransformationBadge(
                  icon: Icons.accessible_rounded,
                  label: 'Travessia Acess\u00edvel',
                  active: hasAccessibleCrossing,
                ),
                _TransformationBadge(
                  icon: Icons.directions_bus_rounded,
                  label: 'Ponto Seguro',
                  active: hasSafeStop,
                ),
                _TransformationBadge(
                  icon: Icons.pedal_bike_rounded,
                  label: 'Rota Compartilhada',
                  active: hasSharedRoute,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransformationBadge extends StatelessWidget {
  const _TransformationBadge({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(active ? Icons.check_circle_rounded : icon, size: 20),
      label: Text(
        active ? '$label \u2014 instalada' : '$label \u2014 pendente',
      ),
    );
  }
}

class _UpgradeSection extends StatelessWidget {
  const _UpgradeSection({required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final progress = controller.progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transforme o Centro',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Use as moedas conquistadas nas miss\u00f5es para melhorar '
          'acessibilidade, transporte coletivo e conviv\u00eancia.',
        ),
        const SizedBox(height: 12),
        for (final upgrade in zone2Upgrades)
          _UpgradeCard(
            key: Key('zone2-upgrade-${upgrade.id}'),
            upgrade: upgrade,
            purchased: progress.purchasedUpgrades.contains(upgrade.id),
            canAfford: progress.coins >= upgrade.cost,
            onPurchase: () async {
              final purchased = await controller.purchaseUpgrade(upgrade.id);

              if (!context.mounted) {
                return;
              }

              final message = purchased
                  ? '${upgrade.title} instalada com sucesso.'
                  : 'Moedas insuficientes ou melhoria j\u00e1 instalada.';

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(message)));
            },
          ),
      ],
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({
    super.key,
    required this.upgrade,
    required this.purchased,
    required this.canAfford,
    required this.onPurchase,
  });

  final UpgradeDefinition upgrade;
  final bool purchased;
  final bool canAfford;
  final Future<void> Function() onPurchase;

  IconData get _icon {
    switch (upgrade.id) {
      case 'TRAVESSIA_ACESSIVEL':
        return Icons.accessible_rounded;
      case 'PONTO_SEGURO':
        return Icons.directions_bus_rounded;
      case 'ROTA_COMPARTILHADA':
        return Icons.pedal_bike_rounded;
      default:
        return Icons.location_city_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 560;

            final details = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: Icon(purchased ? Icons.check_rounded : _icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upgrade.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(upgrade.description),
                      const SizedBox(height: 6),
                      Text(
                        purchased
                            ? 'INSTALADA'
                            : 'Custo: ${upgrade.cost} moedas',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            );

            final button = SizedBox(
              width: compact ? double.infinity : 150,
              child: FilledButton.icon(
                key: Key('zone2-install-${upgrade.id}'),
                onPressed: purchased || !canAfford
                    ? null
                    : () {
                        onPurchase();
                      },
                icon: Icon(
                  purchased ? Icons.verified_rounded : Icons.add_road_rounded,
                ),
                label: Text(purchased ? 'INSTALADA' : 'INSTALAR'),
              ),
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [details, const SizedBox(height: 14), button],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: details),
                const SizedBox(width: 16),
                button,
              ],
            );
          },
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
