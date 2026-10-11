import 'package:cidade_em_movimento/widgets/neighborhood_evolving_scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Set<String> upgrades) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: IgnorePointer(
          child: NeighborhoodEvolvingScene(purchasedUpgrades: upgrades),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('cena inicial mostra tres melhorias pendentes', (tester) async {
    await tester.pumpWidget(_app(<String>{}));
    await tester.pumpAndSettle();

    expect(find.text('Seu bairro em transformacao'), findsOneWidget);
    expect(find.text('0 de 3 melhorias instaladas'), findsOneWidget);
    expect(find.text('Calcada Acessivel - pendente'), findsOneWidget);
    expect(find.text('Praca de Convivencia - pendente'), findsOneWidget);
    expect(find.text('Bicicletario Comunitario - pendente'), findsOneWidget);
  });

  testWidgets('cena completa mostra tres melhorias instaladas', (tester) async {
    await tester.pumpWidget(
      _app(<String>{
        'BAIRRO_CALCADA_ACESSIVEL',
        'BAIRRO_PRACA_CONVIVENCIA',
        'BAIRRO_BICICLETARIO',
      }),
    );
    await tester.pumpAndSettle();

    expect(find.text('3 de 3 melhorias instaladas'), findsOneWidget);
    expect(find.text('Calcada Acessivel - instalada'), findsOneWidget);
    expect(find.text('Praca de Convivencia - instalada'), findsOneWidget);
    expect(find.text('Bicicletario Comunitario - instalada'), findsOneWidget);
  });
}
