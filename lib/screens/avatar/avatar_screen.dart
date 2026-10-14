import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';
import '../../widgets/approved_artwork_page.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key, required this.controller, required this.type});

  final PlayerController controller;
  final PlayerType type;

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  bool _saving = false;

  Future<void> _choose(bool female) async {
    if (_saving) {
      return;
    }
    setState(() => _saving = true);
    final id = switch (widget.type) {
      PlayerType.child => female ? 'child_girl' : 'child_boy',
      PlayerType.teen => female ? 'teen_girl' : 'teen_default',
      PlayerType.adult => female ? 'adult_woman' : 'adult_default',
    };
    try {
      await widget.controller.createProfile(type: widget.type, avatarId: id);
      if (!mounted) {
        return;
      }
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.intro, (route) => route.isFirst);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível salvar. Toque no personagem para tentar novamente.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _back() {
    if (_saving) {
      return;
    }
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bounds measured separately on each approved image; no regenerated art.
    final art = switch (widget.type) {
      PlayerType.child => (
        asset: 'assets/avatar/escolha_crianca_r26.png',
        height: 941.0,
        back: const Rect.fromLTWH(24, 132, 246, 80),
        male: const Rect.fromLTWH(297, 206, 529, 665),
        female: const Rect.fromLTWH(844, 206, 530, 665),
      ),
      PlayerType.teen => (
        asset: 'assets/avatar/escolha_adolescente_r26.png',
        height: 941.0,
        back: const Rect.fromLTWH(50, 143, 240, 72),
        male: const Rect.fromLTWH(293, 229, 533, 652),
        female: const Rect.fromLTWH(844, 229, 533, 652),
      ),
      PlayerType.adult => (
        asset: 'assets/avatar/escolha_adulto_r26.png',
        height: 940.0,
        back: const Rect.fromLTWH(50, 148, 237, 70),
        male: const Rect.fromLTWH(313, 222, 515, 653),
        female: const Rect.fromLTWH(845, 222, 515, 653),
      ),
    };
    return PopScope(
      canPop: !_saving,
      child: Stack(
        children: [
          ApprovedArtworkPage(
            asset: art.asset,
            size: Size(1672, art.height),
            prefix: 'avatar',
            description: 'Escolha seu avatar. Perfil: ${widget.type.label}.',
            actions: [
              Positioned.fromRect(
                rect: art.back,
                child: ArtworkAction(
                  key: const Key('avatar-back-button'),
                  label: 'VOLTAR',
                  hint: 'Voltar à escolha do perfil',
                  onPressed: _saving ? null : _back,
                ),
              ),
              Positioned.fromRect(
                rect: art.male,
                child: ArtworkAction(
                  key: const Key('avatar-male-card'),
                  label: 'MASCULINO',
                  hint: 'Escolher personagem masculino e conhecer o Melo',
                  onPressed: _saving ? null : () => _choose(false),
                ),
              ),
              Positioned.fromRect(
                rect: art.female,
                child: ArtworkAction(
                  key: const Key('avatar-female-card'),
                  label: 'FEMININO',
                  hint: 'Escolher personagem feminino e conhecer o Melo',
                  onPressed: _saving ? null : () => _choose(true),
                ),
              ),
            ],
          ),
          if (_saving)
            const Positioned.fill(
              child: AbsorbPointer(
                child: ColoredBox(
                  color: Color(0x44102A43),
                  child: Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Salvando personagem',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
