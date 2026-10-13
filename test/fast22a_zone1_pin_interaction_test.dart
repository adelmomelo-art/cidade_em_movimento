import 'dart:convert';

import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _ids = ['Z1_M01', 'Z1_M02', 'Z1_M03', 'Z1_M04', 'Z1_M05', 'Z1_SPECIAL'];

Future<PlayerController> _controller({required bool completed}) async {
  SharedPreferences.setMockInitialValues(
    completed
        ? {
            'cidade_em_movimento.player_profile.v1': jsonEncode({
              'type': 'adult',
              'avatarId': 'adult',
            }),
            'cidade_em_movimento.game_progress.v1': jsonEncode({
              'coins': 240,
              'completedMissions': _ids,
              'unlockedMissions': _ids,
              'missionStars': {for (final id in _ids) id: 3},
              'purchasedUpgrades': [
                'FAIXA_SEGURA',
                'ILUMINACAO_ESCOLAR',
                'TRECHO_CICLOVIARIO',
              ],
              'zone1Completed': true,
            }),
          }
        : <String, Object>{},
  );
  final controller = PlayerController(
    StorageService(await SharedPreferences.getInstance()),
  );
  await controller.initialize();
  return controller;
}

void main() {
  for (final width in [390.0, 800.0, 1280.0]) {
    testWidgets(
      'Z1 pins do not overlap and open their own mission dialogs at $width',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 900);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = await _controller(completed: true);
        addTearDown(controller.dispose);
        final opened = <String>[];
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Zone1MapScreen(controller: controller),
            onGenerateRoute: (settings) {
              opened.add(settings.name!);
              return MaterialPageRoute<void>(
                builder: (_) => Scaffold(body: Text(settings.name!)),
              );
            },
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final pins = [
          for (final id in _ids) find.byKey(Key('zone1-visual-mission-$id')),
        ];
        final rects = [for (final pin in pins) tester.getRect(pin)];
        for (var i = 0; i < rects.length; i++) {
          expect(tester.getSize(pins[i]).width, greaterThanOrEqualTo(48));
          expect(tester.getSize(pins[i]).height, greaterThanOrEqualTo(48));
          expect(pins[i].hitTestable(), findsOneWidget);
          expect(rects[i].width, greaterThan(0));
          expect(rects[i].height, greaterThan(0));
          for (var j = i + 1; j < rects.length; j++) {
            expect(
              rects[i].overlaps(rects[j]),
              isFalse,
              reason:
                  '${_ids[i]} ${rects[i]} overlaps ${_ids[j]} ${rects[j]} at $width',
            );
          }
        }
        final before = controller.progress.toJson();
        for (final pin in pins) {
          await tester.ensureVisible(pin);
          await tester.pumpAndSettle();
          await tester.tap(pin);
          await tester.pumpAndSettle();
          expect(find.byType(Zone1MissionDialog), findsOneWidget);
          opened.add(
            tester
                .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
                .mission
                .id,
          );
          await tester.tap(find.byKey(const Key('zone1-close-mission')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        expect(opened, _ids);
        expect(controller.progress.toJson(), before);
        expect(find.textContaining('â˜'), findsNothing);
      },
    );
  }

  testWidgets('locked pins cannot open a route', (tester) async {
    final controller = await _controller(completed: false);
    addTearDown(controller.dispose);
    final opened = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Zone1MapScreen(controller: controller),
        onGenerateRoute: (settings) {
          opened.add(settings.name!);
          return MaterialPageRoute<void>(builder: (_) => const SizedBox());
        },
      ),
    );
    await tester.pumpAndSettle();
    for (final id in _ids.skip(1)) {
      final pin = find.byKey(Key('zone1-visual-mission-$id'));
      await tester.ensureVisible(pin);
      await tester.pumpAndSettle();
      await tester.tap(pin);
      await tester.pumpAndSettle();
    }
    expect(opened, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
