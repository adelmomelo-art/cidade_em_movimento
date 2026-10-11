import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/enums/player_type.dart';
import '../models/faixita_response.dart';
import '../models/game_progress.dart';
import '../models/mission_result.dart';
import '../models/player_profile.dart';

class FaixitaService {
  FaixitaService({required String baseUrl, http.Client? client})
    : _baseUrl = baseUrl.trim().replaceAll(RegExp(r'/$'), ''),
      _client = client ?? http.Client();

  final String _baseUrl;
  final http.Client? _client;

  bool get remoteConfigured => _baseUrl.isNotEmpty;

  Future<FaixitaResponse> ask({
    required String question,
    required PlayerProfile profile,
    required GameProgress progress,
    MissionResult? missionResult,
  }) async {
    final normalized = question.trim();

    if (normalized.isEmpty) {
      return const FaixitaResponse(
        text:
            'Posso ajudar com seguranca no transito, missoes, placas, '
            'cidadania e sua evolucao no jogo.',
        source: FaixitaResponseSource.local,
      );
    }

    if (remoteConfigured) {
      final remote = await _tryRemote(
        question: normalized,
        profile: profile,
        progress: progress,
        missionResult: missionResult,
      );

      if (remote != null) {
        return remote;
      }
    }

    return FaixitaResponse(
      text: _localAnswer(
        question: normalized,
        profile: profile,
        progress: progress,
        missionResult: missionResult,
      ),
      source: FaixitaResponseSource.local,
    );
  }

  Future<FaixitaResponse?> _tryRemote({
    required String question,
    required PlayerProfile profile,
    required GameProgress progress,
    MissionResult? missionResult,
  }) async {
    try {
      final client = _client ?? http.Client();
      final response = await client
          .post(
            Uri.parse('$_baseUrl/v1/faixita/chat'),
            headers: const <String, String>{'content-type': 'application/json'},
            body: jsonEncode(<String, dynamic>{
              'question': question,
              'profileType': profile.type.name,
              'progress': <String, dynamic>{
                'completedMissions': progress.completedMissions.length,
                'completedZones': progress.completedZones.length,
                'totalStars': progress.missionStars.values.fold<int>(
                  0,
                  (sum, stars) => sum + stars,
                ),
                'knowledge': progress.knowledge,
                'citizenshipXp': progress.citizenshipXp,
                'signDuelBestCorrect': progress.signDuelBestCorrect,
              },
              if (missionResult != null)
                'missionResult': <String, dynamic>{
                  'missionId': missionResult.missionId,
                  'stars': missionResult.stars,
                  'score': missionResult.score,
                  'errors': missionResult.errors,
                },
            }),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final answer = decoded['answer'] as String?;

      if (answer == null || answer.trim().isEmpty) {
        return null;
      }

      return FaixitaResponse(
        text: answer.trim(),
        source: FaixitaResponseSource.remote,
      );
    } catch (_) {
      return null;
    }
  }

  String _localAnswer({
    required String question,
    required PlayerProfile profile,
    required GameProgress progress,
    MissionResult? missionResult,
  }) {
    final q = question.toLowerCase();

    if (missionResult != null &&
        (q.contains('resultado') ||
            q.contains('missao') ||
            q.contains('missÃ£o') ||
            q.contains('melhorar'))) {
      return _missionResultAnswer(missionResult);
    }

    if (q.contains('estrela') ||
        q.contains('pontuacao') ||
        q.contains('pontuaÃ§Ã£o')) {
      return _starsAnswer(progress);
    }

    if (q.contains('placa') || q.contains('duelo')) {
      return _signAnswer(progress);
    }

    if (q.contains('bairro') || q.contains('melhoria') || q.contains('moeda')) {
      return _neighborhoodAnswer(progress);
    }

    if (q.contains('estudar') ||
        q.contains('proximo') ||
        q.contains('prÃ³ximo') ||
        q.contains('agora')) {
      return _studyAnswer(profile, progress);
    }

    if (q.contains('seguranca') ||
        q.contains('seguranÃ§a') ||
        q.contains('transito') ||
        q.contains('trÃ¢nsito')) {
      return _safetyAnswer(profile.type);
    }

    return _generalAnswer(profile, progress);
  }

  String _missionResultAnswer(MissionResult result) {
    if (result.stars >= 3) {
      return 'Excelente resultado: 3 estrelas. Voce demonstrou dominio da '
          'situacao. O melhor proximo passo e revisar a justificativa das '
          'decisoes para transformar acerto em conhecimento duradouro.';
    }

    if (result.stars == 2) {
      return 'Bom resultado. Com 2 estrelas, voce ja compreendeu a maior parte '
          'da situacao. Revise os pontos em que houve erro e tente identificar '
          'qual principio de seguranca ou convivencia estava envolvido.';
    }

    if (result.stars == 1) {
      return 'Voce concluiu a missao, e isso ja gera aprendizado. Antes de '
          'repetir, releia a situacao com calma e pense em tres perguntas: '
          'quem esta mais vulneravel, qual risco pode acontecer e qual decisao '
          'reduz esse risco.';
    }

    return 'Essa missao merece uma revisao com calma. Observe o ambiente, os '
        'usuarios mais vulneraveis e as regras apresentadas. A ideia nao e '
        'decorar respostas, mas aprender a decidir com seguranca.';
  }

  String _starsAnswer(GameProgress progress) {
    final totalStars = progress.missionStars.values.fold<int>(
      0,
      (sum, stars) => sum + stars,
    );

    return 'As estrelas representam a qualidade do desempenho nas missoes. '
        'Voce acumulou $totalStars estrelas ate agora. Mais importante que o '
        'numero e perceber em quais situacoes voce ainda pode melhorar a '
        'leitura de risco, convivencia e tomada de decisao.';
  }

  String _signAnswer(GameProgress progress) {
    if (progress.signDuelPlays == 0) {
      return 'Voce ainda nao registrou partidas no Duelo das Placas. Comece '
          'pelas placas mais conhecidas e, em cada resposta, tente lembrar '
          'qual comportamento a sinalizacao pretende organizar ou proteger.';
    }

    return 'No Duelo das Placas, seu melhor resultado e '
        '${progress.signDuelBestCorrect}/6. Para evoluir, associe cada placa '
        'a uma situacao real de circulacao em vez de apenas memorizar o desenho.';
  }

  String _neighborhoodAnswer(GameProgress progress) {
    final installed = progress.purchasedUpgrades.length;

    return 'Voce possui $installed melhorias instaladas no total. No Construa '
        'o Bairro, as moedas representam a capacidade de transformar o espaco '
        'urbano. Priorize melhorias que protejam pedestres, organizem fluxos e '
        'aumentem a acessibilidade.';
  }

  String _studyAnswer(PlayerProfile profile, GameProgress progress) {
    if (progress.completedZones.isEmpty) {
      return 'Seu melhor proximo passo e avancar pela primeira zona, observando '
          'especialmente travessias, convivencia no bairro e seguranca no '
          'caminho para a escola.';
    }

    if (progress.completedZones.length < 6) {
      return 'Voce ja concluiu ${progress.completedZones.length} de 6 zonas. '
          'Continue pela proxima zona disponivel e use o Meu Progresso para '
          'comparar estrelas, medalhas e conhecimento acumulado.';
    }

    return 'As seis zonas principais ja foram concluidas. Agora vale aprofundar '
        'o Duelo das Placas, revisar missoes com menos estrelas e explorar as '
        'melhorias urbanas para consolidar o aprendizado.';
  }

  String _safetyAnswer(PlayerType type) {
    return switch (type) {
      PlayerType.child =>
        'Na seguranca do transito, observe sempre o ambiente, use locais '
            'seguros para atravessar e mantenha atencao mesmo quando estiver '
            'acompanhado. Como pedestre ou passageiro, suas escolhas tambem '
            'fazem parte de um transito mais seguro.',
      PlayerType.teen =>
        'Seguranca no transito envolve previsibilidade, respeito aos usuarios '
            'mais vulneraveis e atencao constante. Como pedestre, ciclista ou '
            'passageiro, evite distraÃ§Ãµes e antecipe riscos.',
      PlayerType.adult =>
        'Uma conducao segura combina respeito as regras, velocidade compativel, '
            'distancia de seguranca, leitura do ambiente e protecao aos usuarios '
            'mais vulneraveis.',
    };
  }

  String _generalAnswer(PlayerProfile profile, GameProgress progress) {
    return 'Sou a Faixita, sua mentora pedagogica. Posso explicar seu progresso, '
        'ajudar a revisar uma missao, conversar sobre placas, seguranca, '
        'cidadania e indicar o que estudar em seguida. Voce ja concluiu '
        '${progress.completedZones.length} de 6 zonas.';
  }
}
