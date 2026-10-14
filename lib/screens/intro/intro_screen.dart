import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../widgets/approved_artwork_page.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key, required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) => ApprovedArtworkPage(
    asset: 'assets/intro/apresentacao_melo_r26.png',
    size: const Size(1672, 941),
    prefix: 'intro',
    description:
        'Bem-vindo à Cidade em Movimento. Olá! Eu sou o Melo. '
        'Aqui, suas decisões ajudam a tornar o trânsito mais seguro e a '
        'transformar a cidade. Vamos começar?',
    actions: [
      Positioned.fromRect(
        rect: const Rect.fromLTWH(194, 716, 598, 173),
        child: ArtworkAction(
          key: const Key('intro-start-button'),
          label: 'COMEÇAR',
          hint: 'Abrir o mapa da cidade',
          onPressed: () => Navigator.of(context).pushReplacementNamed(
            controller.hasProfile ? AppRoutes.fortalezaMap : AppRoutes.profile,
          ),
        ),
      ),
    ],
  );
}
