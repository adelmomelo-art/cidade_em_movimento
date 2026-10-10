import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone3Mission05(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z3_M05',
        title: 'Fluxo da Praia',
        description:
            'Integre aten\u00e7\u00e3o, travessia e conviv\u00eancia na orla.',
        sceneText:
            'Voc\u00ea est\u00e1 em um trecho com pedestres, bicicletas e acessos de ve\u00edculos.',
        question: 'Qual comportamento ajuda mais?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Observo cada fluxo e uso apenas os espa\u00e7os adequados para caminhar e atravessar.',
            isCorrect: true,
            consequenceText: 'Voc\u00ea se movimenta com previsibilidade.',
            meloFeedback:
                'Excelente. Na orla, diferentes caminhos se encontram o tempo todo.',
          ),
          MissionOption(
            id: 'child_wrong_shortcut',
            text: 'Uso o caminho mais curto, mesmo passando pela ciclovia.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea ocupa um espa\u00e7o de outro fluxo.',
            meloFeedback:
                'O caminho mais curto nem sempre \u00e9 o mais seguro.',
          ),
          MissionOption(
            id: 'child_wrong_follow',
            text: 'Sigo quem estiver na minha frente.',
            isCorrect: false,
            consequenceText:
                'A pessoa muda de dire\u00e7\u00e3o e voc\u00ea perde sua refer\u00eancia.',
            meloFeedback: 'Fa\u00e7a sua pr\u00f3pria leitura do ambiente.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z3_M05',
        title: 'Fluxo da Praia',
        description:
            'Compartilhe a orla de forma previs\u00edvel e respeitosa.',
        sceneText:
            'Voc\u00ea pedala em um trecho com grande movimento de pedestres.',
        question: 'Qual atitude melhora a conviv\u00eancia?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Reduzo, sinalizo quando necess\u00e1rio e respeito o espa\u00e7o dos pedestres.',
            isCorrect: true,
            consequenceText:
                'Seu deslocamento se torna previs\u00edvel para os demais.',
            meloFeedback:
                'Muito bem. Conviv\u00eancia segura combina respeito, aten\u00e7\u00e3o e velocidade adequada.',
          ),
          MissionOption(
            id: 'teen_wrong_zigzag',
            text: 'Desvio rapidamente entre as pessoas.',
            isCorrect: false,
            consequenceText: 'Seus movimentos ficam dif\u00edceis de prever.',
            meloFeedback:
                'Evite zigue-zague. Mantenha trajet\u00f3ria previs\u00edvel.',
          ),
          MissionOption(
            id: 'teen_wrong_bell',
            text: 'Uso a campainha para abrir passagem sem reduzir.',
            isCorrect: false,
            consequenceText: 'O aviso n\u00e3o garante espa\u00e7o suficiente.',
            meloFeedback: 'Sinalizar ajuda, mas n\u00e3o substitui reduzir.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z3_M05',
        title: 'Fluxo da Praia',
        description: 'Antecipe conflitos em uma via de lazer e turismo.',
        sceneText:
            'Voc\u00ea conduz em um trecho com pedestres, ciclistas e acessos laterais.',
        question: 'Qual estrat\u00e9gia oferece maior margem?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Mantenho velocidade compat\u00edvel, observo laterais e antecipo movimentos de usu\u00e1rios vulner\u00e1veis.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea ganha tempo para reagir sem pressionar os demais.',
            meloFeedback:
                'Excelente. Em \u00e1rea de lazer, espere comportamentos diversos e mantenha margem.',
          ),
          MissionOption(
            id: 'adult_wrong_flow',
            text: 'Acompanho o ritmo dos outros carros.',
            isCorrect: false,
            consequenceText:
                'O ritmo do fluxo pode n\u00e3o ser adequado ao ambiente.',
            meloFeedback:
                'Sua velocidade deve responder ao risco, n\u00e3o apenas aos outros carros.',
          ),
          MissionOption(
            id: 'adult_wrong_priority',
            text: 'Mantenho meu ritmo porque estou na via principal.',
            isCorrect: false,
            consequenceText: 'Pedestres e ciclistas ficam com menos margem.',
            meloFeedback:
                'Mesmo em via principal, observe e proteja quem est\u00e1 mais vulner\u00e1vel.',
          ),
        ],
      );
  }
}
