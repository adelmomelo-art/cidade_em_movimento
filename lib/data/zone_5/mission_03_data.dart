import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5Mission03(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_M03',
        title: 'Velocidade e Dist\u00e2ncia',
        description: 'Observe a situação e escolha uma atitude segura.',
        sceneText:
            'Você está na calçada com um adulto. Um carro se aproxima rápido da travessia.',
        question: 'Como agir?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Espero com o adulto e só atravesso quando houver condições seguras.',
            isCorrect: true,
            consequenceText:
                'Você ganha tempo para perceber riscos e agir com segurança.',
            meloFeedback:
                'Quanto maior a velocidade, maior tende a ser a distância necessária para parar. Antecipar a decisão ajuda a evitar conflitos.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Entro na rua porque o carro ainda parece longe.',
            isCorrect: false,
            consequenceText:
                'Você deixa pouco tempo para reagir se o trânsito mudar.',
            meloFeedback:
                'A aparência de distância pode enganar. Não dependa de uma parada repentina do veículo.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Corro para passar antes de o carro chegar.',
            isCorrect: false,
            consequenceText:
                'Você reduz a margem de segurança e depende de uma reação imediata.',
            meloFeedback:
                'Segurança exige tempo e espaço. Correr ou ficar muito perto de outro veículo aumenta o risco.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_M03',
        title: 'Velocidade e Dist\u00e2ncia',
        description: 'Avalie os movimentos da via antes de decidir.',
        sceneText:
            'Você pretende atravessar. Um veículo ainda distante vem em velocidade alta.',
        question: 'O que considerar nessa situação?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Ele pode chegar rápido; aguardo condições seguras na travessia.',
            isCorrect: true,
            consequenceText:
                'Você ganha tempo para perceber riscos e agir com segurança.',
            meloFeedback:
                'Quanto maior a velocidade, maior tende a ser a distância necessária para parar. Antecipar a decisão ajuda a evitar conflitos.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'A distância que vejo garante tempo para atravessar.',
            isCorrect: false,
            consequenceText:
                'Você deixa pouco tempo para reagir se o trânsito mudar.',
            meloFeedback:
                'A aparência de distância pode enganar. Não dependa de uma parada repentina do veículo.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Basta o motorista frear quando eu entrar na pista.',
            isCorrect: false,
            consequenceText:
                'Você reduz a margem de segurança e depende de uma reação imediata.',
            meloFeedback:
                'Segurança exige tempo e espaço. Correr ou ficar muito perto de outro veículo aumenta o risco.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_M03',
        title: 'Velocidade e Dist\u00e2ncia',
        description: 'Planeje sua ação considerando os demais usuários.',
        sceneText:
            'Você dirige e percebe uma fila se formando adiante. O trânsito está ficando mais lento.',
        question: 'Qual atitude reduz o risco de colisão?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo progressivamente e mantenho distância do veículo à frente.',
            isCorrect: true,
            consequenceText:
                'Você ganha tempo para perceber riscos e agir com segurança.',
            meloFeedback:
                'Quanto maior a velocidade, maior tende a ser a distância necessária para parar. Antecipar a decisão ajuda a evitar conflitos.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text: 'Mantenho a velocidade até ficar bem perto da fila.',
            isCorrect: false,
            consequenceText:
                'Você deixa pouco tempo para reagir se o trânsito mudar.',
            meloFeedback:
                'A aparência de distância pode enganar. Não dependa de uma parada repentina do veículo.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'Aproximo-me do veículo da frente para impedir que alguém entre.',
            isCorrect: false,
            consequenceText:
                'Você reduz a margem de segurança e depende de uma reação imediata.',
            meloFeedback:
                'Segurança exige tempo e espaço. Correr ou ficar muito perto de outro veículo aumenta o risco.',
          ),
        ],
      );
  }
}
