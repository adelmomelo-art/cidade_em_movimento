import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone5Mission04(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z5_M04',
        title: 'Acesso e Convers\u00e3o',
        description: 'Observe a situação e escolha uma atitude segura.',
        sceneText:
            'Você e um adulto chegam a uma esquina. Um carro se aproxima para virar.',
        question: 'Antes de atravessar, o que fazer?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Espero na calçada com o adulto e observo se o carro vai parar.',
            isCorrect: true,
            consequenceText:
                'Você observa a conversão e evita disputar o mesmo espaço.',
            meloFeedback:
                'Nas esquinas, observe também quem está virando. O cuidado com a travessia continua durante a conversão.',
          ),
          MissionOption(
            id: 'child_wrong_1',
            text: 'Entro na rua porque o carro está dando seta.',
            isCorrect: false,
            consequenceText:
                'Você pode entrar em conflito com quem cruza seu caminho.',
            meloFeedback:
                'Seta não significa parada e pressa não elimina o risco. Verifique o movimento antes de avançar.',
          ),
          MissionOption(
            id: 'child_wrong_2',
            text: 'Corro na frente do carro para ele esperar.',
            isCorrect: false,
            consequenceText:
                'Você deixa de perceber parte dos movimentos da esquina.',
            meloFeedback:
                'Olhe todo o entorno. A faixa e a sinalização não substituem a atenção aos demais usuários.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z5_M04',
        title: 'Acesso e Convers\u00e3o',
        description: 'Avalie os movimentos da via antes de decidir.',
        sceneText:
            'Você chega a uma faixa perto de uma esquina. Há veículos fazendo conversão.',
        question: 'Como iniciar a travessia?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Observo o sinal e os veículos que viram; só avanço com a passagem segura.',
            isCorrect: true,
            consequenceText:
                'Você observa a conversão e evita disputar o mesmo espaço.',
            meloFeedback:
                'Nas esquinas, observe também quem está virando. O cuidado com a travessia continua durante a conversão.',
          ),
          MissionOption(
            id: 'teen_wrong_1',
            text: 'Olho apenas para os veículos que seguem em frente.',
            isCorrect: false,
            consequenceText:
                'Você pode deixar de perceber um veículo que está virando.',
            meloFeedback:
                'Observe os veículos de todas as direções, inclusive os que fazem conversão.',
          ),
          MissionOption(
            id: 'teen_wrong_2',
            text: 'Atravesso sem observar porque estou na faixa.',
            isCorrect: false,
            consequenceText:
                'Você deixa de perceber parte dos movimentos da esquina.',
            meloFeedback:
                'Olhe todo o entorno. A faixa e a sinalização não substituem a atenção aos demais usuários.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z5_M04',
        title: 'Acesso e Convers\u00e3o',
        description: 'Planeje sua ação considerando os demais usuários.',
        sceneText:
            'Você dirige e vai virar em uma esquina com faixa de pedestres.',
        question: 'Como realizar a conversão?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Sinalizo, reduzo e aguardo os pedestres concluírem a travessia antes de virar.',
            isCorrect: true,
            consequenceText:
                'Você observa a conversão e evita disputar o mesmo espaço.',
            meloFeedback:
                'Nas esquinas, observe também quem está virando. O cuidado com a travessia continua durante a conversão.',
          ),
          MissionOption(
            id: 'adult_wrong_1',
            text: 'Viro rapidamente para passar antes dos pedestres.',
            isCorrect: false,
            consequenceText:
                'Você disputa o espaço da travessia com pedestres.',
            meloFeedback:
                'Aguarde a travessia dos pedestres. A pressa na conversão aumenta o risco de atropelamento.',
          ),
          MissionOption(
            id: 'adult_wrong_2',
            text: 'Olho apenas os carros atrás e começo a conversão.',
            isCorrect: false,
            consequenceText:
                'Você deixa de perceber parte dos movimentos da esquina.',
            meloFeedback:
                'Olhe todo o entorno. A faixa e a sinalização não substituem a atenção aos demais usuários.',
          ),
        ],
      );
  }
}
