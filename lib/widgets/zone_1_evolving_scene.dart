import 'package:flutter/material.dart';

class Zone1EvolvingScene extends StatelessWidget {
  const Zone1EvolvingScene({super.key, required this.purchasedUpgrades});

  final Set<String> purchasedUpgrades;

  @override
  Widget build(BuildContext context) {
    final hasCrosswalk = purchasedUpgrades.contains('FAIXA_SEGURA');
    final hasLighting = purchasedUpgrades.contains('ILUMINACAO_ESCOLAR');
    final hasCyclePath = purchasedUpgrades.contains('TRECHO_CICLOVIARIO');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cidade Evolutiva',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Veja como as melhorias conquistadas transformam o entorno '
              'da escola.',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 720;

                const before = _ScenePanel(
                  title: 'ANTES',
                  hasCrosswalk: false,
                  hasLighting: false,
                  hasCyclePath: false,
                  showPendingHints: false,
                );

                final after = _ScenePanel(
                  title: 'AGORA',
                  hasCrosswalk: hasCrosswalk,
                  hasLighting: hasLighting,
                  hasCyclePath: hasCyclePath,
                  showPendingHints: true,
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
            _EvolutionLegend(
              hasCrosswalk: hasCrosswalk,
              hasLighting: hasLighting,
              hasCyclePath: hasCyclePath,
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
    required this.hasCrosswalk,
    required this.hasLighting,
    required this.hasCyclePath,
    required this.showPendingHints,
  });

  final String title;
  final bool hasCrosswalk;
  final bool hasLighting;
  final bool hasCyclePath;
  final bool showPendingHints;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final crosswalkOpacity = hasCrosswalk
        ? 1.0
        : (showPendingHints ? 0.08 : 0.0);
    final lightingOpacity = hasLighting ? 1.0 : (showPendingHints ? 0.18 : 0.0);

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
                      heightFactor: 0.48,
                      widthFactor: 1,
                      child: ColoredBox(
                        color: scheme.primaryContainer.withValues(alpha: 0.55),
                        child: const _SchoolArea(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: 0.52,
                      widthFactor: 1,
                      child: ColoredBox(
                        color: scheme.inverseSurface.withValues(alpha: 0.86),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      key: const Key('scene-cycle-path'),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                      height: hasCyclePath ? 42 : 0,
                      child: hasCyclePath
                          ? ColoredBox(
                              color: scheme.tertiaryContainer,
                              child: Center(
                                child: Icon(
                                  Icons.pedal_bike_rounded,
                                  color: scheme.onTertiaryContainer,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  Center(
                    child: AnimatedOpacity(
                      key: const Key('scene-crosswalk'),
                      duration: const Duration(milliseconds: 350),
                      opacity: crosswalkOpacity,
                      child: const _Crosswalk(),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 18,
                    child: AnimatedOpacity(
                      key: const Key('scene-light-left'),
                      duration: const Duration(milliseconds: 350),
                      opacity: lightingOpacity,
                      child: _LampPost(active: hasLighting),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 18,
                    child: AnimatedOpacity(
                      key: const Key('scene-light-right'),
                      duration: const Duration(milliseconds: 350),
                      opacity: lightingOpacity,
                      child: _LampPost(active: hasLighting),
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

class _SchoolArea extends StatelessWidget {
  const _SchoolArea();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school_rounded,
            size: 46,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(height: 4),
          Text(
            'ESCOLA',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _Crosswalk extends StatelessWidget {
  const _Crosswalk();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surface;

    return SizedBox(
      width: 110,
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var index = 0; index < 6; index++)
            Container(
              width: 12,
              height: 64,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
        ],
      ),
    );
  }
}

class _LampPost extends StatelessWidget {
  const _LampPost({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          width: active ? 32 : 22,
          height: active ? 32 : 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? scheme.secondaryContainer
                : scheme.surfaceContainerHighest,
          ),
          child: Icon(
            Icons.lightbulb_rounded,
            size: active ? 20 : 14,
            color: active
                ? scheme.onSecondaryContainer
                : scheme.onSurfaceVariant,
          ),
        ),
        Container(width: 4, height: 52, color: scheme.outline),
      ],
    );
  }
}

class _EvolutionLegend extends StatelessWidget {
  const _EvolutionLegend({
    required this.hasCrosswalk,
    required this.hasLighting,
    required this.hasCyclePath,
  });

  final bool hasCrosswalk;
  final bool hasLighting;
  final bool hasCyclePath;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _LegendChip(
          key: const Key('legend-crosswalk'),
          label: 'Faixa Segura',
          active: hasCrosswalk,
        ),
        _LegendChip(
          key: const Key('legend-lighting'),
          label: 'Ilumina\u00e7\u00e3o Escolar',
          active: hasLighting,
        ),
        _LegendChip(
          key: const Key('legend-cycle-path'),
          label: 'Trecho Ciclovi\u00e1rio',
          active: hasCyclePath,
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
        active ? '$label \u2014 instalado' : '$label \u2014 pendente',
      ),
    );
  }
}
