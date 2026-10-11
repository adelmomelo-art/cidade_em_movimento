import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/screens/global_progress/global_progress_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Progressao Global exibe criterios e pilares extras', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final controller = PlayerController(StorageService(preferences));
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: GlobalProgressScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Jornada Fortaleza'), findsOneWidget);
    expect(find.text('0% da jornada principal'), findsOneWidget);
    expect(find.byKey(const Key('global-core-progress')), findsOneWidget);
    expect(find.byKey(const Key('global-extra-pillars')), findsOneWidget);
    expect(find.byKey(const Key('global-achievements')), findsOneWidget);
    expect(find.text('Duelo das Placas'), findsOneWidget);
    expect(find.text('Construa o Bairro'), findsOneWidget);
  });
}
