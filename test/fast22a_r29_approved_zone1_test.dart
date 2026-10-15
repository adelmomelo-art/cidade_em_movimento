import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/widgets/fortaleza_map_avatar.dart';
import 'package:cidade_em_movimento/widgets/zone_1_approved_art.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';
import 'fast22a_r14_mission_overlay_test.dart' as flow;
import 'fast22a_r15_navigation_question_test.dart' as fixture;
import 'fast22a_r19_visual_consistency_test.dart' as evidence;
import 'fast22a_r27_functional_map_test.dart' as images;

void main() {
  testWidgets(
    'all six profile avatars reach the map and mission HUD without resetting progress',
    (tester) async {
      tester.view.physicalSize = const Size(1366, 768);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = await fixture.controller(true);
      addTearDown(c.dispose);
      final progress = c.progress.toJson();
      for (final sample in [
        (PlayerType.child, 'child_boy'),
        (PlayerType.child, 'child_girl'),
        (PlayerType.teen, 'teen_boy'),
        (PlayerType.teen, 'teen_girl'),
        (PlayerType.adult, 'adult_man'),
        (PlayerType.adult, 'adult_woman'),
      ]) {
        await c.createProfile(type: sample.$1, avatarId: sample.$2);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Zone1MapScreen(controller: c),
          ),
        );
        await images.waitForArtworkImages(tester);
        final variant = FortalezaMapAvatar.variantFor(c.profile);
        expect(find.byKey(Key('fortaleza-avatar-$variant')), findsOneWidget);
        expect(find.byKey(Key('fortaleza-portrait-$variant')), findsOneWidget);
        await flow.tap(
          tester,
          find.byKey(const Key('zone1-visual-mission-Z1_M01')),
        );
        final dialog = find.byType(Zone1MissionDialog);
        expect(
          find.descendant(
            of: dialog,
            matching: find.byKey(Key('fortaleza-portrait-$variant')),
          ),
          findsOneWidget,
        );
        await flow.tap(tester, find.text('INICIAR'));
        await evidence.capture(tester, 'r29_${variant}_decisao');
        await flow.tap(tester, find.byKey(const Key('zone1-close-mission')));
        expect(c.progress.toJson(), progress);
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets(
    'approved artwork has live text and all decision targets inside the safe area',
    (tester) async {
      tester.view.physicalSize = const Size(800, 360);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = await fixture.controller(true);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: const EdgeInsets.fromLTRB(28, 0, 24, 12),
              textScaler: const TextScaler.linear(1.4),
            ),
            child: child!,
          ),
          home: Zone1MapScreen(controller: c),
        ),
      );
      await images.waitForArtworkImages(tester);
      for (final id in flow.ids) {
        await flow.tap(tester, find.byKey(Key('zone1-visual-mission-$id')));
        final m = tester
            .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
            .mission;
        await flow.tap(tester, find.text('INICIAR'));
        await images.waitForArtworkImages(tester);
        expect(find.text(m.question), findsOneWidget);
        expect(find.text(m.sceneText), findsOneWidget);
        final dialog = find.byType(Zone1MissionDialog);
        expect(
          find.descendant(of: dialog, matching: find.byType(Scrollable)),
          findsNothing,
        );
        const safe = Rect.fromLTRB(28, 0, 776, 348);
        for (final key in [
          'zone1-close-mission',
          'zone1-back-mission',
          'zone1-confirm-answer',
          for (final option in m.options) 'zone1-answer-${option.id}',
        ]) {
          final rect = tester.getRect(find.byKey(Key(key)));
          expect(safe.inflate(.01).contains(rect.topLeft), isTrue, reason: key);
          expect(
            safe.inflate(.01).contains(rect.bottomRight),
            isTrue,
            reason: key,
          );
        }
        if (id != 'Z1_M01') {
          expect(
            tester
                .widget<Zone1MissionScene>(find.byType(Zone1MissionScene))
                .missionId,
            id,
          );
        }
        await evidence.capture(tester, 'r29_${id}_a05_area_segura');
        await flow.tap(tester, find.byKey(const Key('zone1-close-mission')));
        expect(tester.takeException(), isNull);
      }
    },
  );
}
