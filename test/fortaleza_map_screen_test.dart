import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/fortaleza_map/fortaleza_map_screen.dart';
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

Future<void> _completeSpecial(
  PlayerController controller,
  String missionId,
) async {
  await controller.completeMission(
    result: MissionResult(
      missionId: missionId,
      stars: 3,
      score: 100,
      citizenship: 0,
      knowledge: 0,
      coins: 0,
      errors: 0,
    ),
  );
}

Future<void> _materialize(WidgetTester tester, Finder finder) async {
  expect(find.byType(Scrollable), findsNothing);
  expect(finder, findsOneWidget);
  expect(finder.hitTestable(), findsOneWidget);
}

void main() {
  testWidgets('mapa inicial mostra seis zonas e somente Zona 1 disponivel', (
    tester,
  ) async {
    final controller = await _controller();

    await tester.pumpWidget(
      MaterialApp(home: FortalezaMapScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('fortaleza-artwork')), findsOneWidget);
    expect(find.text('PROGRESSÃO DA CIDADE • 0/6'), findsOneWidget);

    for (var zone = 1; zone <= 6; zone++) {
      final card = find.byKey(Key('fortaleza-zone-ZONE_$zone'));
      await _materialize(tester, card);
      expect(card, findsOneWidget);
    }

    expect(
      tester
          .widget<Semantics>(
            find
                .descendant(
                  of: find.byKey(const Key('fortaleza-status-ZONE_1')),
                  matching: find.byType(Semantics),
                )
                .first,
          )
          .properties
          .label,
      'DISPONIVEL',
    );

    expect(
      tester
          .widget<Semantics>(
            find
                .descendant(
                  of: find.byKey(const Key('fortaleza-status-ZONE_6')),
                  matching: find.byType(Semantics),
                )
                .first,
          )
          .properties
          .label,
      'BLOQUEADA',
    );
  });

  testWidgets('conclusao sequencial atualiza estados e medalhas', (
    tester,
  ) async {
    final controller = await _controller();

    await _completeSpecial(controller, 'Z1_SPECIAL');
    await _completeSpecial(controller, 'Z2_SPECIAL');

    await tester.pumpWidget(
      MaterialApp(home: FortalezaMapScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.text('PROGRESSÃO DA CIDADE • 2/6'), findsOneWidget);

    final zone1 = find.byKey(const Key('fortaleza-zone-ZONE_1'));
    await _materialize(tester, zone1);

    expect(
      tester
          .widget<Semantics>(
            find
                .descendant(
                  of: find.byKey(const Key('fortaleza-status-ZONE_1')),
                  matching: find.byType(Semantics),
                )
                .first,
          )
          .properties
          .label,
      'CONCLUIDA',
    );

    expect(find.byKey(const Key('fortaleza-medal-ZONE_1')), findsOneWidget);

    final zone3 = find.byKey(const Key('fortaleza-zone-ZONE_3'));
    await _materialize(tester, zone3);

    expect(
      tester
          .widget<Semantics>(
            find
                .descendant(
                  of: find.byKey(const Key('fortaleza-status-ZONE_3')),
                  matching: find.byType(Semantics),
                )
                .first,
          )
          .properties
          .label,
      'DISPONIVEL',
    );
  });

  testWidgets('seis especiais fecham mapa em seis de seis', (tester) async {
    final controller = await _controller();

    for (final missionId in <String>[
      'Z1_SPECIAL',
      'Z2_SPECIAL',
      'Z3_SPECIAL',
      'Z4_SPECIAL',
      'Z5_SPECIAL',
      'Z6_SPECIAL',
    ]) {
      await _completeSpecial(controller, missionId);
    }

    await tester.pumpWidget(
      MaterialApp(home: FortalezaMapScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.text('PROGRESSÃO DA CIDADE • 6/6'), findsOneWidget);

    final zone6 = find.byKey(const Key('fortaleza-zone-ZONE_6'));
    await _materialize(tester, zone6);

    expect(
      tester
          .widget<Semantics>(
            find
                .descendant(
                  of: find.byKey(const Key('fortaleza-status-ZONE_6')),
                  matching: find.byType(Semantics),
                )
                .first,
          )
          .properties
          .label,
      'CONCLUIDA',
    );

    expect(find.byKey(const Key('fortaleza-medal-ZONE_6')), findsOneWidget);
  });
}
