import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5SpecialMission(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_SPECIAL',
        title: 'Corredor em Equil\u00edbrio',
        description: 'Observe a situação e escolha uma atitude segura.',
        sceneText:
            'No caminho com um adulto, você encontra uma avenida movimentada e um ônibus perto da esquina.',
        question: 'Qual plano reúne os cuidados aprendidos?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Fico na calçada e busco com o adulto uma travessia sinalizada e com boa visão.',
            isCorrect: true,
            consequenceText:
                'Você combina observação, planejamento e respeito ao espaço dos outros.',
            meloFeedback:
                'Nas grandes vias, avalie velocidade, distância, visibilidade e conversões em conjunto. Uma decisão segura considera todo o entorno.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Passo na frente do ônibus para encurtar o caminho.',
            isCorrect: false,
            consequenceText:
                'Você avança com informação insuficiente sobre o que acontece ao redor.',
            meloFeedback:
                'Não confie apenas em uma brecha ou na reação dos outros. Antecipe os riscos antes de agir.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Corro entre os carros quando surge um pequeno espaço.',
            isCorrect: false,
            consequenceText:
                'Você pode entrar em um ponto cego ou em um espaço já ocupado.',
            meloFeedback:
                'Antes de mudar de posição, verifique se pode observar e ser visto. Ônibus e caminhões exigem atenção extra.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_SPECIAL',
        title: 'Corredor em Equil\u00edbrio',
        description: 'Avalie os movimentos da via antes de decidir.',
        sceneText:
            'Você precisa cruzar uma avenida. Um ônibus limita a visão e há carros fazendo conversão.',
        question: 'Qual plano é mais seguro?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Busco a travessia, observo o sinal, a visibilidade e os veículos antes de avançar.',
            isCorrect: true,
            consequenceText:
                'Você combina observação, planejamento e respeito ao espaço dos outros.',
            meloFeedback:
                'Nas grandes vias, avalie velocidade, distância, visibilidade e conversões em conjunto. Uma decisão segura considera todo o entorno.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text:
                'Aproveito a primeira brecha sem verificar os veículos que viram.',
            isCorrect: false,
            consequenceText:
                'Você avança com informação insuficiente sobre o que acontece ao redor.',
            meloFeedback:
                'Não confie apenas em uma brecha ou na reação dos outros. Antecipe os riscos antes de agir.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Sigo o grupo que atravessa atrás do ônibus.',
            isCorrect: false,
            consequenceText:
                'Você pode entrar em um ponto cego ou em um espaço já ocupado.',
            meloFeedback:
                'Antes de mudar de posição, verifique se pode observar e ser visto. Ônibus e caminhões exigem atenção extra.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_SPECIAL',
        title: 'Corredor em Equil\u00edbrio',
        description: 'Planeje sua ação considerando os demais usuários.',
        sceneText:
            'Você dirige por um corredor movimentado, com ônibus, acessos e travessias de pedestres.',
        question: 'Como combinar os cuidados desta zona?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Ajusto a velocidade, mantenho distância e verifico pontos cegos e travessias.',
            isCorrect: true,
            consequenceText:
                'Você combina observação, planejamento e respeito ao espaço dos outros.',
            meloFeedback:
                'Nas grandes vias, avalie velocidade, distância, visibilidade e conversões em conjunto. Uma decisão segura considera todo o entorno.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text:
                'Mantenho a velocidade e confio que todos evitarão meu caminho.',
            isCorrect: false,
            consequenceText:
                'Você avança com informação insuficiente sobre o que acontece ao redor.',
            meloFeedback:
                'Não confie apenas em uma brecha ou na reação dos outros. Antecipe os riscos antes de agir.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'Mudo de faixa junto ao ônibus sem verificar o espaço ao redor.',
            isCorrect: false,
            consequenceText:
                'Você pode entrar em um ponto cego ou em um espaço já ocupado.',
            meloFeedback:
                'Antes de mudar de posição, verifique se pode observar e ser visto. Ônibus e caminhões exigem atenção extra.',
          ),
        ],
      );
  }
}
