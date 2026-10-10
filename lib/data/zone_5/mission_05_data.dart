import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5Mission05(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_M05',
        title: 'Fluxo Intenso',
        description:
            'Isso aumenta press\u00e3o e manobras.CHILD_DESCIsso aumenta press\u00e3o e manobras.',
        sceneText:
            'Isso aumenta press\u00e3o e manobras.CHILD_SCENEIsso aumenta press\u00e3o e manobras.',
        question:
            'Isso aumenta press\u00e3o e manobras.CHILD_QIsso aumenta press\u00e3o e manobras.',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Isso aumenta press\u00e3o e manobras.CHILD_CORRECTIsso aumenta press\u00e3o e manobras.',
            isCorrect: true,
            consequenceText:
                'Isso aumenta press\u00e3o e manobras.CHILD_C_OKIsso aumenta press\u00e3o e manobras.',
            meloFeedback:
                'Isso aumenta press\u00e3o e manobras.CHILD_M_OKIsso aumenta press\u00e3o e manobras.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text:
                'Isso aumenta press\u00e3o e manobras.CHILD_WRONG1Isso aumenta press\u00e3o e manobras.',
            isCorrect: false,
            consequenceText:
                'Isso aumenta press\u00e3o e manobras.CHILD_C_W1Isso aumenta press\u00e3o e manobras.',
            meloFeedback:
                'Isso aumenta press\u00e3o e manobras.CHILD_M_W1Isso aumenta press\u00e3o e manobras.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text:
                'Isso aumenta press\u00e3o e manobras.CHILD_WRONG2Isso aumenta press\u00e3o e manobras.',
            isCorrect: false,
            consequenceText:
                'Isso aumenta press\u00e3o e manobras.CHILD_C_W2Isso aumenta press\u00e3o e manobras.',
            meloFeedback:
                'Isso aumenta press\u00e3o e manobras.CHILD_M_W2Isso aumenta press\u00e3o e manobras.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_M05',
        title: 'Fluxo Intenso',
        description:
            'Isso aumenta press\u00e3o e manobras.TEEN_DESCIsso aumenta press\u00e3o e manobras.',
        sceneText:
            'Isso aumenta press\u00e3o e manobras.TEEN_SCENEIsso aumenta press\u00e3o e manobras.',
        question:
            'Isso aumenta press\u00e3o e manobras.TEEN_QIsso aumenta press\u00e3o e manobras.',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Isso aumenta press\u00e3o e manobras.TEEN_CORRECTIsso aumenta press\u00e3o e manobras.',
            isCorrect: true,
            consequenceText:
                'Isso aumenta press\u00e3o e manobras.TEEN_C_OKIsso aumenta press\u00e3o e manobras.',
            meloFeedback:
                'Isso aumenta press\u00e3o e manobras.TEEN_M_OKIsso aumenta press\u00e3o e manobras.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text:
                'Isso aumenta press\u00e3o e manobras.TEEN_WRONG1Isso aumenta press\u00e3o e manobras.',
            isCorrect: false,
            consequenceText:
                'Isso aumenta press\u00e3o e manobras.TEEN_C_W1Isso aumenta press\u00e3o e manobras.',
            meloFeedback:
                'Isso aumenta press\u00e3o e manobras.TEEN_M_W1Isso aumenta press\u00e3o e manobras.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text:
                'Isso aumenta press\u00e3o e manobras.TEEN_WRONG2Isso aumenta press\u00e3o e manobras.',
            isCorrect: false,
            consequenceText:
                'Isso aumenta press\u00e3o e manobras.TEEN_C_W2Isso aumenta press\u00e3o e manobras.',
            meloFeedback:
                'Isso aumenta press\u00e3o e manobras.TEEN_M_W2Isso aumenta press\u00e3o e manobras.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_M05',
        title: 'Fluxo Intenso',
        description:
            'Isso aumenta press\u00e3o e manobras.ADULT_DESCIsso aumenta press\u00e3o e manobras.',
        sceneText:
            'Isso aumenta press\u00e3o e manobras.ADULT_SCENEIsso aumenta press\u00e3o e manobras.',
        question:
            'Isso aumenta press\u00e3o e manobras.ADULT_QIsso aumenta press\u00e3o e manobras.',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Isso aumenta press\u00e3o e manobras.ADULT_CORRECTIsso aumenta press\u00e3o e manobras.',
            isCorrect: true,
            consequenceText:
                'Isso aumenta press\u00e3o e manobras.ADULT_C_OKIsso aumenta press\u00e3o e manobras.',
            meloFeedback:
                'Isso aumenta press\u00e3o e manobras.ADULT_M_OKIsso aumenta press\u00e3o e manobras.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text:
                'Isso aumenta press\u00e3o e manobras.ADULT_WRONG1Isso aumenta press\u00e3o e manobras.',
            isCorrect: false,
            consequenceText:
                'Isso aumenta press\u00e3o e manobras.ADULT_C_W1Isso aumenta press\u00e3o e manobras.',
            meloFeedback:
                'Isso aumenta press\u00e3o e manobras.ADULT_M_W1Isso aumenta press\u00e3o e manobras.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'Isso aumenta press\u00e3o e manobras.ADULT_WRONG2Isso aumenta press\u00e3o e manobras.',
            isCorrect: false,
            consequenceText:
                'Isso aumenta press\u00e3o e manobras.ADULT_C_W2Isso aumenta press\u00e3o e manobras.',
            meloFeedback:
                'Isso aumenta press\u00e3o e manobras.ADULT_M_W2Isso aumenta press\u00e3o e manobras.',
          ),
        ],
      );
  }
}
