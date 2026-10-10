import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone6SpecialMission(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z6_SPECIAL',
        title: 'Operacao Dia de Jogo',
        description:
            'A chegada e a saida acontecem ao mesmo tempo em diferentes pontos do Polo Castelao.',
        sceneText:
            'A chegada e a saida acontecem ao mesmo tempo em diferentes pontos do Polo Castelao.',
        question: 'Qual regra resume melhor uma participacao segura no evento?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Permanecer nas rotas de pedestres, seguir a sinalizacao e ficar com o grupo.',
            isCorrect: true,
            consequenceText:
                'Voce escolheu uma alternativa mais segura e previsivel.',
            meloFeedback:
                'Boa decisao. Em grandes eventos, observar a sinalizacao e evitar improvisos protege todo mundo.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Escolher sempre o caminho mais curto, mesmo pela pista.',
            isCorrect: false,
            consequenceText:
                'A escolha aumenta o risco em uma area com muita gente e veiculos.',
            meloFeedback:
                'Procure sempre o caminho orientado e espere um momento seguro.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Seguir qualquer grupo sem observar a sinalizacao.',
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
        id: 'Z6_SPECIAL',
        title: 'Operacao Dia de Jogo',
        description:
            'O entorno muda rapidamente com bloqueios, travessias controladas e pontos de embarque.',
        sceneText:
            'O entorno muda rapidamente com bloqueios, travessias controladas e pontos de embarque.',
        question: 'Qual estrategia integra melhor seguranca e mobilidade?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Planejar a rota, observar as mudancas temporarias e respeitar os espacos de cada modo.',
            isCorrect: true,
            consequenceText:
                'Sua escolha reduz conflitos e melhora a previsibilidade do fluxo.',
            meloFeedback:
                'Correto. Ler o ambiente e respeitar a operacao temporaria faz parte da cidadania no transito.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'Confiar apenas na rota usada em dias comuns.',
            isCorrect: false,
            consequenceText:
                'A atitude cria conflito com o fluxo organizado para o evento.',
            meloFeedback:
                'Em eventos, a rota habitual pode mudar. Observe a sinalizacao e os agentes.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Improvisar sempre que houver fila.',
            isCorrect: false,
            consequenceText: 'A decisao aumenta a exposicao ao risco.',
            meloFeedback:
                'Prefira rotas e pontos oficiais, mesmo que parecam um pouco mais longos.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z6_SPECIAL',
        title: 'Operacao Dia de Jogo',
        description:
            'Voce precisa circular pelo entorno durante a operacao especial de um grande jogo.',
        sceneText:
            'Voce precisa circular pelo entorno durante a operacao especial de um grande jogo.',
        question: 'Qual conjunto de atitudes e o mais adequado?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzir velocidade, antecipar decisoes, respeitar bloqueios e priorizar pedestres e orientacao operacional.',
            isCorrect: true,
            consequenceText:
                'A conduta preserva a seguranca e a fluidez da operacao especial.',
            meloFeedback:
                'Correto. Em grandes eventos, previsibilidade e obediencia a sinalizacao temporaria sao essenciais.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text: 'Usar atalhos locais para evitar a operacao.',
            isCorrect: false,
            consequenceText:
                'A manobra interfere no fluxo e pode atingir pedestres.',
            meloFeedback:
                'Nao improvise em areas de bloqueio ou grande concentracao de pessoas.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'Fazer paradas rapidas em qualquer ponto porque o evento ja terminou.',
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
