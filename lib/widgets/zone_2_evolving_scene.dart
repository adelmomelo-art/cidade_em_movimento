import 'package:flutter/material.dart';

class Zone2EvolvingScene extends StatelessWidget {
  const Zone2EvolvingScene({super.key, required this.purchasedUpgrades});

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
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Centro em Transforma\u00e7\u00e3o',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Veja como suas escolhas melhoram acessibilidade, transporte '
              'coletivo e conviv\u00eancia no Centro Hist\u00f3rico.',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 720;

                const before = _ScenePanel(
                  title: 'ANTES',
                  hasAccessibleCrossing: false,
                  hasSafeStop: false,
                  hasSharedRoute: false,
                  showPendingHints: false,
                );

                final now = _ScenePanel(
                  title: 'AGORA',
                  hasAccessibleCrossing: hasAccessibleCrossing,
                  hasSafeStop: hasSafeStop,
                  hasSharedRoute: hasSharedRoute,
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
              hasAccessibleCrossing: hasAccessibleCrossing,
              hasSafeStop: hasSafeStop,
              hasSharedRoute: hasSharedRoute,
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
    required this.hasAccessibleCrossing,
    required this.hasSafeStop,
    required this.hasSharedRoute,
    required this.showPendingHints,
  });

  final String title;
  final bool hasAccessibleCrossing;
  final bool hasSafeStop;
  final bool hasSharedRoute;
  final bool showPendingHints;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final crossingOpacity = hasAccessibleCrossing
        ? 1.0
        : (showPendingHints ? 0.10 : 0.0);
    final stopOpacity = hasSafeStop ? 1.0 : (showPendingHints ? 0.12 : 0.0);
    final sharedOpacity = hasSharedRoute
        ? 1.0
        : (showPendingHints ? 0.12 : 0.0);

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
                      heightFactor: 0.47,
                      widthFactor: 1,
                      child: ColoredBox(
                        color: scheme.primaryContainer.withValues(alpha: 0.55),
                        child: const _HistoricCenterArea(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: 0.53,
                      widthFactor: 1,
                      child: ColoredBox(
                        color: scheme.inverseSurface.withValues(alpha: 0.86),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedOpacity(
                      key: const Key('zone2-scene-shared-route'),
                      duration: const Duration(milliseconds: 350),
                      opacity: sharedOpacity,
                      child: FractionallySizedBox(
                        heightFactor: 0.20,
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
                              const SizedBox(width: 12),
                              Icon(
                                Icons.directions_walk_rounded,
                                color: scheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedOpacity(
                      key: const Key('zone2-scene-accessible-crossing'),
                      duration: const Duration(milliseconds: 350),
                      opacity: crossingOpacity,
                      child: const _AccessibleCrossing(),
                    ),
                  ),
                  Positioned(
                    right: 14,
                    top: 50,
                    child: AnimatedOpacity(
                      key: const Key('zone2-scene-safe-stop'),
                      duration: const Duration(milliseconds: 350),
                      opacity: stopOpacity,
                      child: _SafeBusStop(active: hasSafeStop),
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

class _HistoricCenterArea extends StatelessWidget {
  const _HistoricCenterArea();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_balance_rounded,
          size: 42,
          color: scheme.onPrimaryContainer,
        ),
        const SizedBox(width: 18),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_city_rounded,
              size: 42,
              color: scheme.onPrimaryContainer,
            ),
            const SizedBox(height: 2),
            Text(
              'CENTRO',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(width: 18),
        Icon(
          Icons.storefront_rounded,
          size: 42,
          color: scheme.onPrimaryContainer,
        ),
      ],
    );
  }
}

class _AccessibleCrossing extends StatelessWidget {
  const _AccessibleCrossing();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 126,
      height: 82,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var index = 0; index < 6; index++)
                Container(
                  width: 13,
                  height: 68,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: scheme.secondaryContainer,
              child: Icon(
                Icons.accessible_rounded,
                size: 18,
                color: scheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SafeBusStop extends StatelessWidget {
  const _SafeBusStop({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: active ? 88 : 72,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_bus_rounded,
            size: active ? 28 : 22,
            color: scheme.primary,
          ),
          const SizedBox(height: 4),
          Text(
            'PONTO',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (active) ...[
            const SizedBox(height: 4),
            Icon(Icons.roofing_rounded, size: 20, color: scheme.secondary),
          ],
        ],
      ),
    );
  }
}

class _EvolutionLegend extends StatelessWidget {
  const _EvolutionLegend({
    required this.hasAccessibleCrossing,
    required this.hasSafeStop,
    required this.hasSharedRoute,
  });

  final bool hasAccessibleCrossing;
  final bool hasSafeStop;
  final bool hasSharedRoute;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _LegendChip(
          key: const Key('zone2-legend-accessible-crossing'),
          label: 'Travessia Acess\u00edvel',
          active: hasAccessibleCrossing,
        ),
        _LegendChip(
          key: const Key('zone2-legend-safe-stop'),
          label: 'Ponto Seguro',
          active: hasSafeStop,
        ),
        _LegendChip(
          key: const Key('zone2-legend-shared-route'),
          label: 'Rota Compartilhada',
          active: hasSharedRoute,
        ),
      ],
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({super.key, required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        active ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
        size: 18,
      ),
      label: Text(
        active ? '$label \u2014 instalada' : '$label \u2014 pendente',
      ),
    );
  }
}
