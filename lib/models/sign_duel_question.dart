class SignDuelQuestion {
  const SignDuelQuestion({
    required this.id,
    required this.code,
    required this.title,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.level,
  });

  final String id;
  final String code;
  final String title;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int level;
}
