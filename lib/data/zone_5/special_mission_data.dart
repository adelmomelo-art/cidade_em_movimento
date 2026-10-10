import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5SpecialMission(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_SPECIAL',
        title: 'Corredor em Equil\u00edbrio',
        description:
            'O fluxo pode mudar rapidamente.CHILD_DESCO fluxo pode mudar rapidamente.',
        sceneText:
            'O fluxo pode mudar rapidamente.CHILD_SCENEO fluxo pode mudar rapidamente.',
        question:
            'O fluxo pode mudar rapidamente.CHILD_QO fluxo pode mudar rapidamente.',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'O fluxo pode mudar rapidamente.CHILD_CORRECTO fluxo pode mudar rapidamente.',
            isCorrect: true,
            consequenceText:
                'O fluxo pode mudar rapidamente.CHILD_C_OKO fluxo pode mudar rapidamente.',
            meloFeedback:
                'O fluxo pode mudar rapidamente.CHILD_M_OKO fluxo pode mudar rapidamente.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text:
                'O fluxo pode mudar rapidamente.CHILD_WRONG1O fluxo pode mudar rapidamente.',
            isCorrect: false,
            consequenceText:
                'O fluxo pode mudar rapidamente.CHILD_C_W1O fluxo pode mudar rapidamente.',
            meloFeedback:
                'O fluxo pode mudar rapidamente.CHILD_M_W1O fluxo pode mudar rapidamente.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text:
                'O fluxo pode mudar rapidamente.CHILD_WRONG2O fluxo pode mudar rapidamente.',
            isCorrect: false,
            consequenceText:
                'O fluxo pode mudar rapidamente.CHILD_C_W2O fluxo pode mudar rapidamente.',
            meloFeedback:
                'O fluxo pode mudar rapidamente.CHILD_M_W2O fluxo pode mudar rapidamente.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_SPECIAL',
        title: 'Corredor em Equil\u00edbrio',
        description:
            'O fluxo pode mudar rapidamente.TEEN_DESCO fluxo pode mudar rapidamente.',
        sceneText:
            'O fluxo pode mudar rapidamente.TEEN_SCENEO fluxo pode mudar rapidamente.',
        question:
            'O fluxo pode mudar rapidamente.TEEN_QO fluxo pode mudar rapidamente.',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'O fluxo pode mudar rapidamente.TEEN_CORRECTO fluxo pode mudar rapidamente.',
            isCorrect: true,
            consequenceText:
                'O fluxo pode mudar rapidamente.TEEN_C_OKO fluxo pode mudar rapidamente.',
            meloFeedback:
                'O fluxo pode mudar rapidamente.TEEN_M_OKO fluxo pode mudar rapidamente.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text:
                'O fluxo pode mudar rapidamente.TEEN_WRONG1O fluxo pode mudar rapidamente.',
            isCorrect: false,
            consequenceText:
                'O fluxo pode mudar rapidamente.TEEN_C_W1O fluxo pode mudar rapidamente.',
            meloFeedback:
                'O fluxo pode mudar rapidamente.TEEN_M_W1O fluxo pode mudar rapidamente.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text:
                'O fluxo pode mudar rapidamente.TEEN_WRONG2O fluxo pode mudar rapidamente.',
            isCorrect: false,
            consequenceText:
                'O fluxo pode mudar rapidamente.TEEN_C_W2O fluxo pode mudar rapidamente.',
            meloFeedback:
                'O fluxo pode mudar rapidamente.TEEN_M_W2O fluxo pode mudar rapidamente.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_SPECIAL',
        title: 'Corredor em Equil\u00edbrio',
        description:
            'O fluxo pode mudar rapidamente.ADULT_DESCO fluxo pode mudar rapidamente.',
        sceneText:
            'O fluxo pode mudar rapidamente.ADULT_SCENEO fluxo pode mudar rapidamente.',
        question:
            'O fluxo pode mudar rapidamente.ADULT_QO fluxo pode mudar rapidamente.',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'O fluxo pode mudar rapidamente.ADULT_CORRECTO fluxo pode mudar rapidamente.',
            isCorrect: true,
            consequenceText:
                'O fluxo pode mudar rapidamente.ADULT_C_OKO fluxo pode mudar rapidamente.',
            meloFeedback:
                'O fluxo pode mudar rapidamente.ADULT_M_OKO fluxo pode mudar rapidamente.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text:
                'O fluxo pode mudar rapidamente.ADULT_WRONG1O fluxo pode mudar rapidamente.',
            isCorrect: false,
            consequenceText:
                'O fluxo pode mudar rapidamente.ADULT_C_W1O fluxo pode mudar rapidamente.',
            meloFeedback:
                'O fluxo pode mudar rapidamente.ADULT_M_W1O fluxo pode mudar rapidamente.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'O fluxo pode mudar rapidamente.ADULT_WRONG2O fluxo pode mudar rapidamente.',
            isCorrect: false,
            consequenceText:
                'O fluxo pode mudar rapidamente.ADULT_C_W2O fluxo pode mudar rapidamente.',
            meloFeedback:
                'O fluxo pode mudar rapidamente.ADULT_M_W2O fluxo pode mudar rapidamente.',
          ),
        ],
      );
  }
}
