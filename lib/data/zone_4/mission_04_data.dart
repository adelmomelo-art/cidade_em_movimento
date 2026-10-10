import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone4Mission04(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z4_M04',
        title: '\u00c1rea de Bloqueio',
        description: 'Entenda por que algumas \u00e1reas ficam isoladas.',
        sceneText:
            'Uma rua ao lado do evento est\u00e1 bloqueada com cones e grades.',
        question: 'O que fazer?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text: 'Respeito o bloqueio e sigo o caminho indicado.',
            isCorrect: true,
            consequenceText: 'Voc\u00ea permanece na rota segura.',
            meloFeedback:
                'Muito bem. Bloqueios ajudam a separar pessoas e ve\u00edculos.',
          ),
          MissionOption(
            id: 'child_wrong_gap',
            text: 'Passo por uma abertura na grade.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea entra em uma \u00e1rea n\u00e3o preparada para pedestres.',
            meloFeedback: 'N\u00e3o atravesse barreiras.',
          ),
          MissionOption(
            id: 'child_wrong_follow',
            text: 'Sigo outras pessoas que passaram.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea repete uma escolha insegura.',
            meloFeedback:
                'Siga a sinaliza\u00e7\u00e3o, n\u00e3o o erro dos outros.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z4_M04',
        title: '\u00c1rea de Bloqueio',
        description:
            'Interprete sinaliza\u00e7\u00e3o tempor\u00e1ria de eventos.',
        sceneText: 'Seu caminho habitual est\u00e1 fechado temporariamente.',
        question: 'Qual decis\u00e3o \u00e9 correta?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text: 'Aceito o desvio e procuro a rota indicada.',
            isCorrect: true,
            consequenceText: 'Voc\u00ea se adapta ao plano tempor\u00e1rio.',
            meloFeedback:
                'Boa. Eventos podem alterar temporariamente a circula\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'teen_wrong_shortcut',
            text: 'Procuro uma passagem por tr\u00e1s da barreira.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea entra em uma \u00e1rea restrita.',
            meloFeedback: 'Barreiras devem ser respeitadas.',
          ),
          MissionOption(
            id: 'teen_wrong_ignore',
            text: 'Ignoro porque a rua parece vazia.',
            isCorrect: false,
            consequenceText:
                'A rua pode estar reservada a servi\u00e7os do evento.',
            meloFeedback:
                'Aus\u00eancia de movimento n\u00e3o significa libera\u00e7\u00e3o.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z4_M04',
        title: '\u00c1rea de Bloqueio',
        description: 'Respeite desvios operacionais em grandes eventos.',
        sceneText:
            'Uma via est\u00e1 bloqueada e o aplicativo ainda indica passar por ela.',
        question: 'Qual decis\u00e3o \u00e9 mais segura?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Sigo a sinaliza\u00e7\u00e3o local e abandono a rota do aplicativo.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea respeita a condi\u00e7\u00e3o real da via.',
            meloFeedback:
                'Exato. Sinaliza\u00e7\u00e3o presente no local prevalece sobre uma rota desatualizada.',
          ),
          MissionOption(
            id: 'adult_wrong_app',
            text: 'Sigo o aplicativo porque ele conhece a melhor rota.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea chega a uma \u00e1rea fechada.',
            meloFeedback:
                'A condi\u00e7\u00e3o real deve orientar sua decis\u00e3o.',
          ),
          MissionOption(
            id: 'adult_wrong_gap',
            text: 'Passo pela lateral porque meu ve\u00edculo cabe.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea invade uma \u00e1rea controlada.',
            meloFeedback: 'N\u00e3o contorne bloqueios.',
          ),
        ],
      );
  }
}
