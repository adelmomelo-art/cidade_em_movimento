import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone6Mission02(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z6_M02',
        title: 'Travessia da Torcida',
        description:
            'Uma grande quantidade de torcedores espera para atravessar uma avenida proxima ao estadio.',
        sceneText:
            'Uma grande quantidade de torcedores espera para atravessar uma avenida proxima ao estadio.',
        question: 'O que voce deve fazer?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Esperar no local indicado e atravessar quando a travessia for liberada.',
            isCorrect: true,
            consequenceText:
                'Voce escolheu uma alternativa mais segura e previsivel.',
            meloFeedback:
                'Boa decisao. Em grandes eventos, observar a sinalizacao e evitar improvisos protege todo mundo.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Passar na frente dos outros para atravessar primeiro.',
            isCorrect: false,
            consequenceText:
                'A escolha aumenta o risco em uma area com muita gente e veiculos.',
            meloFeedback:
                'Procure sempre o caminho orientado e espere um momento seguro.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Atravessar fora do ponto porque os carros estao devagar.',
            isCorrect: false,
            consequenceText:
                'A pressa pode colocar voce no caminho de veiculos ou da multidao.',
            meloFeedback:
                'Seguranca vem antes da pressa. Use os pontos organizados.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z6_M02',
        title: 'Travessia da Torcida',
        description:
            'A torcida ocupa a calcada e a travessia esta sendo controlada em grupos.',
        sceneText:
            'A torcida ocupa a calcada e a travessia esta sendo controlada em grupos.',
        question: 'Qual comportamento ajuda a manter o fluxo seguro?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Aguardar a liberacao, manter-se na area de pedestres e acompanhar o fluxo organizado.',
            isCorrect: true,
            consequenceText:
                'Sua escolha reduz conflitos e melhora a previsibilidade do fluxo.',
            meloFeedback:
                'Correto. Ler o ambiente e respeitar a operacao temporaria faz parte da cidadania no transito.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'Usar a bicicleta no meio da multidao para ganhar tempo.',
            isCorrect: false,
            consequenceText:
                'A atitude cria conflito com o fluxo organizado para o evento.',
            meloFeedback:
                'Em eventos, a rota habitual pode mudar. Observe a sinalizacao e os agentes.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Descer para a pista antes da liberacao.',
            isCorrect: false,
            consequenceText: 'A decisao aumenta a exposicao ao risco.',
            meloFeedback:
                'Prefira rotas e pontos oficiais, mesmo que parecam um pouco mais longos.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z6_M02',
        title: 'Travessia da Torcida',
        description:
            'Voce se aproxima de uma travessia com grande volume de pedestres.',
        sceneText:
            'Voce se aproxima de uma travessia com grande volume de pedestres.',
        question: 'Qual e a melhor conduta ao volante?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzir bem a velocidade e respeitar integralmente a prioridade e a operacao da travessia.',
            isCorrect: true,
            consequenceText:
                'A conduta preserva a seguranca e a fluidez da operacao especial.',
            meloFeedback:
                'Correto. Em grandes eventos, previsibilidade e obediencia a sinalizacao temporaria sao essenciais.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text: 'Acelerar para passar antes do proximo grupo.',
            isCorrect: false,
            consequenceText:
                'A manobra interfere no fluxo e pode atingir pedestres.',
            meloFeedback:
                'Nao improvise em areas de bloqueio ou grande concentracao de pessoas.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text: 'Buzinar para abrir espaco entre os pedestres.',
            isCorrect: false,
            consequenceText:
                'A escolha aumenta o risco e prejudica a organizacao do entorno.',
            meloFeedback:
                'Antecipe a decisao, reduza a velocidade e siga a orientacao da operacao.',
          ),
        ],
      );
  }
}
