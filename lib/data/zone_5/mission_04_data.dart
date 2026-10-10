import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5Mission04(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_M04',
        title: 'Acesso e Convers\u00e3o',
        description:
            'Alguns ve\u00edculos podem estar convertendo.CHILD_DESCAlguns ve\u00edculos podem estar convertendo.',
        sceneText:
            'Alguns ve\u00edculos podem estar convertendo.CHILD_SCENEAlguns ve\u00edculos podem estar convertendo.',
        question:
            'Alguns ve\u00edculos podem estar convertendo.CHILD_QAlguns ve\u00edculos podem estar convertendo.',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Alguns ve\u00edculos podem estar convertendo.CHILD_CORRECTAlguns ve\u00edculos podem estar convertendo.',
            isCorrect: true,
            consequenceText:
                'Alguns ve\u00edculos podem estar convertendo.CHILD_C_OKAlguns ve\u00edculos podem estar convertendo.',
            meloFeedback:
                'Alguns ve\u00edculos podem estar convertendo.CHILD_M_OKAlguns ve\u00edculos podem estar convertendo.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text:
                'Alguns ve\u00edculos podem estar convertendo.CHILD_WRONG1Alguns ve\u00edculos podem estar convertendo.',
            isCorrect: false,
            consequenceText:
                'Alguns ve\u00edculos podem estar convertendo.CHILD_C_W1Alguns ve\u00edculos podem estar convertendo.',
            meloFeedback:
                'Alguns ve\u00edculos podem estar convertendo.CHILD_M_W1Alguns ve\u00edculos podem estar convertendo.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text:
                'Alguns ve\u00edculos podem estar convertendo.CHILD_WRONG2Alguns ve\u00edculos podem estar convertendo.',
            isCorrect: false,
            consequenceText:
                'Alguns ve\u00edculos podem estar convertendo.CHILD_C_W2Alguns ve\u00edculos podem estar convertendo.',
            meloFeedback:
                'Alguns ve\u00edculos podem estar convertendo.CHILD_M_W2Alguns ve\u00edculos podem estar convertendo.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_M04',
        title: 'Acesso e Convers\u00e3o',
        description:
            'Alguns ve\u00edculos podem estar convertendo.TEEN_DESCAlguns ve\u00edculos podem estar convertendo.',
        sceneText:
            'Alguns ve\u00edculos podem estar convertendo.TEEN_SCENEAlguns ve\u00edculos podem estar convertendo.',
        question:
            'Alguns ve\u00edculos podem estar convertendo.TEEN_QAlguns ve\u00edculos podem estar convertendo.',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Alguns ve\u00edculos podem estar convertendo.TEEN_CORRECTAlguns ve\u00edculos podem estar convertendo.',
            isCorrect: true,
            consequenceText:
                'Alguns ve\u00edculos podem estar convertendo.TEEN_C_OKAlguns ve\u00edculos podem estar convertendo.',
            meloFeedback:
                'Alguns ve\u00edculos podem estar convertendo.TEEN_M_OKAlguns ve\u00edculos podem estar convertendo.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text:
                'Alguns ve\u00edculos podem estar convertendo.TEEN_WRONG1Alguns ve\u00edculos podem estar convertendo.',
            isCorrect: false,
            consequenceText:
                'Alguns ve\u00edculos podem estar convertendo.TEEN_C_W1Alguns ve\u00edculos podem estar convertendo.',
            meloFeedback:
                'Alguns ve\u00edculos podem estar convertendo.TEEN_M_W1Alguns ve\u00edculos podem estar convertendo.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text:
                'Alguns ve\u00edculos podem estar convertendo.TEEN_WRONG2Alguns ve\u00edculos podem estar convertendo.',
            isCorrect: false,
            consequenceText:
                'Alguns ve\u00edculos podem estar convertendo.TEEN_C_W2Alguns ve\u00edculos podem estar convertendo.',
            meloFeedback:
                'Alguns ve\u00edculos podem estar convertendo.TEEN_M_W2Alguns ve\u00edculos podem estar convertendo.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_M04',
        title: 'Acesso e Convers\u00e3o',
        description:
            'Alguns ve\u00edculos podem estar convertendo.ADULT_DESCAlguns ve\u00edculos podem estar convertendo.',
        sceneText:
            'Alguns ve\u00edculos podem estar convertendo.ADULT_SCENEAlguns ve\u00edculos podem estar convertendo.',
        question:
            'Alguns ve\u00edculos podem estar convertendo.ADULT_QAlguns ve\u00edculos podem estar convertendo.',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Alguns ve\u00edculos podem estar convertendo.ADULT_CORRECTAlguns ve\u00edculos podem estar convertendo.',
            isCorrect: true,
            consequenceText:
                'Alguns ve\u00edculos podem estar convertendo.ADULT_C_OKAlguns ve\u00edculos podem estar convertendo.',
            meloFeedback:
                'Alguns ve\u00edculos podem estar convertendo.ADULT_M_OKAlguns ve\u00edculos podem estar convertendo.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text:
                'Alguns ve\u00edculos podem estar convertendo.ADULT_WRONG1Alguns ve\u00edculos podem estar convertendo.',
            isCorrect: false,
            consequenceText:
                'Alguns ve\u00edculos podem estar convertendo.ADULT_C_W1Alguns ve\u00edculos podem estar convertendo.',
            meloFeedback:
                'Alguns ve\u00edculos podem estar convertendo.ADULT_M_W1Alguns ve\u00edculos podem estar convertendo.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'Alguns ve\u00edculos podem estar convertendo.ADULT_WRONG2Alguns ve\u00edculos podem estar convertendo.',
            isCorrect: false,
            consequenceText:
                'Alguns ve\u00edculos podem estar convertendo.ADULT_C_W2Alguns ve\u00edculos podem estar convertendo.',
            meloFeedback:
                'Alguns ve\u00edculos podem estar convertendo.ADULT_M_W2Alguns ve\u00edculos podem estar convertendo.',
          ),
        ],
      );
  }
}
