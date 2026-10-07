import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';

class Zone1MapScreen extends StatelessWidget {
  const Zone1MapScreen({super.key, required this.controller});

  final PlayerController controller;

  static const _missions = [
    ('Z1_M01', 'Travessia Segura'),
    ('Z1_M02', 'Embarque Seguro'),
    ('Z1_M03', 'Bicicleta na Rota Escolar'),
    ('Z1_M04', 'S\u00f3 um Minutinho'),
    ('Z1_M05', 'Caminho Seguro'),
    ('Z1_SPECIAL', 'Sa\u00edda da Escola'),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = controller.progress;
        final totalStars = progress.missionStars.values.fold<int>(
          0,
          (total, value) => total + value,
        );

        return Scaffold(
          appBar: AppBar(title: const Text('Bairro / Escola')),
          body: Column(
            children: [
              _ScoreBar(
                citizenship: progress.citizenshipXp,
                knowledge: progress.knowledge,
                coins: progress.coins,
                stars: totalStars,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Icon(Icons.school_rounded, size: 72),
                            const SizedBox(height: 12),
                            Text(
                              'ZONA 1',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              'Bairro / Escola',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Observe o bairro, aprenda com as situa\u00e7\u00f5es '
                              'e ajude a transformar a \u00e1rea escolar.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (var index = 0; index < _missions.length; index++)
                      _MissionTile(
                        number: index + 1,
                        id: _missions[index].$1,
                        title: _missions[index].$2,
                        unlocked: progress.unlockedMissions.contains(
                          _missions[index].$1,
                        ),
                        stars: progress.missionStars[_missions[index].$1] ?? 0,
                        special: _missions[index].$1 == 'Z1_SPECIAL',
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.citizenship,
    required this.knowledge,
    required this.coins,
    required this.stars,
  });

  final int citizenship;
  final int knowledge;
  final int coins;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            _ScoreItem(
              icon: Icons.workspace_premium_rounded,
              value: citizenship,
              label: 'Cidadania',
            ),
            _ScoreItem(
              icon: Icons.menu_book_rounded,
              value: knowledge,
              label: 'Conhecimento',
            ),
            _ScoreItem(
              icon: Icons.monetization_on_rounded,
              value: coins,
              label: 'Moedas',
            ),
            _ScoreItem(
              icon: Icons.star_rounded,
              value: stars,
              label: 'Estrelas',
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  const _ScoreItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 2),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _MissionTile extends StatelessWidget {
  const _MissionTile({
    required this.number,
    required this.id,
    required this.title,
    required this.unlocked,
    required this.stars,
    required this.special,
  });

  final int number;
  final String id;
  final String title;
  final bool unlocked;
  final int stars;
  final bool special;

  bool get _isImplemented => id == 'Z1_M01' || id == 'Z1_M02';

  String? get _route {
    switch (id) {
      case 'Z1_M01':
        return AppRoutes.mission1;
      case 'Z1_M02':
        return AppRoutes.mission2;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: CircleAvatar(
          child: Icon(
            unlocked
                ? (special ? Icons.flag_rounded : Icons.location_on_rounded)
                : Icons.lock_rounded,
          ),
        ),
        title: Text(
          special ? 'Miss\u00e3o Especial \u2014 $title' : '$number. $title',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: unlocked
            ? Text(
                stars == 0
                    ? (_isImplemented
                          ? 'Dispon\u00edvel'
                          : 'Desbloqueada \u2014 pr\u00f3ximo pacote')
                    : '${'\u2605' * stars}${'\u2606' * (3 - stars)}',
              )
            : const Text('Bloqueada'),
        trailing: unlocked && _isImplemented
            ? const Icon(Icons.play_circle_outline_rounded)
            : null,
        onTap: unlocked && _isImplemented && _route != null
            ? () {
                Navigator.of(context).pushNamed(_route!);
              }
            : null,
      ),
    );
  }
}
