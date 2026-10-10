import 'package:flutter/material.dart';

import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';
import '../../data/upgrades/upgrade_catalog.dart';
import '../../data/zones/zone_catalog.dart';

class PlayerProgressScreen extends StatelessWidget {
  const PlayerProgressScreen({super.key, required this.controller});

  final PlayerController controller;

  static const _zone1MedalId = 'PROTETOR_DA_ESCOLA';
  static const _zone2MedalId = 'GUARDIAO_DO_CENTRO';
  static const _zone3MedalId = 'GUARDIAO_DA_ORLA';
  static const _zone4MedalId = 'GUARDIAO_DA_CULTURA';
  static const _zone5MedalId = 'GUARDIAO_DAS_VIAS';
  String _medalLabel(String medalId) {
    switch (medalId) {
      case _zone1MedalId:
        return 'Protetor da Escola';
      case _zone2MedalId:
        return 'Guardi\u00e3o do Centro';
      case _zone3MedalId:
        return 'Guardi\u00e3o da Orla';
      case _zone4MedalId:
        return 'Guardi\u00e3o da Cultura';
      case _zone5MedalId:
        return 'Guardi\u00e3o das Vias';
      default:
        return medalId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = controller.progress;
        final profile = controller.profile;

        final totalStars = progress.missionStars.values.fold<int>(
          0,
          (total, stars) => total + stars,
        );

        final installedUpgrades = upgradeCatalog
            .where((upgrade) => progress.purchasedUpgrades.contains(upgrade.id))
            .toList(growable: false);

        final completedZones = zoneCatalog
            .where((zone) => progress.completedZones.contains(zone.id))
            .toList(growable: false);

        return Scaffold(
          appBar: AppBar(title: const Text('Meu Progresso')),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _PlayerHeader(
                        profileTitle: profile?.type.initialTitle ?? 'Jogador',
                      ),
                      const SizedBox(height: 16),
                      _ResourceGrid(
                        citizenship: progress.citizenshipXp,
                        knowledge: progress.knowledge,
                        coins: progress.coins,
                        stars: totalStars,
                      ),
                      const SizedBox(height: 20),
                      _SectionCard(
                        title: 'Zonas concluÃ­das',
                        icon: Icons.map_rounded,
                        emptyText: 'Nenhuma zona concluÃ­da ainda.',
                        children: [
                          for (final zone in completedZones)
                            _ProgressRow(
                              icon: Icons.check_circle_rounded,
                              title: zone.title,
                              subtitle: 'ConcluÃ­da',
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        title: 'Medalhas',
                        icon: Icons.emoji_events_rounded,
                        emptyText: 'Nenhuma medalha conquistada ainda.',
                        children: [
                          for (final medalId in progress.medals)
                            _ProgressRow(
                              icon: Icons.workspace_premium_rounded,
                              title: _medalLabel(medalId),
                              subtitle: 'Conquistada',
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        title: 'Melhorias instaladas',
                        icon: Icons.location_city_rounded,
                        emptyText: 'Nenhuma melhoria instalada ainda.',
                        children: [
                          for (final upgrade in installedUpgrades)
                            _ProgressRow(
                              icon: Icons.check_circle_outline_rounded,
                              title: upgrade.title,
                              subtitle: upgrade.description,
                            ),
                        ],
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

class _PlayerHeader extends StatelessWidget {
  const _PlayerHeader({required this.profileTitle});

  final String profileTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              child: Icon(Icons.person_rounded, size: 34),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jornada do jogador',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    profileTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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

class _ResourceGrid extends StatelessWidget {
  const _ResourceGrid({
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
    final items = <({IconData icon, String label, int value})>[
      (
        icon: Icons.workspace_premium_rounded,
        label: 'Cidadania',
        value: citizenship,
      ),
      (icon: Icons.menu_book_rounded, label: 'Conhecimento', value: knowledge),
      (icon: Icons.monetization_on_rounded, label: 'Moedas', value: coins),
      (icon: Icons.star_rounded, label: 'Estrelas', value: stars),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700 ? 4 : 2;
        final width = (constraints.maxWidth - (12 * (columns - 1))) / columns;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: _MetricCard(
                  icon: item.icon,
                  label: item.label,
                  value: item.value,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Column(
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.emptyText,
    required this.children,
  });

  final String title;
  final IconData icon;
  final String emptyText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (children.isEmpty)
              Text(emptyText)
            else
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index < children.length - 1) const Divider(height: 22),
              ],
          ],
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(subtitle),
            ],
          ),
        ),
      ],
    );
  }
}
