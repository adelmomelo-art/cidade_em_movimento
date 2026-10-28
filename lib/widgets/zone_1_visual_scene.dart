import 'package:flutter/material.dart';

import '../ui/visual_system.dart';
import 'zone_1_art.dart';

class Zone1VisualMission {
  const Zone1VisualMission({
    required this.id,
    required this.number,
    required this.title,
    required this.icon,
    required this.color,
    required this.alignment,
    required this.unlocked,
    required this.stars,
    required this.special,
  });

  final String id;
  final int number;
  final String title;
  final IconData icon;
  final Color color;
  final Alignment alignment;
  final bool unlocked;
  final int stars;
  final bool special;
}

class Zone1VisualScene extends StatelessWidget {
  const Zone1VisualScene({
    super.key,
    required this.missions,
    required this.purchasedUpgrades,
    required this.onMissionTap,
    this.scoreHud,
    this.upgradePanel,
    this.nightPreview = false,
    this.navigationPanel,
    this.orientationHint,
    this.viewportHeight,
    this.contentInsets = EdgeInsets.zero,
  });

  final List<Zone1VisualMission> missions;
  final Set<String> purchasedUpgrades;
  final ValueChanged<String> onMissionTap;
  final Widget? scoreHud;
  final Widget? upgradePanel;
  final bool nightPreview;
  final Widget? navigationPanel;
  final Widget? orientationHint;
  final double? viewportHeight;
  final EdgeInsets contentInsets;

  @override
  Widget build(BuildContext context) {
    final hasCrosswalk = purchasedUpgrades.contains('FAIXA_SEGURA');
    final hasLighting = purchasedUpgrades.contains('ILUMINACAO_ESCOLAR');
    final hasCyclePath = purchasedUpgrades.contains('TRECHO_CICLOVIARIO');

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final compact = width < 720;
        final worldHeight = viewportHeight ?? width / 1.5;
        final contentWidth = width - contentInsets.horizontal;
        final mentorWidth = contentWidth * .16;
        final world = Stack(
          fit: StackFit.expand,
          children: [
            Zone1NeighborhoodArt(
              nightPreview: nightPreview,
              crosswalk: hasCrosswalk,
              lighting: hasLighting,
              cyclePath: hasCyclePath,
            ),
          ],
        );
        Widget frame;
        if (compact) {
          frame = Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(
                  color: GameColors.navy,
                  child: Opacity(
                    opacity: .28,
                    child: Image.asset(
                      'assets/zone_1/bairro_escola_base_r7.webp',
                      cacheWidth: 768,
                      fit: BoxFit.cover,
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: worldHeight, child: world),
                  if (scoreHud != null || navigationPanel != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          ?scoreHud,
                          if (navigationPanel != null) ...[
                            const SizedBox(height: 6),
                            navigationPanel!,
                          ],
                          if (orientationHint != null) ...[
                            const SizedBox(height: 6),
                            orientationHint!,
                          ],
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 58,
                          child: Column(
                            children: [
                              const _MissionInvitation(),
                              const SizedBox(height: 6),
                              _MissionProgressionPanel(
                                missions: missions,
                                onMissionTap: onMissionTap,
                              ),
                            ],
                          ),
                        ),
                        if (upgradePanel == null)
                          const SizedBox(
                            width: 116,
                            height: 86,
                            child: IgnorePointer(child: _MentorPanel()),
                          ),
                        if (upgradePanel != null) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 42,
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 132,
                                  height: 98,
                                  child: IgnorePointer(child: _MentorPanel()),
                                ),
                                const SizedBox(height: 6),
                                upgradePanel!,
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          final upgradeWidth = contentWidth * (width >= 1000 ? .18 : .20);
          frame = SizedBox(
            height: worldHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                world,
                if (scoreHud != null)
                  Positioned(
                    key: const Key('zone1-score-overlay'),
                    left: contentInsets.left + 8,
                    right:
                        contentInsets.right +
                        (navigationPanel != null ? 232 : 8),
                    top: contentInsets.top + 10,
                    child: scoreHud!,
                  ),
                if (navigationPanel != null)
                  Positioned(
                    right: contentInsets.right + 8,
                    top: contentInsets.top + 10,
                    width: 216,
                    child: navigationPanel!,
                  ),
                Positioned(
                  left: contentInsets.left + 8,
                  bottom: contentInsets.bottom + 10,
                  width: contentWidth * .62,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _MissionInvitation(),
                      const SizedBox(height: 6),
                      _MissionProgressionPanel(
                        missions: missions,
                        onMissionTap: onMissionTap,
                        forceHorizontal: true,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: contentInsets.left + contentWidth * .62 + 12,
                  bottom: contentInsets.bottom + 10,
                  width: mentorWidth,
                  height: mentorWidth * .78,
                  child: const IgnorePointer(child: _MentorPanel()),
                ),
                if (upgradePanel != null)
                  Positioned(
                    right: contentInsets.right + 8,
                    top:
                        contentInsets.top + (navigationPanel != null ? 88 : 74),
                    bottom: contentInsets.bottom + 8,
                    width: upgradeWidth,
                    child: LayoutBuilder(
                      builder: (context, space) => Align(
                        alignment: Alignment.topCenter,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: space.maxWidth,
                            child: upgradePanel!,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
        return ClipRRect(
          key: const Key('zone1-map-canvas'),
          borderRadius: viewportHeight == null
              ? BorderRadius.circular(GameVisual.radiusLarge)
              : BorderRadius.zero,
          child: frame,
        );
      },
    );
  }
}

class _MissionProgressionPanel extends StatelessWidget {
  const _MissionProgressionPanel({
    required this.missions,
    required this.onMissionTap,
    this.forceHorizontal = false,
  });
  final bool forceHorizontal;
  final List<Zone1VisualMission> missions;
  final ValueChanged<String> onMissionTap;
  @override
  Widget build(BuildContext context) => Container(
    key: const Key('zone1-mission-window'),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF073650), GameColors.navy],
      ),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFF277797), width: 1.5),
      boxShadow: const [
        BoxShadow(
          color: Color(0x260A263B),
          blurRadius: 14,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = forceHorizontal || constraints.maxWidth >= 650;
            final dense = constraints.maxWidth < 650;
            if (!horizontal) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < missions.length; i += 2)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var j = i; j < i + 2 && j < missions.length; j++)
                          Expanded(
                            child: _ProgressionMissionEntry(
                              mission: missions[j],
                              horizontal: true,
                              dense: true,
                              onTap: missions[j].unlocked
                                  ? () => onMissionTap(missions[j].id)
                                  : null,
                            ),
                          ),
                      ],
                    ),
                ],
              );
            }
            final children = <Widget>[];
            for (var i = 0; i < missions.length; i++) {
              final mission = missions[i];
              final entry = _ProgressionMissionEntry(
                mission: mission,
                horizontal: horizontal,
                dense: dense,
                onTap: mission.unlocked ? () => onMissionTap(mission.id) : null,
              );
              children.add(horizontal ? Expanded(child: entry) : entry);
              if (i < missions.length - 1) {
                children.add(
                  Icon(
                    horizontal
                        ? Icons.arrow_forward_rounded
                        : Icons.arrow_downward_rounded,
                    size: horizontal ? 16 : 14,
                    color: mission.stars > 0
                        ? const Color(0xFFFF584D)
                        : const Color(0xFF56748A),
                  ),
                );
              }
            }
            return horizontal
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  )
                : Column(children: children);
          },
        ),
      ],
    ),
  );
}

class _ProgressionMissionEntry extends StatelessWidget {
  const _ProgressionMissionEntry({
    required this.mission,
    required this.onTap,
    required this.horizontal,
    required this.dense,
  });
  final bool dense;
  final Zone1VisualMission mission;
  final VoidCallback? onTap;
  final bool horizontal;
  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: dense ? 20 : 24,
      height: dense ? 20 : 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: mission.unlocked
            ? const Color(0xFFD5E0E9)
            : const Color(0xFF52677B),
        border: Border.all(
          color: mission.unlocked
              ? const Color(0xFF8FD7EE)
              : const Color(0xFF6F8496),
          width: 2,
        ),
      ),
      child: Center(
        child: !mission.unlocked
            ? const Icon(Icons.lock_rounded, size: 16, color: Color(0xFFCBD5E1))
            : mission.special
            ? const Icon(Icons.star_rounded, size: 20, color: GameColors.yellow)
            : Text(
                '${mission.number}',
                style: const TextStyle(
                  color: GameColors.navy,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
    final title = Text(
      mission.title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      textAlign: horizontal ? TextAlign.center : TextAlign.left,
      style: TextStyle(
        color: mission.unlocked ? Colors.white : const Color(0xFFACBBC9),
        fontWeight: FontWeight.w800,
        fontSize: 10,
        height: 1.15,
      ),
    );
    final details = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: horizontal
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 2),
        Zone1MissionStars(stars: mission.stars),
      ],
    );
    return Tooltip(
      message: mission.unlocked ? mission.title : '${mission.title}: bloqueada',
      child: Semantics(
        button: mission.unlocked,
        enabled: mission.unlocked,
        label:
            '${mission.number}. ${mission.title}. ${mission.unlocked ? 'Disponível' : 'Bloqueada'}',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: Key('zone1-visual-mission-${mission.id}'),
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 76),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                child: horizontal
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [badge, const SizedBox(height: 2), details],
                      )
                    : Row(
                        children: [
                          badge,
                          const SizedBox(width: 12),
                          Expanded(child: details),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MissionInvitation extends StatelessWidget {
  const _MissionInvitation();
  @override
  Widget build(BuildContext context) => const Text(
    'ESCOLHA A MISSÃO E AVANCE PELO BAIRRO',
    key: Key('zone1-mission-invitation'),
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w900,
      shadows: [
        Shadow(color: GameColors.navy, blurRadius: 4),
        Shadow(color: GameColors.navy, offset: Offset(0, 1), blurRadius: 2),
      ],
    ),
  );
}

class _MentorPanel extends StatelessWidget {
  const _MentorPanel();
  @override
  Widget build(BuildContext context) => const SizedBox.expand(
    key: Key('zone1-mentor-panel'),
    child: MeloMascot(presenting: true),
  );
}

class Zone1MissionStars extends StatelessWidget {
  const Zone1MissionStars({super.key, required this.stars});
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '$stars de 3 estrelas: ${'\u2605' * stars}${'\u2606' * (3 - stars)}',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < 3; index++)
              Icon(
                index < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 14,
                color: GameColors.yellow,
              ),
          ],
        ),
      ),
    );
  }
}
