import 'dart:io';
import 'dart:ui' as ui;

import 'package:cidade_em_movimento/app/routes.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/screens/avatar/avatar_screen.dart';
import 'package:cidade_em_movimento/screens/profile/profile_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> loadPlayer() async {
  SharedPreferences.setMockInitialValues({});
  final c = PlayerController(
    StorageService(await SharedPreferences.getInstance()),
  );
  await c.initialize();
  return c;
}

Future<void> capture(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('profile-viewport-capture')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory('build/fast22a_r25_evidencias');
      await dir.create(recursive: true);
      await File('${dir.path}/$name.png').writeAsBytes(
        data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } finally {
      image.dispose();
    }
  });
}

// Centres measured on the approved image, not on the implementation widgets.
const cards = [
  (PlayerType.child, 'CRIANÇA', 353.0),
  (PlayerType.teen, 'ADOLESCENTE', 836.0),
  (PlayerType.adult, 'ADULTO', 1317.0),
];

void main() {
  for (final size in [
    const Size(600, 390),
    const Size(800, 360),
    const Size(844, 390),
    const Size(1280, 800),
    const Size(1366, 768),
  ]) {
    testWidgets(
      'three profile cards stay visible and send correct type at $size',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final c = await loadPlayer();
        addTearDown(c.dispose);
        final before = c.progress.toJson();
        final opened = <RouteSettings>[];
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding: const EdgeInsets.fromLTRB(24, 0, 16, 12),
                viewPadding: const EdgeInsets.fromLTRB(24, 0, 16, 12),
                textScaler: const TextScaler.linear(1.4),
              ),
              child: child!,
            ),
            home: const RepaintBoundary(
              key: Key('profile-viewport-capture'),
              child: ProfileScreen(),
            ),
            onGenerateRoute: (settings) {
              opened.add(settings);
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (_) =>
                    const Scaffold(body: Text('avatar destination')),
              );
            },
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Scrollable), findsNothing);
        final art = tester.getRect(find.byKey(const Key('profile-artwork')));
        final safe = Rect.fromLTRB(24, 0, size.width - 16, size.height - 12);
        expect(art.width / art.height, closeTo(1672 / 940, .001));
        expect(safe.inflate(.01).contains(art.topLeft), isTrue);
        expect(safe.inflate(.01).contains(art.bottomRight), isTrue);
        expect(
          tester.getRect(find.byKey(const Key('profile-ambient-background'))),
          Offset.zero & size,
        );
        final scale = art.width / 1672;
        final rects = <Rect>[];
        for (final card in cards) {
          final target = find.byKey(Key('profile-card-${card.$1.name}'));
          expect(target.hitTestable(), findsOneWidget);
          expect(find.bySemanticsLabel(card.$2), findsOneWidget);
          final rect = tester.getRect(target);
          expect(safe.inflate(.01).contains(rect.topLeft), isTrue);
          expect(safe.inflate(.01).contains(rect.bottomRight), isTrue);
          for (final previous in rects) {
            expect(rect.overlaps(previous), isFalse);
          }
          rects.add(rect);
        }
        final back = tester.getRect(
          find.byKey(const Key('profile-back-button')),
        );
        expect(safe.inflate(.01).contains(back.topLeft), isTrue);
        expect(safe.inflate(.01).contains(back.bottomRight), isTrue);
        await tester.tapAt(art.topLeft + const Offset(836, 100) * scale);
        await tester.pumpAndSettle();
        expect(opened, isEmpty);
        await capture(tester, '${size.width.toInt()}x${size.height.toInt()}');
        for (final card in cards) {
          // Both portrait and description of the card must be selectable.
          for (final y in [450.0, 835.0]) {
            await tester.tapAt(art.topLeft + Offset(card.$3, y) * scale);
            await tester.pumpAndSettle();
            expect(opened.last.name, AppRoutes.avatar);
            expect(opened.last.arguments, card.$1);
            Navigator.of(tester.element(find.text('avatar destination'))).pop();
            await tester.pumpAndSettle();
            expect(c.profile, isNull);
            expect(c.progress.toJson(), before);
          }
        }
        expect(tester.takeException(), isNull);
      },
      semanticsEnabled: true,
    );
  }

  testWidgets('profile rendering equals approved mockup pixel for pixel', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1672, 940);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const ProfileScreen()),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('profile-artwork')),
      matchesGoldenFile('../assets/profile/escolha_perfil_r25.png'),
    );
    expect(tester.takeException(), isNull);
  });

  for (final card in cards) {
    testWidgets('existing avatar screen receives ${card.$1}', (tester) async {
      final c = await loadPlayer();
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const ProfileScreen(),
          onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(settings, c),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('profile-card-${card.$1.name}')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<AvatarScreen>(find.byType(AvatarScreen)).type,
        card.$1,
      );
      expect(find.byKey(const Key('avatar-male-card')), findsOneWidget);
      expect(find.byKey(const Key('avatar-female-card')), findsOneWidget);
      expect(c.profile, isNull);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('back returns to previous screen; root fallback returns home', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.profile),
              child: const Text('home marker'),
            ),
          ),
        ),
        routes: {AppRoutes.profile: (_) => const ProfileScreen()},
      ),
    );
    await tester.tap(find.text('home marker'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-back-button')));
    await tester.pumpAndSettle();
    expect(find.text('home marker'), findsOneWidget);
    expect(find.byType(ProfileScreen), findsNothing);
    await tester.pumpWidget(
      MaterialApp(
        key: UniqueKey(),
        theme: AppTheme.light,
        initialRoute: AppRoutes.profile,
        routes: {
          AppRoutes.home: (_) => const Scaffold(body: Text('home fallback')),
          AppRoutes.profile: (_) => const ProfileScreen(),
        },
        onGenerateInitialRoutes: (route) => [
          MaterialPageRoute<void>(
            settings: const RouteSettings(name: AppRoutes.profile),
            builder: (_) => const ProfileScreen(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-back-button')));
    await tester.pumpAndSettle();
    expect(find.text('home fallback'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard chooses child after back button', (tester) async {
    RouteSettings? opened;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const ProfileScreen(),
        onGenerateRoute: (settings) {
          opened = settings;
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('avatar destination')),
          );
        },
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(opened?.name, AppRoutes.avatar);
    expect(opened?.arguments, PlayerType.child);
    expect(tester.takeException(), isNull);
  });
}
