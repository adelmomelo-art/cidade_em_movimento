import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/data/sign_duel/sign_duel_catalog.dart';
import 'package:cidade_em_movimento/screens/sign_duel/sign_duel_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:cidade_em_movimento/widgets/sign_duel_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> player(PlayerType type) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(preferences));
  await controller.initialize();
  await controller.createProfile(type: type, avatarId: 'child_boy');
  return controller;
}

Future<void> start(
  WidgetTester tester,
  PlayerController controller, {
  Size size = const Size(1280, 720),
  double scale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: SignDuelScreen(controller: controller),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> tap(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

Future<void> finish(WidgetTester tester) async {
  for (final q in signDuelQuestions) {
    await tap(tester, 'duel-option-${q.correctIndex}');
    await tap(tester, 'duel-confirm');
    await tap(tester, 'duel-continue');
  }
}

void main() {
  for (final entry in [
    (PlayerType.child, 20),
    (PlayerType.teen, 15),
    (PlayerType.adult, 10),
  ]) {
    testWidgets(
      'R42 ${entry.$1} has ${entry.$2} seconds and timeout feedback',
      (tester) async {
        final controller = await player(entry.$1);
        await start(tester, controller);
        expect(find.text('00:${entry.$2}'), findsOneWidget);
        await tap(tester, 'duel-option-1');
        expect(find.text('Pontos: 0'), findsOneWidget);
        await tester.pump(Duration(seconds: entry.$2));
        await tester.pump();
        expect(find.text('00:00'), findsOneWidget);
        expect(find.text('Tempo esgotado'), findsOneWidget);
        expect(find.byKey(const Key('duel-correct-answer')), findsOneWidget);
        expect(find.text(signDuelQuestions.first.explanation), findsOneWidget);
        expect(find.text('Pontos: 0'), findsOneWidget);
        expect(controller.progress.signDuelPlays, 0);
        await tap(tester, 'duel-continue');
        expect(find.text('Rodada 2 de 6'), findsOneWidget);
        expect(find.text('00:${entry.$2}'), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  testWidgets('R42 can change selection, confirm once and stop time', (
    tester,
  ) async {
    final controller = await player(PlayerType.adult);
    await start(tester, controller);
    await tap(tester, 'duel-option-0');
    expect(find.byKey(const Key('duel-feedback')), findsNothing);
    await tap(tester, 'duel-option-1');
    await tap(tester, 'duel-confirm');
    expect(find.text('Pontos: 100'), findsOneWidget);
    final remaining = tester
        .widget<Text>(find.byKey(const Key('duel-timer')))
        .data;
    await tester.pump(const Duration(seconds: 30));
    expect(find.text(remaining!), findsOneWidget);
    expect(find.text('Pontos: 100'), findsOneWidget);
    expect(controller.progress.signDuelPlays, 0);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'R42 six rounds keep rewards and replay does not duplicate knowledge',
    (tester) async {
      final controller = await player(PlayerType.child);
      await start(tester, controller);
      await finish(tester);
      expect(controller.progress.signDuelPlays, 1);
      expect(controller.progress.signDuelBestScore, 600);
      expect(controller.progress.knowledge, 12);
      await tap(tester, 'duel-restart');
      await finish(tester);
      expect(controller.progress.signDuelPlays, 2);
      expect(controller.progress.knowledge, 12);
      final preferences = await SharedPreferences.getInstance();
      final restored = PlayerController(StorageService(preferences));
      await restored.initialize();
      expect(restored.progress.signDuelBestScore, 600);
      expect(restored.progress.knowledge, 12);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('R42 lifecycle pauses countdown without losing selection', (
    tester,
  ) async {
    final controller = await player(PlayerType.adult);
    await start(tester, controller);
    await tap(tester, 'duel-option-1');
    final before = tester
        .widget<Text>(find.byKey(const Key('duel-timer')))
        .data;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump(const Duration(seconds: 30));
    expect(find.text(before!), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(seconds: 1));
    expect(
      tester.widget<Text>(find.byKey(const Key('duel-timer'))).data,
      isNot(before),
    );
    await tap(tester, 'duel-confirm');
    expect(find.text('Pontos: 100'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('R42 hidden route pauses and leaving early gives no reward', (
    tester,
  ) async {
    final controller = await player(PlayerType.child);
    await start(tester, controller);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    final before = tester
        .widget<Text>(find.byKey(const Key('duel-timer')))
        .data;
    navigator.push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Outra tela')),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 40));
    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text(before!), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 30));
    expect(controller.progress.signDuelPlays, 0);
    expect(controller.progress.knowledge, 0);
  });

  testWidgets('R42 disabled ticker pauses countdown for orientation gate', (
    tester,
  ) async {
    final controller = await player(PlayerType.child);
    final enabled = ValueNotifier<bool>(true);
    addTearDown(enabled.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: ValueListenableBuilder<bool>(
          valueListenable: enabled,
          child: SignDuelScreen(controller: controller),
          builder: (_, value, child) =>
              TickerMode(enabled: value, child: child!),
        ),
      ),
    );
    await tester.pumpAndSettle();
    enabled.value = false;
    await tester.pump();
    await tester.pump(const Duration(seconds: 40));
    expect(find.text('00:20'), findsOneWidget);
    enabled.value = true;
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:19'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final size in [
    const Size(600, 390),
    const Size(844, 390),
    const Size(1280, 800),
    const Size(1366, 768),
  ]) {
    for (final scale in [1.0, 1.4, 2.0]) {
      testWidgets('R42 complete horizontal controls at $size scale $scale', (
        tester,
      ) async {
        final controller = await player(PlayerType.child);
        await start(tester, controller, size: size, scale: scale);
        expect(find.byType(Scrollable), findsNothing);
        for (final q in signDuelQuestions) {
          expect(find.byKey(Key('duel-sign-${q.code}')), findsOneWidget);
          expect(tester.widget<DuelSign>(find.byType(DuelSign)).code, q.code);
          for (var i = 0; i < q.options.length; i++) {
            final finder = find.byKey(Key('duel-option-$i'));
            expect(finder.hitTestable(), findsOneWidget);
            final rect = tester.getRect(finder);
            expect(rect.left, greaterThanOrEqualTo(0));
            expect(rect.right, lessThanOrEqualTo(size.width));
            expect(rect.top, greaterThanOrEqualTo(0));
            expect(rect.bottom, lessThanOrEqualTo(size.height));
            expect(find.text(q.options[i]), findsOneWidget);
          }
          await tap(tester, 'duel-option-${q.correctIndex}');
          await tap(tester, 'duel-confirm');
          expect(find.text(q.explanation), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tap(tester, 'duel-continue');
        }
        expect(find.byKey(const Key('duel-final-score')), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
