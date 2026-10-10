import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../data/zone_4/upgrade_data.dart';
import '../../models/upgrade_definition.dart';
import '../../widgets/zone_4_evolving_scene.dart';

class Zone4MapScreen extends StatelessWidget {
  const Zone4MapScreen({super.key, required this.controller});

  final PlayerController controller;

  static const _missions = [
    ('Z4_M01', 'Chegada ao Evento'),
    ('Z4_M02', 'Travessia com Multid\u00e3o'),
    ('Z4_M03', 'Embarque Organizado'),
    ('Z4_M04', '\u00c1rea de Bloqueio'),
    ('Z4_M05', 'Sa\u00edda Segura'),
    ('Z4_SPECIAL', 'Cidade em Festa'),
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
            title: const Text('Cultura / Eventos'),
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
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (progress.isZoneCompleted('ZONE_4')) ...[
                          const _ZoneCompletedCard(),
                          const SizedBox(height: 10),
                          FilledButton.icon(
                            onPressed: controller.isZoneUnlocked('ZONE_5')
                                ? () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(AppRoutes.zone5);
                                  }
                                : null,
                            icon: const Icon(Icons.alt_route_rounded),
                            label: const Text('AVAN\u00c7AR PARA GRANDES VIAS'),
                          ),
                          const SizedBox(height: 16),
                        ],
                        _CultureCard(
                          purchasedUpgrades: progress.purchasedUpgrades,
                        ),
                        const SizedBox(height: 16),
                        IgnorePointer(
                          child: Zone4EvolvingScene(
                            purchasedUpgrades: progress.purchasedUpgrades,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _UpgradeSection(controller: controller),
                        const SizedBox(height: 20),
                        Text(
                          'Miss\u00f5es da Zona 4',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
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
                            special: _missions[index].$1 == 'Z4_SPECIAL',
                          ),
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
                    'Zona 4 conclu\u00edda',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text('Medalha: Guardi\u00e3o da Cultura'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CultureCard extends StatelessWidget {
  const _CultureCard({required this.purchasedUpgrades});

  final Set<String> purchasedUpgrades;

  @override
  Widget build(BuildContext context) {
    final hasCrossing = purchasedUpgrades.contains('TRAVESSIA_EVENTO_SEGURA');
    final hasTemporarySigns = purchasedUpgrades.contains(
      'SINALIZACAO_TEMPORARIA',
    );
    final hasBoarding = purchasedUpgrades.contains(
      'EMBARQUE_EVENTO_ORGANIZADO',
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.festival_rounded, size: 72),
            const SizedBox(height: 12),
            Text('ZONA 4', style: Theme.of(context).textTheme.labelLarge),
            Text(
              'Cultura / Eventos',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Mobilidade em Grandes Encontros',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Aprenda a circular com seguran\u00e7a em eventos, shows, '
              'festivais e grandes concentra\u00e7\u00f5es de p\u00fablico.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _TransformationBadge(
                  label: 'Travessia',
                  installed: hasCrossing,
                ),
                _TransformationBadge(
                  label: 'Sinaliza\u00e7\u00e3o',
                  installed: hasTemporarySigns,
                ),
                _TransformationBadge(label: 'Embarque', installed: hasBoarding),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransformationBadge extends StatelessWidget {
  const _TransformationBadge({required this.label, required this.installed});

  final String label;
  final bool installed;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        installed
            ? Icons.check_circle_rounded
            : Icons.radio_button_unchecked_rounded,
        size: 18,
      ),
      label: Text(label),
    );
  }
}

class _UpgradeSection extends StatelessWidget {
  const _UpgradeSection({required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final progress = controller.progress;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transforme o Evento',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Use as moedas conquistadas para instalar melhorias urbanas. '
              'As compras s\u00e3o opcionais e n\u00e3o bloqueiam a progress\u00e3o.',
            ),
            const SizedBox(height: 14),
            for (final upgrade in zone4Upgrades) ...[
              _UpgradeCard(
                controller: controller,
                upgrade: upgrade,
                purchased: progress.purchasedUpgrades.contains(upgrade.id),
                canAfford: progress.coins >= upgrade.cost,
              ),
              if (upgrade != zone4Upgrades.last) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({
    required this.controller,
    required this.upgrade,
    required this.purchased,
    required this.canAfford,
  });

  final PlayerController controller;
  final UpgradeDefinition upgrade;
  final bool purchased;
  final bool canAfford;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('zone4-upgrade-${upgrade.id}'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Icon(
              purchased
                  ? Icons.check_circle_rounded
                  : Icons.construction_rounded,
            ),
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
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.monetization_on_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text('${upgrade.cost} moedas'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      key: Key('zone4-install-${upgrade.id}'),
                      onPressed: purchased || !canAfford
                          ? null
                          : () async {
                              final ok = await controller.purchaseUpgrade(
                                upgrade.id,
                              );

                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    ok
                                        ? '${upgrade.title} instalada.'
                                        : 'N\u00e3o foi poss\u00edvel instalar ${upgrade.title}.',
                                  ),
                                ),
                              );
                            },
                      child: Text(purchased ? 'INSTALADA' : 'INSTALAR'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
      case 'Z4_M01':
        return AppRoutes.zone4Mission1;
      case 'Z4_M02':
        return AppRoutes.zone4Mission2;
      case 'Z4_M03':
        return AppRoutes.zone4Mission3;
      case 'Z4_M04':
        return AppRoutes.zone4Mission4;
      case 'Z4_M05':
        return AppRoutes.zone4Mission5;
      case 'Z4_SPECIAL':
        return AppRoutes.zone4SpecialMission;
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
