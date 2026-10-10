import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5Mission01(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_M01',
        title: 'Travessia de Grande Avenida',
        description:
            'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_DESCA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
        sceneText:
            'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_SCENEA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
        question:
            'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_QA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_CORRECTA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            isCorrect: true,
            consequenceText:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_C_OKA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            meloFeedback:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_M_OKA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_WRONG1A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            isCorrect: false,
            consequenceText:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_C_W1A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            meloFeedback:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_M_W1A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_WRONG2A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            isCorrect: false,
            consequenceText:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_C_W2A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            meloFeedback:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.CHILD_M_W2A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_M01',
        title: 'Travessia de Grande Avenida',
        description:
            'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_DESCA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
        sceneText:
            'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_SCENEA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
        question:
            'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_QA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_CORRECTA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            isCorrect: true,
            consequenceText:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_C_OKA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            meloFeedback:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_M_OKA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_WRONG1A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            isCorrect: false,
            consequenceText:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_C_W1A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            meloFeedback:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_M_W1A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_WRONG2A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            isCorrect: false,
            consequenceText:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_C_W2A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            meloFeedback:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.TEEN_M_W2A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_M01',
        title: 'Travessia de Grande Avenida',
        description:
            'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_DESCA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
        sceneText:
            'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_SCENEA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
        question:
            'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_QA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_CORRECTA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            isCorrect: true,
            consequenceText:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_C_OKA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            meloFeedback:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_M_OKA dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_WRONG1A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            isCorrect: false,
            consequenceText:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_C_W1A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            meloFeedback:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_M_W1A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_WRONG2A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            isCorrect: false,
            consequenceText:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_C_W2A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
            meloFeedback:
                'A dist\u00e2ncia e a velocidade tornam a brecha enganosa.ADULT_M_W2A dist\u00e2ncia e a velocidade tornam a brecha enganosa.',
          ),
        ],
      );
  }
}
