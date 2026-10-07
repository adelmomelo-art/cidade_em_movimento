import 'package:cidade_em_movimento/models/mission.dart';
import 'package:cidade_em_movimento/services/scoring_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mission = Mission(
    id: 'TEST',
    title: 'Teste',
    description: 'Teste',
    sceneText: 'Teste',
    question: 'Teste',
    options: [],
    maxCitizenship: 20,
    maxKnowledge: 10,
    maxCoins: 15,
  );

  const service = ScoringService();

  test('sem erro gera 3 estrelas', () {
    final result = service.calculate(mission: mission, errors: 0);

    expect(result.score, 100);
    expect(result.stars, 3);
  });

  test('um erro gera 2 estrelas', () {
    final result = service.calculate(mission: mission, errors: 1);

    expect(result.score, 80);
    expect(result.stars, 2);
  });

  test('dois erros geram 1 estrela', () {
    final result = service.calculate(mission: mission, errors: 2);

    expect(result.score, 60);
    expect(result.stars, 1);
  });
}
