import 'package:flutter/material.dart';

class Zone4EvolvingScene extends StatelessWidget {
  const Zone4EvolvingScene({super.key, required this.purchasedUpgrades});

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
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evento em Transforma\u00e7\u00e3o',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Veja como suas escolhas melhoram travessias, orienta\u00e7\u00e3o '
              'tempor\u00e1ria e embarque em grandes eventos.',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 720;

                const before = _ScenePanel(
                  title: 'ANTES',
                  hasCrossing: false,
                  hasTemporarySigns: false,
                  hasBoarding: false,
                  showPendingHints: false,
                );

                final now = _ScenePanel(
                  title: 'AGORA',
                  hasCrossing: hasCrossing,
                  hasTemporarySigns: hasTemporarySigns,
                  hasBoarding: hasBoarding,
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
            _EvolutionLegend(
              hasCrossing: hasCrossing,
              hasTemporarySigns: hasTemporarySigns,
              hasBoarding: hasBoarding,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenePanel extends StatelessWidget {
  const _ScenePanel({
    required this.title,
    required this.hasCrossing,
    required this.hasTemporarySigns,
    required this.hasBoarding,
    required this.showPendingHints,
  });

  final String title;
  final bool hasCrossing;
  final bool hasTemporarySigns;
  final bool hasBoarding;
  final bool showPendingHints;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final crossingOpacity = hasCrossing ? 1.0 : (showPendingHints ? 0.10 : 0.0);
    final signsOpacity = hasTemporarySigns
        ? 1.0
        : (showPendingHints ? 0.12 : 0.0);
    final boardingOpacity = hasBoarding ? 1.0 : (showPendingHints ? 0.12 : 0.0);

    return Semantics(
      label: 'Cena $title',
      child: Column(
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
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: scheme.surfaceContainerHighest),
                  Align(
                    alignment: Alignment.topCenter,
                    child: FractionallySizedBox(
                      heightFactor: 0.42,
                      widthFactor: 1,
                      child: ColoredBox(
                        color: scheme.primaryContainer.withValues(alpha: 0.58),
                        child: const _EventArea(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: 0.58,
                      widthFactor: 1,
                      child: ColoredBox(
                        color: scheme.inverseSurface.withValues(alpha: 0.86),
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedOpacity(
                      key: const Key('zone4-scene-crossing'),
                      duration: const Duration(milliseconds: 350),
                      opacity: crossingOpacity,
                      child: const _SafeCrossing(),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 52,
                    child: AnimatedOpacity(
                      key: const Key('zone4-scene-signs'),
                      duration: const Duration(milliseconds: 350),
                      opacity: signsOpacity,
                      child: _TemporarySigns(active: hasTemporarySigns),
                    ),
                  ),
                  Positioned(
                    right: 14,
                    top: 52,
                    child: AnimatedOpacity(
                      key: const Key('zone4-scene-boarding'),
                      duration: const Duration(milliseconds: 350),
                      opacity: boardingOpacity,
                      child: _BoardingPoint(active: hasBoarding),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventArea extends StatelessWidget {
  const _EventArea();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.music_note_rounded,
          size: 40,
          color: scheme.onPrimaryContainer,
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.festival_rounded,
              size: 42,
              color: scheme.onPrimaryContainer,
            ),
            const SizedBox(height: 2),
            Text(
              'EVENTO',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Icon(Icons.groups_rounded, size: 42, color: scheme.onPrimaryContainer),
      ],
    );
  }
}

class _SafeCrossing extends StatelessWidget {
  const _SafeCrossing();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 128,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < 5; index++)
            Container(
              height: 8,
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          const SizedBox(height: 4),
          Icon(Icons.groups_2_rounded, color: scheme.surface, size: 24),
        ],
      ),
    );
  }
}

class _TemporarySigns extends StatelessWidget {
  const _TemporarySigns({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 78,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active
              ? scheme.tertiary
              : scheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, color: scheme.onTertiaryContainer),
          const SizedBox(height: 4),
          Text(
            'DESVIO',
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

class _BoardingPoint extends StatelessWidget {
  const _BoardingPoint({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 78,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active
              ? scheme.secondary
              : scheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_bus_filled_rounded,
            color: scheme.onSecondaryContainer,
          ),
          const SizedBox(height: 4),
          Text(
            'EMBARQUE',
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

class _EvolutionLegend extends StatelessWidget {
  const _EvolutionLegend({
    required this.hasCrossing,
    required this.hasTemporarySigns,
    required this.hasBoarding,
  });

  final bool hasCrossing;
  final bool hasTemporarySigns;
  final bool hasBoarding;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _LegendChip(
          key: const Key('zone4-legend-crossing'),
          label:
              'Travessia do Evento \u2014 ${hasCrossing ? 'instalada' : 'pendente'}',
          installed: hasCrossing,
        ),
        _LegendChip(
          key: const Key('zone4-legend-signs'),
          label:
              'Sinaliza\u00e7\u00e3o Tempor\u00e1ria \u2014 ${hasTemporarySigns ? 'instalada' : 'pendente'}',
          installed: hasTemporarySigns,
        ),
        _LegendChip(
          key: const Key('zone4-legend-boarding'),
          label:
              'Embarque Organizado \u2014 ${hasBoarding ? 'instalada' : 'pendente'}',
          installed: hasBoarding,
        ),
      ],
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
