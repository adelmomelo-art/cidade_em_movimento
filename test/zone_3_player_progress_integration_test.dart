import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/player_progress/player_progress_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Meu Progresso lista melhorias instaladas da Zona 3', (
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

    await controller.completeMission(
      result: const MissionResult(
        missionId: 'FAST6_PROGRESS_COINS',
        stars: 3,
        score: 100,
        citizenship: 0,
        knowledge: 0,
        coins: 240,
        errors: 0,
      ),
    );

    await controller.purchaseUpgrade('TRAVESSIA_ORLA_SEGURA');
    await controller.purchaseUpgrade('CICLOVIA_CONECTADA');
    await controller.purchaseUpgrade('EMBARQUE_ORGANIZADO');

    await tester.pumpWidget(
      MaterialApp(home: PlayerProgressScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    final scrollable = find.byType(Scrollable).first;

    for (final title in <String>[
      'Travessia da Orla',
      'Ciclovia Conectada',
      'Embarque Organizado',
    ]) {
      final finder = find.text(title);
      await tester.scrollUntilVisible(finder, 260, scrollable: scrollable);
      await tester.pumpAndSettle();
      expect(finder, findsOneWidget);
    }
  });
}
