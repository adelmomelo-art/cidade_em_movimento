import 'package:cidade_em_movimento/widgets/zone_2_evolving_scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Set<String> upgrades) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: Zone2EvolvingScene(purchasedUpgrades: upgrades),
      ),
    ),
  );
}

void main() {
  testWidgets('estado inicial mostra melhorias Zona 2 pendentes', (
    tester,
  ) async {
    await tester.pumpWidget(_app(<String>{}));
    await tester.pumpAndSettle();

    expect(find.text('Centro em Transforma\u00e7\u00e3o'), findsOneWidget);
    expect(find.text('ANTES'), findsOneWidget);
    expect(find.text('AGORA'), findsOneWidget);
    expect(
      find.text('Travessia Acess\u00edvel \u2014 pendente'),
      findsOneWidget,
    );
    expect(find.text('Ponto Seguro \u2014 pendente'), findsOneWidget);
    expect(find.text('Rota Compartilhada \u2014 pendente'), findsOneWidget);
  });

  testWidgets('tres melhorias aparecem instaladas na cena', (tester) async {
    await tester.pumpWidget(
      _app(<String>{
        'TRAVESSIA_ACESSIVEL',
        'PONTO_SEGURO',
        'ROTA_COMPARTILHADA',
      }),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Travessia Acess\u00edvel \u2014 instalada'),
      findsOneWidget,
    );
    expect(find.text('Ponto Seguro \u2014 instalada'), findsOneWidget);
    expect(find.text('Rota Compartilhada \u2014 instalada'), findsOneWidget);
  });

  testWidgets('comparacao preserva antes e agora', (tester) async {
    await tester.pumpWidget(_app(<String>{'TRAVESSIA_ACESSIVEL'}));
    await tester.pumpAndSettle();

    expect(find.text('ANTES'), findsOneWidget);
    expect(find.text('AGORA'), findsOneWidget);
    expect(
      find.text('Travessia Acess\u00edvel \u2014 instalada'),
      findsOneWidget,
    );
    expect(find.text('Ponto Seguro \u2014 pendente'), findsOneWidget);
    expect(find.text('Rota Compartilhada \u2014 pendente'), findsOneWidget);
  });
}
