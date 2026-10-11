import 'package:flutter/material.dart';

import '../../controllers/player_controller.dart';
import '../../data/build_neighborhood/upgrade_data.dart';
import '../../models/upgrade_definition.dart';
import '../../widgets/neighborhood_evolving_scene.dart';

class BuildNeighborhoodScreen extends StatelessWidget {
  const BuildNeighborhoodScreen({super.key, required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = controller.progress;
        final installed = buildNeighborhoodUpgrades
            .where((upgrade) => progress.purchasedUpgrades.contains(upgrade.id))
            .length;

        return Scaffold(
          appBar: AppBar(title: const Text('Construa o Bairro')),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _HeaderCard(
                          coins: progress.coins,
                          installed: installed,
                        ),
                        const SizedBox(height: 16),
                        IgnorePointer(
                          child: NeighborhoodEvolvingScene(
                            purchasedUpgrades: progress.purchasedUpgrades,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _UpgradeSection(controller: controller),
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.coins, required this.installed});

  final int coins;
  final int installed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.location_city_rounded, size: 64),
            const SizedBox(height: 12),
            Text(
              'Transforme seu bairro',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Use as moedas conquistadas nas jornadas para escolher melhorias '
              'urbanas e acompanhar a transformacao do espaco.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                Chip(
                  key: const Key('build-coins'),
                  avatar: const Icon(Icons.monetization_on_rounded, size: 18),
                  label: Text('$coins moedas'),
                ),
                Chip(
                  key: const Key('build-installed'),
                  avatar: const Icon(Icons.construction_rounded, size: 18),
                  label: Text('$installed/3 melhorias'),
                ),
              ],
            ),
          ],
        ),
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Escolha as melhorias',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cada instalacao usa moedas uma unica vez e fica salva no seu progresso.',
            ),
            const SizedBox(height: 14),
            for (final upgrade in buildNeighborhoodUpgrades) ...[
              _UpgradeCard(
                controller: controller,
                upgrade: upgrade,
                purchased: progress.purchasedUpgrades.contains(upgrade.id),
                canAfford: progress.coins >= upgrade.cost,
              ),
              if (upgrade != buildNeighborhoodUpgrades.last)
                const SizedBox(height: 10),
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
      key: Key('build-upgrade-${upgrade.id}'),
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
                Row(
                  children: [
                    const Icon(Icons.monetization_on_rounded, size: 18),
                    const SizedBox(width: 4),
                    Text('${upgrade.cost} moedas'),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: Key('build-install-${upgrade.id}'),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
