import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key, required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final profile = controller.profile;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 54,
                        child: Icon(Icons.person_pin_circle_rounded, size: 66),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Olá! Eu sou o Melo.',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Nossa cidade precisa de pessoas que saibam fazer '
                        'boas escolhas. Aqui você não ganha apenas acertando '
                        'perguntas: suas decisões ajudam a tornar o trânsito '
                        'mais seguro e a transformar o bairro.',
                        textAlign: TextAlign.center,
                      ),
                      if (profile != null) ...[
                        const SizedBox(height: 20),
                        Text(
                          profile.type.initialTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                      const SizedBox(height: 30),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRoutes.zone1);
                        },
                        icon: const Icon(Icons.map_rounded),
                        label: const Text('COMEÇAR'),
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
