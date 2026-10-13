import 'package:flutter/material.dart';

/// Keeps the Navigator mounted while the player rotates the device.
class GameOrientationGate extends StatelessWidget {
  const GameOrientationGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final horizontal = constraints.maxWidth > constraints.maxHeight;
      return Stack(
        fit: StackFit.expand,
        children: [
          Offstage(
            offstage: !horizontal,
            child: ExcludeFocus(
              excluding: !horizontal,
              child: TickerMode(enabled: horizontal, child: child),
            ),
          ),
          if (!horizontal)
            const ColoredBox(
              key: Key('game-rotate-screen'),
              color: Color(0xFF123D68),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: 280,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.screen_rotation_rounded,
                              size: 72,
                              color: Color(0xFFFFD54F),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Gire a tela para jogar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Use o aparelho na horizontal. '
                              'No computador, aumente a largura da janela.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}
