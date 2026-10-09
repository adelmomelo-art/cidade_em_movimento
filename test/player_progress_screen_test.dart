import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/player_progress/player_progress_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _controller() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();
  await controller.createProfile(
    type: PlayerType.adult,
    avatarId: 'adult_default',
  );
  return controller;
}

void main() {
  testWidgets('tela exibe recursos basicos do jogador', (tester) async {
    final controller = await _controller();

    await controller.completeMission(
      result: const MissionResult(
        missionId: 'TEST_PROGRESS',
        stars: 3,
        score: 100,
        citizenship: 25,
        knowledge: 15,
        coins: 20,
        errors: 0,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: PlayerProgressScreen(controller: controller)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Meu Progresso'), findsOneWidget);
    expect(find.text('Condutor(a) Consciente'), findsOneWidget);
    expect(find.text('Cidadania'), findsOneWidget);
    expect(find.text('Conhecimento'), findsOneWidget);
    expect(find.text('Moedas'), findsOneWidget);
    expect(find.text('Estrelas'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('tela exibe estados vazios de progresso', (tester) async {
    final controller = await _controller();

    await tester.pumpWidget(
      MaterialApp(home: PlayerProgressScreen(controller: controller)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Nenhuma zona concluÃ­da ainda.'), findsOneWidget);
    expect(find.text('Nenhuma medalha conquistada ainda.'), findsOneWidget);
    expect(find.text('Nenhuma melhoria instalada ainda.'), findsOneWidget);
  });
}
