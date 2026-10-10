import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone6Mission05(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z6_M05',
        title: 'Saida do Estadio',
        description:
            'O jogo terminou e milhares de pessoas saem ao mesmo tempo.',
        sceneText: 'O jogo terminou e milhares de pessoas saem ao mesmo tempo.',
        question: 'Qual comportamento e mais seguro?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Sair com calma, permanecer com o grupo e seguir o fluxo orientado.',
            isCorrect: true,
            consequenceText:
                'Voce escolheu uma alternativa mais segura e previsivel.',
            meloFeedback:
                'Boa decisao. Em grandes eventos, observar a sinalizacao e evitar improvisos protege todo mundo.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Correr para chegar primeiro ao estacionamento.',
            isCorrect: false,
            consequenceText:
                'A escolha aumenta o risco em uma area com muita gente e veiculos.',
            meloFeedback:
                'Procure sempre o caminho orientado e espere um momento seguro.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Descer para a pista quando a calcada estiver cheia.',
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
        id: 'Z6_M05',
        title: 'Saida do Estadio',
        description:
            'Na dispersao, pedestres, bicicletas, onibus e carros voltam a ocupar o entorno.',
        sceneText:
            'Na dispersao, pedestres, bicicletas, onibus e carros voltam a ocupar o entorno.',
        question: 'Como reduzir o risco nesse momento?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Manter atencao, evitar disputar espaco e usar os corredores definidos para cada modo.',
            isCorrect: true,
            consequenceText:
                'Sua escolha reduz conflitos e melhora a previsibilidade do fluxo.',
            meloFeedback:
                'Correto. Ler o ambiente e respeitar a operacao temporaria faz parte da cidadania no transito.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'Pedalar rapido entre os pedestres.',
            isCorrect: false,
            consequenceText:
                'A atitude cria conflito com o fluxo organizado para o evento.',
            meloFeedback:
                'Em eventos, a rota habitual pode mudar. Observe a sinalizacao e os agentes.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Usar a pista como atalho porque o fluxo esta lento.',
            isCorrect: false,
            consequenceText: 'A decisao aumenta a exposicao ao risco.',
            meloFeedback:
                'Prefira rotas e pontos oficiais, mesmo que parecam um pouco mais longos.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z6_M05',
        title: 'Saida do Estadio',
        description:
            'Voce sai de um estacionamento com grande fila e intenso movimento de pedestres.',
        sceneText:
            'Voce sai de um estacionamento com grande fila e intenso movimento de pedestres.',
        question: 'Qual e a melhor estrategia?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Manter baixa velocidade, dar prioridade aos pedestres e entrar no fluxo somente com espaco seguro.',
            isCorrect: true,
            consequenceText:
                'A conduta preserva a seguranca e a fluidez da operacao especial.',
            meloFeedback:
                'Correto. Em grandes eventos, previsibilidade e obediencia a sinalizacao temporaria sao essenciais.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text: 'Forcar a entrada para nao perder sua vez.',
            isCorrect: false,
            consequenceText:
                'A manobra interfere no fluxo e pode atingir pedestres.',
            meloFeedback:
                'Nao improvise em areas de bloqueio ou grande concentracao de pessoas.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'Usar o acostamento ou area de pedestres para ultrapassar a fila.',
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
