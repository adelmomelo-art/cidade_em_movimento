import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone4Mission01(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z4_M01',
        title: 'Chegada ao Evento',
        description:
            'Aprenda a chegar com seguran\u00e7a a um local movimentado.',
        sceneText:
            'Voc\u00ea chega com sua fam\u00edlia a um evento cultural com muitas pessoas.',
        question: 'Qual atitude \u00e9 mais segura?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text: 'Permane\u00e7o com o grupo e uso os acessos indicados.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea evita circular por \u00e1reas de ve\u00edculos.',
            meloFeedback:
                'Muito bem. Em eventos, siga a sinaliza\u00e7\u00e3o e fique com seu grupo.',
          ),
          MissionOption(
            id: 'child_wrong_shortcut',
            text: 'Uso um atalho entre carros para chegar mais r\u00e1pido.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea entra em uma \u00e1rea com movimentos dif\u00edceis de prever.',
            meloFeedback: 'Prefira sempre os acessos organizados.',
          ),
          MissionOption(
            id: 'child_wrong_run',
            text: 'Corro para n\u00e3o perder o in\u00edcio do evento.',
            isCorrect: false,
            consequenceText: 'A pressa reduz sua aten\u00e7\u00e3o ao entorno.',
            meloFeedback:
                'Chegar seguro \u00e9 mais importante do que chegar correndo.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z4_M01',
        title: 'Chegada ao Evento',
        description:
            'Planeje uma chegada segura em \u00e1rea de grande p\u00fablico.',
        sceneText:
            'Voc\u00ea chega a um evento e encontra desvios e bloqueios tempor\u00e1rios.',
        question: 'Qual decis\u00e3o melhora sua seguran\u00e7a?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Sigo a rota indicada e observo a sinaliza\u00e7\u00e3o tempor\u00e1ria.',
            isCorrect: true,
            consequenceText: 'Voc\u00ea entra pelo fluxo planejado.',
            meloFeedback:
                'Boa escolha. Eventos mudam o funcionamento normal das vias.',
          ),
          MissionOption(
            id: 'teen_wrong_barrier',
            text: 'Passo pela barreira porque vejo pessoas do outro lado.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea entra em uma \u00e1rea isolada para controle de fluxo.',
            meloFeedback:
                'Barreiras e desvios fazem parte da organiza\u00e7\u00e3o do evento.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text: 'Vou olhando o celular para encontrar meus amigos.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea deixa de perceber mudan\u00e7as no fluxo.',
            meloFeedback: 'Pare em local seguro antes de usar o celular.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z4_M01',
        title: 'Chegada ao Evento',
        description:
            'Antecipe desvios e grande concentra\u00e7\u00e3o de pedestres.',
        sceneText:
            'Voc\u00ea dirige para um evento e encontra bloqueios pr\u00f3ximos ao local.',
        question: 'Qual conduta \u00e9 mais adequada?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo, sigo os desvios e procuro um local permitido para parar.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea evita criar novos conflitos no entorno.',
            meloFeedback:
                'Excelente. Em eventos, o planejamento tempor\u00e1rio deve ser respeitado.',
          ),
          MissionOption(
            id: 'adult_wrong_stop',
            text: 'Paro rapidamente perto da entrada com o alerta ligado.',
            isCorrect: false,
            consequenceText: 'A parada cria um obst\u00e1culo no fluxo.',
            meloFeedback:
                'Sinaliza\u00e7\u00e3o de emerg\u00eancia n\u00e3o torna uma parada irregular segura.',
          ),
          MissionOption(
            id: 'adult_wrong_barrier',
            text: 'Contorno a barreira por uma rua lateral.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea entra em um fluxo n\u00e3o planejado.',
            meloFeedback: 'Siga a rota oficial do evento.',
          ),
        ],
      );
  }
}
