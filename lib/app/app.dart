import 'package:flutter/material.dart';

import '../controllers/player_controller.dart';
import '../widgets/game_orientation_gate.dart';
import 'routes.dart';
import 'theme.dart';

class CidadeEmMovimentoApp extends StatelessWidget {
  const CidadeEmMovimentoApp({super.key, required this.controller});

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      title: 'Cidade em Movimento',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) =>
          GameOrientationGate(child: child ?? const SizedBox.shrink()),
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        return AppRoutes.onGenerateRoute(settings, controller);
      },
    );
  }
}
