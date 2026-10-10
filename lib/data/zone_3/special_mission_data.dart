import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone3SpecialMission(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z3_SPECIAL',
        title: 'Orla em Equil\u00edbrio',
        description:
            'Use tudo o que aprendeu para circular pela Praia de Iracema.',
        sceneText:
            'No entorno da Praia de Iracema, pedestres, bicicletas e ve\u00edculos dividem espa\u00e7os muito pr\u00f3ximos.',
        question: 'Qual conjunto de atitudes ajuda mais?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Observo, respeito cada espa\u00e7o e atravesso apenas em condi\u00e7\u00e3o segura.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea circula com aten\u00e7\u00e3o e previsibilidade.',
            meloFeedback:
                'Excelente. Uma orla segura depende de muitas pequenas escolhas corretas.',
          ),
          MissionOption(
            id: 'child_wrong_hurry',
            text: 'Fa\u00e7o tudo rapidamente para chegar logo.',
            isCorrect: false,
            consequenceText: 'A pressa reduz sua observa\u00e7\u00e3o.',
            meloFeedback:
                'Na orla movimentada, desacelerar a decis\u00e3o ajuda a perceber melhor o ambiente.',
          ),
          MissionOption(
            id: 'child_wrong_follow',
            text: 'Sigo as outras pessoas sem olhar.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea deixa sua seguran\u00e7a depender dos outros.',
            meloFeedback: 'Observe e decida com aten\u00e7\u00e3o.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z3_SPECIAL',
        title: 'Orla em Equil\u00edbrio',
        description:
            'Integre aten\u00e7\u00e3o, ciclovia, travessia e conviv\u00eancia.',
        sceneText:
            'Voc\u00ea percorre um trecho de grande movimento na Praia de Iracema.',
        question: 'Qual postura representa melhor a conviv\u00eancia segura?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Adapto meu ritmo, mantenho aten\u00e7\u00e3o e respeito o espa\u00e7o dos demais.',
            isCorrect: true,
            consequenceText:
                'Seu deslocamento se integra ao ambiente com menos conflitos.',
            meloFeedback:
                'Muito bem. Mobilidade segura tamb\u00e9m \u00e9 conviv\u00eancia.',
          ),
          MissionOption(
            id: 'teen_wrong_speed',
            text: 'Escolho sempre a rota mais r\u00e1pida.',
            isCorrect: false,
            consequenceText:
                'A pressa aumenta os conflitos com outros usu\u00e1rios.',
            meloFeedback:
                'Considere o ambiente completo, n\u00e3o apenas sua velocidade.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text: 'Uso o celular porque o movimento est\u00e1 lento.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea perde informa\u00e7\u00f5es importantes do entorno.',
            meloFeedback: 'Movimento lento ainda exige aten\u00e7\u00e3o.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z3_SPECIAL',
        title: 'Orla em Equil\u00edbrio',
        description:
            'Integre previsibilidade, aten\u00e7\u00e3o e respeito aos modos vulner\u00e1veis.',
        sceneText:
            'Voc\u00ea dirige por um trecho da Praia de Iracema com fluxo intenso de pedestres e ciclistas.',
        question:
            'Qual postura resume melhor uma condu\u00e7\u00e3o cidad\u00e3?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo quando necess\u00e1rio, antecipo conflitos e preservo o espa\u00e7o de pedestres e ciclistas.',
            isCorrect: true,
            consequenceText: 'Sua condu\u00e7\u00e3o cria margem para todos.',
            meloFeedback:
                'Excelente. Na orla, conduzir bem \u00e9 compartilhar o espa\u00e7o com responsabilidade.',
          ),
          MissionOption(
            id: 'adult_wrong_flow',
            text: 'Mantenho o ritmo para n\u00e3o atrapalhar o fluxo.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea prioriza o fluxo dos carros em vez do ambiente completo.',
            meloFeedback: 'O tr\u00e2nsito inclui todos os usu\u00e1rios.',
          ),
          MissionOption(
            id: 'adult_wrong_stop',
            text: 'Fa\u00e7o paradas r\u00e1pidas quando precisar.',
            isCorrect: false,
            consequenceText:
                'Uma parada inadequada cria obst\u00e1culos para outros modos.',
            meloFeedback:
                'Conveni\u00eancia n\u00e3o pode virar risco para os demais.',
          ),
        ],
      );
  }
}
