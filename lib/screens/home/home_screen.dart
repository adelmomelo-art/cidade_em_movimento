import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../ui/visual_system.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GameBackground(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Column(
                  children: [
                    Container(
                      key: const Key('home-brand-mark'),
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [GameColors.blue, GameColors.cyan],
                        ),
                        boxShadow: GameVisual.softShadow,
                      ),
                      child: const Icon(
                        Icons.traffic_rounded,
                        color: Colors.white,
                        size: 62,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'CIDADE EM MOVIMENTO',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aprenda. Decida. Transforme a cidade.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: GameColors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30),
                    GameHeroPanel(
                      eyebrow: 'Seu guia',
                      title: 'Melo',
                      subtitle:
                          'Agente de Transito e mentor da sua jornada por uma Fortaleza mais segura.',
                      icon: Icons.person_pin_circle_rounded,
                      trailing: Row(
                        children: [
                          Icon(
                            Icons.location_city_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Fortaleza - Ceara',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    FilledButton.icon(
                      key: const Key('home-play-button'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          controller.hasProfile
                              ? AppRoutes.fortalezaMap
                              : AppRoutes.profile,
                        );
                      },
                      icon: Icon(
                        controller.hasProfile
                            ? Icons.play_arrow_rounded
                            : Icons.sports_esports_rounded,
                      ),
                      label: Text(
                        controller.hasProfile ? 'CONTINUAR' : 'JOGAR',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Transito, cidadania, mobilidade e convivencia em uma experiencia educativa.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
