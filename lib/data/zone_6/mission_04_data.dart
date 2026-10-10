import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone6Mission04(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z6_M04',
        title: 'Bloqueio Temporario',
        description:
            'Uma rua que voce conhece esta fechada durante o evento e ha agentes orientando as pessoas.',
        sceneText:
            'Uma rua que voce conhece esta fechada durante o evento e ha agentes orientando as pessoas.',
        question: 'Como voce deve agir?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Seguir o caminho alternativo indicado e permanecer na area segura.',
            isCorrect: true,
            consequenceText:
                'Voce escolheu uma alternativa mais segura e previsivel.',
            meloFeedback:
                'Boa decisao. Em grandes eventos, observar a sinalizacao e evitar improvisos protege todo mundo.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text:
                'Passar por baixo da barreira porque nao ha carro naquele momento.',
            isCorrect: false,
            consequenceText:
                'A escolha aumenta o risco em uma area com muita gente e veiculos.',
            meloFeedback:
                'Procure sempre o caminho orientado e espere um momento seguro.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Ficar parado no acesso bloqueado esperando abrir.',
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
        id: 'Z6_M04',
        title: 'Bloqueio Temporario',
        description:
            'Um bloqueio temporario altera sua rota de bicicleta e de pedestre.',
        sceneText:
            'Um bloqueio temporario altera sua rota de bicicleta e de pedestre.',
        question: 'Qual e a atitude correta?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text: 'Respeitar o bloqueio e usar a rota alternativa sinalizada.',
            isCorrect: true,
            consequenceText:
                'Sua escolha reduz conflitos e melhora a previsibilidade do fluxo.',
            meloFeedback:
                'Correto. Ler o ambiente e respeitar a operacao temporaria faz parte da cidadania no transito.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'Contornar a barreira pela pista contraria.',
            isCorrect: false,
            consequenceText:
                'A atitude cria conflito com o fluxo organizado para o evento.',
            meloFeedback:
                'Em eventos, a rota habitual pode mudar. Observe a sinalizacao e os agentes.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Ignorar o agente e seguir pelo trecho vazio.',
            isCorrect: false,
            consequenceText: 'A decisao aumenta a exposicao ao risco.',
            meloFeedback:
                'Prefira rotas e pontos oficiais, mesmo que parecam um pouco mais longos.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z6_M04',
        title: 'Bloqueio Temporario',
        description:
            'Sua rota habitual foi fechada para proteger o fluxo de pedestres no entorno do estadio.',
        sceneText:
            'Sua rota habitual foi fechada para proteger o fluxo de pedestres no entorno do estadio.',
        question: 'O que deve fazer?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Aceitar o desvio, sinalizar a manobra com antecedencia e seguir a rota operacional.',
            isCorrect: true,
            consequenceText:
                'A conduta preserva a seguranca e a fluidez da operacao especial.',
            meloFeedback:
                'Correto. Em grandes eventos, previsibilidade e obediencia a sinalizacao temporaria sao essenciais.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text: 'Mover a barreira para acessar a rua.',
            isCorrect: false,
            consequenceText:
                'A manobra interfere no fluxo e pode atingir pedestres.',
            meloFeedback:
                'Nao improvise em areas de bloqueio ou grande concentracao de pessoas.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text: 'Parar na via para esperar o bloqueio terminar.',
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
