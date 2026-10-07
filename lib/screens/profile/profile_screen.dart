import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/enums/player_type.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha seu perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ProfileCard(
            type: PlayerType.child,
            icon: Icons.child_care_rounded,
            subtitle: 'Travessia, bicicleta, escola e segurança.',
          ),
          _ProfileCard(
            type: PlayerType.teen,
            icon: Icons.directions_bike_rounded,
            subtitle: 'Mobilidade, convivência e cidadania.',
          ),
          _ProfileCard(
            type: PlayerType.adult,
            icon: Icons.directions_car_rounded,
            subtitle: 'Legislação, direção defensiva e responsabilidade.',
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.type,
    required this.icon,
    required this.subtitle,
  });

  final PlayerType type;
  final IconData icon;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.avatar, arguments: type);
        },
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              CircleAvatar(radius: 32, child: Icon(icon, size: 34)),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(type.initialTitle),
                    const SizedBox(height: 6),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
