import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/enums/player_type.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const artworkAsset = 'assets/profile/escolha_perfil_r25.png';
  static const artworkSize = Size(1672, 940);
  static const _profiles = [
    (
      type: PlayerType.child,
      label: 'CRIANÇA',
      hint:
          'Explorador da Cidade. Aprenda brincando com missões do dia a dia. Escolher avatar de criança.',
      bounds: Rect.fromLTWH(114, 198, 479, 699),
    ),
    (
      type: PlayerType.teen,
      label: 'ADOLESCENTE',
      hint:
          'Cidadão em Formação. Enfrente novos desafios e se prepare para o futuro. Escolher avatar de adolescente.',
      bounds: Rect.fromLTWH(606, 198, 460, 699),
    ),
    (
      type: PlayerType.adult,
      label: 'ADULTO',
      hint:
          'Condutor Consciente. Aprofunde seus conhecimentos e seja referência no trânsito. Escolher avatar de adulto.',
      bounds: Rect.fromLTWH(1079, 198, 477, 699),
    ),
  ];

  void _back(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF102A43),
    body: Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRect(
              child: ImageFiltered(
                key: const Key('profile-ambient-background'),
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
          child: IgnorePointer(child: ColoredBox(color: Color(0x22102A43))),
        ),
        SafeArea(
          child: SizedBox.expand(
            child: FittedBox(
              key: const Key('profile-fitted-artwork'),
              fit: BoxFit.contain,
              child: RepaintBoundary(
                key: const Key('profile-artwork'),
                child: SizedBox(
                  width: artworkSize.width,
                  height: artworkSize.height,
                  child: Stack(
                    key: const Key('profile-visual-list'),
                    fit: StackFit.expand,
                    children: [
                      Semantics(
                        label:
                            'Escolha seu perfil. A mesma cidade, diferentes desafios.',
                        image: true,
                        child: Image.asset(
                          artworkAsset,
                          key: const Key('profile-approved-image'),
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.medium,
                          excludeFromSemantics: true,
                        ),
                      ),
                      Positioned.fromRect(
                        rect: const Rect.fromLTWH(26, 40, 244, 88),
                        child: _ProfileAction(
                          key: const Key('profile-back-button'),
                          label: 'VOLTAR',
                          hint: 'Voltar à tela anterior',
                          onPressed: () => _back(context),
                        ),
                      ),
                      for (final profile in _profiles)
                        Positioned.fromRect(
                          rect: profile.bounds,
                          child: _ProfileAction(
                            key: Key('profile-card-${profile.type.name}'),
                            label: profile.label,
                            hint: profile.hint,
                            onPressed: () => Navigator.of(context).pushNamed(
                              AppRoutes.avatar,
                              arguments: profile.type,
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
  );
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
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
          borderRadius: BorderRadius.circular(32),
          hoverColor: const Color(0x22FFFFFF),
          focusColor: const Color(0x55FFFFFF),
          splashColor: const Color(0x44FFFFFF),
          child: const SizedBox.expand(),
        ),
      ),
    ),
  );
}
