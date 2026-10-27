import 'package:flutter/material.dart';

import '../../controllers/player_controller.dart';
import '../../services/global_progress_service.dart';
import '../../widgets/city_utility_page.dart';

class GlobalProgressScreen extends StatelessWidget {
  const GlobalProgressScreen({super.key, required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final summary = const GlobalProgressService().summarize(
          controller.progress,
        );

        return CityUtilityPage(
          title: 'PROGRESSÃO GLOBAL',
          prefix: 'global-progress',
          child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _JourneyHeader(summary: summary),
                        const SizedBox(height: 16),
                        _CoreProgress(summary: summary),
                        const SizedBox(height: 16),
                        _ExtraPillars(summary: summary),
                        const SizedBox(height: 16),
                        _Achievements(summary: summary),
                        if (summary.fortalezaComplete) ...[
                          const SizedBox(height: 16),
                          const _CompletionCard(),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
          ),
        );
      },
    );
  }
}

class _JourneyHeader extends StatelessWidget {
  const _JourneyHeader({required this.summary});
  final GlobalProgressSummary summary;
  @override
  Widget build(BuildContext context) => Card(
    key: const Key('global-progress-header'),
    child: Padding(padding: const EdgeInsets.all(24),
      child: Row(children: [
        Icon(summary.fortalezaComplete ? Icons.workspace_premium_rounded
          : Icons.map_rounded, size: 84, color: const Color(0xFF0062CF)),
        const SizedBox(width: 20),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(summary.fortalezaComplete ? 'Fortaleza concluida' : 'Jornada Fortaleza',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            LinearProgressIndicator(key: const Key('global-progress-bar'),
              value: summary.completionRatio, minHeight: 16,
              borderRadius: BorderRadius.circular(12)),
            const SizedBox(height: 10),
            Text('${summary.completionPercent}% da jornada principal',
              key: const Key('global-progress-percent'),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        )),
      ]),
    ),
  );
}

class _CoreProgress extends StatelessWidget {
  const _CoreProgress({required this.summary});
  final GlobalProgressSummary summary;
  @override
  Widget build(BuildContext context) => Card(
    key: const Key('global-core-progress'),
    child: Padding(padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Critérios de conclusão Fortaleza',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('O 100% exige as 6 zonas, as 6 medalhas e as 36 missões concluídas.',
          style: TextStyle(fontSize: 26)),
        const SizedBox(height: 14),
        _ProgressRow(key: const Key('global-zones'), icon: Icons.map_rounded,
          title: 'Zonas', value: '${summary.completedZones}/${summary.totalZones}',
          complete: summary.completedZones == summary.totalZones),
        const Divider(height: 14),
        _ProgressRow(key: const Key('global-medals'), icon: Icons.emoji_events_rounded,
          title: 'Medalhas', value: '${summary.medals}/${summary.totalMedals}',
          complete: summary.medals == summary.totalMedals),
        const Divider(height: 14),
        _ProgressRow(key: const Key('global-missions'), icon: Icons.flag_rounded,
          title: 'Missões', value: '${summary.completedMissions}/${summary.totalMissions}',
          complete: summary.completedMissions == summary.totalMissions),
        const Divider(height: 14),
        _ProgressRow(key: const Key('global-stars'), icon: Icons.star_rounded,
          title: 'Estrelas acumuladas', value: '${summary.totalStars}', complete: false),
      ]),
    ),
  );
}

class _ExtraPillars extends StatelessWidget {
  const _ExtraPillars({required this.summary});

  final GlobalProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('global-extra-pillars'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilares extras',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Duelo das Placas e Construa o Bairro ampliam a experiencia, mas nao bloqueiam o fechamento das seis zonas.',
            ),
            const SizedBox(height: 16),
            _ProgressRow(
              key: const Key('global-duel'),
              icon: Icons.signpost_rounded,
              title: 'Duelo das Placas',
              value:
                  '${summary.signDuelBestCorrect}/6 melhor resultado - ${summary.signDuelPlays} duelos',
              complete: summary.signMasterAchievement,
            ),
            const Divider(height: 24),
            _ProgressRow(
              key: const Key('global-neighborhood'),
              icon: Icons.location_city_rounded,
              title: 'Construa o Bairro',
              value:
                  '${summary.neighborhoodUpgrades}/${summary.totalNeighborhoodUpgrades} melhorias',
              complete: summary.neighborhoodBuilderAchievement,
            ),
          ],
        ),
      ),
    );
  }
}

class _Achievements extends StatelessWidget {
  const _Achievements({required this.summary});

  final GlobalProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    final achievements =
        <({String title, String description, bool unlocked, IconData icon})>[
          (
            title: 'Primeiro Passo',
            description: 'Concluir a primeira zona.',
            unlocked: summary.firstZoneAchievement,
            icon: Icons.directions_walk_rounded,
          ),
          (
            title: 'Meio Caminho',
            description: 'Concluir pelo menos tres zonas.',
            unlocked: summary.halfwayAchievement,
            icon: Icons.route_rounded,
          ),
          (
            title: 'Guardiao de Fortaleza',
            description: 'Concluir integralmente a jornada das seis zonas.',
            unlocked: summary.fortalezaGuardianAchievement,
            icon: Icons.workspace_premium_rounded,
          ),
          (
            title: 'Mestre das Placas',
            description: 'Acertar 6 de 6 no Duelo das Placas.',
            unlocked: summary.signMasterAchievement,
            icon: Icons.signpost_rounded,
          ),
          (
            title: 'Transformador Urbano',
            description: 'Instalar as tres melhorias de Construa o Bairro.',
            unlocked: summary.neighborhoodBuilderAchievement,
            icon: Icons.construction_rounded,
          ),
        ];

    return Card(
      key: const Key('global-achievements'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conquistas',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            for (var index = 0; index < achievements.length; index++) ...[
              _AchievementRow(
                title: achievements[index].title,
                description: achievements[index].description,
                unlocked: achievements[index].unlocked,
                icon: achievements[index].icon,
              ),
              if (index < achievements.length - 1) const Divider(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.complete,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool complete;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Icon(icon, size: 38, color: const Color(0xFF0062CF)),
      const SizedBox(width: 14),
      Expanded(flex: 3, child: Text(title,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700))),
      const SizedBox(width: 12),
      Flexible(flex: 4, child: Text(value, textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800))),
      const SizedBox(width: 10),
      Icon(complete ? Icons.check_circle_rounded
        : Icons.radio_button_unchecked_rounded,
        size: 30, color: complete ? const Color(0xFF239947)
          : const Color(0xFF8293A3)),
    ]),
  );
}

class _AchievementRow extends StatelessWidget {
  const _AchievementRow({
    required this.title,
    required this.description,
    required this.unlocked,
    required this.icon,
  });

  final String title;
  final String description;
  final bool unlocked;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(child: Icon(unlocked ? icon : Icons.lock_outline_rounded)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(description),
            ],
          ),
        ),
        Text(
          unlocked ? 'CONQUISTADA' : 'PENDENTE',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('global-fortaleza-complete'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.celebration_rounded, size: 64),
            const SizedBox(height: 12),
            Text(
              'Fortaleza em Movimento - Jornada Concluida',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'As seis zonas da cidade foram percorridas. Seu legado de cidadania, conhecimento e boas decisoes esta registrado.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
