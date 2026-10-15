import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/zone_4_map/zone_4_map_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _unlockedController() async {
  SharedPreferences.setMockInitialValues({});
  final controller = PlayerController(
    StorageService(await SharedPreferences.getInstance()),
  );
  await controller.initialize();
  await controller.completeMission(
    result: const MissionResult(
      missionId: 'Z3_SPECIAL',
      stars: 3,
      score: 100,
      citizenship: 50,
      knowledge: 30,
      coins: 50,
      errors: 0,
    ),
  );
  return controller;
}

void main() {
  testWidgets('Zona 4 tem mapa aprovado e seis alvos sem rolagem', (
    tester,
  ) async {
    final controller = await _unlockedController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Zone4MapScreen(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('zone4-map-artwork')), findsOneWidget);
    expect(find.byKey(const Key('zone4-score-hud')), findsOneWidget);
    expect(find.byType(Scrollable), findsNothing);
    for (final id in [
      'Z4_M01',
      'Z4_M02',
      'Z4_M03',
      'Z4_M04',
      'Z4_M05',
      'Z4_SPECIAL',
    ]) {
      expect(find.byKey(Key('zone4-visual-mission-$id')), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'compra Travessia do Evento atualiza custo e instalada uma unica vez',
    (tester) async {
      final controller = await _unlockedController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Zone4MapScreen(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('zone4-open-upgrades')));
      await tester.pumpAndSettle();
      final button = find.byKey(
        const Key('zone4-install-TRAVESSIA_EVENTO_SEGURA'),
      );
      expect(button.hitTestable(), findsOneWidget);
      final before = controller.progress.coins;
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(
        controller.progress.purchasedUpgrades,
        contains('TRAVESSIA_EVENTO_SEGURA'),
      );
      expect(controller.progress.coins, before - 60);
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      expect(
        find.descendant(
          of: find.byKey(const Key('zone4-upgrade-TRAVESSIA_EVENTO_SEGURA')),
          matching: find.text('INSTALADA'),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('VOLTAR AO EVENTO'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('zone4-open-upgrades')));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      final reloaded = PlayerController(
        StorageService(await SharedPreferences.getInstance()),
      );
      addTearDown(reloaded.dispose);
      await reloaded.initialize();
      expect(reloaded.progress.coins, before - 60);
      expect(
        reloaded.progress.purchasedUpgrades,
        contains('TRAVESSIA_EVENTO_SEGURA'),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
