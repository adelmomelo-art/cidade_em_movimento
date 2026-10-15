import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/services/game_orientation_service.dart';
import 'package:cidade_em_movimento/widgets/game_orientation_gate.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fast22a_r14_mission_overlay_test.dart' as flow;
import 'fast22a_r27_functional_map_test.dart' as images;
import 'fast22a_r15_navigation_question_test.dart' as fixture;

Future<void> captureMap(WidgetTester tester, String name) async {
  await images.waitForArtworkImages(tester);
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('zone1-r22-map-capture')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final directory = Directory('build/fast22a_r29_evidencias');
      await directory.create(recursive: true);
      await File('${directory.path}/$name.png').writeAsBytes(
        data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } finally {
      image.dispose();
    }
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final sample in [
    (const Size(600, 390), EdgeInsets.zero, 1.4),
    (const Size(844, 390), const EdgeInsets.fromLTRB(24, 0, 24, 16), 1.0),
    (const Size(1280, 800), EdgeInsets.zero, 1.4),
    (const Size(1366, 768), EdgeInsets.zero, 1.0),
  ]) {
    testWidgets('whole map stays visible without scrolling at $sample', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = sample.$1;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final c = await fixture.controller(true);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: sample.$2,
              viewPadding: sample.$2,
              textScaler: TextScaler.linear(sample.$3),
            ),
            child: GameOrientationGate(child: child!),
          ),
          home: RepaintBoundary(
            key: const Key('zone1-r22-map-capture'),
            child: Zone1MapScreen(controller: c),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Scrollable), findsNothing);
      final frame = tester.getRect(find.byKey(const Key('zone1-map-canvas')));
      final safe = Rect.fromLTRB(
        sample.$2.left,
        sample.$2.top,
        sample.$1.width - sample.$2.right,
        sample.$1.height - sample.$2.bottom,
      );
      // R23 fills the viewport; only controls are inset around system UI.
      expect(frame.left, closeTo(0, .01));
      expect(frame.top, closeTo(0, .01));
      expect(frame.width, closeTo(sample.$1.width, .01));
      expect(frame.height, closeTo(sample.$1.height, .01));
      for (final key in [
        'zone1-score-hud',
        'zone1-navigation-window',
        'zone1-open-upgrades',
        'zone1-mentor-panel',
        for (final id in flow.ids) 'zone1-visual-mission-$id',
      ]) {
        final target = find.byKey(Key(key));
        final rect = tester.getRect(target);
        expect(safe.inflate(.01).contains(rect.topLeft), isTrue, reason: key);
        expect(
          safe.inflate(.01).contains(rect.bottomRight),
          isTrue,
          reason: key,
        );
      }
      await tester.drag(
        find.byKey(const Key('zone1-fitted-map')),
        const Offset(0, -150),
      );
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(const Key('zone1-map-canvas'))), frame);
      await captureMap(
        tester,
        '${sample.$1.width.toInt()}x${sample.$1.height.toInt()}_${sample.$3}',
      );
      for (final id in flow.ids) {
        await flow.tap(tester, find.byKey(Key('zone1-visual-mission-$id')));
        expect(find.byType(Zone1MissionDialog), findsOneWidget);
        expect(
          tester
              .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
              .mission
              .id,
          id,
        );
        await flow.tap(tester, find.byKey(const Key('zone1-close-mission')));
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('rotation gate keeps mission and pending answer mounted', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(844, 390);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final c = await fixture.controller(false);
    addTearDown(c.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) => GameOrientationGate(child: child!),
        home: Zone1MapScreen(controller: c),
      ),
    );
    await tester.pumpAndSettle();
    final before = c.progress.toJson();
    final mapState = tester.state(find.byType(Zone1MapScreen));
    await flow.tap(
      tester,
      find.byKey(const Key('zone1-visual-mission-Z1_M01')),
    );
    await flow.tap(tester, find.text('INICIAR'));
    final dialog = find.byType(Zone1MissionDialog);
    final dialogState = tester.state(dialog);
    final mission = tester.widget<Zone1MissionDialog>(dialog).mission;
    final correct = mission.options.firstWhere((option) => option.isCorrect);
    await flow.tap(tester, find.byKey(Key('zone1-answer-${correct.id}')));
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('game-rotate-screen')), findsOneWidget);
    expect(dialog, findsNothing);
    expect(
      find.byType(Zone1MissionDialog, skipOffstage: false),
      findsOneWidget,
    );
    expect(c.progress.toJson(), before);
    tester.view.physicalSize = const Size(844, 390);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('game-rotate-screen')), findsNothing);
    expect(tester.state(dialog), same(dialogState));
    expect(tester.state(find.byType(Zone1MapScreen)), same(mapState));
    final confirm = find.byKey(const Key('zone1-confirm-answer'));
    expect(tester.widget<FilledButton>(confirm).onPressed, isNotNull);
    await flow.tap(tester, confirm);
    expect(find.text(correct.consequenceText), findsOneWidget);
    await flow.tap(tester, find.byKey(const Key('zone1-close-mission')));
    expect(c.progress.toJson(), before);
    expect(tester.takeException(), isNull);
  });

  test('Android requests both landscape orientations', () async {
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          calls.add(call);
          return null;
        });
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await configureGameOrientation();
    expect(calls.single.method, 'SystemChrome.setPreferredOrientations');
    expect(calls.single.arguments, [
      'DeviceOrientation.landscapeLeft',
      'DeviceOrientation.landscapeRight',
    ]);
    calls.clear();
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    await configureGameOrientation();
    expect(calls, isEmpty);
  });
}
