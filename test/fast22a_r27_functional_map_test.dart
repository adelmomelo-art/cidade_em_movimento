import 'dart:io';
import 'dart:ui' as ui;

import 'package:cidade_em_movimento/app/routes.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/models/player_profile.dart';
import 'package:cidade_em_movimento/screens/fortaleza_map/fortaleza_map_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:cidade_em_movimento/widgets/fortaleza_map_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> player() async {
  SharedPreferences.setMockInitialValues({});
  final c = PlayerController(
    StorageService(await SharedPreferences.getInstance()),
  );
  await c.initialize();
  await c.createProfile(type: PlayerType.child, avatarId: 'child_boy');
  addTearDown(c.dispose);
  return c;
}

Future<void> complete(PlayerController c, int zone) async => c.completeMission(
  result: MissionResult(
    missionId: 'Z${zone}_SPECIAL',
    stars: 3,
    score: 100,
    citizenship: 7,
    knowledge: 5,
    coins: 11,
    errors: 0,
  ),
);

void viewport(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

String status(WidgetTester tester, int zone) => tester
    .widget<Semantics>(
      find
          .descendant(
            of: find.byKey(Key('fortaleza-status-ZONE_$zone')),
            matching: find.byType(Semantics),
          )
          .first,
    )
    .properties
    .label!;

Widget app(PlayerController c, {bool safe = false, List<String>? opened}) =>
    MaterialApp(
      theme: AppTheme.light,
      home: FortalezaMapScreen(controller: c),
      onGenerateRoute: (settings) {
        opened?.add(settings.name!);
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => Scaffold(body: Text('destination ${settings.name}')),
        );
      },
      builder: safe
          ? (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding: const EdgeInsets.fromLTRB(24, 0, 16, 12),
                viewPadding: const EdgeInsets.fromLTRB(24, 0, 16, 12),
                textScaler: const TextScaler.linear(1.4),
              ),
              child: child!,
            )
          : null,
    );

// Asset decoding uses real asynchronous work. pumpAndSettle alone can finish
// before a decoded frame is available, leaving only native controls painted.
Future<void> waitForArtworkImages(WidgetTester tester) async {
  final images = find.byType(Image).evaluate().toList();
  expect(images, isNotEmpty, reason: 'The map must contain image widgets.');
  for (final element in images) {
    final provider = (element.widget as Image).image;
    Object? loadingError;
    await tester.runAsync(() async {
      await precacheImage(
        provider,
        element,
        onError: (error, stackTrace) => loadingError = error,
      ).timeout(const Duration(seconds: 30));
    });
    expect(
      loadingError,
      isNull,
      reason: 'Failed to decode map image: $provider',
    );
    expect(tester.takeException(), isNull);
  }
  await tester.pumpAndSettle();
  final paintedImages = tester.widgetList<RawImage>(find.byType(RawImage));
  expect(paintedImages, isNotEmpty);
  for (final image in paintedImages) {
    expect(
      image.image,
      isNotNull,
      reason: 'A map image has no decoded frame before capture.',
    );
  }
}

Future<void> capture(WidgetTester tester, String name) async {
  await waitForArtworkImages(tester);
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('fortaleza-artwork')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory('build/fast22a_r27_evidencias');
      await dir.create(recursive: true);
      await File('${dir.path}/$name.png').writeAsBytes(
        bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      );
    } finally {
      image.dispose();
    }
  });
}

void main() {
  testWidgets('native cathedral, pier and lighthouse retain approved pixels', (
    tester,
  ) async {
    viewport(tester, const Size(1672, 941));
    final c = await player();
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    await waitForArtworkImages(tester);
    final actualBounds = tester.getRect(
      find.byKey(const Key('fortaleza-artwork')),
    );
    expect(actualBounds.size, const Size(1672, 941));

    Future<List<int>?> renderPixels(Key key, String name) async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(key),
      );
      return tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 1);
        try {
          final pixels = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          final directory = Directory('build/fast22a_r27_evidencias');
          await directory.create(recursive: true);
          await File('${directory.path}/$name.png').writeAsBytes(
            png!.buffer.asUint8List(png.offsetInBytes, png.lengthInBytes),
          );
          return pixels!.buffer.asUint8List(
            pixels.offsetInBytes,
            pixels.lengthInBytes,
          );
        } finally {
          image.dispose();
        }
      });
    }

    final actual = await renderPixels(
      const Key('fortaleza-artwork'),
      'r27c_actual_map',
    );
    expect(actual, isNotNull);
    expect(actual!.length, 1672 * 941 * 4);

    // Render the independent approved reference with the same Flutter image
    // paint path. Direct codec bytes bypass this path and aren't screenshots.
    await tester.pumpWidget(
      MaterialApp(
        key: UniqueKey(),
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: const Key('r27c-approved-reference'),
              child: SizedBox(
                width: 1672,
                height: 941,
                child: Image.asset(
                  'assets/fortaleza/mapa_aprovado_r27.png',
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.medium,
                  excludeFromSemantics: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('r27c-approved-reference'))).size,
      const Size(1672, 941),
    );
    await waitForArtworkImages(tester);
    final expected = await renderPixels(
      const Key('r27c-approved-reference'),
      'r27c_approved_reference',
    );
    expect(expected, isNotNull);
    expect(expected!.length, actual.length);

    String? firstDifference;
    var samples = 0;
    var differences = 0;
    // Same reference areas, sampling and tolerance as R27: no widened limits.
    for (final rect in [
      const Rect.fromLTWH(450, 100, 330, 330),
      const Rect.fromLTWH(1150, 355, 470, 285),
    ]) {
      for (var y = rect.top.toInt(); y < rect.bottom; y += 7) {
        for (var x = rect.left.toInt(); x < rect.right; x += 7) {
          final offset = (y * 1672 + x) * 4;
          samples++;
          for (var channel = 0; channel < 4; channel++) {
            if ((actual[offset + channel] - expected[offset + channel]).abs() >
                1) {
              differences++;
              firstDifference ??=
                  'Approved landmark changed at ($x, $y), channel $channel: '
                  'expected RGBA ${expected.sublist(offset, offset + 4)}, '
                  'actual RGBA ${actual.sublist(offset, offset + 4)}';
              break;
            }
          }
        }
      }
    }
    await tester.runAsync(
      () => File('build/fast22a_r27_evidencias/r27c_pixels.txt').writeAsString(
        'Samples: $samples\nDifferent samples: $differences\nTolerance per channel: 1\n'
        '${firstDifference ?? 'Approved landmark samples match.'}\n',
      ),
    );
    expect(differences, 0, reason: firstDifference);
    expect(tester.takeException(), isNull);
  });
  for (final size in [
    const Size(600, 390),
    const Size(800, 360),
    const Size(844, 390),
    const Size(1280, 800),
    const Size(1366, 768),
  ]) {
    testWidgets(
      'whole approved map, six cards and start avatar fit without scrolling at $size',
      (tester) async {
        viewport(tester, size);
        final c = await player();
        final before = c.progress.toJson();
        final opened = <String>[];
        await tester.pumpWidget(app(c, safe: true, opened: opened));
        await tester.pumpAndSettle();
        expect(find.byType(Scrollable), findsNothing);
        final art = tester.getRect(find.byKey(const Key('fortaleza-artwork')));
        final safe = Rect.fromLTRB(
          24,
          0,
          size.width - 16,
          size.height - 12,
        ).inflate(.01);
        expect(art.width / art.height, closeTo(1672 / 941, .001));
        expect(safe.contains(art.topLeft), isTrue);
        expect(safe.contains(art.bottomRight), isTrue);
        expect(
          tester.getRect(find.byKey(const Key('fortaleza-ambient-background'))),
          Offset.zero & size,
        );
        final rects = <Rect>[];
        for (var zone = 1; zone <= 6; zone++) {
          final rect = tester.getRect(
            find.byKey(Key('fortaleza-zone-ZONE_$zone')),
          );
          expect(safe.contains(rect.topLeft), isTrue);
          expect(safe.contains(rect.bottomRight), isTrue);
          for (final other in rects) {
            expect(rect.overlaps(other), isFalse);
          }
          rects.add(rect);
          expect(status(tester, zone), zone == 1 ? 'DISPONIVEL' : 'BLOQUEADA');
        }
        for (final key in [
          'fortaleza-start-avatar',
          'fortaleza-menu-button',
          'fortaleza-missions-button',
          'fortaleza-build-neighborhood',
          'fortaleza-medals-button',
          'fortaleza-global-summary',
        ]) {
          final rect = tester.getRect(find.byKey(Key(key)));
          expect(safe.contains(rect.topLeft), isTrue);
          expect(safe.contains(rect.bottomRight), isTrue);
        }
        await capture(tester, '${size.width.toInt()}x${size.height.toInt()}');
        // Points measured on the approved image, including disabled card art.
        for (final point in [
          const Offset(550, 500),
          const Offset(1450, 290),
          const Offset(1000, 365),
          const Offset(930, 695),
          const Offset(1450, 730),
        ]) {
          await tester.tapAt(art.topLeft + point * (art.width / 1672));
          await tester.pumpAndSettle();
        }
        expect(opened, isEmpty);
        await tester.tapAt(
          art.topLeft + const Offset(306, 605) * (art.width / 1672),
        );
        await tester.pumpAndSettle();
        expect(opened, [AppRoutes.zone1]);
        expect(c.progress.toJson(), before);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'engine sequential unlock, earned medals, HUD and routes update in place',
    (tester) async {
      viewport(tester, const Size(1280, 800));
      final c = await player();
      final opened = <String>[];
      await tester.pumpWidget(app(c, opened: opened));
      await tester.pumpAndSettle();
      const routes = [
        AppRoutes.zone1,
        AppRoutes.zone2,
        AppRoutes.zone3,
        AppRoutes.zone4,
        AppRoutes.zone5,
        AppRoutes.zone6,
      ];
      for (var done = 0; done <= 6; done++) {
        final before = c.progress.toJson();
        expect(find.text('PROGRESSÃO DA CIDADE • $done/6'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byKey(const Key('fortaleza-coins')),
            matching: find.text('${c.progress.coins}'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('fortaleza-citizenship')),
            matching: find.text('${c.progress.citizenshipXp}'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('fortaleza-knowledge')),
            matching: find.text('${c.progress.knowledge}'),
          ),
          findsOneWidget,
        );
        for (var zone = 1; zone <= 6; zone++) {
          expect(
            status(tester, zone),
            zone <= done
                ? 'CONCLUIDA'
                : zone == done + 1
                ? 'DISPONIVEL'
                : 'BLOQUEADA',
          );
          expect(
            find.byKey(Key('fortaleza-medal-ZONE_$zone')),
            zone <= done ? findsOneWidget : findsNothing,
          );
          if (zone <= done + 1) {
            await tester.tap(find.byKey(Key('fortaleza-zone-ZONE_$zone')));
            await tester.pumpAndSettle();
            expect(opened.last, routes[zone - 1]);
            Navigator.of(
              tester.element(find.text('destination ${routes[zone - 1]}')),
            ).pop();
            await tester.pumpAndSettle();
          }
        }
        expect(c.progress.toJson(), before);
        if (done < 6) {
          await complete(c, done + 1);
          await tester.pumpAndSettle();
        }
      }
      await capture(tester, 'six_zones_complete');
      expect(tester.takeException(), isNull);
    },
  );

  const variants = [
    (PlayerType.child, 'child_boy', 'child_male'),
    (PlayerType.child, 'child_girl', 'child_female'),
    (PlayerType.teen, 'teen_default', 'teen_male'),
    (PlayerType.teen, 'teen_girl', 'teen_female'),
    (PlayerType.adult, 'adult_default', 'adult_male'),
    (PlayerType.adult, 'adult_woman', 'adult_female'),
  ];
  for (final variant in variants) {
    testWidgets('chosen ${variant.$3} appears at INICIO and HUD', (
      tester,
    ) async {
      viewport(tester, const Size(844, 390));
      final c = await player();
      await c.createProfile(type: variant.$1, avatarId: variant.$2);
      final before = c.progress.toJson();
      await tester.pumpWidget(app(c));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('fortaleza-avatar-${variant.$3}')), findsOneWidget);
      expect(
        find.byKey(Key('fortaleza-portrait-${variant.$3}')),
        findsOneWidget,
      );
      await capture(tester, variant.$3);
      expect(c.profile!.avatarId, variant.$2);
      expect(c.progress.toJson(), before);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('footer and existing menu destinations preserve all progress', (
    tester,
  ) async {
    viewport(tester, const Size(844, 390));
    final c = await player();
    final before = c.progress.toJson();
    final opened = <String>[];
    await tester.pumpWidget(app(c, opened: opened));
    await tester.pumpAndSettle();
    for (final action in [
      ('fortaleza-missions-button', AppRoutes.zone1),
      ('fortaleza-build-neighborhood', AppRoutes.buildNeighborhood),
      ('fortaleza-medals-button', AppRoutes.playerProgress),
      ('fortaleza-global-summary', AppRoutes.globalProgress),
    ]) {
      await tester.tap(find.byKey(Key(action.$1)));
      await tester.pumpAndSettle();
      expect(opened.last, action.$2);
      Navigator.of(tester.element(find.text('destination ${action.$2}'))).pop();
      await tester.pumpAndSettle();
    }
    for (final action in [
      ('fortaleza-faixita', AppRoutes.faixita),
      ('fortaleza-sign-duel', AppRoutes.signDuel),
    ]) {
      await tester.tap(find.byKey(const Key('fortaleza-menu-button')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(Key(action.$1)));
      await tester.tap(find.byKey(Key(action.$1)));
      await tester.pumpAndSettle();
      expect(opened.last, action.$2);
      Navigator.of(tester.element(find.text('destination ${action.$2}'))).pop();
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    }
    expect(c.progress.toJson(), before);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'rotation preserves map state and keyboard can open available zone',
    (tester) async {
      viewport(tester, const Size(844, 390));
      final c = await player();
      final opened = <String>[];
      await tester.pumpWidget(app(c, opened: opened));
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(844, 390);
      await tester.pumpAndSettle();
      expect(status(tester, 1), 'DISPONIVEL');
      expect(find.byType(Scrollable), findsNothing);
      // First native action is menu, second is the available Zone 1.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(opened.last, AppRoutes.zone1);
      expect(tester.takeException(), isNull);
    },
  );

  test('unknown legacy avatar uses profile type and never resets data', () {
    expect(
      FortalezaMapAvatar.variantFor(
        const PlayerProfile(type: PlayerType.adult, avatarId: 'old_avatar'),
      ),
      'adult_male',
    );
    expect(FortalezaMapAvatar.variantFor(null), 'child_male');
  });
}
