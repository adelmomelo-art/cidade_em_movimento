import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FAST-21 possui sistema visual oficial sem alterar motor', () {
    final visual = File('lib/ui/visual_system.dart').readAsStringSync();
    final theme = File('lib/app/theme.dart').readAsStringSync();
    final home = File('lib/screens/home/home_screen.dart').readAsStringSync();
    final profile = File(
      'lib/screens/profile/profile_screen.dart',
    ).readAsStringSync();
    final map = File(
      'lib/screens/fortaleza_map/fortaleza_map_screen.dart',
    ).readAsStringSync();

    expect(visual, contains('class GameColors'));
    expect(visual, contains('class GameHeroPanel'));
    expect(visual, contains('class GameSectionCard'));
    expect(theme, contains('GameColors.blue'));
    expect(home, contains("Key('home-brand-mark')"));
    expect(home, contains('Aprenda. Decida. Transforme a cidade.'));
    expect(profile, contains("Key('profile-visual-list')"));
    expect(map, contains('ApprovedArtworkPage'));
    expect(map, contains('ZONE_6'));
    expect(map, isNot(contains('ZONE_7')));
  });
}
