import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const Icon(Icons.traffic_rounded, size: 96),
                  const SizedBox(height: 24),
                  Text(
                    'CIDADE EM MOVIMENTO',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aprenda. Decida. Transforme a cidade.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 36),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 38,
                            child: Icon(
                              Icons.person_pin_circle_rounded,
                              size: 46,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Melo',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Agente de Tr\u00e2nsito e guia da sua jornada.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        controller.hasProfile
                            ? AppRoutes.zone1
                            : AppRoutes.profile,
                      );
                    },
                    icon: Icon(
                      controller.hasProfile
                          ? Icons.play_arrow_rounded
                          : Icons.sports_esports_rounded,
                    ),
                    label: Text(controller.hasProfile ? 'CONTINUAR' : 'JOGAR'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
