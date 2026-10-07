import 'package:flutter/material.dart';

import '../../models/mission_result.dart';

class MissionResultScreen extends StatelessWidget {
  const MissionResultScreen({super.key, required this.result});

  final MissionResult result;

  @override
  Widget build(BuildContext context) {
    final stars = '${'\u2605' * result.stars}${'\u2606' * (3 - result.stars)}';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Icon(Icons.emoji_events_rounded, size: 92),
                      const SizedBox(height: 18),
                      Text(
                        'MISS\u00c3O CONCLU\u00cdDA',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        stars,
                        style: const TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Pontua\u00e7\u00e3o: ${result.score}/100',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 28),
                      _RewardRow(
                        icon: Icons.workspace_premium_rounded,
                        label: 'Cidadania',
                        value: result.citizenship,
                      ),
                      _RewardRow(
                        icon: Icons.menu_book_rounded,
                        label: 'Conhecimento',
                        value: result.knowledge,
                      ),
                      _RewardRow(
                        icon: Icons.monetization_on_rounded,
                        label: 'Moedas',
                        value: result.coins,
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Voc\u00ea concluiu mais uma etapa e ajudou '
                        'a tornar o bairro mais seguro.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 26),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).popUntil(
                            (route) =>
                                route.settings.name == '/zone-1' ||
                                route.isFirst,
                          );
                        },
                        icon: const Icon(Icons.map_rounded),
                        label: const Text('VOLTAR AO MAPA'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 14),
          Expanded(child: Text(label)),
          Text('+$value', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
