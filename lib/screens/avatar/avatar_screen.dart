import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key, required this.controller, required this.type});

  final PlayerController controller;
  final PlayerType type;

  @override
  Widget build(BuildContext context) {
    final options = switch (type) {
      PlayerType.child => const [
        _AvatarOption(
          id: 'child_boy',
          label: 'Menino',
          icon: Icons.boy_rounded,
        ),
        _AvatarOption(
          id: 'child_girl',
          label: 'Menina',
          icon: Icons.girl_rounded,
        ),
      ],
      PlayerType.teen => const [
        _AvatarOption(
          id: 'teen_default',
          label: 'Adolescente',
          icon: Icons.person_rounded,
        ),
      ],
      PlayerType.adult => const [
        _AvatarOption(
          id: 'adult_default',
          label: 'Adulto',
          icon: Icons.person_rounded,
        ),
      ],
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Escolha seu avatar')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: GridView.count(
            padding: const EdgeInsets.all(24),
            crossAxisCount: options.length == 1 ? 1 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: options.length == 1 ? 1.8 : 0.9,
            children: [
              for (final option in options)
                Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      await controller.createProfile(
                        type: type,
                        avatarId: option.id,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.intro,
                        (route) => route.isFirst,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(option.icon, size: 76),
                          const SizedBox(height: 16),
                          Text(
                            option.label,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarOption {
  const _AvatarOption({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}
