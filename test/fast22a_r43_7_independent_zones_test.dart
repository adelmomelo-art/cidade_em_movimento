import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/widgets/neighborhood_construction_art.dart';
import 'package:cidade_em_movimento/widgets/neighborhood_construction_data.dart';
import 'package:cidade_em_movimento/widgets/neighborhood_upgrade_layer.dart';
import 'package:cidade_em_movimento/widgets/zone_1_construction_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('25 intervenções correspondem exatamente ao catálogo das zonas 2 a 6', () {
    expect(constructionZones.length, 5);
    final ids = <String>{};
    for (final entry in constructionZones.entries) {
      expect(entry.value.pieces.map((p) => p.id).toSet(),
        upgradesForZone(entry.key).map((p) => p.id).toSet());
      for (final piece in entry.value.pieces) {
        expect(ids.add(piece.id), isTrue);
        expect(piece.ground.length, 4);
        for (final p in piece.ground) {
          expect(p.dx, inInclusiveRange(0,1672));
          expect(p.dy, inInclusiveRange(0,941));
        }
      }
    }
    expect(ids.length, 25);
  });

  for (final entry in constructionZones.entries) {
    final zone = entry.key;
    final pieces = entry.value.pieces;
    for (var mask=0;mask<32;mask++) {
      testWidgets('$zone: compras independentes na combinação $mask', (tester) async {
        final purchased=<String>{
          'FAIXA_SEGURA',
          for(var i=0;i<5;i++) if((mask & (1<<i)) != 0) pieces[i].id,
        };
        final before=Set<String>.of(purchased);
        await tester.pumpWidget(MaterialApp(home:SizedBox.expand(
          child:NeighborhoodUpgradeLayer(zoneId:zone,purchased:purchased),
        )));
        await tester.pumpAndSettle();
        for(var i=0;i<5;i++) {
          expect(find.byKey(Key('r43-scene-${pieces[i].id}')),
            (mask & (1<<i)) != 0 ? findsOneWidget : findsNothing);
        }
        expect(find.byType(Zone1ConstructionArt),findsNothing);
        expect(purchased,before);
        expect(tester.takeException(),isNull);
      });
    }
    testWidgets('$zone: prévia cancelada não compra e não altera outros itens', (tester) async {
      final purchased=<String>{pieces[1].id};
      Future<void> render(String? preview,bool night) => tester.pumpWidget(
        MaterialApp(home:SizedBox.expand(child:NeighborhoodUpgradeLayer(
          zoneId:zone,purchased:purchased,previewId:preview,night:night,
        ))));
      await render(pieces[0].id,true);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('r43-scene-${pieces[0].id}')),findsOneWidget);
      await render(null,false);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('r43-scene-${pieces[0].id}')),findsNothing);
      expect(find.byKey(Key('r43-scene-${pieces[1].id}')),findsOneWidget);
      expect(purchased,{pieces[1].id});
      expect(tester.takeException(),isNull);
    });
    test('$zone: substituições não cobrem os marcadores do mapa', () {
      final clipper=ConstructionPatchClipper([
        const [Offset(0,0),Offset(1672,0),Offset(1672,941),Offset(0,941)],
      ],foreground:entry.value.mapForeground);
      for(final scale in [1.0,.5]) {
        final clip=clipper.getClip(Size(1672*scale,941*scale));
        for(final rect in entry.value.mapForeground) {
          expect(clip.contains(rect.center*scale),isFalse);
        }
      }
    });
  }
  test('Orla mantém correção de portas fora das compras', () {
    expect(constructionZones['ZONE_3']!.permanent,isNotEmpty);
  });
  test('Centro usa ciclorrota e Castelão usa corredor de pedestres', () {
    expect(constructionZones['ZONE_2']!.pieces.singleWhere(
      (p)=>p.id=='ROTA_COMPARTILHADA').kind,'shared');
    expect(constructionZones['ZONE_6']!.pieces.singleWhere(
      (p)=>p.id=='CORREDOR_PEDESTRE_CASTELAO').kind,'corridor');
  });
}
