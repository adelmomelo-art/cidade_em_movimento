import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone2Mission03(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z2_M03',
        title: 'Cal\u00e7ada \u00e9 de Todos',
        description:
            'Perceba como a cal\u00e7ada ajuda diferentes pessoas a circular.',
        sceneText:
            'No Centro, a cal\u00e7ada est\u00e1 cheia. H\u00e1 um idoso e uma pessoa com mobilidade reduzida.',
        question: 'Como voc\u00ea ajuda a manter a passagem segura?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Caminho sem bloquear a passagem e deixo espa\u00e7o para quem precisa.',
            isCorrect: true,
            consequenceText:
                'As pessoas conseguem seguir pelo passeio sem precisar desviar para a rua.',
            meloFeedback:
                'Muito bem. A cal\u00e7ada \u00e9 um espa\u00e7o de circula\u00e7\u00e3o compartilhado.',
          ),
          MissionOption(
            id: 'child_wrong_group',
            text: 'Paro com meus amigos no meio da passagem para conversar.',
            isCorrect: false,
            consequenceText: 'Outras pessoas precisam desviar de voc\u00eas.',
            meloFeedback:
                'Converse em um ponto onde a passagem continue livre.',
          ),
          MissionOption(
            id: 'child_wrong_street',
            text: 'Vou para a rua para passar mais r\u00e1pido.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea troca um espa\u00e7o protegido por uma \u00e1rea de maior conflito.',
            meloFeedback:
                'Prefira permanecer no espa\u00e7o destinado ao pedestre.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z2_M03',
        title: 'Cal\u00e7ada \u00e9 de Todos',
        description:
            'Reconhe\u00e7a acessibilidade como parte da conviv\u00eancia urbana.',
        sceneText:
            'Voc\u00ea e seus amigos ocupam parte da cal\u00e7ada enquanto uma pessoa em cadeira de rodas se aproxima.',
        question: 'Qual atitude demonstra cidadania?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Reorganizo o grupo e deixo uma passagem livre e confort\u00e1vel.',
            isCorrect: true,
            consequenceText:
                'A circula\u00e7\u00e3o continua sem que ningu\u00e9m precise pedir passagem.',
            meloFeedback:
                'Boa escolha. Acessibilidade tamb\u00e9m depende do comportamento de quem usa o espa\u00e7o.',
          ),
          MissionOption(
            id: 'teen_wrong_wait',
            text:
                'Continuo onde estou e espero que a pessoa pe\u00e7a passagem.',
            isCorrect: false,
            consequenceText:
                'A pessoa precisa interromper o deslocamento para negociar espa\u00e7o.',
            meloFeedback:
                'Antecipar a necessidade do outro \u00e9 parte da boa conviv\u00eancia.',
          ),
          MissionOption(
            id: 'teen_wrong_detour',
            text: 'Aponto um desvio para ela passar por outro lado.',
            isCorrect: false,
            consequenceText:
                'O desvio transfere o problema para quem j\u00e1 encontra mais barreiras.',
            meloFeedback:
                'O melhor \u00e9 liberar o espa\u00e7o de circula\u00e7\u00e3o.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z2_M03',
        title: 'Cal\u00e7ada \u00e9 de Todos',
        description:
            'Perceba como obstru\u00e7\u00f5es afetam pedestres e acessibilidade.',
        sceneText:
            'Um ve\u00edculo ocupa parte da cal\u00e7ada em uma \u00e1rea comercial movimentada.',
        question: 'Qual consequ\u00eancia merece maior aten\u00e7\u00e3o?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'A obstru\u00e7\u00e3o pode for\u00e7ar pedestres a desviar e dificultar a acessibilidade.',
            isCorrect: true,
            consequenceText:
                'Pessoas com diferentes necessidades perdem continuidade no percurso.',
            meloFeedback:
                'Exato. Espa\u00e7o do pedestre precisa permanecer utiliz\u00e1vel e previs\u00edvel.',
          ),
          MissionOption(
            id: 'adult_wrong_short',
            text: 'N\u00e3o h\u00e1 problema se a perman\u00eancia for curta.',
            isCorrect: false,
            consequenceText:
                'Mesmo por pouco tempo, a barreira afeta quem chega naquele momento.',
            meloFeedback:
                'A dura\u00e7\u00e3o n\u00e3o elimina a dificuldade criada.',
          ),
          MissionOption(
            id: 'adult_wrong_room',
            text: 'Basta sobrar algum espa\u00e7o para a maioria das pessoas.',
            isCorrect: false,
            consequenceText:
                'O espa\u00e7o restante pode n\u00e3o atender quem precisa de maior largura ou manobra.',
            meloFeedback:
                'Acessibilidade precisa considerar diferentes usu\u00e1rios, n\u00e3o apenas a maioria.',
          ),
        ],
      );
  }
}
