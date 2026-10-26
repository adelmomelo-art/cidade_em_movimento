import 'package:cidade_em_movimento/widgets/neighborhood_upgrade_layer.dart';
import 'package:cidade_em_movimento/widgets/zone_1_construction_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (var mask = 0; mask < 32; mask++) {
    testWidgets('Zona 1 compõe aquisições independentes: $mask', (tester) async {
      final ids = Zone1ConstructionArt.ids;
      final purchased = <String>{
        for (var bit = 0; bit < ids.length; bit++)
          if ((mask & (1 << bit)) != 0) ids[bit],
      };
      final before = Set<String>.of(purchased);
      await tester.pumpWidget(MaterialApp(home: SizedBox.expand(
        child: NeighborhoodUpgradeLayer(zoneId: 'ZONE_1', purchased: purchased),
      )));
      await tester.pumpAndSettle();
      expect(find.byType(Zone1ConstructionArt), findsOneWidget);
      for (final id in ids) {
        expect(find.byKey(Key('r43-scene-$id')),
            purchased.contains(id) ? findsOneWidget : findsNothing);
      }
      expect(purchased, before, reason: 'renderização não modifica compras');
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('prévia não instala nem remove compras anteriores', (tester) async {
    final purchased = <String>{'FAIXA_SEGURA'};
    Future<void> render(String? preview) => tester.pumpWidget(MaterialApp(
      home: SizedBox.expand(child: NeighborhoodUpgradeLayer(
        zoneId: 'ZONE_1', purchased: purchased, previewId: preview,
      )),
    ));
    await render('BICICLETARIO_ESCOLAR');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('r43-scene-FAIXA_SEGURA')), findsOneWidget);
    expect(find.byKey(const Key('r43-scene-BICICLETARIO_ESCOLAR')), findsOneWidget);
    expect(purchased, {'FAIXA_SEGURA'});
    await render(null);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('r43-scene-BICICLETARIO_ESCOLAR')), findsNothing);
    expect(find.byKey(const Key('r43-scene-FAIXA_SEGURA')), findsOneWidget);
    expect(purchased, {'FAIXA_SEGURA'});
    expect(tester.takeException(), isNull);
  });
}
