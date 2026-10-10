import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5Mission03(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_M03',
        title: 'Velocidade e Dist\u00e2ncia',
        description:
            'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_DESCMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
        sceneText:
            'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_SCENEMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
        question:
            'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_QMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_CORRECTMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            isCorrect: true,
            consequenceText:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_C_OKMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            meloFeedback:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_M_OKMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_WRONG1Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            isCorrect: false,
            consequenceText:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_C_W1Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            meloFeedback:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_M_W1Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_WRONG2Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            isCorrect: false,
            consequenceText:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_C_W2Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            meloFeedback:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.CHILD_M_W2Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_M03',
        title: 'Velocidade e Dist\u00e2ncia',
        description:
            'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_DESCMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
        sceneText:
            'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_SCENEMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
        question:
            'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_QMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_CORRECTMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            isCorrect: true,
            consequenceText:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_C_OKMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            meloFeedback:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_M_OKMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_WRONG1Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            isCorrect: false,
            consequenceText:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_C_W1Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            meloFeedback:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_M_W1Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_WRONG2Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            isCorrect: false,
            consequenceText:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_C_W2Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            meloFeedback:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.TEEN_M_W2Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_M03',
        title: 'Velocidade e Dist\u00e2ncia',
        description:
            'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_DESCMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
        sceneText:
            'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_SCENEMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
        question:
            'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_QMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_CORRECTMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            isCorrect: true,
            consequenceText:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_C_OKMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            meloFeedback:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_M_OKMaior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_WRONG1Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            isCorrect: false,
            consequenceText:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_C_W1Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            meloFeedback:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_M_W1Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_WRONG2Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            isCorrect: false,
            consequenceText:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_C_W2Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
            meloFeedback:
                'Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.ADULT_M_W2Maior velocidade aumenta a dist\u00e2ncia necess\u00e1ria.',
          ),
        ],
      );
  }
}
