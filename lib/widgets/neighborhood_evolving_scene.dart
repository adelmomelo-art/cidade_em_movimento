import 'package:flutter/material.dart';

class NeighborhoodEvolvingScene extends StatelessWidget {
  const NeighborhoodEvolvingScene({super.key, required this.purchasedUpgrades});

  final Set<String> purchasedUpgrades;

  @override
  Widget build(BuildContext context) {
    final hasSidewalk = purchasedUpgrades.contains('BAIRRO_CALCADA_ACESSIVEL');
    final hasSquare = purchasedUpgrades.contains('BAIRRO_PRACA_CONVIVENCIA');
    final hasBikeRack = purchasedUpgrades.contains('BAIRRO_BICICLETARIO');

    final installedCount = <bool>[
      hasSidewalk,
      hasSquare,
      hasBikeRack,
    ].where((value) => value).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seu bairro em transformacao',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '$installedCount de 3 melhorias instaladas',
              key: const Key('build-neighborhood-progress'),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 720;

                const before = _NeighborhoodPanel(
                  title: 'ANTES',
                  hasSidewalk: false,
                  hasSquare: false,
                  hasBikeRack: false,
                  showPendingHints: false,
                );

                final now = _NeighborhoodPanel(
                  title: 'AGORA',
                  hasSidewalk: hasSidewalk,
                  hasSquare: hasSquare,
                  hasBikeRack: hasBikeRack,
                  showPendingHints: true,
                );

                if (compact) {
                  return Column(
                    children: [before, const SizedBox(height: 14), now],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: before),
                    const SizedBox(width: 14),
                    Expanded(child: now),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _LegendChip(
                  key: const Key('build-legend-sidewalk'),
                  label:
                      'Calcada Acessivel - ${hasSidewalk ? 'instalada' : 'pendente'}',
                  installed: hasSidewalk,
                ),
                _LegendChip(
                  key: const Key('build-legend-square'),
                  label:
                      'Praca de Convivencia - ${hasSquare ? 'instalada' : 'pendente'}',
                  installed: hasSquare,
                ),
                _LegendChip(
                  key: const Key('build-legend-bike'),
                  label:
                      'Bicicletario Comunitario - ${hasBikeRack ? 'instalada' : 'pendente'}',
                  installed: hasBikeRack,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NeighborhoodPanel extends StatelessWidget {
  const _NeighborhoodPanel({
    required this.title,
    required this.hasSidewalk,
    required this.hasSquare,
    required this.hasBikeRack,
    required this.showPendingHints,
  });

  final String title;
  final bool hasSidewalk;
  final bool hasSquare;
  final bool hasBikeRack;
  final bool showPendingHints;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          key: Key('build-scene-$title'),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SceneFeature(
                      icon: Icons.home_rounded,
                      label: 'MORADIAS',
                      active: true,
                      pendingHint: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SceneFeature(
                      key: const Key('build-scene-square'),
                      icon: Icons.park_rounded,
                      label: 'PRACA',
                      active: hasSquare,
                      pendingHint: showPendingHints,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _StreetBand(scheme: scheme),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _SceneFeature(
                      key: const Key('build-scene-sidewalk'),
                      icon: Icons.accessible_rounded,
                      label: 'CALCADA',
                      active: hasSidewalk,
                      pendingHint: showPendingHints,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SceneFeature(
                      key: const Key('build-scene-bike'),
                      icon: Icons.pedal_bike_rounded,
                      label: 'BICICLETARIO',
                      active: hasBikeRack,
                      pendingHint: showPendingHints,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StreetBand extends StatelessWidget {
  const _StreetBand({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: scheme.inverseSurface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.directions_walk_rounded, color: scheme.onInverseSurface),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                for (var index = 0; index < 5; index++) ...[
                  Expanded(
                    child: Container(
                      height: 3,
                      color: scheme.onInverseSurface.withValues(alpha: 0.72),
                    ),
                  ),
                  if (index < 4) const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.directions_car_rounded, color: scheme.onInverseSurface),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _SceneFeature extends StatelessWidget {
  const _SceneFeature({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.pendingHint,
  });

  final IconData icon;
  final String label;
  final bool active;
  final bool pendingHint;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visible = active || pendingHint;

    return Container(
      constraints: const BoxConstraints(minHeight: 74),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: visible
            ? scheme.primaryContainer.withValues(alpha: active ? 1 : 0.28)
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active
              ? scheme.primary
              : scheme.outlineVariant.withValues(alpha: visible ? 1 : 0.45),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active
                ? scheme.onPrimaryContainer
                : scheme.onSurfaceVariant.withValues(
                    alpha: visible ? 0.72 : 0.30,
                  ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({super.key, required this.label, required this.installed});

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
