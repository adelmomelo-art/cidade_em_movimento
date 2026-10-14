import 'package:flutter/material.dart';

import '../core/enums/player_type.dart';
import '../models/player_profile.dart';

class FortalezaMapAvatar extends StatelessWidget {
  const FortalezaMapAvatar({
    super.key,
    required this.profile,
    this.portrait = false,
  });

  final PlayerProfile? profile;
  final bool portrait;

  static String variantFor(PlayerProfile? profile) {
    final female = const {
      'child_girl',
      'teen_girl',
      'adult_woman',
    }.contains(profile?.avatarId);
    final type = profile?.type ?? PlayerType.child;
    return '${type.name}_${female ? 'female' : 'male'}';
  }

  @override
  Widget build(BuildContext context) {
    final variant = variantFor(profile);
    if (!portrait) {
      return Image.asset(
        'assets/fortaleza/$variant.png',
        key: Key('fortaleza-avatar-$variant'),
        fit: BoxFit.contain,
        cacheWidth: 256,
        excludeFromSemantics: true,
      );
    }
    final type = profile?.type ?? PlayerType.child;
    final female = variant.endsWith('female');
    final source = switch (type) {
      PlayerType.child => 'assets/avatar/escolha_crianca_r26.png',
      PlayerType.teen => 'assets/avatar/escolha_adolescente_r26.png',
      PlayerType.adult => 'assets/avatar/escolha_adulto_r26.png',
    };
    final crop = switch (type) {
      PlayerType.child =>
        female
            ? const Rect.fromLTWH(934, 244, 365, 340)
            : const Rect.fromLTWH(350, 229, 431, 368),
      PlayerType.teen =>
        female
            ? const Rect.fromLTWH(928, 248, 371, 345)
            : const Rect.fromLTWH(374, 239, 374, 342),
      PlayerType.adult =>
        female
            ? const Rect.fromLTWH(936, 257, 360, 345)
            : const Rect.fromLTWH(360, 235, 399, 350),
    };
    return ClipOval(
      key: Key('fortaleza-portrait-$variant'),
      child: ColoredBox(
        color: const Color(0xFF1FC4F2),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: crop.width,
            height: crop.height,
            child: Stack(
              children: [
                Positioned(
                  left: -crop.left,
                  top: -crop.top,
                  width: 1672,
                  height: type == PlayerType.adult ? 940 : 941,
                  child: Image.asset(
                    source,
                    fit: BoxFit.fill,
                    cacheWidth: 836,
                    excludeFromSemantics: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
