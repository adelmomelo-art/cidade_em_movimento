import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/screens/sign_duel/sign_duel_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _controller() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();
  return controller;
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  expect(finder, findsOneWidget);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Duelo mostra feedback e percorre seis rodadas', (tester) async {
    final controller = await _controller();

    await tester.pumpWidget(
      MaterialApp(home: SignDuelScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    final correctIndexes = <int>[1, 0, 2, 1, 0, 1];

    for (var round = 0; round < correctIndexes.length; round++) {
      expect(find.text('Rodada ${round + 1} de 6'), findsOneWidget);

      await _tapVisible(
        tester,
        find.byKey(Key('duel-option-${correctIndexes[round]}')),
      );

      expect(find.byKey(const Key('duel-feedback')), findsOneWidget);
      expect(find.text('Boa decisao!'), findsOneWidget);

      await _tapVisible(tester, find.byKey(const Key('duel-continue')));
    }

    expect(find.text('Duelo concluido'), findsOneWidget);
    expect(find.text('6 de 6 respostas corretas'), findsOneWidget);
    expect(find.text('Pontuacao: 600'), findsOneWidget);
    expect(controller.progress.signDuelBestScore, 600);
    expect(controller.progress.signDuelBestCorrect, 6);
    expect(controller.progress.signDuelPlays, 1);
    expect(controller.progress.knowledge, 12);
  });
}
