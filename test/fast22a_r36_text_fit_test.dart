import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_em_movimento/widgets/zone_1_approved_art.dart';
import 'package:cidade_em_movimento/widgets/zone_2_approved_art.dart';
import 'package:cidade_em_movimento/widgets/zone_3_approved_art.dart';
import 'package:cidade_em_movimento/widgets/zone_4_approved_art.dart';
import 'package:cidade_em_movimento/widgets/zone_5_approved_art.dart';
import 'package:cidade_em_movimento/widgets/zone_6_approved_art.dart';

import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/data/zone_1/mission_02_data.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';
import 'fast22a_r14_mission_overlay_test.dart' as flow;
import 'fast22a_r15_navigation_question_test.dart' as fixture;

typedef TextBuilder =
    Widget Function(String text, Key key, int? lines, double size);
final builders = <TextBuilder>[
  (text, key, lines, size) =>
      Zone1ArtText(text, textKey: key, maxLines: lines, fontSize: size),
  (text, key, lines, size) =>
      Zone2ArtText(text, textKey: key, maxLines: lines, fontSize: size),
  (text, key, lines, size) =>
      Zone3ArtText(text, textKey: key, maxLines: lines, fontSize: size),
  (text, key, lines, size) =>
      Zone4ArtText(text, textKey: key, maxLines: lines, fontSize: size),
  (text, key, lines, size) =>
      Zone5ArtText(text, textKey: key, maxLines: lines, fontSize: size),
  (text, key, lines, size) =>
      Zone6ArtText(text, textKey: key, maxLines: lines, fontSize: size),
];

String? selectionOverflow(WidgetTester tester, Key textKey, Key slotKey) {
  final render = tester.renderObject<RenderParagraph>(find.byKey(textKey));
  final text = render.text.toPlainText();
  final boxes = render.getBoxesForSelection(
    TextSelection(baseOffset: 0, extentOffset: text.length),
  );
  if (boxes.isEmpty) return 'Nenhuma caixa de texto para $text';
  final slot = tester.getRect(find.byKey(slotKey)).inflate(0.6);
  for (final box in boxes) {
    final local = box.toRect();
    final painted = Rect.fromPoints(
      render.localToGlobal(local.topLeft),
      render.localToGlobal(local.bottomRight),
    );
    if (!slot.contains(painted.topLeft) ||
        !slot.contains(painted.bottomRight)) {
      return '$text: selecao=$painted; area=$slot; paragrafo=${render.size}';
    }
  }
  return null;
}

void expectComplete(WidgetTester tester, Key key, String text, {int? lines}) {
  final render = tester.renderObject<RenderParagraph>(find.byKey(key));
  expect(render.text.toPlainText(), text);
  expect(render.maxLines, lines);
  expect(render.didExceedMaxLines, isFalse);
  // Glyph selection metrics may extend outside the inner paragraph box.
  // The visible label must fit its allocated UI slot, in the same coordinates.
  expect(selectionOverflow(tester, key, const Key('text-slot')), isNull);
}

void main() {
  testWidgets('slot check detects deliberately clipped text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: SizedBox(
            key: Key('overflow-slot'),
            width: 96,
            height: 24,
            child: ClipRect(
              child: Text(
                'Conhecimento',
                key: Key('overflow-text'),
                maxLines: 1,
                softWrap: false,
                style: TextStyle(fontFamily: 'Ahem', fontSize: 48),
              ),
            ),
          ),
        ),
      ),
    );
    expect(
      selectionOverflow(
        tester,
        const Key('overflow-text'),
        const Key('overflow-slot'),
      ),
      isNotNull,
    );
  });

  for (var zone = 0; zone < builders.length; zone++) {
    for (final scale in [1.0, 1.4, 2.0]) {
      testWidgets(
        'zone ${zone + 1} fits complete labels with inherited spacing at scale $scale',
        (tester) async {
          final samples = [
            ('Conhecimento', const Size(96, 24), 1, 17.0),
            ('Progresso', const Size(107, 42), 1, 24.0),
            ('Próxima zona', const Size(107, 42), 1, 24.0),
            ('CONFIRMAR RESPOSTA', const Size(449, 80), 1, 30.0),
            (
              'Espero o veículo parar completamente e embarco com calma.',
              const Size(390, 96),
              null,
              26.0,
            ),
          ];
          for (final sample in samples) {
            const key = Key('measured-text');
            await tester.pumpWidget(
              MaterialApp(
                home: MediaQuery(
                  data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontFamily: 'Ahem',
                      letterSpacing: 1.7,
                      height: 1.7,
                    ),
                    child: Center(
                      child: SizedBox.fromSize(
                        key: const Key('text-slot'),
                        size: sample.$2,
                        child: builders[zone](
                          sample.$1,
                          key,
                          sample.$3,
                          sample.$4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            expectComplete(tester, key, sample.$1, lines: sample.$3);
            expect(tester.takeException(), isNull);
          }
        },
      );
    }
  }

  for (final type in PlayerType.values) {
    testWidgets(
      'Embarque Seguro uses smaller text and keeps all answers for $type',
      (tester) async {
        tester.view.physicalSize = const Size(844, 390);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final c = await fixture.controller(false);
        addTearDown(c.dispose);
        await c.createProfile(
          type: type,
          avatarId: type == PlayerType.child ? 'child_girl' : type.name,
        );
        final mission = buildZone1Mission02(type);
        final before = c.progress.toJson();
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Zone1MissionDialog(mission: mission, player: c),
          ),
        );
        await tester.pumpAndSettle();
        await flow.tap(tester, find.text('INICIAR'));
        final question = tester.widget<Zone1ArtText>(
          find.ancestor(
            of: find.byKey(const Key('zone1-question-text')),
            matching: find.byType(Zone1ArtText),
          ),
        );
        expect(question.fontSize, 36);
        for (final option in mission.options) {
          final art = tester.widget<Zone1ArtText>(
            find.ancestor(
              of: find.text(option.text),
              matching: find.byType(Zone1ArtText),
            ),
          );
          expect(art.fontSize, 26);
        }
        final confirmation = tester.widget<Text>(
          find.text('CONFIRMAR RESPOSTA'),
        );
        expect(confirmation.maxLines, 1);
        expect(confirmation.style!.fontSize, lessThanOrEqualTo(30));
        expect(c.progress.toJson(), before);
        expect(find.byType(Scrollable), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      },
    );
  }
}
