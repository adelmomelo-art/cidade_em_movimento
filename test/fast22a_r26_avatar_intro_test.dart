import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cidade_em_movimento/app/routes.dart';
import 'package:cidade_em_movimento/app/theme.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/models/game_progress.dart';
import 'package:cidade_em_movimento/models/player_profile.dart';
import 'package:cidade_em_movimento/screens/avatar/avatar_screen.dart';
import 'package:cidade_em_movimento/screens/fortaleza_map/fortaleza_map_screen.dart';
import 'package:cidade_em_movimento/screens/home/home_screen.dart';
import 'package:cidade_em_movimento/screens/intro/intro_screen.dart';
import 'package:cidade_em_movimento/screens/profile/profile_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const profiles = [
  (PlayerType.child, 'child_boy', 'child_girl', 'crianca', 941.0),
  (PlayerType.teen, 'teen_default', 'teen_girl', 'adolescente', 941.0),
  (PlayerType.adult, 'adult_default', 'adult_woman', 'adulto', 940.0),
];

Future<StorageService> storageWithProgress() async {
  SharedPreferences.setMockInitialValues({});
  final storage = StorageService(await SharedPreferences.getInstance());
  final json = GameProgress.initial().toJson()
    ..['coins'] = 77
    ..['knowledge'] = 12
    ..['citizenshipXp'] = 23
    ..['completedMissions'] = ['Z1_M01']
    ..['missionStars'] = {'Z1_M01': 3}
    ..['unlockedMissions'] = ['Z1_M01', 'Z1_M02'];
  await storage.saveProgress(GameProgress.fromJson(json));
  return storage;
}

void setViewport(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget app(Widget home, PlayerController c, {bool safe = false}) => MaterialApp(
  key: UniqueKey(),
  theme: AppTheme.light,
  home: home,
  onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(settings, c),
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

Future<void> capture(WidgetTester tester, String prefix, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(Key('$prefix-artwork')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final directory = Directory('build/fast22a_r26_evidencias');
      await directory.create(recursive: true);
      await File('${directory.path}/$name.png').writeAsBytes(
        bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      );
    } finally {
      image.dispose();
    }
  });
}

class DelayedPlayer extends PlayerController {
  DelayedPlayer(super.storage);

  Completer<void> saving = Completer<void>();
  int calls = 0;

  @override
  Future<void> createProfile({
    required PlayerType type,
    required String avatarId,
  }) async {
    calls++;
    await saving.future;
    await super.createProfile(type: type, avatarId: avatarId);
  }
}

void main() {
  for (final profile in profiles) {
    for (final size in [
      const Size(600, 390),
      const Size(800, 360),
      const Size(844, 390),
      const Size(1280, 800),
      const Size(1366, 768),
    ]) {
      testWidgets(
        'approved ${profile.$1.name} fits, saves both choices and opens Melo at $size',
        (tester) async {
          setViewport(tester, size);
          final storage = await storageWithProgress();
          final c = PlayerController(storage);
          await c.initialize();
          addTearDown(c.dispose);
          final before = c.progress.toJson();
          for (final female in [false, true]) {
            await tester.pumpWidget(
              app(AvatarScreen(controller: c, type: profile.$1), c, safe: true),
            );
            await tester.pumpAndSettle();
            expect(find.byType(Scrollable), findsNothing);
            final art = tester.getRect(find.byKey(const Key('avatar-artwork')));
            final safeRect = Rect.fromLTRB(
              24,
              0,
              size.width - 16,
              size.height - 12,
            );
            expect(art.width / art.height, closeTo(1672 / profile.$5, .001));
            expect(safeRect.inflate(.01).contains(art.topLeft), isTrue);
            expect(safeRect.inflate(.01).contains(art.bottomRight), isTrue);
            expect(
              tester.getRect(
                find.byKey(const Key('avatar-ambient-background')),
              ),
              Offset.zero & size,
            );
            for (final key in [
              'avatar-back-button',
              'avatar-male-card',
              'avatar-female-card',
            ]) {
              final button = find.byKey(Key(key));
              expect(button.hitTestable(), findsOneWidget);
              final bounds = tester.getRect(button);
              expect(safeRect.inflate(.01).contains(bounds.topLeft), isTrue);
              expect(
                safeRect.inflate(.01).contains(bounds.bottomRight),
                isTrue,
              );
            }
            expect(find.bySemanticsLabel('MASCULINO'), findsOneWidget);
            expect(find.bySemanticsLabel('FEMININO'), findsOneWidget);
            // Coordinates on the reference: portrait and glossy card footer.
            final point = Offset(female ? 1100 : 555, female ? 810 : 470);
            await capture(
              tester,
              'avatar',
              '${profile.$4}_${size.width.toInt()}x${size.height.toInt()}',
            );
            await tester.tapAt(art.topLeft + point * (art.width / 1672));
            await tester.pumpAndSettle();
            expect(find.byType(IntroScreen), findsOneWidget);
            expect(c.profile!.type, profile.$1);
            expect(c.profile!.avatarId, female ? profile.$3 : profile.$2);
            expect(storage.loadProfile()!.avatarId, c.profile!.avatarId);
            expect(storage.loadProgress().toJson(), before);
            expect(c.progress.toJson(), before);
            expect(find.byType(Scrollable), findsNothing);
            final intro = tester.getRect(
              find.byKey(const Key('intro-artwork')),
            );
            expect(safeRect.inflate(.01).contains(intro.topLeft), isTrue);
            expect(safeRect.inflate(.01).contains(intro.bottomRight), isTrue);
            expect(
              find.byKey(const Key('intro-start-button')).hitTestable(),
              findsOneWidget,
            );
            expect(tester.takeException(), isNull);
          }
        },
        semanticsEnabled: true,
      );
    }

    testWidgets('native ${profile.$1.name} equals approved artwork', (
      tester,
    ) async {
      setViewport(tester, Size(1672, profile.$5));
      final c = PlayerController(await storageWithProgress());
      await c.initialize();
      addTearDown(c.dispose);
      await tester.pumpWidget(
        app(AvatarScreen(controller: c, type: profile.$1), c),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(const Key('avatar-artwork')),
        matchesGoldenFile('../assets/avatar/escolha_${profile.$4}_r26.png'),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('native Melo equals approved artwork', (tester) async {
    setViewport(tester, const Size(1672, 941));
    final c = PlayerController(await storageWithProgress());
    await c.initialize();
    addTearDown(c.dispose);
    await tester.pumpWidget(app(IntroScreen(controller: c), c));
    await tester.pumpAndSettle();
    await capture(tester, 'intro', 'melo_native');
    await expectLater(
      find.byKey(const Key('intro-artwork')),
      matchesGoldenFile('../assets/intro/apresentacao_melo_r26.png'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'home, profile, gender, Melo and actual map; progress survives restart',
    (tester) async {
      setViewport(tester, const Size(844, 390));
      final storage = await storageWithProgress();
      final c = PlayerController(storage);
      await c.initialize();
      addTearDown(c.dispose);
      final before = c.progress.toJson();
      await tester.pumpWidget(app(HomeScreen(controller: c), c));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-play-button')));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
      await tester.tap(find.byKey(const Key('profile-card-adult')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('avatar-female-card')));
      await tester.pumpAndSettle();
      expect(find.byType(IntroScreen), findsOneWidget);
      await tester.tap(find.byKey(const Key('intro-start-button')));
      await tester.pumpAndSettle();
      expect(find.byType(FortalezaMapScreen), findsOneWidget);
      expect(find.byType(ProfileScreen), findsNothing);
      expect(find.byType(AvatarScreen), findsNothing);
      expect(c.progress.toJson(), before);
      final restarted = PlayerController(storage);
      await restarted.initialize();
      addTearDown(restarted.dispose);
      expect(restarted.profile!.avatarId, 'adult_woman');
      expect(restarted.progress.toJson(), before);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('back and rotation before choosing do not create profile', (
    tester,
  ) async {
    setViewport(tester, const Size(844, 390));
    final c = PlayerController(await storageWithProgress());
    await c.initialize();
    addTearDown(c.dispose);
    final before = c.progress.toJson();
    await tester.pumpWidget(app(const ProfileScreen(), c));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-card-teen')));
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(844, 390);
    await tester.pumpAndSettle();
    expect(
      tester.widget<AvatarScreen>(find.byType(AvatarScreen)).type,
      PlayerType.teen,
    );
    await tester.tap(find.byKey(const Key('avatar-back-button')));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(c.profile, isNull);
    expect(c.progress.toJson(), before);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saving blocks double tap and back; failure permits retry', (
    tester,
  ) async {
    setViewport(tester, const Size(844, 390));
    final c = DelayedPlayer(await storageWithProgress());
    await c.initialize();
    addTearDown(c.dispose);
    final before = c.progress.toJson();
    await tester.pumpWidget(app(const ProfileScreen(), c));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-card-child')));
    await tester.pumpAndSettle();
    final point = tester.getCenter(find.byKey(const Key('avatar-male-card')));
    await tester.tapAt(point);
    await tester.pump();
    await tester.tapAt(point);
    await tester.pump();
    expect(c.calls, 1);
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(AvatarScreen), findsOneWidget);
    c.saving.completeError(StateError('offline write failed'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Não foi possível salvar'), findsOneWidget);
    expect(c.profile, isNull);
    c.saving = Completer<void>();
    await tester.tap(find.byKey(const Key('avatar-male-card')));
    await tester.pump();
    c.saving.complete();
    await tester.pumpAndSettle();
    expect(c.calls, 2);
    expect(find.byType(IntroScreen), findsOneWidget);
    expect(c.profile!.avatarId, 'child_boy');
    expect(c.progress.toJson(), before);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard selects male and starts the map', (tester) async {
    final c = PlayerController(await storageWithProgress());
    await c.initialize();
    addTearDown(c.dispose);
    await tester.pumpWidget(
      app(AvatarScreen(controller: c, type: PlayerType.teen), c),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(c.profile!.avatarId, 'teen_default');
    expect(find.byType(IntroScreen), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(FortalezaMapScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('legacy profile IDs load without migration or progress reset', () async {
    for (final profile in profiles) {
      final storage = await storageWithProgress();
      await storage.saveProfile(
        PlayerProfile(type: profile.$1, avatarId: profile.$2),
      );
      final c = PlayerController(storage);
      await c.initialize();
      expect(c.profile!.avatarId, profile.$2);
      expect(c.progress.coins, 77);
      c.dispose();
    }
  });
}
