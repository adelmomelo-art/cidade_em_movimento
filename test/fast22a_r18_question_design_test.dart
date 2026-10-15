import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';
import 'package:cidade_em_movimento/widgets/zone_1_approved_art.dart';
import 'fast22a_r14_mission_overlay_test.dart' as flow;
import 'fast22a_r15_navigation_question_test.dart' as fixture;

void main() {
  for (final config in [
    (const Size(390, 844), 1.0),
    (const Size(844, 390), 1.0),
    (const Size(600, 390), 1.4),
    (const Size(1280, 900), 1.0),
  ]) {
    testWidgets('proposal 3 selection, confirmation and rewards at $config', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = config.$1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = await fixture.controller(false);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(config.$2)),
            child: child!,
          ),
          home: Zone1MapScreen(controller: c),
        ),
      );
      await tester.pumpAndSettle();
      final mapState = tester.state(find.byType(Zone1MapScreen));
      await flow.tap(
        tester,
        find.byKey(const Key('zone1-visual-mission-Z1_M01')),
      );
      final m = tester
          .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
          .mission;
      await flow.tap(tester, find.text('INICIAR'));
      expect(find.byKey(const Key('zone1-mission-header')), findsOneWidget);
      final title = tester.widget<Text>(
        find.byKey(const Key('zone1-mission-title')),
      );
      expect(title.style!.color, Colors.white);
      expect(title.data, m.title.toUpperCase());
      expect(find.byKey(const Key('zone1-question-night')), findsOneWidget);
      expect(find.byKey(const Key('zone1-question-melo')), findsOneWidget);
      expect(find.text(m.question), findsOneWidget);
      expect(
        tester
            .widget<IconButton>(find.byKey(const Key('zone1-voice-preview')))
            .onPressed,
        isNull,
      );
      expect(find.byTooltip('Voz em breve'), findsOneWidget);
      final confirm = find.byKey(const Key('zone1-confirm-answer'));
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
      final before = c.progress.toJson();
      final wrong = m.options.firstWhere((o) => !o.isCorrect);
      final correct = m.options.firstWhere((o) => o.isCorrect);
      for (final option in m.options) {
        final target = find.byKey(Key('zone1-answer-${option.id}'));
        final button = tester.widget<OutlinedButton>(target);
        expect(button.style!.backgroundColor!.resolve({}), Colors.transparent);
        expect(button.style!.foregroundColor!.resolve({}), Colors.white);
        final targetRect = tester.getRect(target);
        final viewport = tester.getRect(
          find.byKey(const Key('zone1-mission-content-viewport')),
        );
        expect(targetRect.width, greaterThan(0));
        expect(targetRect.height, greaterThan(0));
        expect(viewport.inflate(.01).contains(targetRect.topLeft), isTrue);
        expect(viewport.inflate(.01).contains(targetRect.bottomRight), isTrue);
      }
      await flow.tap(tester, find.byKey(Key('zone1-answer-${wrong.id}')));
      expect(find.text(wrong.consequenceText), findsNothing);
      expect(c.progress.toJson(), before);
      await flow.tap(tester, find.byKey(Key('zone1-answer-${correct.id}')));
      expect(find.text(correct.consequenceText), findsNothing);
      expect(tester.widget<FilledButton>(confirm).onPressed, isNotNull);
      await flow.tap(tester, confirm);
      expect(find.text(correct.consequenceText), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Zone1MissionDialog),
          matching: find.byType(Scrollable),
        ),
        findsNothing,
      );
      await flow.tap(tester, find.text('CONTINUAR'));
      await flow.tap(tester, find.text('VER RESULTADO'));
      await flow.tap(tester, find.byKey(const Key('zone1-finish-mission')));
      expect(c.progress.missionStars['Z1_M01'], 3);
      expect(c.progress.coins, m.maxCoins);
      expect(tester.state(find.byType(Zone1MapScreen)), same(mapState));
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('pending selection survives rotation and exit gives no reward', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final c = await fixture.controller(false);
    addTearDown(c.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Zone1MapScreen(controller: c),
      ),
    );
    await tester.pumpAndSettle();
    final before = c.progress.toJson();
    await flow.tap(
      tester,
      find.byKey(const Key('zone1-visual-mission-Z1_M01')),
    );
    await flow.tap(tester, find.text('INICIAR'));
    final m = tester
        .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
        .mission;
    await flow.tap(
      tester,
      find.byKey(Key('zone1-answer-${m.options.first.id}')),
    );
    tester.view.physicalSize = const Size(844, 390);
    await tester.pumpAndSettle();
    expect(find.text(m.question), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('zone1-confirm-answer')))
          .onPressed,
      isNotNull,
    );
    await flow.tap(tester, find.byKey(const Key('zone1-close-mission')));
    expect(c.progress.toJson(), before);
    expect(find.byType(Zone1MissionDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('question background respects current night mode', (
    tester,
  ) async {
    final c = await fixture.controller(true);
    addTearDown(c.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Zone1MapScreen(controller: c),
      ),
    );
    await tester.pumpAndSettle();
    await flow.tap(tester, find.byKey(const Key('zone1-toggle-night')));
    await flow.tap(
      tester,
      find.byKey(const Key('zone1-visual-mission-Z1_M01')),
    );
    expect(
      tester
          .widget<Zone1NightLayer>(
            find.byKey(const Key('zone1-question-night')),
          )
          .night,
      isTrue,
    );
    await flow.tap(tester, find.byKey(const Key('zone1-close-mission')));
    expect(tester.takeException(), isNull);
  });
}
