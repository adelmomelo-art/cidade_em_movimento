import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/data/zone_5/mission_01_data.dart';
import 'package:cidade_em_movimento/data/zone_5/mission_02_data.dart';
import 'package:cidade_em_movimento/data/zone_5/mission_03_data.dart';
import 'package:cidade_em_movimento/data/zone_5/mission_04_data.dart';
import 'package:cidade_em_movimento/data/zone_5/mission_05_data.dart';
import 'package:cidade_em_movimento/data/zone_5/special_mission_data.dart';

void main() {
  final builders = [
    buildZone5Mission01,
    buildZone5Mission02,
    buildZone5Mission03,
    buildZone5Mission04,
    buildZone5Mission05,
    buildZone5SpecialMission,
  ];
  for (final type in PlayerType.values) {
    for (var i = 0; i < builders.length; i++) {
      test('zone 5 mission ${i + 1} complete content for $type', () {
        final mission = builders[i](type);
        expect(mission.options, hasLength(3));
        expect(mission.options.where((o) => o.isCorrect), hasLength(1));
        expect(mission.options.map((o) => o.text).toSet(), hasLength(3));
        expect(mission.question.endsWith('?'), isTrue);
        final texts = [
          mission.description,
          mission.sceneText,
          mission.question,
          for (final option in mission.options) ...[
            option.text,
            option.consequenceText,
            option.meloFeedback,
          ],
        ];
        for (final text in texts) {
          expect(text.trim(), isNotEmpty);
          expect(RegExp(r'(CHILD|TEEN|ADULT)_[A-Z]').hasMatch(text), isFalse);
        }
      });
    }
  }
}
