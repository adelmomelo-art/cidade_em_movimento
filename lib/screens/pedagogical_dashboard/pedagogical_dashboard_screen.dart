import 'package:flutter/material.dart';

import '../../controllers/player_controller.dart';
import '../../services/global_progress_service.dart';
import '../../services/pedagogical_sync_service.dart';

class PedagogicalDashboardScreen extends StatefulWidget {
  const PedagogicalDashboardScreen({super.key, required this.controller});
  final PlayerController controller;

  @override
  State<PedagogicalDashboardScreen> createState() =>
      _PedagogicalDashboardScreenState();
}

class _PedagogicalDashboardScreenState
    extends State<PedagogicalDashboardScreen> {
  bool _syncing = false;

  Future<void> _sync() async {
    if (_syncing) return;
    setState(() => _syncing = true);
    final result = await widget.controller.syncPedagogicalNow();
    if (!mounted) return;
    setState(() => _syncing = false);
    final message = switch (result) {
      PedagogicalSyncStatus.synced => 'Dados pedagogicos sincronizados.',
      PedagogicalSyncStatus.nothingPending => 'Nenhum dado pendente.',
      PedagogicalSyncStatus.backendNotConfigured =>
        'Backend HML ainda nao configurado neste build.',
      PedagogicalSyncStatus.failed =>
        'Falha de rede. O dado permanece salvo offline.',
    };
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final p = widget.controller.progress;
        final s = const GlobalProgressService().summarize(p);
        final rate = s.totalMissions == 0
            ? 0
            : ((s.completedMissions / s.totalMissions) * 100).round();
        return Scaffold(
          appBar: AppBar(title: const Text('Painel Pedagogico')),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Card(
                          key: const Key('pedagogical-dashboard-header'),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Icon(Icons.school_rounded, size: 56),
                                const SizedBox(height: 10),
                                Text(
                                  'Leitura Pedagogica',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                LinearProgressIndicator(
                                  value: rate / 100,
                                  minHeight: 10,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$rate% das missoes concluidas',
                                  key: const Key('pedagogical-mission-rate'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _Metrics(
                          missions: '${s.completedMissions}/${s.totalMissions}',
                          zones: '${s.completedZones}/${s.totalZones}',
                          medals: '${s.medals}/${s.totalMedals}',
                          stars: '${s.totalStars}',
                          knowledge: '${p.knowledge}',
                          citizenship: '${p.citizenshipXp}',
                        ),
                        const SizedBox(height: 14),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Indicadores de aprendizagem',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Duelo das Placas: ${p.signDuelBestCorrect}/6 - ${p.signDuelPlays} partidas',
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Melhorias instaladas: ${p.purchasedUpgrades.length}',
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Construa o Bairro: ${s.neighborhoodUpgrades}/${s.totalNeighborhoodUpgrades}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Card(
                          key: const Key('pedagogical-sync-card'),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sincronizacao pedagogica',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.controller.pedagogicalBackendConfigured
                                      ? 'Backend configurado para este build.'
                                      : 'Backend HML ainda nao configurado. O progresso permanece seguro no aparelho.',
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${widget.controller.pendingPedagogicalSnapshots} snapshot pendente',
                                  key: const Key('pedagogical-pending-count'),
                                ),
                                const SizedBox(height: 12),
                                FilledButton.icon(
                                  onPressed: _syncing ? null : _sync,
                                  icon: const Icon(Icons.sync_rounded),
                                  label: Text(
                                    _syncing
                                        ? 'SINCRONIZANDO'
                                        : 'SINCRONIZAR AGORA',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

class _Metrics extends StatelessWidget {
  const _Metrics({
    required this.missions,
    required this.zones,
    required this.medals,
    required this.stars,
    required this.knowledge,
    required this.citizenship,
  });
  final String missions;
  final String zones;
  final String medals;
  final String stars;
  final String knowledge;
  final String citizenship;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Missoes', missions),
      ('Zonas', zones),
      ('Medalhas', medals),
      ('Estrelas', stars),
      ('Conhecimento', knowledge),
      ('Cidadania', citizenship),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 3 : 2;
        final width = (constraints.maxWidth - (12 * (columns - 1))) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          item.$2,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Text(item.$1),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
