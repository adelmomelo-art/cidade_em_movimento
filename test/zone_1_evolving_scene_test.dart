import 'package:cidade_em_movimento/widgets/zone_1_evolving_scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Set<String> upgrades) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: Zone1EvolvingScene(purchasedUpgrades: upgrades),
      ),
    ),
  );
}

void main() {
  testWidgets('estado inicial mostra melhorias pendentes', (tester) async {
    await tester.pumpWidget(_app(<String>{}));
    await tester.pumpAndSettle();

    expect(find.text('Cidade Evolutiva'), findsOneWidget);
    expect(find.text('ANTES'), findsOneWidget);
    expect(find.text('AGORA'), findsOneWidget);
    expect(find.text('Faixa Segura \u2014 pendente'), findsOneWidget);
    expect(
      find.text('Ilumina\u00e7\u00e3o Escolar \u2014 pendente'),
      findsOneWidget,
    );
    expect(
      find.text('Trecho Ciclovi\u00e1rio \u2014 pendente'),
      findsOneWidget,
    );
  });

  testWidgets('melhorias compradas aparecem como instaladas', (tester) async {
    await tester.pumpWidget(
      _app(<String>{
        'FAIXA_SEGURA',
        'ILUMINACAO_ESCOLAR',
        'TRECHO_CICLOVIARIO',
      }),
    );
    await tester.pumpAndSettle();

    expect(find.text('Faixa Segura \u2014 instalado'), findsOneWidget);
    expect(
      find.text('Ilumina\u00e7\u00e3o Escolar \u2014 instalado'),
      findsOneWidget,
    );
    expect(
      find.text('Trecho Ciclovi\u00e1rio \u2014 instalado'),
      findsOneWidget,
    );
  });

  testWidgets('comparacao preserva painel antes e painel atual', (
    tester,
  ) async {
    await tester.pumpWidget(_app(<String>{'FAIXA_SEGURA'}));
    await tester.pumpAndSettle();

    expect(find.text('ANTES'), findsOneWidget);
    expect(find.text('AGORA'), findsOneWidget);
    expect(find.text('Faixa Segura \u2014 instalado'), findsOneWidget);
    expect(
      find.text('Ilumina\u00e7\u00e3o Escolar \u2014 pendente'),
      findsOneWidget,
    );
    expect(
      find.text('Trecho Ciclovi\u00e1rio \u2014 pendente'),
      findsOneWidget,
    );
  });
}
