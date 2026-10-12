import 'package:flutter/material.dart';

import '../ui/visual_system.dart';
import 'zone_1_art.dart';

class Zone1EvolvingScene extends StatelessWidget {
  const Zone1EvolvingScene({super.key, required this.purchasedUpgrades});

  final Set<String> purchasedUpgrades;

  @override
  Widget build(BuildContext context) {
    final hasCrosswalk = purchasedUpgrades.contains('FAIXA_SEGURA');
    final hasLighting = purchasedUpgrades.contains('ILUMINACAO_ESCOLAR');
    final hasCyclePath = purchasedUpgrades.contains('TRECHO_CICLOVIARIO');

    return GameSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cidade Evolutiva',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: GameColors.navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Compare o entorno escolar antes e depois das melhorias conquistadas.',
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;

              final before = const _EvolutionPanel(
                title: 'ANTES',
                subtitle: 'Entorno sem melhorias',
                crosswalk: false,
                lighting: false,
                cyclePath: false,
              );

              final after = _EvolutionPanel(
                title: 'AGORA',
                subtitle: 'Seu bairro em transformacao',
                crosswalk: hasCrosswalk,
                lighting: hasLighting,
                cyclePath: hasCyclePath,
              );

              if (compact) {
                return Column(
                  children: [before, const SizedBox(height: 14), after],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: before),
                  const SizedBox(width: 14),
                  Expanded(child: after),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final statuses = <Widget>[
                _EvolutionStatus(
                  label: 'Faixa Segura',
                  active: hasCrosswalk,
                  icon: Icons.signpost_rounded,
                ),
                _EvolutionStatus(
                  label: 'Ilumina\u00e7\u00e3o Escolar',
                  active: hasLighting,
                  icon: Icons.lightbulb_rounded,
                ),
                _EvolutionStatus(
                  label: 'Trecho Ciclovi\u00e1rio',
                  active: hasCyclePath,
                  icon: Icons.pedal_bike_rounded,
                ),
              ];

              if (constraints.maxWidth < 520) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var index = 0; index < statuses.length; index++) ...[
                      statuses[index],
                      if (index < statuses.length - 1)
                        const SizedBox(height: 8),
                    ],
                  ],
                );
              }

              return Wrap(spacing: 10, runSpacing: 10, children: statuses);
            },
          ),
          const SizedBox(height: 22),
          Text(
            'Iluminação no entorno — simulação noturna',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: GameColors.navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text('Observe a luz sobre a calçada e os acessos à escola.'),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              const before = _EvolutionPanel(
                title: 'SEM ILUMINAÇÃO',
                subtitle: 'Comparação noturna',
                crosswalk: false,
                lighting: false,
                cyclePath: false,
                nightPreview: true,
              );
              final after = _EvolutionPanel(
                title: hasLighting
                    ? 'ILUMINAÇÃO INSTALADA'
                    : 'AINDA SEM ILUMINAÇÃO',
                subtitle: 'Melhorias conquistadas',
                crosswalk: hasCrosswalk,
                lighting: hasLighting,
                cyclePath: hasCyclePath,
                nightPreview: true,
              );
              if (constraints.maxWidth < 760) {
                return Column(
                  children: [before, const SizedBox(height: 14), after],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: before),
                  const SizedBox(width: 14),
                  Expanded(child: after),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EvolutionPanel extends StatelessWidget {
  const _EvolutionPanel({
    required this.title,
    required this.subtitle,
    required this.crosswalk,
    required this.lighting,
    required this.cyclePath,
    this.nightPreview = false,
  });

  final String title;
  final String subtitle;
  final bool crosswalk;
  final bool lighting;
  final bool cyclePath;
  final bool nightPreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 420) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: GameColors.navy,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: GameColors.navy,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Zone1NeighborhoodArt(
              crosswalk: crosswalk,
              lighting: lighting,
              cyclePath: cyclePath,
              showPeople: true,
              showVehicles: true,
              nightPreview: nightPreview,
            ),
          ),
        ),
      ],
    );
  }
}

class _EvolutionStatus extends StatelessWidget {
  const _EvolutionStatus({
    required this.label,
    required this.active,
    required this.icon,
  });

  final String label;
  final bool active;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final text = active ? '$label \u2014 instalado' : '$label \u2014 pendente';

    final foreground = active ? const Color(0xFF14532D) : GameColors.navy;

    final background = active
        ? const Color(0xFFDDF7E5)
        : const Color(0xFFE9EEF5);

    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active ? Icons.check_circle_rounded : icon,
            size: 18,
            color: foreground,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              text,
              softWrap: true,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
