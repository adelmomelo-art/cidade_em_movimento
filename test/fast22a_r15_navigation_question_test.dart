import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cidade_em_movimento/app/routes.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/widgets/zone_1_approved_art.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';
import 'fast22a_r14_mission_overlay_test.dart' as fixture;

Future<PlayerController> controller(bool completed) async {
  SharedPreferences.setMockInitialValues({
    'cidade_em_movimento.player_profile.v1':
        '{"type":"adult","avatarId":"adult"}',
    if (completed)
      'cidade_em_movimento.game_progress.v1': jsonEncode({
        'coins': 240,
        'citizenshipXp': 350,
        'knowledge': 120,
        'completedMissions': fixture.ids,
        'unlockedMissions': fixture.ids,
        'missionStars': {for (final id in fixture.ids) id: 3},
        'medals': ['PROTETOR_DA_ESCOLA'],
        'zone1Completed': true,
      }),
  });
  final c = PlayerController(
    StorageService(await SharedPreferences.getInstance()),
  );
  await c.initialize();
  return c;
}

void main() {
  for (final size in [
    const Size(390, 844),
    const Size(844, 390),
    const Size(1280, 900),
  ]) {
    testWidgets(
      'navigation shares the scene with KPI without overlap at $size',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final c = await controller(true);
        addTearDown(c.dispose);
        final routes = <String>[];
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Zone1MapScreen(controller: c),
            onGenerateRoute: (settings) {
              routes.add(settings.name!);
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (_) => const Scaffold(body: Text('destination')),
              );
            },
          ),
        );
        await tester.pumpAndSettle();
        final frame = find.byKey(const Key('zone1-map-canvas'));
        final nav = find.byKey(const Key('zone1-navigation-window'));
        final navRect = tester.getRect(nav), frameRect = tester.getRect(frame);
        expect(find.descendant(of: frame, matching: nav), findsOneWidget);
        expect(frameRect.contains(navRect.topLeft), isTrue);
        expect(frameRect.contains(navRect.bottomRight), isTrue);
        for (final key in [
          'zone1-score-hud',
          'zone1-mentor-panel',
          'zone1-earned-medal',
        ]) {
          expect(
            navRect.overlaps(tester.getRect(find.byKey(Key(key)))),
            isFalse,
          );
        }
        for (final key in [
          'zone1-toggle-night',
          'zone1-open-progress',
          'zone1-advance-zone2',
        ]) {
          final f = find.byKey(Key(key));
          expect(find.descendant(of: nav, matching: f), findsOneWidget);
          final r = tester.getRect(f);
          // Native target keeps 48 dp; the whole board has a viewport transform.
          expect(tester.getSize(f).width, greaterThanOrEqualTo(48));
          expect(tester.getSize(f).height, greaterThanOrEqualTo(48));
          expect(r.width, greaterThan(0));
          expect(f.hitTestable(), findsOneWidget);
          expect(r.height, greaterThan(0));
        }
        final before = c.progress.toJson();
        await fixture.tap(tester, find.byKey(const Key('zone1-toggle-night')));
        expect(
          tester
              .widget<Zone1NightLayer>(find.byKey(const Key('zone1-map-night')))
              .night,
          isTrue,
        );
        expect(c.progress.toJson(), before);
        await fixture.tap(tester, find.byKey(const Key('zone1-open-progress')));
        expect(routes.last, AppRoutes.playerProgress);
        Navigator.of(tester.element(find.text('destination'))).pop();
        await tester.pumpAndSettle();
        await fixture.tap(tester, find.byKey(const Key('zone1-advance-zone2')));
        expect(routes.last, AppRoutes.zone2);
        Navigator.of(tester.element(find.text('destination'))).pop();
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('zone1-landscape-hint')), findsNothing);
        await fixture.tap(
          tester,
          find.byKey(const Key('zone1-visual-mission-Z1_M01')),
        );
        expect(find.byType(Zone1MissionDialog), findsOneWidget);
        await fixture.tap(tester, find.byKey(const Key('zone1-close-mission')));
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'next zone stays hidden until unlocked and map returns to Fortaleza',
    (tester) async {
      final c = await controller(false);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.fortalezaMap,
          routes: {
            '/': (_) => const Scaffold(body: Text('home')),
            AppRoutes.fortalezaMap: (_) => Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.zone1),
                  child: const Text('enter'),
                ),
              ),
            ),
            AppRoutes.zone1: (_) => Zone1MapScreen(controller: c),
          },
        ),
      );
      await tester.pumpAndSettle();
      await fixture.tap(tester, find.text('enter'));
      expect(find.byKey(const Key('zone1-advance-zone2')), findsNothing);
      await fixture.tap(
        tester,
        find.byKey(const Key('zone1-back-to-fortaleza')),
      );
      expect(find.text('enter'), findsOneWidget);
      expect(find.byType(Zone1MapScreen), findsNothing);
    },
  );
  for (final width in [390.0, 1280.0]) {
    testWidgets(
      'Melo presents the approved blue decision panel and survives rotation at $width',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 900);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final c = await controller(false);
        addTearDown(c.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Zone1MapScreen(controller: c),
          ),
        );
        await tester.pumpAndSettle();
        await fixture.tap(
          tester,
          find.byKey(const Key('zone1-visual-mission-Z1_M01')),
        );
        final mascot = find.byKey(const Key('zone1-question-melo'));
        final frame = tester.getRect(
          find.byKey(const Key('zone1-mission-frame')),
        );
        final hero = tester.getRect(mascot);
        expect(hero.width / frame.width, closeTo(350 / 1672, .01));
        expect(frame.contains(hero.center), isTrue);
        await fixture.tap(tester, find.text('INICIAR'));
        expect(
          find.byKey(const Key('zone1-question-highlight')),
          findsOneWidget,
        );
        expect(find.byKey(const Key('zone1-question-text')), findsOneWidget);
        if (width == 390) {
          tester.view.physicalSize = const Size(844, 390);
          await tester.pumpAndSettle();
          expect(
            find.byKey(const Key('zone1-question-highlight')),
            findsOneWidget,
          );
          expect(find.text('INICIAR'), findsNothing);
        }
        final m = tester
            .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
            .mission;
        await fixture.answerAndConfirm(
          tester,
          find.byKey(
            Key('zone1-answer-${m.options.firstWhere((o) => o.isCorrect).id}'),
          ),
        );
        await fixture.tap(tester, find.text('CONTINUAR'));
        await fixture.tap(tester, find.text('VER RESULTADO'));
        await fixture.tap(
          tester,
          find.byKey(const Key('zone1-finish-mission')),
        );
        expect(c.progress.missionStars['Z1_M01'], 3);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
