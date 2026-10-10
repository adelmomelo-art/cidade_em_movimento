import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone6Mission01(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z6_M01',
        title: 'Chegada ao Castelao',
        description:
            'Voce chega ao entorno do estadio com sua familia e encontra muita gente desembarcando.',
        sceneText:
            'Voce chega ao entorno do estadio com sua familia e encontra muita gente desembarcando.',
        question: 'Qual e a forma mais segura de seguir ate a entrada?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Permanecer com o grupo e usar o caminho de pedestres indicado.',
            isCorrect: true,
            consequenceText:
                'Voce escolheu uma alternativa mais segura e previsivel.',
            meloFeedback:
                'Boa decisao. Em grandes eventos, observar a sinalizacao e evitar improvisos protege todo mundo.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Atravessar entre carros parados para cortar caminho.',
            isCorrect: false,
            consequenceText:
                'A escolha aumenta o risco em uma area com muita gente e veiculos.',
            meloFeedback:
                'Procure sempre o caminho orientado e espere um momento seguro.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Sair correndo sozinho em direcao ao estadio.',
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
        id: 'Z6_M01',
        title: 'Chegada ao Castelao',
        description:
            'Na chegada ao jogo, calcadas e travessias ficam cheias e algumas rotas mudam.',
        sceneText:
            'Na chegada ao jogo, calcadas e travessias ficam cheias e algumas rotas mudam.',
        question: 'Como voce deve organizar seu deslocamento?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Observar a sinalizacao temporaria, usar a rota de pedestres e evitar atalhos pela pista.',
            isCorrect: true,
            consequenceText:
                'Sua escolha reduz conflitos e melhora a previsibilidade do fluxo.',
            meloFeedback:
                'Correto. Ler o ambiente e respeitar a operacao temporaria faz parte da cidadania no transito.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'Seguir a multidao mesmo quando ela entra na pista.',
            isCorrect: false,
            consequenceText:
                'A atitude cria conflito com o fluxo organizado para o evento.',
            meloFeedback:
                'Em eventos, a rota habitual pode mudar. Observe a sinalizacao e os agentes.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Ignorar o bloqueio porque conhece o bairro.',
            isCorrect: false,
            consequenceText: 'A decisao aumenta a exposicao ao risco.',
            meloFeedback:
                'Prefira rotas e pontos oficiais, mesmo que parecam um pouco mais longos.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z6_M01',
        title: 'Chegada ao Castelao',
        description:
            'Voce dirige para o Polo Castelao e encontra bloqueios e desvios temporarios.',
        sceneText:
            'Voce dirige para o Polo Castelao e encontra bloqueios e desvios temporarios.',
        question: 'Qual conduta e mais segura na aproximacao?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzir a velocidade, antecipar a rota e seguir a sinalizacao da operacao.',
            isCorrect: true,
            consequenceText:
                'A conduta preserva a seguranca e a fluidez da operacao especial.',
            meloFeedback:
                'Correto. Em grandes eventos, previsibilidade e obediencia a sinalizacao temporaria sao essenciais.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text: 'Parar na faixa para perguntar onde estacionar.',
            isCorrect: false,
            consequenceText:
                'A manobra interfere no fluxo e pode atingir pedestres.',
            meloFeedback:
                'Nao improvise em areas de bloqueio ou grande concentracao de pessoas.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text: 'Fazer retorno improvisado ao encontrar o bloqueio.',
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
