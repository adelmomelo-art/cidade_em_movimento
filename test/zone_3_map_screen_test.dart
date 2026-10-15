import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/zone_3_map/zone_3_map_screen.dart';
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
      missionId: 'Z2_SPECIAL',
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
  testWidgets('Zona 3 tem mapa aprovado e seis alvos sem rolagem', (
    tester,
  ) async {
    final controller = await _unlockedController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Zone3MapScreen(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('zone3-map-artwork')), findsOneWidget);
    expect(find.byKey(const Key('zone3-score-hud')), findsOneWidget);
    expect(find.byType(Scrollable), findsNothing);
    for (final id in [
      'Z3_M01',
      'Z3_M02',
      'Z3_M03',
      'Z3_M04',
      'Z3_M05',
      'Z3_SPECIAL',
    ]) {
      expect(find.byKey(Key('zone3-visual-mission-$id')), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'compra Travessia da Orla atualiza custo e instalada uma unica vez',
    (tester) async {
      final controller = await _unlockedController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Zone3MapScreen(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('zone3-open-upgrades')));
      await tester.pumpAndSettle();
      final button = find.byKey(
        const Key('zone3-install-TRAVESSIA_ORLA_SEGURA'),
      );
      expect(button.hitTestable(), findsOneWidget);
      final before = controller.progress.coins;
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(
        controller.progress.purchasedUpgrades,
        contains('TRAVESSIA_ORLA_SEGURA'),
      );
      expect(controller.progress.coins, before - 60);
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      expect(
        find.descendant(
          of: find.byKey(const Key('zone3-upgrade-TRAVESSIA_ORLA_SEGURA')),
          matching: find.text('INSTALADA'),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('VOLTAR À ORLA'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('zone3-open-upgrades')));
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
        contains('TRAVESSIA_ORLA_SEGURA'),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
