import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final PlayerController controller;

  static const artworkAsset = 'assets/home/tela_inicial_r24.png';
  static const artworkSize = Size(1672, 941);
  static const _brandLabel =
      'CIDADE EM MOVIMENTO. Aprenda. Decida. Transforme a cidade. '
      'Jogo educativo de trânsito. Melo, Agente de Trânsito da AMC. '
      'Seu guia no jogo. Aqui você aprende, decide e ajuda a construir '
      'uma cidade melhor!';

  // Coordinates measured on the approved artwork, including its button borders.
  static const _actions = [
    (
      key: 'home-play-button',
      label: 'JOGAR',
      route: AppRoutes.fortalezaMap,
      bounds: Rect.fromLTWH(46, 594, 389, 144),
    ),
    (
      key: 'home-map-button',
      label: 'MAPA DA CIDADE',
      route: AppRoutes.fortalezaMap,
      bounds: Rect.fromLTWH(439, 594, 399, 144),
    ),
    (
      key: 'home-missions-button',
      label: 'MINHAS MISSÕES',
      route: AppRoutes.zone1,
      bounds: Rect.fromLTWH(46, 742, 389, 140),
    ),
    (
      key: 'home-achievements-button',
      label: 'CONQUISTAS',
      route: AppRoutes.playerProgress,
      bounds: Rect.fromLTWH(439, 742, 399, 140),
    ),
  ];

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => Scaffold(
      backgroundColor: const Color(0xFF102A43),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fill only the extra viewport area with ambient scenery. The sharp
          // approved artwork below remains complete and proportional.
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRect(
                child: ImageFiltered(
                  key: const Key('home-ambient-background'),
                  imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Image.asset(
                    artworkAsset,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: IgnorePointer(child: ColoredBox(color: Color(0x33102A43))),
          ),
          SafeArea(
            child: SizedBox.expand(
              child: FittedBox(
                key: const Key('home-fitted-artwork'),
                fit: BoxFit.contain,
                child: RepaintBoundary(
                  key: const Key('home-artwork'),
                  child: SizedBox(
                    width: artworkSize.width,
                    height: artworkSize.height,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Semantics(
                          key: const Key('home-brand-mark'),
                          label: _brandLabel,
                          image: true,
                          child: Image.asset(
                            artworkAsset,
                            key: const Key('home-approved-image'),
                            fit: BoxFit.fill,
                            excludeFromSemantics: true,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                        for (final action in _actions)
                          Positioned.fromRect(
                            rect: action.bounds,
                            child: _ArtworkButton(
                              key: Key(action.key),
                              label: action.label,
                              hint: controller.hasProfile
                                  ? action.key == 'home-play-button'
                                        ? 'Continuar sua jornada'
                                        : 'Abrir ${action.label.toLowerCase()}'
                                  : 'Escolha seu perfil para começar',
                              onPressed: () => Navigator.of(context).pushNamed(
                                controller.hasProfile
                                    ? action.route
                                    : AppRoutes.profile,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ArtworkButton extends StatelessWidget {
  const _ArtworkButton({
    super.key,
    required this.label,
    required this.hint,
    required this.onPressed,
  });

  final String label;
  final String hint;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    hint: hint,
    onTap: onPressed,
    child: Tooltip(
      message: hint,
      excludeFromSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          excludeFromSemantics: true,
          borderRadius: BorderRadius.circular(40),
          hoverColor: const Color(0x22FFFFFF),
          focusColor: const Color(0x55FFFFFF),
          splashColor: const Color(0x44FFFFFF),
          child: const SizedBox.expand(),
        ),
      ),
    ),
  );
}
