import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Local, silent preview. The approved scene remains underneath on failure.
class MissionSceneVideo extends StatefulWidget {
  const MissionSceneVideo({super.key, required this.active});

  final bool active;
  static const asset = 'assets/zone_1/r35/travessia_segura.mp4';

  @override
  State<MissionSceneVideo> createState() => _MissionSceneVideoState();
}

class _MissionSceneVideoState extends State<MissionSceneVideo>
    with WidgetsBindingObserver {
  late final VideoPlayerController _video;
  bool _ready = false;
  bool _failed = false;
  bool _foreground = true;
  bool _ticker = true;
  bool _reducedMotion = false;
  bool _autoplayAttempted = false;

  bool get _allowed => widget.active && _foreground && _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _video = VideoPlayerController.asset(MissionSceneVideo.asset);
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      await _video.initialize();
      if (!mounted) return;
      await _video.setVolume(0);
      await _video.setLooping(false);
      if (!mounted) return;
      setState(() => _ready = true);
      _video.addListener(_changed);
      _autoplay();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  Future<void> _play({bool replay = false}) async {
    if (!_ready || !_allowed || _failed) return;
    try {
      if (replay || _video.value.position >= _video.value.duration) {
        await _video.seekTo(Duration.zero);
      }
      if (!mounted || !_allowed) return;
      await _video.play();
    } catch (_) {
      // Browsers may reject autoplay; the manual play control stays available.
    }
  }

  Future<void> _pause() async {
    if (!_ready) return;
    try {
      await _video.pause();
    } catch (_) {
      // Closing the route may dispose the native surface concurrently.
    }
  }

  void _autoplay() {
    if (_ready && _allowed && !_reducedMotion && !_autoplayAttempted) {
      _autoplayAttempted = true;
      unawaited(_play());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ticker = TickerMode.valuesOf(context).enabled;
    _reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (!_allowed || _reducedMotion) {
      unawaited(_pause());
    } else {
      _autoplay();
    }
  }

  @override
  void didUpdateWidget(covariant MissionSceneVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_allowed) unawaited(_pause());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (!_foreground) unawaited(_pause());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _video.removeListener(_changed);
    unawaited(_video.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed || _video.value.hasError) {
      return const SizedBox.expand(key: Key('mission-video-fallback'));
    }
    if (!_ready) {
      return const SizedBox.expand(key: Key('mission-video-loading'));
    }
    return ColoredBox(
      key: const Key('mission-scene-video'),
      color: const Color(0xFF10233E),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: _video.value.aspectRatio,
                child: VideoPlayer(_video),
              ),
            ),
          ),
          SizedBox(
            height: 82,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  key: const Key('mission-video-play-pause'),
                  tooltip: _video.value.isPlaying
                      ? 'Pausar vídeo'
                      : 'Reproduzir vídeo',
                  iconSize: 44,
                  color: Colors.white,
                  onPressed: !_allowed
                      ? null
                      : () {
                          if (_video.value.isPlaying) {
                            unawaited(_pause());
                          } else {
                            unawaited(_play());
                          }
                        },
                  icon: Icon(
                    _video.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  key: const Key('mission-video-replay'),
                  tooltip: 'Repetir vídeo',
                  iconSize: 44,
                  color: Colors.white,
                  onPressed: _allowed
                      ? () => unawaited(_play(replay: true))
                      : null,
                  icon: const Icon(Icons.replay),
                ),
                const SizedBox(width: 24),
                const Icon(Icons.volume_off, color: Colors.white70, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
