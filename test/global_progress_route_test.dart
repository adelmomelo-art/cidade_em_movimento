import 'package:cidade_em_movimento/app/routes.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/screens/global_progress/global_progress_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('rota Progressao Global abre para jogador com perfil', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final controller = PlayerController(StorageService(preferences));
    await controller.initialize();

    await controller.createProfile(
      type: PlayerType.adult,
      avatarId: 'adult_default',
    );

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRoutes.globalProgress,
        onGenerateRoute: (settings) {
          return AppRoutes.onGenerateRoute(settings, controller);
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GlobalProgressScreen), findsOneWidget);
    expect(find.text('PROGRESSÃO GLOBAL'), findsOneWidget);
  });
}
