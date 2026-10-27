import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'approved_artwork_page.dart';

/// Production plates derived from the approved R44 mockups. Text, navigation
/// and all player values are native widgets in the same artwork coordinates.
class CityUtilityPage extends StatelessWidget {
  const CityUtilityPage({super.key, required this.title,
    required this.prefix, required this.child, this.trailing});
  static const menuAsset = 'assets/utility/r44/mais_opcoes_base.png';
  static const progressAsset = 'assets/utility/r44/progresso_global_base.png';
  static const artworkSize = Size(1672, 941);
  final String title;
  final String prefix;
  final Widget child;
  final Widget? trailing;
  bool get _menu => prefix == 'more-options';

  @override
  Widget build(BuildContext context) {
    final asset = _menu ? menuAsset : progressAsset;
    final theme = Theme.of(context);
    return Scaffold(backgroundColor: const Color(0xFF062565),
      body: Stack(fit: StackFit.expand, children: [
        IgnorePointer(child: ClipRect(child: ImageFiltered(
          imageFilter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Image.asset(asset, fit: BoxFit.cover,
            excludeFromSemantics: true),
        ))),
        const IgnorePointer(child: ColoredBox(color: Color(0x44062565))),
        SafeArea(child: SizedBox.expand(child: FittedBox(fit: BoxFit.contain,
          child: SizedBox(width: artworkSize.width, height: artworkSize.height,
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(asset, key: Key('$prefix-city-background'),
                fit: BoxFit.fill, filterQuality: FilterQuality.medium,
                excludeFromSemantics: true),
              Positioned.fromRect(
                rect: _menu ? const Rect.fromLTWH(290, 26, 945, 96)
                  : const Rect.fromLTWH(300, 20, 1060, 96),
                child: Center(child: FittedBox(fit: BoxFit.scaleDown,
                  child: Text(title, style: const TextStyle(
                    color: Colors.white, fontSize: 76,
                    fontWeight: FontWeight.w900,
                    shadows: [Shadow(color: Color(0x88062565),
                      offset: Offset(0, 4), blurRadius: 3)],
                  )),
                )),
              ),
              if (_menu) Positioned.fill(child: child)
              else Positioned.fromRect(
                rect: const Rect.fromLTWH(815, 165, 785, 711),
                child: ClipRRect(borderRadius: BorderRadius.circular(24),
                  child: Theme(data: theme.copyWith(
                    textTheme: theme.textTheme.apply(fontSizeFactor: 2,
                      bodyColor: const Color(0xFF062565),
                      displayColor: const Color(0xFF062565)),
                    cardTheme: CardThemeData(color: const Color(0xFFFFFEF8),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                        side: const BorderSide(color: Color(0xFFE1E8EC))),
                    ),
                  ), child: child),
                ),
              ),
              Positioned.fromRect(rect: const Rect.fromLTWH(25, 12, 150, 130),
                child: ArtworkAction(key: Key('$prefix-back'),
                  label: 'Voltar', hint: 'Voltar à tela anterior',
                  onPressed: () => Navigator.of(context).maybePop()),
              ),
              if (trailing != null) Positioned.fromRect(
                rect: const Rect.fromLTWH(1485, 26, 150, 96),
                child: trailing!,
              ),
            ]),
          ),
        ))),
      ]),
    );
  }
}

class CityMenuAction extends StatelessWidget {
  const CityMenuAction({super.key, required this.bounds,
    required this.labelBounds, required this.title, required this.onTap,
    this.subtitle, this.subtitleKey, this.subtitleBounds, this.fontSize = 48});
  final Rect bounds;
  final Rect labelBounds;
  final String title;
  final VoidCallback onTap;
  final String? subtitle;
  final Key? subtitleKey;
  final Rect? subtitleBounds;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Positioned.fromRect(rect: bounds,
    child: Semantics(button: true, label: title,
      value: subtitle, onTap: onTap,
      child: Material(color: Colors.transparent,
        child: InkWell(onTap: onTap,
          borderRadius: BorderRadius.circular(44),
          excludeFromSemantics: true,
          child: ExcludeSemantics(child: Stack(children: [
            Positioned.fromRect(rect: labelBounds.shift(-bounds.topLeft),
              child: Center(child: FittedBox(fit: BoxFit.scaleDown,
                child: Text(title, style: TextStyle(color: Colors.white,
                  fontSize: fontSize, fontWeight: FontWeight.w900)),
              )),
            ),
            if (subtitle != null && subtitleBounds != null)
              Positioned.fromRect(rect: subtitleBounds!.shift(-bounds.topLeft),
                child: Center(child: FittedBox(fit: BoxFit.scaleDown,
                  child: Text(subtitle!, key: subtitleKey,
                    style: const TextStyle(color: Color(0xFFC7F6FF),
                      fontSize: 34, fontWeight: FontWeight.w700)),
                )),
              ),
          ])),
        ),
      ),
    ),
  );
}
