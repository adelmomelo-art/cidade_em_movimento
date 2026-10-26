import 'dart:convert';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:cidade_em_movimento/data/zones/zone_catalog.dart';
import 'package:cidade_em_movimento/models/game_progress.dart';
import 'package:cidade_em_movimento/screens/build_neighborhood/build_neighborhood_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _player({
  int coins = 1000,
  bool unlocked = true,
}) async {
  final zones = unlocked ? zoneCatalog.map((z) => z.id).toList() : <String>[];
  SharedPreferences.setMockInitialValues({
    'cidade_em_movimento.game_progress.v1': jsonEncode(
      GameProgress.initial().toJson()..addAll({
        'coins': coins,
        'completedZones': zones,
        'claimedZoneCompletionBonuses': zones,
        'claimedR43ZoneBonuses': zones,
        'medals': unlocked
            ? zoneCatalog.map((z) => z.medalId).toList()
            : <String>[],
      }),
    ),
  });
  final c = PlayerController(
    StorageService(await SharedPreferences.getInstance()),
  );
  await c.initialize();
  addTearDown(c.dispose);
  return c;
}

Future<void> _tap(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

void main() {
  for (final size in [
    const Size(800, 360),
    const Size(1280, 800),
    const Size(1366, 768),
  ]) {
    testWidgets(
      'cinco opções, confirmação e cancelamento sem rolagem em $size',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final c = await _player();
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.4)),
              child: child!,
            ),
            home: BuildNeighborhoodScreen(controller: c),
          ),
        );
        await tester.pumpAndSettle();
        for (final u in upgradesForZone('ZONE_1')) {
          expect(
            find.byKey(Key('r43-select-${u.id}')).hitTestable(),
            findsOneWidget,
          );
        }
        expect(find.byType(Scrollable), findsNothing);
        await _tap(tester, 'r43-select-CALCADA_ACESSIVEL_ESCOLAR');
        expect(c.progress.coins, 1000);
        expect(c.progress.purchasedUpgrades, isEmpty);
        await _tap(tester, 'r43-build');
        await _tap(tester, 'r43-cancel');
        expect(c.progress.coins, 1000);
        await _tap(tester, 'r43-build');
        await _tap(tester, 'r43-confirm');
        expect(c.progress.coins, 960);
        expect(
          c.progress.purchasedUpgrades,
          contains('CALCADA_ACESSIVEL_ESCOLAR'),
        );
        expect(
          tester
              .widget<FilledButton>(find.byKey(const Key('r43-build')))
              .onPressed,
          isNull,
        );
        expect(
          find.byKey(const Key('r43-scene-CALCADA_ACESSIVEL_ESCOLAR')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('cada zona apresenta cinco opções e Meu Bairro mantém três', (
    tester,
  ) async {
    final c = await _player();
    await tester.pumpWidget(
      MaterialApp(home: BuildNeighborhoodScreen(controller: c)),
    );
    await tester.pumpAndSettle();
    for (var i = 1; i <= 6; i++) {
      for (final u in upgradesForZone('ZONE_$i')) {
        expect(find.byKey(Key('r43-select-${u.id}')), findsOneWidget);
      }
      await _tap(tester, 'r43-zone-next');
    }
    for (final u in upgradesForZone('BUILD_NEIGHBORHOOD')) {
      expect(find.byKey(Key('r43-select-${u.id}')), findsOneWidget);
    }
    expect(c.progress.coins, 1000);
    expect(c.progress.purchasedUpgrades, isEmpty);
    expect(tester.takeException(), isNull);
  });
  testWidgets('saldo insuficiente e zona bloqueada impedem confirmação', (
    tester,
  ) async {
    final c = await _player(coins: 39, unlocked: false);
    await tester.pumpWidget(
      MaterialApp(home: BuildNeighborhoodScreen(controller: c)),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(find.byKey(const Key('r43-build'))).onPressed,
      isNull,
    );
    await _tap(tester, 'r43-zone-next');
    expect(
      tester.widget<FilledButton>(find.byKey(const Key('r43-build'))).onPressed,
      isNull,
    );
    expect(c.progress.coins, 39);
    expect(c.progress.purchasedUpgrades, isEmpty);
  });
}
