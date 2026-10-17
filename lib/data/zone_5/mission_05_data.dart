import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5Mission05(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_M05',
        title: 'Fluxo Intenso',
        description: 'Observe a situação e escolha uma atitude segura.',
        sceneText:
            'Você e um adulto caminham junto a uma avenida congestionada. Há carros e motos na via.',
        question: 'Como chegar ao outro lado?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Continuo pela calçada com o adulto até uma travessia segura.',
            isCorrect: true,
            consequenceText:
                'Você mantém espaço e visibilidade para lidar com mudanças no trânsito.',
            meloFeedback:
                'Congestionamento não significa ausência de movimento. Preserve as travessias e observe motos, bicicletas e pedestres.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Passo entre os carros porque a fila está parada.',
            isCorrect: false,
            consequenceText:
                'Você pode entrar no caminho de alguém que ainda está em movimento.',
            meloFeedback:
                'Evite decisões bruscas entre filas. Veículos parados podem esconder outros usuários da via.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Sigo alguém que está correndo entre os veículos.',
            isCorrect: false,
            consequenceText:
                'Você ocupa um espaço de circulação ou travessia e aumenta os conflitos.',
            meloFeedback:
                'Cada pessoa precisa de espaço seguro. Não use a pista como atalho nem bloqueie a passagem de pedestres.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_M05',
        title: 'Fluxo Intenso',
        description: 'Avalie os movimentos da via antes de decidir.',
        sceneText:
            'O trânsito está parado, mas motos e bicicletas ainda circulam entre os veículos.',
        question: 'Qual atitude você escolhe?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Uso uma travessia com visibilidade e observo todos os movimentos.',
            isCorrect: true,
            consequenceText:
                'Você mantém espaço e visibilidade para lidar com mudanças no trânsito.',
            meloFeedback:
                'Congestionamento não significa ausência de movimento. Preserve as travessias e observe motos, bicicletas e pedestres.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'Atravesso entre os carros sem olhar, pois estão parados.',
            isCorrect: false,
            consequenceText:
                'Você pode entrar no caminho de alguém que ainda está em movimento.',
            meloFeedback:
                'Evite decisões bruscas entre filas. Veículos parados podem esconder outros usuários da via.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Desço da calçada para caminhar pelo espaço entre as filas.',
            isCorrect: false,
            consequenceText:
                'Você ocupa um espaço de circulação ou travessia e aumenta os conflitos.',
            meloFeedback:
                'Cada pessoa precisa de espaço seguro. Não use a pista como atalho nem bloqueie a passagem de pedestres.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_M05',
        title: 'Fluxo Intenso',
        description: 'Planeje sua ação considerando os demais usuários.',
        sceneText:
            'Você dirige em uma avenida congestionada. Outros condutores disputam espaços.',
        question: 'Como contribuir para um trânsito seguro?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Mantenho distância, evito mudanças bruscas e deixo as travessias livres.',
            isCorrect: true,
            consequenceText:
                'Você mantém espaço e visibilidade para lidar com mudanças no trânsito.',
            meloFeedback:
                'Congestionamento não significa ausência de movimento. Preserve as travessias e observe motos, bicicletas e pedestres.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text: 'Troco de faixa repetidamente para ganhar alguns metros.',
            isCorrect: false,
            consequenceText:
                'As mudanças repetidas criam conflitos com os veículos ao lado.',
            meloFeedback:
                'Evite disputar espaços. Planeje a mudança de faixa e só a realize com segurança.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'Avanço sobre a faixa de pedestres mesmo sem espaço depois dela.',
            isCorrect: false,
            consequenceText:
                'Você ocupa um espaço de circulação ou travessia e aumenta os conflitos.',
            meloFeedback:
                'Cada pessoa precisa de espaço seguro. Não use a pista como atalho nem bloqueie a passagem de pedestres.',
          ),
        ],
      );
  }
}
