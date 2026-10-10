import 'package:cidade_em_movimento/widgets/zone_3_evolving_scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Set<String> upgrades) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: Zone3EvolvingScene(purchasedUpgrades: upgrades),
      ),
    ),
  );
}

void main() {
  testWidgets('estado inicial mostra melhorias Zona 3 pendentes', (
    tester,
  ) async {
    await tester.pumpWidget(_app(<String>{}));
    await tester.pumpAndSettle();

    expect(find.text('Orla em Transforma\u00e7\u00e3o'), findsOneWidget);
    expect(find.text('ANTES'), findsOneWidget);
    expect(find.text('AGORA'), findsOneWidget);
    expect(find.text('Travessia da Orla \u2014 pendente'), findsOneWidget);
    expect(find.text('Ciclovia Conectada \u2014 pendente'), findsOneWidget);
    expect(find.text('Embarque Organizado \u2014 pendente'), findsOneWidget);
  });

  testWidgets('tres melhorias aparecem instaladas na cena', (tester) async {
    await tester.pumpWidget(
      _app(<String>{
        'TRAVESSIA_ORLA_SEGURA',
        'CICLOVIA_CONECTADA',
        'EMBARQUE_ORGANIZADO',
      }),
    );
    await tester.pumpAndSettle();

    expect(find.text('Travessia da Orla \u2014 instalada'), findsOneWidget);
    expect(find.text('Ciclovia Conectada \u2014 instalada'), findsOneWidget);
    expect(find.text('Embarque Organizado \u2014 instalada'), findsOneWidget);
  });
}
