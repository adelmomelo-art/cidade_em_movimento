import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:cidade_em_movimento/widgets/mission_scene_video.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'fast22a_r14_mission_overlay_test.dart' as flow;
import 'fast22a_r15_navigation_question_test.dart' as fixture;

class PreviewPlatform extends VideoPlayerPlatform {
  final streams = <int, StreamController<VideoEvent>>{};
  final calls = <String>[];
  final disposedPlayers = <int>{};
  bool fail = false;
  int next = 0;
  Duration position = Duration.zero;

  @override
  Future<void> init() async {}

  @override
  Future<int?> createWithOptions(VideoCreationOptions options) async {
    expect(options.dataSource.asset, MissionSceneVideo.asset);
    final id = next++;
    final stream = streams[id] = StreamController<VideoEvent>();
    if (fail) {
      stream.addError(
        PlatformException(
          code: 'VideoError',
          message: 'Simulated decode failure',
        ),
      );
    } else {
      stream.add(
        VideoEvent(
          eventType: VideoEventType.initialized,
          size: const Size(1280, 720),
          duration: const Duration(seconds: 10),
        ),
      );
    }
    return id;
  }

  @override
  Stream<VideoEvent> videoEventsFor(int playerId) => streams[playerId]!.stream;
  @override
  Future<void> dispose(int playerId) async {
    calls.add('dispose');
    await streams[playerId]!.close();
    disposedPlayers.add(playerId);
  }

  @override
  Future<void> play(int playerId) async => calls.add('play');
  @override
  Future<void> pause(int playerId) async => calls.add('pause');
  @override
  Future<void> setVolume(int playerId, double volume) async =>
      calls.add('volume:$volume');
  @override
  Future<void> setLooping(int playerId, bool looping) async =>
      calls.add('loop:$looping');
  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) async {}
  @override
  Future<Duration> getPosition(int playerId) async => position;
  @override
  Future<void> seekTo(int playerId, Duration position) async {
    this.position = position;
    calls.add('seek:${position.inMilliseconds}');
  }

  @override
  Widget buildViewWithOptions(VideoViewOptions options) =>
      const ColoredBox(color: Colors.blue);
}

Future<void> unmountAndWaitForDisposal(
  WidgetTester tester,
  PreviewPlatform platform,
) async {
  await tester.pumpWidget(const SizedBox.shrink());
  // Cancellation can await a completed future owned by the real async zone.
  // Drain that zone and fake-frame microtasks before restoring the platform.
  for (
    var frame = 0;
    frame < 50 && platform.disposedPlayers.length < platform.next;
    frame++
  ) {
    await tester.runAsync(() async {
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pump();
  }
  expect(
    platform.disposedPlayers.length,
    platform.next,
    reason:
        'Every created video player must complete disposal before teardown. '
        'Calls: ${platform.calls}; '
        'closed: ${platform.streams.map((id, stream) => MapEntry(id, stream.isClosed))}; '
        'listeners: ${platform.streams.map((id, stream) => MapEntry(id, stream.hasListener))}',
  );
}

void main() {
  late PreviewPlatform platform;
  late VideoPlayerPlatform previous;
  setUp(() {
    previous = VideoPlayerPlatform.instance;
    platform = PreviewPlatform();
    VideoPlayerPlatform.instance = platform;
  });
  tearDown(() => VideoPlayerPlatform.instance = previous);

  testWidgets('only child boy sees the preview; exit gives no reward', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final player = await fixture.controller(false);
    addTearDown(player.dispose);
    for (final sample in [
      (PlayerType.child, 'child_boy', true),
      (PlayerType.child, 'child_girl', false),
      (PlayerType.teen, 'teen_boy', false),
      (PlayerType.adult, 'adult_man', false),
    ]) {
      await player.createProfile(type: sample.$1, avatarId: sample.$2);
      final before = player.progress.toJson();
      await tester.pumpWidget(
        MaterialApp(home: Zone1MapScreen(controller: player)),
      );
      await tester.pumpAndSettle();
      await flow.tap(
        tester,
        find.byKey(const Key('zone1-visual-mission-Z1_M01')),
      );
      expect(
        find.byType(MissionSceneVideo),
        sample.$3 ? findsOneWidget : findsNothing,
      );
      await flow.tap(tester, find.text('INICIAR'));
      if (sample.$3) {
        expect(
          find.byKey(const Key('mission-video-play-pause')),
          findsOneWidget,
        );
      }
      await flow.tap(tester, find.byKey(const Key('zone1-close-mission')));
      expect(player.progress.toJson(), before);
      expect(tester.takeException(), isNull);
    }
    await unmountAndWaitForDisposal(tester, platform);
  });

  Widget host({bool active = true, bool reduced = true, bool ticker = true}) =>
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: reduced),
          child: TickerMode(
            enabled: ticker,
            child: Scaffold(
              body: SizedBox(
                width: 753,
                height: 651,
                child: MissionSceneVideo(active: active),
              ),
            ),
          ),
        ),
      );

  testWidgets('answering pauses the video and preserves mission rewards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final player = await fixture.controller(false);
    addTearDown(player.dispose);
    await player.createProfile(type: PlayerType.child, avatarId: 'child_boy');
    final coins = player.progress.coins;
    await tester.pumpWidget(
      MaterialApp(home: Zone1MapScreen(controller: player)),
    );
    await tester.pumpAndSettle();
    await flow.tap(
      tester,
      find.byKey(const Key('zone1-visual-mission-Z1_M01')),
    );
    final mission = tester
        .widget<Zone1MissionDialog>(find.byType(Zone1MissionDialog))
        .mission;
    await flow.tap(tester, find.text('INICIAR'));
    await tester.tap(find.byKey(const Key('mission-video-play-pause')));
    await tester.pump();
    final answer = mission.options.firstWhere((option) => option.isCorrect);
    await flow.tap(tester, find.byKey(Key('zone1-answer-${answer.id}')));
    await flow.tap(tester, find.byKey(const Key('zone1-confirm-answer')));
    expect(platform.calls.last, 'pause');
    await flow.tap(tester, find.text('CONTINUAR'));
    await flow.tap(tester, find.text('VER RESULTADO'));
    expect(player.progress.completedMissions, contains(mission.id));
    expect(player.progress.missionStars[mission.id], 3);
    expect(player.progress.coins, coins + mission.maxCoins);
    await unmountAndWaitForDisposal(tester, platform);
    expect(tester.takeException(), isNull);
  });

  testWidgets('silent manual controls, replay and disposal', (tester) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    expect(
      platform.calls.lastWhere((c) => c.startsWith('volume:')),
      'volume:0.0',
    );
    expect(platform.calls, contains('loop:false'));
    expect(platform.calls, isNot(contains('play')));
    await tester.tap(find.byKey(const Key('mission-video-play-pause')));
    await tester.pump();
    expect(platform.calls, contains('play'));
    await tester.tap(find.byKey(const Key('mission-video-play-pause')));
    await tester.pump();
    expect(platform.calls.last, 'pause');
    platform.position = const Duration(seconds: 5);
    await tester.tap(find.byKey(const Key('mission-video-replay')));
    await tester.pump();
    expect(platform.calls, contains('seek:0'));
    expect(platform.calls.last, 'play');
    await unmountAndWaitForDisposal(tester, platform);
    expect(platform.calls, contains('dispose'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('autoplay pauses on stage change and hidden route', (
    tester,
  ) async {
    await tester.pumpWidget(host(reduced: false));
    await tester.pump();
    await tester.pump();
    expect(platform.calls, contains('play'));
    await tester.pumpWidget(host(active: false, reduced: false));
    await tester.pump();
    expect(platform.calls.last, 'pause');
    expect(
      tester
          .widget<IconButton>(find.byKey(const Key('mission-video-replay')))
          .onPressed,
      isNull,
    );
    await tester.pumpWidget(host(reduced: false, ticker: false));
    await tester.pump();
    expect(platform.calls.last, 'pause');
    await unmountAndWaitForDisposal(tester, platform);
  });

  testWidgets('decode failure keeps the approved scene visible', (
    tester,
  ) async {
    platform.fail = true;
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('mission-video-fallback')), findsOneWidget);
    expect(find.byKey(const Key('mission-scene-video')), findsNothing);
    await unmountAndWaitForDisposal(tester, platform);
    expect(tester.takeException(), isNull);
  });
}
