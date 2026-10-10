import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../data/zone_6/upgrade_data.dart';
import '../../models/upgrade_definition.dart';
import '../../widgets/zone_6_evolving_scene.dart';

class Zone6MapScreen extends StatelessWidget {
  const Zone6MapScreen({super.key, required this.controller});

  final PlayerController controller;

  static const _missions = [
    ('Z6_M01', 'Chegada ao Castelao'),
    ('Z6_M02', 'Travessia da Torcida'),
    ('Z6_M03', 'Embarque e Desembarque'),
    ('Z6_M04', 'Bloqueio Temporario'),
    ('Z6_M05', 'Saida do Estadio'),
    ('Z6_SPECIAL', 'Operacao Dia de Jogo'),
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
            title: const Text('Polo Castelao'),
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
                        if (progress.isZoneCompleted('ZONE_6')) ...[
                          const _ZoneCompletedCard(),
                          const SizedBox(height: 16),
                        ],
                        _CastelaoCard(
                          purchasedUpgrades: progress.purchasedUpgrades,
                        ),
                        const SizedBox(height: 16),
                        IgnorePointer(
                          child: Zone6EvolvingScene(
                            purchasedUpgrades: progress.purchasedUpgrades,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _UpgradeSection(controller: controller),
                        const SizedBox(height: 20),
                        Text(
                          'Missoes da Zona 6',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Complete as cinco missoes, alcance pelo menos '
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
                            special: _missions[index].$1 == 'Z6_SPECIAL',
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
                    'Zona 6 concluida',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text('Medalha: Guardiao do Castelao'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CastelaoCard extends StatelessWidget {
  const _CastelaoCard({required this.purchasedUpgrades});

  final Set<String> purchasedUpgrades;

  @override
  Widget build(BuildContext context) {
    final hasPedestrianCorridor = purchasedUpgrades.contains(
      'CORREDOR_PEDESTRE_CASTELAO',
    );
    final hasLighting = purchasedUpgrades.contains(
      'ILUMINACAO_ENTORNO_CASTELAO',
    );
    final hasBoarding = purchasedUpgrades.contains(
      'EMBARQUE_INTEGRADO_CASTELAO',
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.stadium_rounded, size: 72),
            const SizedBox(height: 12),
            Text('ZONA 6', style: Theme.of(context).textTheme.labelLarge),
            Text(
              'Polo Castelao',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Mobilidade em Dias de Jogo',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            const Text(
              'Aprenda a chegar, circular e sair com seguranca em grandes '
              'eventos esportivos, respeitando pedestres, bloqueios e pontos '
              'organizados de transporte.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _TransformationBadge(
                  label: 'Pedestres',
                  installed: hasPedestrianCorridor,
                ),
                _TransformationBadge(
                  label: 'Iluminacao',
                  installed: hasLighting,
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
              'Transforme o Polo Castelao',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Use as moedas conquistadas para instalar melhorias urbanas. '
              'As compras sao opcionais e nao bloqueiam a progressao.',
            ),
            const SizedBox(height: 14),
            for (final upgrade in zone6Upgrades) ...[
              _UpgradeCard(
                controller: controller,
                upgrade: upgrade,
                purchased: progress.purchasedUpgrades.contains(upgrade.id),
                canAfford: progress.coins >= upgrade.cost,
              ),
              if (upgrade != zone6Upgrades.last) const SizedBox(height: 10),
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
      key: Key('zone6-upgrade-${upgrade.id}'),
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
                      key: Key('zone6-install-${upgrade.id}'),
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
                                        : 'Nao foi possivel instalar ${upgrade.title}.',
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
      case 'Z6_M01':
        return AppRoutes.zone6Mission1;
      case 'Z6_M02':
        return AppRoutes.zone6Mission2;
      case 'Z6_M03':
        return AppRoutes.zone6Mission3;
      case 'Z6_M04':
        return AppRoutes.zone6Mission4;
      case 'Z6_M05':
        return AppRoutes.zone6Mission5;
      case 'Z6_SPECIAL':
        return AppRoutes.zone6SpecialMission;
      default:
        return null;
    }
  }

  String _starsLabel() {
    if (stars <= 0) {
      return 'Disponivel';
    }

    final filled = List<String>.filled(stars, '\u2605').join();
    final empty = List<String>.filled(3 - stars, '\u2606').join();
    return '$filled$empty';
  }

  @override
  Widget build(BuildContext context) {
    final route = _route;
    final canOpen = unlocked && route != null;
    final subtitle = unlocked ? _starsLabel() : 'Bloqueada';

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
                      special ? 'Missao Especial - $title' : '$number. $title',
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
