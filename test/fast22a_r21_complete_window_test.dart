import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';
import 'fast22a_r14_mission_overlay_test.dart' as flow;
import 'fast22a_r15_navigation_question_test.dart' as fixture;

void main() {
  for (final config in [
    (const Size(1280, 900), 1.0),
    (const Size(844, 390), 1.0),
    (const Size(600, 390), 1.4),
    (const Size(390, 844), 1.0),
  ]) {
    testWidgets(
      'six missions show complete content without scrolling at $config',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = config.$1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final c = await fixture.controller(true);
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
        for (final id in flow.ids) {
          await flow.tap(tester, find.byKey(Key('zone1-visual-mission-$id')));
          final initialFrame = tester.getRect(
            find.byKey(const Key('zone1-mission-frame')),
          );
          final initialHero = tester.getRect(
            find.byKey(const Key('zone1-question-melo')),
          );
          final m = tester
              .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
              .mission;
          void completeVisibleContent() {
            expect(
              tester.getRect(find.byKey(const Key('zone1-mission-frame'))),
              initialFrame,
            );
            expect(
              tester.getRect(find.byKey(const Key('zone1-question-melo'))),
              initialHero,
            );
            expect(
              find.descendant(
                of: find.byType(Zone1MissionDialog),
                matching: find.byType(Scrollable),
              ),
              findsNothing,
            );
            final viewport = find.byKey(
              const Key('zone1-mission-content-viewport'),
            );
            final bounds = tester.getRect(viewport).inflate(.5);
            final paragraphs = find.descendant(
              of: viewport,
              matching: find.byType(Text),
            );
            expect(paragraphs, findsWidgets);
            for (final element in paragraphs.evaluate()) {
              final rect = tester.getRect(find.byWidget(element.widget));
              expect(rect.width, greaterThan(0));
              expect(rect.height, greaterThan(0));
              expect(
                bounds.contains(rect.topLeft),
                isTrue,
                reason:
                    'Texto fora da janela: ${(element.widget as Text).data}',
              );
              expect(
                bounds.contains(rect.bottomRight),
                isTrue,
                reason: 'Texto cortado: ${(element.widget as Text).data}',
              );
              expect(
                (element.widget as Text).overflow,
                isNot(TextOverflow.ellipsis),
              );
            }
            final actions = find.descendant(
              of: viewport,
              matching: find.byWidgetPredicate(
                (w) => w is FilledButton || w is OutlinedButton,
              ),
            );
            final rectangles = <Rect>[];
            for (final element in actions.evaluate()) {
              final rect = tester.getRect(find.byWidget(element.widget));
              expect(bounds.contains(rect.topLeft), isTrue);
              expect(bounds.contains(rect.bottomRight), isTrue);
              for (final other in rectangles) {
                expect(rect.overlaps(other), isFalse);
              }
              rectangles.add(rect);
            }
            expect(tester.takeException(), isNull);
          }

          completeVisibleContent();
          await flow.tap(tester, find.text('INICIAR'));
          completeVisibleContent();
          for (final option in m.options) {
            expect(
              find.byKey(Key('zone1-answer-${option.id}')).hitTestable(),
              findsOneWidget,
            );
          }
          final correct = m.options.firstWhere((o) => o.isCorrect);
          await flow.answerAndConfirm(
            tester,
            find.byKey(Key('zone1-answer-${correct.id}')),
          );
          completeVisibleContent();
          await flow.tap(tester, find.text('CONTINUAR'));
          completeVisibleContent();
          await flow.tap(tester, find.text('VER RESULTADO'));
          completeVisibleContent();
          await flow.tap(tester, find.byKey(const Key('zone1-finish-mission')));
          expect(tester.state(find.byType(Zone1MapScreen)), same(mapState));
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
}
