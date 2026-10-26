import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cidade_em_movimento/app/routes.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:cidade_em_movimento/screens/zone_5_map/zone_5_map_screen.dart';
import 'package:cidade_em_movimento/widgets/fortaleza_map_avatar.dart';
import 'package:cidade_em_movimento/widgets/game_orientation_gate.dart';
import 'package:cidade_em_movimento/widgets/zone_5_mission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fast22a_r14_mission_overlay_test.dart' as old_flow;
import 'fast22a_r27_functional_map_test.dart' as images;

const ids = ['Z5_M01', 'Z5_M02', 'Z5_M03', 'Z5_M04', 'Z5_M05', 'Z5_SPECIAL'];

Map<String, Object> initial({
  bool unlocked = true,
  bool all = false,
  PlayerType type = PlayerType.child,
  String avatar = 'child_boy',
}) => {
  'cidade_em_movimento.player_profile.v1': jsonEncode({
    'type': type.name,
    'avatarId': avatar,
  }),
  'cidade_em_movimento.game_progress.v1': jsonEncode({
    'coins': 250,
    'citizenshipXp': 50,
    'knowledge': 30,
    'completedMissions': [
      if (unlocked) ...['Z1_SPECIAL', 'Z2_SPECIAL', 'Z3_SPECIAL', 'Z4_SPECIAL'],
      if (all) ...ids,
    ],
    'missionStars': {
      if (unlocked) 'Z1_SPECIAL': 3,
      if (unlocked) 'Z2_SPECIAL': 3,
      if (unlocked) 'Z3_SPECIAL': 3,
      if (unlocked) 'Z4_SPECIAL': 3,
      if (all)
        for (final id in ids) id: 3,
    },
    'unlockedMissions': [
      'Z1_M01',
      if (unlocked) 'Z2_M01',
      if (unlocked) 'Z3_M01',
      if (unlocked) 'Z4_M01',
      if (unlocked) 'Z5_M01',
      if (all) ...ids,
      if (all) 'Z6_M01',
    ],
    'medals': [
      if (unlocked) 'PROTETOR_DA_ESCOLA',
      if (unlocked) 'GUARDIAO_DO_CENTRO',
      if (unlocked) 'GUARDIAO_DA_ORLA',
      if (unlocked) 'GUARDIAO_DA_CULTURA',
      if (all) 'GUARDIAO_DAS_VIAS',
    ],
    'completedZones': [
      if (unlocked) ...['ZONE_1', 'ZONE_2', 'ZONE_3', 'ZONE_4'],
      if (all) 'ZONE_5',
    ],
    'claimedZoneCompletionBonuses': [
      if (unlocked) ...['ZONE_1', 'ZONE_2', 'ZONE_3', 'ZONE_4'],
      if (all) 'ZONE_5',
    ],
    'purchasedUpgrades': <String>[],
  }),
};

Future<PlayerController> player({
  bool unlocked = true,
  bool all = false,
  PlayerType type = PlayerType.child,
  String avatar = 'child_boy',
}) async {
  SharedPreferences.setMockInitialValues(
    initial(unlocked: unlocked, all: all, type: type, avatar: avatar),
  );
  final c = PlayerController(
    StorageService(await SharedPreferences.getInstance()),
  );
  await c.initialize();
  addTearDown(c.dispose);
  return c;
}

Widget app(
  PlayerController c, {
  double scale = 1,
  EdgeInsets safe = EdgeInsets.zero,
  bool gate = false,
  List<String>? routes,
}) => MaterialApp(
  theme: AppTheme.light,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      padding: safe,
      viewPadding: safe,
      textScaler: TextScaler.linear(scale),
    ),
    child: gate ? GameOrientationGate(child: child!) : child!,
  ),
  onGenerateRoute: (settings) {
    routes?.add(settings.name!);
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const Scaffold(body: Text('destination')),
    );
  },
  home: Zone5MapScreen(controller: c),
);

void viewport(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> tap(WidgetTester tester, Finder f) async {
  expect(f.hitTestable(), findsOneWidget);
  await tester.tap(f);
  await tester.pumpAndSettle();
}

Future<void> capture(WidgetTester tester, String key, String name) async {
  await images.waitForArtworkImages(tester);
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(Key(key)),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory('build/fast22a_r33_evidencias');
      await dir.create(recursive: true);
      await File('${dir.path}/$name.png').writeAsBytes(
        data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } finally {
      image.dispose();
    }
  });
}

Future<void> complete(WidgetTester tester) async {
  final m = tester
      .widget<Zone5MissionDialog>(find.byType(Zone5MissionDialog))
      .mission;
  await tap(tester, find.text('INICIAR'));
  final correct = m.options.firstWhere((o) => o.isCorrect);
  await tap(tester, find.byKey(Key('zone5-answer-${correct.id}')));
  await tap(tester, find.byKey(const Key('zone5-confirm-answer')));
  expect(find.text(correct.consequenceText), findsOneWidget);
  await tap(tester, find.text('CONTINUAR'));
  expect(find.text(correct.meloFeedback), findsOneWidget);
  await tap(tester, find.text('VER RESULTADO'));
}

void main() {
  for (final type in PlayerType.values) {
    testWidgets(
      'six missions complete, reload and replay without duplicate awards for $type',
      (tester) async {
        viewport(tester, const Size(1366, 768));
        final c = await player(type: type);
        await tester.pumpWidget(app(c));
        await tester.pumpAndSettle();
        final mapState = tester.state(find.byType(Zone5MapScreen));
        var expectedCoins = c.progress.coins;
        var expectedCitizenship = c.progress.citizenshipXp;
        var expectedKnowledge = c.progress.knowledge;
        for (final id in ids) {
          expect(c.progress.unlockedMissions, contains(id));
          await tap(tester, find.byKey(Key('zone5-visual-mission-$id')));
          final m = tester
              .widget<Zone5MissionDialog>(find.byType(Zone5MissionDialog))
              .mission;
          expect(m.id, id);
          expectedCoins += m.maxCoins;
          expectedCitizenship += m.maxCitizenship;
          expectedKnowledge += m.maxKnowledge;
          await complete(tester);
          expect(find.text('MISSÃO CONCLUÍDA'), findsOneWidget);
          await tap(tester, find.byKey(const Key('zone5-finish-mission')));
          expect(c.progress.missionStars[id], 3);
          expect(tester.state(find.byType(Zone5MapScreen)), same(mapState));
        }
        expect(c.progress.coins, expectedCoins + 190);
        expect(c.progress.citizenshipXp, expectedCitizenship);
        expect(c.progress.knowledge, expectedKnowledge);
        expect(c.progress.medals, contains('GUARDIAO_DAS_VIAS'));
        expect(c.isZoneUnlocked('ZONE_6'), isTrue);
        expect(find.byKey(const Key('zone5-advance-zone6')), findsOneWidget);
        final before = c.progress.toJson();
        await tap(tester, find.byKey(const Key('zone5-visual-mission-Z5_M01')));
        await complete(tester);
        expect(find.textContaining('Recompensas já recebidas'), findsOneWidget);
        await tap(tester, find.byKey(const Key('zone5-finish-mission')));
        expect(c.progress.toJson(), before);
        final reload = PlayerController(
          StorageService(await SharedPreferences.getInstance()),
        );
        addTearDown(reload.dispose);
        await reload.initialize();
        expect(reload.progress.toJson(), before);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final sample in [
    (const Size(844, 390), const EdgeInsets.fromLTRB(24, 0, 16, 12), 1.0),
    (const Size(600, 390), EdgeInsets.zero, 1.4),
    (const Size(1280, 800), const EdgeInsets.only(top: 20), 1.4),
    (const Size(1366, 768), EdgeInsets.zero, 1.0),
  ]) {
    testWidgets('complete board and every mission stage fit at $sample', (
      tester,
    ) async {
      viewport(tester, sample.$1);
      final c = await player(all: true);
      await tester.pumpWidget(app(c, scale: sample.$3, safe: sample.$2));
      await tester.pumpAndSettle();
      expect(find.byType(Scrollable), findsNothing);
      final safe = Rect.fromLTRB(
        sample.$2.left,
        sample.$2.top,
        sample.$1.width - sample.$2.right,
        sample.$1.height - sample.$2.bottom,
      ).inflate(.02);
      final rects = <Rect>[];
      for (final id in ids) {
        final rect = tester.getRect(
          find.byKey(Key('zone5-visual-mission-$id')),
        );
        expect(safe.contains(rect.topLeft), isTrue);
        expect(safe.contains(rect.bottomRight), isTrue);
        for (final prior in rects) {
          expect(rect.overlaps(prior), isFalse);
        }
        rects.add(rect);
      }
      await capture(
        tester,
        'zone5-map-artwork',
        'mapa_${sample.$1.width.toInt()}',
      );
      for (final id in ids) {
        await tap(tester, find.byKey(Key('zone5-visual-mission-$id')));
        final frame = tester.getRect(
          find.byKey(const Key('zone5-mission-frame')),
        );
        final hero = tester.getRect(
          find.byKey(const Key('zone5-question-melo')),
        );
        void check() {
          expect(
            tester.getRect(find.byKey(const Key('zone5-mission-frame'))),
            frame,
          );
          expect(
            tester.getRect(find.byKey(const Key('zone5-question-melo'))),
            hero,
          );
          expect(
            find.descendant(
              of: find.byType(Zone5MissionDialog),
              matching: find.byType(Scrollable),
            ),
            findsNothing,
          );
          final area = tester
              .getRect(find.byKey(const Key('zone5-mission-content-viewport')))
              .inflate(.02);
          for (final e
              in find
                  .descendant(
                    of: find.byKey(const Key('zone5-mission-content-viewport')),
                    matching: find.byType(Text),
                  )
                  .evaluate()) {
            final bounds = tester.getRect(find.byWidget(e.widget));
            expect(
              area.contains(bounds.topLeft),
              isTrue,
              reason: (e.widget as Text).data,
            );
            expect(
              area.contains(bounds.bottomRight),
              isTrue,
              reason: (e.widget as Text).data,
            );
          }
          expect(tester.takeException(), isNull);
        }

        check();
        await tap(tester, find.text('INICIAR'));
        check();
        final m = tester
            .widget<Zone5MissionDialog>(find.byType(Zone5MissionDialog))
            .mission;
        final confirm = find.byKey(const Key('zone5-confirm-answer'));
        expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
        await capture(
          tester,
          'zone5-mission-capture',
          '${id}_${sample.$1.width.toInt()}_decisao',
        );
        final correct = m.options.firstWhere((o) => o.isCorrect);
        await tap(tester, find.byKey(Key('zone5-answer-${correct.id}')));
        await tap(tester, confirm);
        check();
        await tap(tester, find.text('CONTINUAR'));
        check();
        await tap(tester, find.text('VER RESULTADO'));
        check();
        await tap(tester, find.byKey(const Key('zone5-finish-mission')));
      }
    });
  }

  testWidgets(
    'locked zone and future pins cannot start; selection and cancellation do not reward',
    (tester) async {
      viewport(tester, const Size(844, 390));
      final locked = await player(unlocked: false);
      await tester.pumpWidget(app(locked));
      await tester.pumpAndSettle();
      for (final id in ids) {
        await tap(tester, find.byKey(Key('zone5-visual-mission-$id')));
        expect(find.byType(Zone5MissionDialog), findsNothing);
      }
      final c = await player();
      await tester.pumpWidget(app(c));
      await tester.pumpAndSettle();
      final before = c.progress.toJson();
      for (final id in ids.skip(1)) {
        await tap(tester, find.byKey(Key('zone5-visual-mission-$id')));
        expect(find.byType(Zone5MissionDialog), findsNothing);
      }
      await tap(tester, find.byKey(const Key('zone5-visual-mission-Z5_M01')));
      await tap(tester, find.text('INICIAR'));
      final m = tester
          .widget<Zone5MissionDialog>(find.byType(Zone5MissionDialog))
          .mission;
      final wrong = m.options.firstWhere((o) => !o.isCorrect);
      await tap(tester, find.byKey(Key('zone5-answer-${wrong.id}')));
      expect(c.progress.toJson(), before);
      await tap(tester, find.byKey(const Key('zone5-confirm-answer')));
      await tap(tester, find.text('CONTINUAR'));
      await tap(tester, find.text('TENTAR NOVAMENTE'));
      expect(c.progress.toJson(), before);
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('zone5-confirm-answer')))
            .onPressed,
        isNull,
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(Zone5MissionDialog), findsNothing);
      expect(c.progress.toJson(), before);
    },
  );

  testWidgets(
    'rotation retains pending answer and night preview leaves progress intact',
    (tester) async {
      viewport(tester, const Size(844, 390));
      final c = await player();
      await tester.pumpWidget(app(c, gate: true));
      await tester.pumpAndSettle();
      final before = c.progress.toJson();
      await tap(tester, find.byKey(const Key('zone5-toggle-night')));
      await tap(tester, find.byKey(const Key('zone5-visual-mission-Z5_M01')));
      await tap(tester, find.text('INICIAR'));
      final dialog = find.byType(Zone5MissionDialog);
      final state = tester.state(dialog);
      expect(tester.widget<Zone5MissionDialog>(dialog).nightPreview, isTrue);
      final option = tester
          .widget<Zone5MissionDialog>(dialog)
          .mission
          .options
          .first;
      await tap(tester, find.byKey(Key('zone5-answer-${option.id}')));
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('game-rotate-screen')), findsOneWidget);
      tester.view.physicalSize = const Size(844, 390);
      await tester.pumpAndSettle();
      expect(tester.state(dialog), same(state));
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('zone5-confirm-answer')))
            .onPressed,
        isNotNull,
      );
      await tap(tester, find.byKey(const Key('zone5-close-mission')));
      expect(c.progress.toJson(), before);
    },
  );

  testWidgets('saving blocks close and retry saves once', (tester) async {
    viewport(tester, const Size(844, 390));
    SharedPreferences.setMockInitialValues(initial());
    final storage = old_flow.DelayedStorage(
      await SharedPreferences.getInstance(),
    );
    final c = PlayerController(storage);
    addTearDown(c.dispose);
    await c.initialize();
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    await tap(tester, find.byKey(const Key('zone5-visual-mission-Z5_M01')));
    final m = tester
        .widget<Zone5MissionDialog>(find.byType(Zone5MissionDialog))
        .mission;
    final before = c.progress.coins;
    await tap(tester, find.text('INICIAR'));
    await tap(
      tester,
      find.byKey(
        Key('zone5-answer-${m.options.firstWhere((o) => o.isCorrect).id}'),
      ),
    );
    await tap(tester, find.byKey(const Key('zone5-confirm-answer')));
    await tap(tester, find.text('CONTINUAR'));
    storage.pending = Completer<void>();
    storage.failOnce = true;
    await tester.tap(find.text('VER RESULTADO'));
    await tester.pump();
    expect(
      tester
          .widget<IconButton>(find.byKey(const Key('zone5-close-mission')))
          .onPressed,
      isNull,
    );
    storage.pending!.complete();
    await tester.pumpAndSettle();
    storage.pending = null;
    await tap(tester, find.text('TENTAR SALVAR NOVAMENTE'));
    expect(c.progress.coins, before + m.maxCoins);
    expect(storage.loadProgress().coins, before + m.maxCoins);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'all six avatars, progress, Faixita and next-zone destinations preserve progress',
    (tester) async {
      viewport(tester, const Size(1366, 768));
      final c = await player(all: true);
      final destinations = <String>[];
      await tester.pumpWidget(app(c, routes: destinations));
      await tester.pumpAndSettle();
      final before = c.progress.toJson();
      for (final pair in [
        (PlayerType.child, 'child_boy'),
        (PlayerType.child, 'child_girl'),
        (PlayerType.teen, 'teen_boy'),
        (PlayerType.teen, 'teen_girl'),
        (PlayerType.adult, 'adult_man'),
        (PlayerType.adult, 'adult_woman'),
      ]) {
        await c.createProfile(type: pair.$1, avatarId: pair.$2);
        await tester.pumpAndSettle();
        final variant = FortalezaMapAvatar.variantFor(c.profile);
        expect(find.byKey(Key('fortaleza-avatar-$variant')), findsOneWidget);
        expect(find.byKey(Key('fortaleza-portrait-$variant')), findsOneWidget);
      }
      for (final pair in [
        ('zone5-open-progress', AppRoutes.playerProgress),
        ('zone5-advance-zone6', AppRoutes.zone6),
      ]) {
        await tap(tester, find.byKey(Key(pair.$1)));
        expect(destinations.last, pair.$2);
        Navigator.of(tester.element(find.text('destination'))).pop();
        await tester.pumpAndSettle();
      }
      await tap(tester, find.byKey(const Key('zone5-visual-mission-Z5_M01')));
      await complete(tester);
      await tap(tester, find.text('PERGUNTAR À FAIXITA'));
      expect(destinations.last, AppRoutes.faixita);
      Navigator.of(tester.element(find.text('destination'))).pop();
      await tester.pumpAndSettle();
      await tap(tester, find.byKey(const Key('zone5-finish-mission')));
      expect(c.progress.toJson(), before);
      await tap(tester, find.byKey(const Key('zone5-back-to-fortaleza')));
      expect(destinations.last, AppRoutes.fortalezaMap);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'purchased corridor lighting appears only at night and persists',
    (tester) async {
      viewport(tester, const Size(844, 390));
      final c = await player();
      await tester.pumpWidget(app(c));
      await tester.pumpAndSettle();
      final before = c.progress.coins;
      final glow = find.byKey(const Key('zone5-night-lighting-glow'));
      expect(glow, findsNothing);
      await tap(tester, find.byKey(const Key('zone5-toggle-night')));
      expect(glow, findsNothing);
      await tap(tester, find.byKey(const Key('zone5-open-upgrades')));
      await tap(
        tester,
        find.byKey(const Key('r43-select-ILUMINACAO_CORREDOR')),
      );
      await tap(tester, find.byKey(const Key('r43-build')));
      await tap(tester, find.byKey(const Key('r43-confirm')));
      await tap(tester, find.byKey(const Key('r43-back')));
      expect(c.progress.coins, before - 80);
      expect(glow, findsOneWidget);
      await tap(tester, find.byKey(const Key('zone5-visual-mission-Z5_M01')));
      expect(
        find.descendant(
          of: find.byKey(const Key('zone5-question-night')),
          matching: glow,
        ),
        findsOneWidget,
      );
      await tap(tester, find.byKey(const Key('zone5-close-mission')));
      await tap(tester, find.byKey(const Key('zone5-toggle-night')));
      expect(glow, findsNothing);
      final reloaded = PlayerController(
        StorageService(await SharedPreferences.getInstance()),
      );
      addTearDown(reloaded.dispose);
      await reloaded.initialize();
      expect(
        reloaded.progress.purchasedUpgrades,
        contains('ILUMINACAO_CORREDOR'),
      );
      expect(reloaded.progress.coins, before - 80);
      expect(tester.takeException(), isNull);
    },
  );
}
