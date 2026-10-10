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

Future<void> _materialize(
  WidgetTester tester,
  Finder finder, {
  int maxSteps = 30,
}) async {
  final scrollable = find.byType(Scrollable).first;

  for (var step = 0; step < maxSteps && finder.evaluate().isEmpty; step++) {
    await tester.drag(scrollable, const Offset(0, -260));
    await tester.pumpAndSettle();
  }

  expect(finder, findsWidgets);
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
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

    expect(find.text('Fortaleza em Movimento'), findsOneWidget);
    expect(find.text('0 de 6 zonas concluidas'), findsOneWidget);

    for (var zone = 1; zone <= 6; zone++) {
      final card = find.byKey(Key('fortaleza-zone-ZONE_$zone'));
      await _materialize(tester, card);
      expect(card, findsOneWidget);
    }

    expect(
      find.descendant(
        of: find.byKey(const Key('fortaleza-status-ZONE_1')),
        matching: find.text('DISPONIVEL'),
      ),
      findsOneWidget,
    );

    expect(
      find.descendant(
        of: find.byKey(const Key('fortaleza-status-ZONE_6')),
        matching: find.text('BLOQUEADA'),
      ),
      findsOneWidget,
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

    expect(find.text('2 de 6 zonas concluidas'), findsOneWidget);

    final zone1 = find.byKey(const Key('fortaleza-zone-ZONE_1'));
    await _materialize(tester, zone1);

    expect(
      find.descendant(
        of: find.byKey(const Key('fortaleza-status-ZONE_1')),
        matching: find.text('CONCLUIDA'),
      ),
      findsOneWidget,
    );

    expect(find.byKey(const Key('fortaleza-medal-ZONE_1')), findsOneWidget);

    final zone3 = find.byKey(const Key('fortaleza-zone-ZONE_3'));
    await _materialize(tester, zone3);

    expect(
      find.descendant(
        of: find.byKey(const Key('fortaleza-status-ZONE_3')),
        matching: find.text('DISPONIVEL'),
      ),
      findsOneWidget,
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

    expect(find.text('6 de 6 zonas concluidas'), findsOneWidget);

    final zone6 = find.byKey(const Key('fortaleza-zone-ZONE_6'));
    await _materialize(tester, zone6);

    expect(
      find.descendant(
        of: find.byKey(const Key('fortaleza-status-ZONE_6')),
        matching: find.text('CONCLUIDA'),
      ),
      findsOneWidget,
    );

    expect(find.byKey(const Key('fortaleza-medal-ZONE_6')), findsOneWidget);
  });
}
