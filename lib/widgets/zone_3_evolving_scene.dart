import 'package:flutter/material.dart';

class Zone3EvolvingScene extends StatelessWidget {
  const Zone3EvolvingScene({super.key, required this.purchasedUpgrades});

  final Set<String> purchasedUpgrades;

  @override
  Widget build(BuildContext context) {
    final hasCrossing = purchasedUpgrades.contains('TRAVESSIA_ORLA_SEGURA');
    final hasCycleway = purchasedUpgrades.contains('CICLOVIA_CONECTADA');
    final hasBoarding = purchasedUpgrades.contains('EMBARQUE_ORGANIZADO');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orla em Transforma\u00e7\u00e3o',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Veja como suas escolhas melhoram travessias, ciclovia e '
              'embarque na Praia de Iracema.',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 720;

                const before = _ScenePanel(
                  title: 'ANTES',
                  hasCrossing: false,
                  hasCycleway: false,
                  hasBoarding: false,
                  showPendingHints: false,
                );

                final now = _ScenePanel(
                  title: 'AGORA',
                  hasCrossing: hasCrossing,
                  hasCycleway: hasCycleway,
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
              hasCycleway: hasCycleway,
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
    required this.hasCycleway,
    required this.hasBoarding,
    required this.showPendingHints,
  });

  final String title;
  final bool hasCrossing;
  final bool hasCycleway;
  final bool hasBoarding;
  final bool showPendingHints;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final crossingOpacity = hasCrossing ? 1.0 : (showPendingHints ? 0.10 : 0.0);
    final cycleOpacity = hasCycleway ? 1.0 : (showPendingHints ? 0.12 : 0.0);
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
                      heightFactor: 0.38,
                      widthFactor: 1,
                      child: ColoredBox(
                        color: scheme.primaryContainer.withValues(alpha: 0.58),
                        child: const _WaterfrontArea(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: 0.62,
                      widthFactor: 1,
                      child: ColoredBox(
                        color: scheme.inverseSurface.withValues(alpha: 0.86),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedOpacity(
                      key: const Key('zone3-scene-cycleway'),
                      duration: const Duration(milliseconds: 350),
                      opacity: cycleOpacity,
                      child: FractionallySizedBox(
                        heightFactor: 0.18,
                        widthFactor: 1,
                        child: ColoredBox(
                          color: scheme.tertiaryContainer,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pedal_bike_rounded,
                                color: scheme.onTertiaryContainer,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'CICLOVIA',
                                style: TextStyle(
                                  color: scheme.onTertiaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedOpacity(
                      key: const Key('zone3-scene-crossing'),
                      duration: const Duration(milliseconds: 350),
                      opacity: crossingOpacity,
                      child: const _SafeCrossing(),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 44,
                    child: AnimatedOpacity(
                      key: const Key('zone3-scene-boarding'),
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

class _WaterfrontArea extends StatelessWidget {
  const _WaterfrontArea();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.waves_rounded, size: 42, color: scheme.onPrimaryContainer),
        const SizedBox(width: 18),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.beach_access_rounded,
              size: 42,
              color: scheme.onPrimaryContainer,
            ),
            const SizedBox(height: 2),
            Text(
              'ORLA',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(width: 18),
        Icon(
          Icons.directions_walk_rounded,
          size: 42,
          color: scheme.onPrimaryContainer,
        ),
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
      width: 132,
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
          Icon(
            Icons.accessible_forward_rounded,
            color: scheme.surface,
            size: 24,
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
      width: 74,
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
    required this.hasCycleway,
    required this.hasBoarding,
  });

  final bool hasCrossing;
  final bool hasCycleway;
  final bool hasBoarding;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _LegendChip(
          key: const Key('zone3-legend-crossing'),
          label:
              'Travessia da Orla \u2014 ${hasCrossing ? 'instalada' : 'pendente'}',
          installed: hasCrossing,
        ),
        _LegendChip(
          key: const Key('zone3-legend-cycleway'),
          label:
              'Ciclovia Conectada \u2014 ${hasCycleway ? 'instalada' : 'pendente'}',
          installed: hasCycleway,
        ),
        _LegendChip(
          key: const Key('zone3-legend-boarding'),
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
