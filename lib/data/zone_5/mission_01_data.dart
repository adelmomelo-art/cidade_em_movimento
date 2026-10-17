import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5Mission01(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_M01',
        title: 'Travessia de Grande Avenida',
        description: 'Observe a situação e escolha uma atitude segura.',
        sceneText:
            'Você e um adulto chegam a uma avenida larga. Há uma faixa com semáforo mais adiante.',
        question: 'Como atravessar essa avenida?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Vou com o adulto até a faixa e espero o sinal de pedestres e a parada dos veículos.',
            isCorrect: true,
            consequenceText:
                'Você busca uma travessia com melhores condições para observar e ser visto.',
            meloFeedback:
                'Em avenidas largas, um veículo pode esconder outro. Observe todas as faixas antes de atravessar.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Corro pela avenida quando vejo um espaço entre os carros.',
            isCorrect: false,
            consequenceText:
                'Você se expõe a veículos que podem chegar antes do esperado.',
            meloFeedback:
                'Uma brecha pode enganar. Prefira a travessia sinalizada e não tente vencer os carros na corrida.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Sigo quem atravessa fora da faixa, sem observar o trânsito.',
            isCorrect: false,
            consequenceText:
                'Você pode entrar na via sem perceber um veículo se aproximando.',
            meloFeedback:
                'A decisão de outra pessoa não garante sua segurança. Observe o trânsito antes de avançar.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_M01',
        title: 'Travessia de Grande Avenida',
        description: 'Avalie os movimentos da via antes de decidir.',
        sceneText:
            'Você vai encontrar amigos do outro lado da avenida. A faixa com semáforo fica mais adiante.',
        question: 'Qual caminho você escolhe?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Uso a faixa, aguardo o sinal de pedestres e verifico se os veículos pararam.',
            isCorrect: true,
            consequenceText:
                'Você busca uma travessia com melhores condições para observar e ser visto.',
            meloFeedback:
                'Em avenidas largas, um veículo pode esconder outro. Observe todas as faixas antes de atravessar.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'Calculo uma brecha e corro entre os veículos.',
            isCorrect: false,
            consequenceText:
                'Você se expõe a veículos que podem chegar antes do esperado.',
            meloFeedback:
                'Uma brecha pode enganar. Prefira a travessia sinalizada e não tente vencer os carros na corrida.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Atravesso olhando o celular para avisar que estou chegando.',
            isCorrect: false,
            consequenceText:
                'O celular desvia sua atenção dos veículos durante a travessia.',
            meloFeedback:
                'Pare em local seguro para usar o celular. Ao atravessar, mantenha a atenção no trânsito.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_M01',
        title: 'Travessia de Grande Avenida',
        description: 'Planeje sua ação considerando os demais usuários.',
        sceneText:
            'Você está a pé e precisa cruzar uma avenida com várias faixas e travessia sinalizada próxima.',
        question: 'Qual é a decisão mais segura?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Sigo até a travessia e observo o sinal de pedestres e a parada em todas as faixas.',
            isCorrect: true,
            consequenceText:
                'Você busca uma travessia com melhores condições para observar e ser visto.',
            meloFeedback:
                'Em avenidas largas, um veículo pode esconder outro. Observe todas as faixas antes de atravessar.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text:
                'Atravesso fora da faixa porque o primeiro carro parece distante.',
            isCorrect: false,
            consequenceText:
                'Você se expõe a veículos que podem chegar antes do esperado.',
            meloFeedback:
                'Uma brecha pode enganar. Prefira a travessia sinalizada e não tente vencer os carros na corrida.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text:
                'Inicio a travessia assim que um veículo reduz, sem verificar as outras faixas.',
            isCorrect: false,
            consequenceText:
                'Um veículo de outra faixa pode continuar avançando.',
            meloFeedback:
                'A parada de um carro não garante a parada dos demais. Observe todas as faixas.',
          ),
        ],
      );
  }
}
