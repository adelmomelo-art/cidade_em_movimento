import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/models/faixita_response.dart';
import 'package:cidade_em_movimento/models/game_progress.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/models/player_profile.dart';
import 'package:cidade_em_movimento/services/faixita_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const profile = PlayerProfile(
    type: PlayerType.adult,
    avatarId: 'adult_default',
  );

  test('Faixita funciona localmente sem backend', () async {
    final service = FaixitaService(baseUrl: '');

    final response = await service.ask(
      question: 'O que devo estudar agora?',
      profile: profile,
      progress: GameProgress.initial(),
    );

    expect(response.source, FaixitaResponseSource.local);
    expect(response.text, isNotEmpty);
    expect(response.text, contains('primeira zona'));
  });

  test('Faixita contextualiza resultado de missao', () async {
    final service = FaixitaService(baseUrl: '');

    final response = await service.ask(
      question: 'Como melhorar meu resultado nesta missao?',
      profile: profile,
      progress: GameProgress.initial(),
      missionResult: const MissionResult(
        missionId: 'Z1_M01',
        stars: 1,
        score: 55,
        citizenship: 10,
        knowledge: 5,
        coins: 10,
        errors: 2,
      ),
    );

    expect(response.source, FaixitaResponseSource.local);
    expect(response.text, contains('concluiu a missao'));
  });

  test('Faixita usa resposta remota quando endpoint responde', () async {
    final client = MockClient((request) async {
      return http.Response(
        '{"ok":true,"answer":"Resposta remota segura."}',
        200,
      );
    });

    final service = FaixitaService(
      baseUrl: 'https://faixita.example',
      client: client,
    );

    final response = await service.ask(
      question: 'Explique minhas estrelas.',
      profile: profile,
      progress: GameProgress.initial(),
    );

    expect(response.source, FaixitaResponseSource.remote);
    expect(response.text, 'Resposta remota segura.');
  });

  test('Faixita cai para local quando backend falha', () async {
    final client = MockClient((request) async {
      return http.Response('{"ok":false}', 503);
    });

    final service = FaixitaService(
      baseUrl: 'https://faixita.example',
      client: client,
    );

    final response = await service.ask(
      question: 'Como estou no Duelo das Placas?',
      profile: profile,
      progress: GameProgress.initial(),
    );

    expect(response.source, FaixitaResponseSource.local);
    expect(response.text, contains('Duelo das Placas'));
  });
}
