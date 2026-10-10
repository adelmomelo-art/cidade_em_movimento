import 'package:cidade_em_movimento/widgets/zone_5_evolving_scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Set<String> upgrades) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: IgnorePointer(
          child: Zone5EvolvingScene(purchasedUpgrades: upgrades),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('estado inicial mostra melhorias Zona 5 pendentes', (
    tester,
  ) async {
    await tester.pumpWidget(_app(<String>{}));
    await tester.pumpAndSettle();

    expect(
      find.text('Grandes Vias em Transforma\u00e7\u00e3o'),
      findsOneWidget,
    );
    expect(find.text('ANTES'), findsOneWidget);
    expect(find.text('AGORA'), findsOneWidget);
    expect(find.text('Travessia Protegida \u2014 pendente'), findsOneWidget);
    expect(
      find.text('Ilumina\u00e7\u00e3o do Corredor \u2014 pendente'),
      findsOneWidget,
    );
    expect(
      find.text('Ref\u00fagio de Pedestres \u2014 pendente'),
      findsOneWidget,
    );
  });

  testWidgets('tres melhorias aparecem instaladas na cena', (tester) async {
    await tester.pumpWidget(
      _app(<String>{
        'TRAVESSIA_GRANDE_VIA',
        'ILUMINACAO_CORREDOR',
        'REFUGIO_PEDESTRE',
      }),
    );
    await tester.pumpAndSettle();

    expect(find.text('Travessia Protegida \u2014 instalada'), findsOneWidget);
    expect(
      find.text('Ilumina\u00e7\u00e3o do Corredor \u2014 instalada'),
      findsOneWidget,
    );
    expect(
      find.text('Ref\u00fagio de Pedestres \u2014 instalada'),
      findsOneWidget,
    );
  });
}
