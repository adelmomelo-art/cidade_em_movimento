import 'dart:io';
import 'dart:ui' as ui;

import 'package:cidade_em_movimento/app/routes.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/screens/home/home_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> loadPlayer(bool existing) async {
  SharedPreferences.setMockInitialValues({
    if (existing)
      'cidade_em_movimento.player_profile.v1':
          '{"type":"adult","avatarId":"adult"}',
  });
  final controller = PlayerController(
    StorageService(await SharedPreferences.getInstance()),
  );
  await controller.initialize();
  return controller;
}

Future<void> capture(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('home-r24-viewport-capture')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final directory = Directory('build/fast22a_r24_evidencias');
      await directory.create(recursive: true);
      await File('${directory.path}/$name.png').writeAsBytes(
        bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      );
    } finally {
      image.dispose();
    }
  });
}

// Button centres measured on the approved mockup, independently of widget keys.
const approvedTargets = [
  ('home-play-button', 'JOGAR', Offset(240, 667), AppRoutes.fortalezaMap),
  (
    'home-map-button',
    'MAPA DA CIDADE',
    Offset(637, 667),
    AppRoutes.fortalezaMap,
  ),
  ('home-missions-button', 'MINHAS MISSÕES', Offset(240, 812), AppRoutes.zone1),
  (
    'home-achievements-button',
    'CONQUISTAS',
    Offset(637, 812),
    AppRoutes.playerProgress,
  ),
];

void main() {
  for (final size in [
    const Size(600, 390),
    const Size(800, 360),
    const Size(844, 390),
    const Size(1280, 800),
    const Size(1366, 768),
  ]) {
    for (final existing in [false, true]) {
      testWidgets(
        'approved art and four actions at $size existing=$existing',
        (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          // testWidgets owns and releases the semantics handle before its checks.
          final c = await loadPlayer(existing);
          addTearDown(c.dispose);
          final before = c.progress.toJson();
          final opened = <String>[];
          const insets = EdgeInsets.fromLTRB(24, 0, 16, 12);
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.light,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  padding: insets,
                  viewPadding: insets,
                  textScaler: const TextScaler.linear(1.4),
                ),
                child: child!,
              ),
              home: RepaintBoundary(
                key: const Key('home-r24-viewport-capture'),
                child: HomeScreen(controller: c),
              ),
              onGenerateRoute: (settings) {
                opened.add(settings.name!);
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => const Scaffold(body: Text('destination')),
                );
              },
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.byType(Scrollable), findsNothing);
          final artwork = tester.getRect(find.byKey(const Key('home-artwork')));
          final safe = Rect.fromLTRB(24, 0, size.width - 16, size.height - 12);
          expect(artwork.width / artwork.height, closeTo(1672 / 941, .001));
          expect(safe.inflate(.01).contains(artwork.topLeft), isTrue);
          expect(safe.inflate(.01).contains(artwork.bottomRight), isTrue);
          final ambient = tester.getRect(
            find.byKey(const Key('home-ambient-background')),
          );
          expect(ambient, Offset.zero & size);
          final image = tester.widget<Image>(
            find.byKey(const Key('home-approved-image')),
          );
          expect(
            (image.image as AssetImage).assetName,
            HomeScreen.artworkAsset,
          );
          final scale = artwork.width / 1672;
          final rects = <Rect>[];
          for (final action in approvedTargets) {
            final button = find.byKey(Key(action.$1));
            expect(button.hitTestable(), findsOneWidget);
            expect(find.bySemanticsLabel(action.$2), findsOneWidget);
            final rect = tester.getRect(button);
            final approvedCentre = artwork.topLeft + action.$3 * scale;
            expect(rect.contains(approvedCentre), isTrue, reason: action.$2);
            expect(safe.inflate(.01).contains(rect.topLeft), isTrue);
            expect(safe.inflate(.01).contains(rect.bottomRight), isTrue);
            for (final previous in rects) {
              expect(rect.overlaps(previous), isFalse);
            }
            rects.add(rect);
          }
          await tester.tapAt(artwork.topLeft + const Offset(1100, 250) * scale);
          await tester.pumpAndSettle();
          expect(opened, isEmpty);
          await capture(
            tester,
            '${size.width.toInt()}x${size.height.toInt()}_${existing ? 'retorno' : 'novo'}',
          );
          for (final action in approvedTargets) {
            // Tap the artwork's visible icon/label position, not the widget centre.
            await tester.tapAt(artwork.topLeft + action.$3 * scale);
            await tester.pumpAndSettle();
            expect(opened.last, existing ? action.$4 : AppRoutes.profile);
            Navigator.of(tester.element(find.text('destination'))).pop();
            await tester.pumpAndSettle();
            expect(c.progress.toJson(), before);
          }
          expect(tester.takeException(), isNull);
        },
        semanticsEnabled: true,
      );
    }
  }

  testWidgets('native rendering equals approved mockup pixel for pixel', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1672, 941);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final c = await loadPlayer(false);
    addTearDown(c.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: HomeScreen(controller: c),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('home-artwork')),
      matchesGoldenFile('../assets/home/tela_inicial_r24.png'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard activates play without resetting progress', (
    tester,
  ) async {
    final c = await loadPlayer(true);
    addTearDown(c.dispose);
    final before = c.progress.toJson();
    final opened = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: HomeScreen(controller: c),
        onGenerateRoute: (settings) {
          opened.add(settings.name!);
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('destination')),
          );
        },
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(opened, [AppRoutes.fortalezaMap]);
    expect(c.progress.toJson(), before);
    expect(tester.takeException(), isNull);
  });
}
