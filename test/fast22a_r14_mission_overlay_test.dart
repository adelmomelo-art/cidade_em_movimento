import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/models/game_progress.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/widgets/zone_1_art.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';

const ids = ['Z1_M01', 'Z1_M02', 'Z1_M03', 'Z1_M04', 'Z1_M05', 'Z1_SPECIAL'];

Future<PlayerController> player(
  PlayerType type, {
  StorageService? storage,
}) async {
  final c = PlayerController(
    storage ?? StorageService(await SharedPreferences.getInstance()),
  );
  await c.initialize();
  await c.createProfile(type: type, avatarId: type.name);
  return c;
}

Future<void> tap(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: .5);
  await tester.pumpAndSettle();
  expect(
    finder.hitTestable(),
    findsOneWidget,
    reason: 'O centro do alvo precisa estar dentro da área visível.',
  );
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> answerAndConfirm(WidgetTester tester, Finder answer) async {
  await tap(tester, answer);
  await tap(tester, find.byKey(const Key('zone1-confirm-answer')));
}

Future<void> complete(WidgetTester tester) async {
  final dialog = tester.widget<Zone1MissionDialog>(
    find.byType(Zone1MissionDialog),
  );
  await tap(tester, find.text('INICIAR'));
  final correct = dialog.mission.options.firstWhere((o) => o.isCorrect);
  await answerAndConfirm(tester, find.byKey(Key('zone1-answer-${correct.id}')));
  expect(find.text(correct.consequenceText), findsOneWidget);
  await tap(tester, find.text('CONTINUAR'));
  expect(find.text(correct.meloFeedback), findsOneWidget);
  await tap(tester, find.text('VER RESULTADO'));
}

class DelayedStorage extends StorageService {
  DelayedStorage(super.preferences);
  Completer<void>? pending;
  bool failOnce = false;
  @override
  Future<void> saveProgress(GameProgress progress) async {
    if (pending != null) await pending!.future;
    if (failOnce) {
      failOnce = false;
      throw StateError('simulated save failure');
    }
    await super.saveProgress(progress);
  }
}

void main() {
  for (final entry in [
    (390.0, PlayerType.child),
    (800.0, PlayerType.teen),
    (1280.0, PlayerType.adult),
  ]) {
    testWidgets(
      'six missions stay over the map and persist for ${entry.$2} at ${entry.$1}',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(entry.$1, entry.$1 == 800 ? 600 : 900);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        final c = await player(entry.$2);
        addTearDown(c.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Zone1MapScreen(controller: c),
          ),
        );
        await tester.pumpAndSettle();
        final originalMapState = tester.state(find.byType(Zone1MapScreen));
        expect(find.text('Cidade Evolutiva'), findsNothing);
        expect(find.text('ANTES'), findsNothing);
        expect(find.text('AGORA'), findsNothing);
        expect(find.text('Zona 1 - Bairro / Escola'), findsNothing);
        var citizenship = c.progress.citizenshipXp;
        var knowledge = c.progress.knowledge;
        var coins = c.progress.coins;
        for (final id in ids) {
          await tap(tester, find.byKey(Key('zone1-visual-mission-$id')));
          final dialog = tester.widget<Zone1MissionDialog>(
            find.byType(Zone1MissionDialog),
          );
          expect(dialog.mission.id, id);
          expect(find.byKey(const Key('zone1-map-canvas')), findsOneWidget);
          expect(find.byType(Zone1MapScreen), findsOneWidget);
          citizenship += dialog.mission.maxCitizenship;
          knowledge += dialog.mission.maxKnowledge;
          coins += dialog.mission.maxCoins;
          await complete(tester);
          expect(find.text('MISSÃO CONCLUÍDA'), findsOneWidget);
          expect(c.progress.missionStars[id], 3);
          await tap(tester, find.byKey(const Key('zone1-finish-mission')));
          expect(find.byType(Zone1MissionDialog), findsNothing);
          expect(
            tester.state(find.byType(Zone1MapScreen)),
            same(originalMapState),
          );
          expect(tester.takeException(), isNull);
        }
        expect(c.progress.citizenshipXp, citizenship);
        expect(c.progress.knowledge, knowledge);
        expect(c.progress.coins, coins + 60);
        expect(c.progress.medals, contains('PROTETOR_DA_ESCOLA'));
        expect(find.byKey(const Key('zone1-earned-medal')), findsOneWidget);
        expect(find.byKey(const Key('zone1-advance-zone2')), findsOneWidget);
        final beforeReplay = c.progress.toJson();
        await tap(tester, find.byKey(const Key('zone1-visual-mission-Z1_M01')));
        await complete(tester);
        expect(find.textContaining('Recompensas já recebidas'), findsOneWidget);
        await tap(tester, find.byKey(const Key('zone1-finish-mission')));
        expect(c.progress.toJson(), beforeReplay);
        final reloaded = PlayerController(
          StorageService(await SharedPreferences.getInstance()),
        );
        addTearDown(reloaded.dispose);
        await reloaded.initialize();
        expect(reloaded.progress.toJson(), c.progress.toJson());
      },
    );
  }
  testWidgets(
    'cancel grants nothing; wrong answer retries in the same window',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final c = await player(PlayerType.adult);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Zone1MapScreen(controller: c),
        ),
      );
      await tester.pumpAndSettle();
      final before = c.progress.toJson();
      await tap(tester, find.byKey(const Key('zone1-visual-mission-Z1_M01')));
      await tap(tester, find.byKey(const Key('zone1-close-mission')));
      expect(c.progress.toJson(), before);
      await tap(tester, find.byKey(const Key('zone1-visual-mission-Z1_M01')));
      final m = tester
          .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
          .mission;
      await tap(tester, find.text('INICIAR'));
      await answerAndConfirm(
        tester,
        find.byKey(
          Key('zone1-answer-${m.options.firstWhere((o) => !o.isCorrect).id}'),
        ),
      );
      await tap(tester, find.text('CONTINUAR'));
      await tap(tester, find.text('TENTAR NOVAMENTE'));
      expect(find.text(m.question), findsOneWidget);
      expect(c.progress.toJson(), before);
      await answerAndConfirm(
        tester,
        find.byKey(
          Key('zone1-answer-${m.options.firstWhere((o) => o.isCorrect).id}'),
        ),
      );
      await tap(tester, find.text('CONTINUAR'));
      await tap(tester, find.text('VER RESULTADO'));
      expect(c.progress.missionStars['Z1_M01'], 2);
      await tap(tester, find.byKey(const Key('zone1-finish-mission')));
      expect(c.progress.unlockedMissions, contains('Z1_M02'));
    },
  );
  testWidgets('night view reflects actual lighting and retains map progress', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'cidade_em_movimento.game_progress.v1': '{"coins":200}',
    });
    final c = await player(PlayerType.adult);
    addTearDown(c.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Zone1MapScreen(controller: c),
      ),
    );
    await tester.pumpAndSettle();
    final before = c.progress.toJson();
    await tap(tester, find.byKey(const Key('zone1-toggle-night')));
    final art = tester.widget<Zone1NeighborhoodArt>(
      find.byType(Zone1NeighborhoodArt),
    );
    expect(art.nightPreview, isTrue);
    expect(art.lighting, isFalse);
    expect(find.byKey(const Key('zone1-night-upgrade-layer')), findsOneWidget);
    await tap(tester, find.byKey(const Key('zone1-toggle-night')));
    expect(
      tester
          .widget<Zone1NeighborhoodArt>(find.byType(Zone1NeighborhoodArt))
          .nightPreview,
      isFalse,
    );
    expect(c.progress.toJson(), before);
    expect(await c.purchaseUpgrade('ILUMINACAO_ESCOLAR'), isTrue);
    await tester.pumpAndSettle();
    await tap(tester, find.byKey(const Key('zone1-toggle-night')));
    final lit = tester.widget<Zone1NeighborhoodArt>(
      find.byType(Zone1NeighborhoodArt),
    );
    expect(lit.nightPreview, isTrue);
    expect(lit.lighting, isTrue);
  });
  testWidgets(
    'saving blocks close, failure offers retry without duplicate award',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = DelayedStorage(await SharedPreferences.getInstance());
      final c = await player(PlayerType.adult, storage: storage);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Zone1MapScreen(controller: c),
        ),
      );
      await tester.pumpAndSettle();
      await tap(tester, find.byKey(const Key('zone1-visual-mission-Z1_M01')));
      final m = tester
          .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
          .mission;
      await tap(tester, find.text('INICIAR'));
      await answerAndConfirm(
        tester,
        find.byKey(
          Key('zone1-answer-${m.options.firstWhere((o) => o.isCorrect).id}'),
        ),
      );
      await tap(tester, find.text('CONTINUAR'));
      final resultButton = find.text('VER RESULTADO');
      await Scrollable.ensureVisible(
        tester.element(resultButton),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      expect(resultButton.hitTestable(), findsOneWidget);
      storage.pending = Completer<void>();
      storage.failOnce = true;
      await tester.tap(resultButton);
      await tester.pump();
      expect(
        tester
            .widget<IconButton>(find.byKey(const Key('zone1-close-mission')))
            .onPressed,
        isNull,
      );
      expect(find.text('MISSÃO CONCLUÍDA'), findsNothing);
      storage.pending!.complete();
      await tester.pumpAndSettle();
      expect(find.text('TENTAR SALVAR NOVAMENTE'), findsOneWidget);
      storage.pending = null;
      await tap(tester, find.text('TENTAR SALVAR NOVAMENTE'));
      expect(c.progress.coins, m.maxCoins);
      expect(find.text('MISSÃO CONCLUÍDA'), findsOneWidget);
      expect(
        StorageService(
          await SharedPreferences.getInstance(),
        ).loadProgress().coins,
        m.maxCoins,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'landscape phone with enlarged text fits and Android back cancels safely',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(600, 390);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final c = await player(PlayerType.teen);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.4)),
            child: child!,
          ),
          home: Zone1MapScreen(controller: c),
        ),
      );
      await tester.pumpAndSettle();
      await tap(tester, find.byKey(const Key('zone1-visual-mission-Z1_M01')));
      await tap(tester, find.text('INICIAR'));
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(Zone1MissionDialog), findsNothing);
      expect(c.progress.completedMissions, isEmpty);
      await tap(tester, find.byKey(const Key('zone1-visual-mission-Z1_M01')));
      await complete(tester);
      await tap(tester, find.byKey(const Key('zone1-finish-mission')));
      expect(c.progress.completedMissions, contains('Z1_M01'));
      expect(tester.takeException(), isNull);
    },
  );
}
