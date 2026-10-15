import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';
import 'package:cidade_em_movimento/widgets/zone_1_approved_art.dart';
import 'fast22a_r27_functional_map_test.dart' as images;
import 'fast22a_r14_mission_overlay_test.dart' as flow;
import 'fast22a_r15_navigation_question_test.dart' as fixture;

Future<void> capture(WidgetTester tester, String name) async {
  await images.waitForArtworkImages(tester);
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('zone1-mission-capture')),
  );
  await tester.runAsync(() async {
    final rendered = await boundary.toImage(pixelRatio: 1);
    try {
      final data = await rendered.toByteData(format: ui.ImageByteFormat.png);
      final directory = Directory('build/fast22a_r29_evidencias');
      await directory.create(recursive: true);
      await File('${directory.path}/$name.png').writeAsBytes(
        data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } finally {
      rendered.dispose();
    }
  });
}

void main() {
  for (final config in [
    ('desktop', const Size(1280, 900), 1.0),
    ('a05_horizontal', const Size(844, 390), 1.0),
    ('vertical', const Size(390, 844), 1.0),
    ('texto_ampliado', const Size(600, 390), 1.4),
  ]) {
    testWidgets('consistent mockup layout across all stages ${config.$1}', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = config.$2;
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
            ).copyWith(textScaler: TextScaler.linear(config.$3)),
            child: child!,
          ),
          home: Zone1MapScreen(controller: c),
        ),
      );
      await tester.pumpAndSettle();
      final originalMapState = tester.state(find.byType(Zone1MapScreen));
      await flow.tap(
        tester,
        find.byKey(const Key('zone1-visual-mission-Z1_M01')),
      );
      final m = tester
          .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
          .mission;
      final frame = tester.getRect(
        find.byKey(const Key('zone1-mission-frame')),
      );
      if (config.$1 == 'desktop') {
        expect(
          frame.width / frame.height,
          closeTo(zone1ArtworkSize.aspectRatio, .001),
        );
      }
      void visualContract(bool question) {
        final currentFrame = tester.getRect(
          find.byKey(const Key('zone1-mission-frame')),
        );
        expect(currentFrame, frame);
        final hero = tester.getRect(
          find.byKey(const Key('zone1-question-melo')),
        );
        expect(find.byKey(const Key('zone1-mockup-melo')), findsOneWidget);
        expect(frame.contains(hero.center), isTrue);
        if (config.$2.width > config.$2.height) {
          expect(hero.width / frame.width, closeTo(350 / 1672, .01));
          expect(hero.height, greaterThan(frame.height * .6));
        }
        final title = tester.widget<Text>(
          find.byKey(const Key('zone1-mission-title')),
        );
        expect(title.textAlign, TextAlign.center);
        expect(title.style!.color, Colors.white);
        expect(find.byKey(const Key('zone1-mission-header')), findsOneWidget);
        expect(
          find.byKey(
            Key(question ? 'zone1-question-highlight' : 'zone1-stage-balloon'),
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('zone1-question-scenario')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(Zone1MissionDialog),
            matching: find.byType(Scrollable),
          ),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
      }

      visualContract(false);
      await capture(tester, '${config.$1}_01_introducao');
      await flow.tap(tester, find.text('INICIAR'));
      visualContract(true);
      expect(find.text(m.sceneText), findsOneWidget);
      expect(find.text(m.question), findsOneWidget);
      final confirm = tester.widget<FilledButton>(
        find.byKey(const Key('zone1-confirm-answer')),
      );
      expect(confirm.onPressed, isNull);
      expect(
        confirm.style!.backgroundColor!.resolve({WidgetState.disabled}),
        const Color(0x77062365),
      );
      expect(
        confirm.style!.foregroundColor!.resolve({WidgetState.disabled}),
        Colors.white,
      );
      await capture(tester, '${config.$1}_02_pergunta');
      final correct = m.options.firstWhere((o) => o.isCorrect);
      await flow.tap(tester, find.byKey(Key('zone1-answer-${correct.id}')));
      expect(c.progress.completedMissions, isEmpty);
      await capture(tester, '${config.$1}_03_selecao');
      await flow.tap(tester, find.byKey(const Key('zone1-confirm-answer')));
      visualContract(false);
      expect(find.text(correct.consequenceText), findsOneWidget);
      await capture(tester, '${config.$1}_04_consequencia');
      await flow.tap(tester, find.text('CONTINUAR'));
      visualContract(false);
      expect(find.text(correct.meloFeedback), findsOneWidget);
      await capture(tester, '${config.$1}_05_explicacao');
      await flow.tap(tester, find.text('VER RESULTADO'));
      visualContract(false);
      expect(find.text('MISSÃO CONCLUÍDA'), findsOneWidget);
      expect(c.progress.missionStars['Z1_M01'], 3);
      await capture(tester, '${config.$1}_06_resultado');
      await flow.tap(tester, find.byKey(const Key('zone1-finish-mission')));
      expect(tester.state(find.byType(Zone1MapScreen)), same(originalMapState));
      expect(tester.takeException(), isNull);
    });
  }
}
