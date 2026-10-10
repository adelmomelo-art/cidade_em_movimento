import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone2Mission01(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z2_M01',
        title: 'Cruzamento em Movimento',
        description:
            'Aprenda a observar o sinal e o ambiente antes de atravessar.',
        sceneText:
            'Voc\u00ea est\u00e1 perto da Pra\u00e7a do Ferreira. '
            'Muitas pessoas atravessam e o sinal muda em poucos segundos.',
        question:
            'Qual atitude ajuda voc\u00ea a atravessar com seguran\u00e7a?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Espero o momento seguro, observo a via e atravesso pelo local indicado.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea confirma o momento seguro e faz uma travessia previs\u00edvel.',
            meloFeedback:
                'Muito bem. Mesmo quando outras pessoas est\u00e3o atravessando, observe por si mesmo antes de seguir.',
          ),
          MissionOption(
            id: 'child_wrong_crowd',
            text:
                'Atravesso junto com o grupo sem olhar porque todos est\u00e3o indo.',
            isCorrect: false,
            consequenceText:
                'O fluxo muda e voc\u00ea percebe tarde que nem todos estavam atentos.',
            meloFeedback:
                'Seguir a multid\u00e3o n\u00e3o substitui a sua observa\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'child_wrong_run',
            text: 'Corro para terminar a travessia antes do sinal mudar.',
            isCorrect: false,
            consequenceText:
                'A pressa diminui sua capacidade de observar mudan\u00e7as no fluxo.',
            meloFeedback:
                'Evite transformar o tempo do sinal em uma corrida. Priorize uma travessia segura.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z2_M01',
        title: 'Cruzamento em Movimento',
        description:
            'Reconhe\u00e7a como distra\u00e7\u00e3o e press\u00e3o do grupo afetam a travessia.',
        sceneText:
            'Voc\u00ea chega a um cruzamento movimentado com amigos. '
            'O grupo come\u00e7a a atravessar enquanto voc\u00ea olha uma mensagem no celular.',
        question: 'Qual \u00e9 a melhor decis\u00e3o?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Guardo o celular, observo o cruzamento e atravesso somente quando estiver seguro.',
            isCorrect: true,
            consequenceText:
                'Com aten\u00e7\u00e3o total, voc\u00ea percebe melhor o sinal e o movimento.',
            meloFeedback:
                'Boa escolha. O grupo pode seguir, mas sua decis\u00e3o precisa vir da leitura do ambiente.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text:
                'Continuo olhando o celular e sigo os amigos para n\u00e3o ficar para tr\u00e1s.',
            isCorrect: false,
            consequenceText:
                'Sua aten\u00e7\u00e3o fica dividida justamente no ponto de maior conflito.',
            meloFeedback:
                'Travessia exige aten\u00e7\u00e3o ao ambiente. O celular pode esperar alguns segundos.',
          ),
          MissionOption(
            id: 'teen_wrong_signal',
            text:
                'Entro na travessia porque ainda vejo pessoas terminando de passar.',
            isCorrect: false,
            consequenceText:
                'O fluxo pode mudar antes de voc\u00ea concluir a travessia.',
            meloFeedback:
                'Observe sua pr\u00f3pria condi\u00e7\u00e3o de travessia, n\u00e3o apenas quem est\u00e1 \u00e0 frente.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z2_M01',
        title: 'Cruzamento em Movimento',
        description:
            'Antecipe conflitos entre sinaliza\u00e7\u00e3o, pedestres e fluxo de ve\u00edculos.',
        sceneText:
            'Voc\u00ea se aproxima de um cruzamento movimentado. '
            'Pedestres ainda est\u00e3o concluindo a travessia.',
        question: 'Qual conduta protege melhor quem est\u00e1 no cruzamento?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo, observo o cruzamento e aguardo a conclus\u00e3o segura da travessia.',
            isCorrect: true,
            consequenceText:
                'A redu\u00e7\u00e3o cria margem para perceber pedestres e reagir sem conflito.',
            meloFeedback:
                'Boa decis\u00e3o. Em cruzamentos movimentados, antecipe o risco antes de precisar reagir.',
          ),
          MissionOption(
            id: 'adult_wrong_gap',
            text:
                'Aproveito um espa\u00e7o entre os pedestres e sigo rapidamente.',
            isCorrect: false,
            consequenceText:
                'O espa\u00e7o diminui e a margem de seguran\u00e7a fica muito pequena.',
            meloFeedback:
                'Uma brecha n\u00e3o deve ser tratada como convite para acelerar a decis\u00e3o.',
          ),
          MissionOption(
            id: 'adult_wrong_horn',
            text: 'Buzino para avisar e mantenho meu ritmo.',
            isCorrect: false,
            consequenceText:
                'O aviso sonoro n\u00e3o substitui a redu\u00e7\u00e3o nem organiza o conflito.',
            meloFeedback:
                'O mais seguro \u00e9 reduzir e tornar sua aproxima\u00e7\u00e3o previs\u00edvel.',
          ),
        ],
      );
  }
}
