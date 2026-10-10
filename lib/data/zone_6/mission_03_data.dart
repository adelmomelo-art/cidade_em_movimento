import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone6Mission03(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z6_M03',
        title: 'Embarque e Desembarque',
        description:
            'Depois do evento, sua familia precisa encontrar o ponto correto para embarcar.',
        sceneText:
            'Depois do evento, sua familia precisa encontrar o ponto correto para embarcar.',
        question: 'Onde voces devem esperar?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text: 'Na area de embarque sinalizada, juntos e fora da pista.',
            isCorrect: true,
            consequenceText:
                'Voce escolheu uma alternativa mais segura e previsivel.',
            meloFeedback:
                'Boa decisao. Em grandes eventos, observar a sinalizacao e evitar improvisos protege todo mundo.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Na beira da faixa para o carro parar mais perto.',
            isCorrect: false,
            consequenceText:
                'A escolha aumenta o risco em uma area com muita gente e veiculos.',
            meloFeedback:
                'Procure sempre o caminho orientado e espere um momento seguro.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Em qualquer portao, mesmo que nao seja area de embarque.',
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
        id: 'Z6_M03',
        title: 'Embarque e Desembarque',
        description:
            'Na saida, carros por aplicativo e transporte coletivo usam pontos organizados.',
        sceneText:
            'Na saida, carros por aplicativo e transporte coletivo usam pontos organizados.',
        question: 'Qual escolha reduz conflitos?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Ir ao ponto oficial de embarque e combinar o encontro antes de chegar a pista.',
            isCorrect: true,
            consequenceText:
                'Sua escolha reduz conflitos e melhora a previsibilidade do fluxo.',
            meloFeedback:
                'Correto. Ler o ambiente e respeitar a operacao temporaria faz parte da cidadania no transito.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'Pedir ao motorista para parar no bloqueio.',
            isCorrect: false,
            consequenceText:
                'A atitude cria conflito com o fluxo organizado para o evento.',
            meloFeedback:
                'Em eventos, a rota habitual pode mudar. Observe a sinalizacao e os agentes.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Ficar procurando o veiculo caminhando pela pista.',
            isCorrect: false,
            consequenceText: 'A decisao aumenta a exposicao ao risco.',
            meloFeedback:
                'Prefira rotas e pontos oficiais, mesmo que parecam um pouco mais longos.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z6_M03',
        title: 'Embarque e Desembarque',
        description:
            'Voce vai buscar passageiros apos o jogo e a area principal esta bloqueada.',
        sceneText:
            'Voce vai buscar passageiros apos o jogo e a area principal esta bloqueada.',
        question: 'Onde deve realizar o embarque?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'No ponto permitido pela operacao, mesmo que exija pequena caminhada dos passageiros.',
            isCorrect: true,
            consequenceText:
                'A conduta preserva a seguranca e a fluidez da operacao especial.',
            meloFeedback:
                'Correto. Em grandes eventos, previsibilidade e obediencia a sinalizacao temporaria sao essenciais.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text: 'Parar em fila dupla proximo ao portao.',
            isCorrect: false,
            consequenceText:
                'A manobra interfere no fluxo e pode atingir pedestres.',
            meloFeedback:
                'Nao improvise em areas de bloqueio ou grande concentracao de pessoas.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text: 'Entrar na area bloqueada apenas para embarcar rapidamente.',
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
