import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/screens/fortaleza_map/fortaleza_map_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Mapa de Fortaleza exibe card do Duelo e recorde', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final controller = PlayerController(StorageService(preferences));
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: FortalezaMapScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('fortaleza-sign-duel')), findsOneWidget);
    expect(find.text('Duelo das Placas'), findsOneWidget);
    expect(find.text('Ainda nao jogado'), findsOneWidget);

    await controller.recordSignDuelResult(score: 500, correctAnswers: 5);
    await tester.pumpAndSettle();

    expect(find.text('Recorde: 500 pontos - 5/6'), findsOneWidget);
  });
}
