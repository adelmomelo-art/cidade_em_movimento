import 'package:cidade_em_movimento/widgets/zone_6_evolving_scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Set<String> upgrades) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: IgnorePointer(
          child: Zone6EvolvingScene(purchasedUpgrades: upgrades),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('estado inicial mostra melhorias Zona 6 pendentes', (
    tester,
  ) async {
    await tester.pumpWidget(_app(<String>{}));
    await tester.pumpAndSettle();

    expect(find.text('Polo Castelao em Transformacao'), findsOneWidget);
    expect(find.text('ANTES'), findsOneWidget);
    expect(find.text('AGORA'), findsOneWidget);
    expect(find.text('Corredor de Pedestres - pendente'), findsOneWidget);
    expect(find.text('Iluminacao do Entorno - pendente'), findsOneWidget);
    expect(find.text('Area de Embarque Integrada - pendente'), findsOneWidget);
  });

  testWidgets('tres melhorias aparecem instaladas na cena', (tester) async {
    await tester.pumpWidget(
      _app(<String>{
        'CORREDOR_PEDESTRE_CASTELAO',
        'ILUMINACAO_ENTORNO_CASTELAO',
        'EMBARQUE_INTEGRADO_CASTELAO',
      }),
    );
    await tester.pumpAndSettle();

    expect(find.text('Corredor de Pedestres - instalada'), findsOneWidget);
    expect(find.text('Iluminacao do Entorno - instalada'), findsOneWidget);
    expect(find.text('Area de Embarque Integrada - instalada'), findsOneWidget);
  });
}
