import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5Mission02(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_M02',
        title: 'Ponto Cego',
        description:
            'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_DESCO motorista pode n\u00e3o enxergar voc\u00ea.',
        sceneText:
            'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_SCENEO motorista pode n\u00e3o enxergar voc\u00ea.',
        question:
            'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_QO motorista pode n\u00e3o enxergar voc\u00ea.',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_CORRECTO motorista pode n\u00e3o enxergar voc\u00ea.',
            isCorrect: true,
            consequenceText:
                'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_C_OKO motorista pode n\u00e3o enxergar voc\u00ea.',
            meloFeedback:
                'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_M_OKO motorista pode n\u00e3o enxergar voc\u00ea.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text:
                'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_WRONG1O motorista pode n\u00e3o enxergar voc\u00ea.',
            isCorrect: false,
            consequenceText:
                'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_C_W1O motorista pode n\u00e3o enxergar voc\u00ea.',
            meloFeedback:
                'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_M_W1O motorista pode n\u00e3o enxergar voc\u00ea.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text:
                'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_WRONG2O motorista pode n\u00e3o enxergar voc\u00ea.',
            isCorrect: false,
            consequenceText:
                'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_C_W2O motorista pode n\u00e3o enxergar voc\u00ea.',
            meloFeedback:
                'O motorista pode n\u00e3o enxergar voc\u00ea.CHILD_M_W2O motorista pode n\u00e3o enxergar voc\u00ea.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_M02',
        title: 'Ponto Cego',
        description:
            'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_DESCO motorista pode n\u00e3o enxergar voc\u00ea.',
        sceneText:
            'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_SCENEO motorista pode n\u00e3o enxergar voc\u00ea.',
        question:
            'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_QO motorista pode n\u00e3o enxergar voc\u00ea.',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_CORRECTO motorista pode n\u00e3o enxergar voc\u00ea.',
            isCorrect: true,
            consequenceText:
                'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_C_OKO motorista pode n\u00e3o enxergar voc\u00ea.',
            meloFeedback:
                'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_M_OKO motorista pode n\u00e3o enxergar voc\u00ea.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text:
                'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_WRONG1O motorista pode n\u00e3o enxergar voc\u00ea.',
            isCorrect: false,
            consequenceText:
                'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_C_W1O motorista pode n\u00e3o enxergar voc\u00ea.',
            meloFeedback:
                'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_M_W1O motorista pode n\u00e3o enxergar voc\u00ea.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text:
                'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_WRONG2O motorista pode n\u00e3o enxergar voc\u00ea.',
            isCorrect: false,
            consequenceText:
                'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_C_W2O motorista pode n\u00e3o enxergar voc\u00ea.',
            meloFeedback:
                'O motorista pode n\u00e3o enxergar voc\u00ea.TEEN_M_W2O motorista pode n\u00e3o enxergar voc\u00ea.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_M02',
        title: 'Ponto Cego',
        description:
            'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_DESCO motorista pode n\u00e3o enxergar voc\u00ea.',
        sceneText:
            'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_SCENEO motorista pode n\u00e3o enxergar voc\u00ea.',
        question:
            'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_QO motorista pode n\u00e3o enxergar voc\u00ea.',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_CORRECTO motorista pode n\u00e3o enxergar voc\u00ea.',
            isCorrect: true,
            consequenceText:
                'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_C_OKO motorista pode n\u00e3o enxergar voc\u00ea.',
            meloFeedback:
                'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_M_OKO motorista pode n\u00e3o enxergar voc\u00ea.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text:
                'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_WRONG1O motorista pode n\u00e3o enxergar voc\u00ea.',
            isCorrect: false,
            consequenceText:
                'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_C_W1O motorista pode n\u00e3o enxergar voc\u00ea.',
            meloFeedback:
                'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_M_W1O motorista pode n\u00e3o enxergar voc\u00ea.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_WRONG2O motorista pode n\u00e3o enxergar voc\u00ea.',
            isCorrect: false,
            consequenceText:
                'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_C_W2O motorista pode n\u00e3o enxergar voc\u00ea.',
            meloFeedback:
                'O motorista pode n\u00e3o enxergar voc\u00ea.ADULT_M_W2O motorista pode n\u00e3o enxergar voc\u00ea.',
          ),
        ],
      );
  }
}
