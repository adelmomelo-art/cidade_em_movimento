import 'package:flutter/material.dart';

class Zone5EvolvingScene extends StatelessWidget {
  const Zone5EvolvingScene({super.key, required this.purchasedUpgrades});

  final Set<String> purchasedUpgrades;

  @override
  Widget build(BuildContext context) {
    final hasCrossing = purchasedUpgrades.contains('TRAVESSIA_GRANDE_VIA');
    final hasLighting = purchasedUpgrades.contains('ILUMINACAO_CORREDOR');
    final hasRefuge = purchasedUpgrades.contains('REFUGIO_PEDESTRE');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grandes Vias em Transforma\u00e7\u00e3o',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Veja como suas escolhas tornam os grandes corredores mais '
              'previs\u00edveis e seguros para quem atravessa e circula.',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 720;

                const before = _RoadScenePanel(
                  title: 'ANTES',
                  hasCrossing: false,
                  hasLighting: false,
                  hasRefuge: false,
                  showPendingHints: false,
                );

                final now = _RoadScenePanel(
                  title: 'AGORA',
                  hasCrossing: hasCrossing,
                  hasLighting: hasLighting,
                  hasRefuge: hasRefuge,
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
                  key: const Key('zone5-legend-crossing'),
                  label:
                      'Travessia Protegida \u2014 ${hasCrossing ? 'instalada' : 'pendente'}',
                  installed: hasCrossing,
                ),
                _LegendChip(
                  key: const Key('zone5-legend-lighting'),
                  label:
                      'Ilumina\u00e7\u00e3o do Corredor \u2014 ${hasLighting ? 'instalada' : 'pendente'}',
                  installed: hasLighting,
                ),
                _LegendChip(
                  key: const Key('zone5-legend-refuge'),
                  label:
                      'Ref\u00fagio de Pedestres \u2014 ${hasRefuge ? 'instalada' : 'pendente'}',
                  installed: hasRefuge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoadScenePanel extends StatelessWidget {
  const _RoadScenePanel({
    required this.title,
    required this.hasCrossing,
    required this.hasLighting,
    required this.hasRefuge,
    required this.showPendingHints,
  });

  final String title;
  final bool hasCrossing;
  final bool hasLighting;
  final bool hasRefuge;
  final bool showPendingHints;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
          Container(
            key: Key('zone5-scene-$title'),
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
                        icon: Icons.traffic_rounded,
                        label: 'CORREDOR',
                        active: true,
                        pendingHint: false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SceneFeature(
                        key: const Key('zone5-scene-lighting'),
                        icon: Icons.lightbulb_rounded,
                        label: 'ILUMINA\u00c7\u00c3O',
                        active: hasLighting,
                        pendingHint: showPendingHints,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _LaneBand(scheme: scheme),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _SceneFeature(
                        key: const Key('zone5-scene-crossing'),
                        icon: Icons.signpost_rounded,
                        label: 'TRAVESSIA',
                        active: hasCrossing,
                        pendingHint: showPendingHints,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SceneFeature(
                        key: const Key('zone5-scene-refuge'),
                        icon: Icons.accessibility_new_rounded,
                        label: 'REF\u00daGIO',
                        active: hasRefuge,
                        pendingHint: showPendingHints,
                      ),
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

class _LaneBand extends StatelessWidget {
  const _LaneBand({required this.scheme});

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
          Icon(Icons.directions_car_rounded, color: scheme.onInverseSurface),
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
          Icon(Icons.local_shipping_rounded, color: scheme.onInverseSurface),
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
