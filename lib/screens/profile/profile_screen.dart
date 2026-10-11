import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/enums/player_type.dart';
import '../../ui/visual_system.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha seu perfil')),
      body: GameBackground(
        child: ListView(
          key: const Key('profile-visual-list'),
          children: [
            const GameHeroPanel(
              eyebrow: 'Comece sua jornada',
              title: 'Como voce participa da cidade?',
              subtitle:
                  'O conteudo se adapta ao seu perfil sem alterar as regras centrais do jogo.',
              icon: Icons.people_alt_rounded,
            ),
            const SizedBox(height: 18),
            _ProfileCard(
              type: PlayerType.child,
              icon: Icons.child_care_rounded,
              subtitle: 'Travessia, bicicleta, escola e seguranca.',
              accent: GameColors.green,
            ),
            _ProfileCard(
              type: PlayerType.teen,
              icon: Icons.directions_bike_rounded,
              subtitle: 'Mobilidade, convivencia e cidadania.',
              accent: GameColors.orange,
            ),
            _ProfileCard(
              type: PlayerType.adult,
              icon: Icons.directions_car_rounded,
              subtitle: 'Legislacao, direcao defensiva e responsabilidade.',
              accent: GameColors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.type,
    required this.icon,
    required this.subtitle,
    required this.accent,
  });

  final PlayerType type;
  final IconData icon;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GameSectionCard(
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.avatar, arguments: type);
        },
        child: Row(
          children: [
            GameIllustrationBadge(icon: icon, size: 66, color: accent),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    type.initialTitle,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(subtitle),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
