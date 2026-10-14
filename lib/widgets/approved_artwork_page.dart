import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Complete approved composition, with native controls in image coordinates.
class ApprovedArtworkPage extends StatelessWidget {
  const ApprovedArtworkPage({
    super.key,
    required this.asset,
    required this.size,
    required this.prefix,
    required this.description,
    required this.actions,
  });

  final String asset;
  final Size size;
  final String prefix;
  final String description;
  final List<Widget> actions;

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
                key: Key('$prefix-ambient-background'),
                imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Image.asset(
                  asset,
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
              fit: BoxFit.contain,
              child: RepaintBoundary(
                key: Key('$prefix-artwork'),
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Semantics(
                        image: true,
                        label: description,
                        child: Image.asset(
                          asset,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.medium,
                          excludeFromSemantics: true,
                        ),
                      ),
                      ...actions,
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

class ArtworkAction extends StatelessWidget {
  const ArtworkAction({
    super.key,
    required this.label,
    required this.hint,
    required this.onPressed,
  });

  final String label;
  final String hint;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onPressed != null,
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
