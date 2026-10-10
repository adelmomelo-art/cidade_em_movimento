import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/player_progress/player_progress_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _materialize(
  WidgetTester tester,
  Finder finder, {
  int maxSteps = 24,
}) async {
  final scrollable = find.byType(Scrollable).first;

  for (var step = 0; step < maxSteps && finder.evaluate().isEmpty; step++) {
    await tester.drag(scrollable, const Offset(0, -260));
    await tester.pumpAndSettle();
  }

  expect(finder, findsWidgets);
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Meu Progresso lista melhorias instaladas da Zona 4', (
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
        missionId: 'FAST8_PROGRESS_COINS',
        stars: 3,
        score: 100,
        citizenship: 0,
        knowledge: 0,
        coins: 240,
        errors: 0,
      ),
    );

    await controller.purchaseUpgrade('TRAVESSIA_EVENTO_SEGURA');
    await controller.purchaseUpgrade('SINALIZACAO_TEMPORARIA');
    await controller.purchaseUpgrade('EMBARQUE_EVENTO_ORGANIZADO');

    await tester.pumpWidget(
      MaterialApp(home: PlayerProgressScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    for (final title in <String>[
      'Travessia do Evento',
      'Sinaliza\u00e7\u00e3o Tempor\u00e1ria',
      'Embarque Organizado',
    ]) {
      final finder = find.text(title);
      await _materialize(tester, finder);
      expect(finder, findsOneWidget);
    }
  });
}
