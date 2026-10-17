import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5Mission02(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_M02',
        title: 'Ponto Cego',
        description: 'Observe a situação e escolha uma atitude segura.',
        sceneText:
            'Você está na calçada com um adulto. Um caminhão parado encobre parte da rua.',
        question: 'O que fazer antes de atravessar?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Fico na calçada e vou com o adulto até uma travessia com boa visão.',
            isCorrect: true,
            consequenceText:
                'Você evita atravessar junto ao veículo que impede a visão.',
            meloFeedback:
                'Pontos cegos são áreas que o motorista pode não enxergar. Busque boa visibilidade para observar e ser visto.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Passo bem perto da frente do caminhão.',
            isCorrect: false,
            consequenceText:
                'Você fica muito próximo de um veículo que pode começar a se mover.',
            meloFeedback:
                'Um veículo parado pode sair ou manobrar. Evite atravessar rente a ônibus e caminhões.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Atravesso atrás do caminhão sem olhar o restante da via.',
            isCorrect: false,
            consequenceText:
                'Você pode surpreender um motorista ou não perceber uma manobra.',
            meloFeedback:
                'Não suponha que foi visto. Espere em local protegido e procure uma travessia com boa visão.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_M02',
        title: 'Ponto Cego',
        description: 'Avalie os movimentos da via antes de decidir.',
        sceneText:
            'Você caminha perto de um ônibus parado. O veículo esconde o trânsito que vem ao lado.',
        question: 'Como evitar o ponto cego?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Permaneço na calçada e procuro uma travessia com visibilidade.',
            isCorrect: true,
            consequenceText:
                'Você evita atravessar junto ao veículo que impede a visão.',
            meloFeedback:
                'Pontos cegos são áreas que o motorista pode não enxergar. Busque boa visibilidade para observar e ser visto.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'Passo rente ao ônibus porque ele está parado.',
            isCorrect: false,
            consequenceText:
                'Você fica muito próximo de um veículo que pode começar a se mover.',
            meloFeedback:
                'Um veículo parado pode sair ou manobrar. Evite atravessar rente a ônibus e caminhões.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Confio que o motorista me viu e atravesso imediatamente.',
            isCorrect: false,
            consequenceText:
                'Você pode surpreender um motorista ou não perceber uma manobra.',
            meloFeedback:
                'Não suponha que foi visto. Espere em local protegido e procure uma travessia com boa visão.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_M02',
        title: 'Ponto Cego',
        description: 'Planeje sua ação considerando os demais usuários.',
        sceneText:
            'A pé, você chega ao lado de um caminhão. Não consegue observar toda a via.',
        question: 'Como seguir com segurança?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Afasto-me pela calçada até uma travessia com boa visibilidade e verifico o trânsito.',
            isCorrect: true,
            consequenceText:
                'Você evita atravessar junto ao veículo que impede a visão.',
            meloFeedback:
                'Pontos cegos são áreas que o motorista pode não enxergar. Busque boa visibilidade para observar e ser visto.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text: 'Atravesso junto à cabine, supondo que o motorista me veja.',
            isCorrect: false,
            consequenceText:
                'Você fica muito próximo de um veículo que pode começar a se mover.',
            meloFeedback:
                'Um veículo parado pode sair ou manobrar. Evite atravessar rente a ônibus e caminhões.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'Passo por trás do caminhão enquanto ele pode iniciar uma manobra.',
            isCorrect: false,
            consequenceText:
                'Você pode surpreender um motorista ou não perceber uma manobra.',
            meloFeedback:
                'Não suponha que foi visto. Espere em local protegido e procure uma travessia com boa visão.',
          ),
        ],
      );
  }
}
