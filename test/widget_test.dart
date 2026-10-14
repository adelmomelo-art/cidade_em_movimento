import 'package:cidade_em_movimento/app/app.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('abre tela inicial do Cidade em Movimento', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final preferences = await SharedPreferences.getInstance();
    final storage = StorageService(preferences);
    final controller = PlayerController(storage);

    await controller.initialize();
    addTearDown(controller.dispose);

    await tester.pumpWidget(CidadeEmMovimentoApp(controller: controller));

    await tester.pumpAndSettle();

    // testWidgets owns and releases the semantics handle before its checks.
    expect(find.byKey(const Key('home-brand-mark')), findsOneWidget);
    expect(find.bySemanticsLabel('JOGAR'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('CIDADE EM MOVIMENTO.*Melo')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('home-play-button')).hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  }, semanticsEnabled: true);
}
