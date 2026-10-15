import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FAST-22A R29 integra arte aprovada com o mesmo motor', () {
    final screen = File(
      'lib/screens/zone_1_map/zone_1_map_screen.dart',
    ).readAsStringSync();
    final scene = File(
      'lib/widgets/zone_1_visual_scene.dart',
    ).readAsStringSync();
    final art = File('lib/widgets/zone_1_art.dart').readAsStringSync();
    final evolving = File(
      'lib/widgets/zone_1_evolving_scene.dart',
    ).readAsStringSync();
    final dialog = File(
      'lib/widgets/zone_1_mission_dialog.dart',
    ).readAsStringSync();

    expect(screen, contains('Zone1ArtworkBoard'));
    expect(screen, contains('Zone1MissionDialog'));
    expect(dialog, contains('MissionController(mission: widget.mission)'));
    expect(dialog, contains('widget.player.completeMission('));
    expect(screen, contains("('Z1_M01'"));
    expect(screen, contains("('Z1_SPECIAL'"));
    expect(screen, contains("Key('zone1-score-hud')"));

    expect(scene, contains('MeloMascot'));
    expect(scene, contains('Zone1NeighborhoodArt'));
    expect(scene, contains("Key('zone1-visual-mission-\${mission.id}')"));
    expect(scene, contains(r'\u2605'));

    expect(art, contains('class Zone1NeighborhoodArt'));
    expect(art, contains('class MeloMascot'));
    expect(art, contains('_drawSchool'));
    expect(art, contains('_drawBus'));
    expect(art, contains('_drawPlaza'));

    expect(evolving, contains('ANTES'));
    expect(evolving, contains('AGORA'));
    expect(evolving, contains('Zone1NeighborhoodArt'));
  });
}
