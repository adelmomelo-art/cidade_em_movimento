import 'mission_option.dart';

class Mission {
  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.sceneText,
    required this.question,
    required this.options,
    required this.maxCitizenship,
    required this.maxKnowledge,
    required this.maxCoins,
  });

  final String id;
  final String title;
  final String description;
  final String sceneText;
  final String question;
  final List<MissionOption> options;

  final int maxCitizenship;
  final int maxKnowledge;
  final int maxCoins;
}
