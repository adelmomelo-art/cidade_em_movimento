class MissionOption {
  const MissionOption({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.consequenceText,
    required this.meloFeedback,
  });

  final String id;
  final String text;
  final bool isCorrect;
  final String consequenceText;
  final String meloFeedback;
}
