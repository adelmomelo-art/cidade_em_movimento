import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone3Mission03(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z3_M03',
        title: 'Desembarque na Orla',
        description: 'Aprenda a sair do ve\u00edculo pelo lado mais seguro.',
        sceneText: 'O carro para perto da orla e voc\u00ea vai desembarcar.',
        question: 'Qual cuidado vem primeiro?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text: 'Espero o adulto indicar e observo antes de abrir a porta.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea evita abrir a porta na passagem de ciclistas ou ve\u00edculos.',
            meloFeedback:
                'Muito bem. Antes de abrir a porta, observe o entorno.',
          ),
          MissionOption(
            id: 'child_wrong_fast',
            text: 'Abro a porta assim que o carro para.',
            isCorrect: false,
            consequenceText: 'Uma bicicleta passa muito perto.',
            meloFeedback:
                'Parar o carro n\u00e3o significa que o entorno esteja livre.',
          ),
          MissionOption(
            id: 'child_wrong_side',
            text: 'Saio pelo lado mais perto da praia sem olhar.',
            isCorrect: false,
            consequenceText: 'Esse lado pode ter fluxo de bicicletas.',
            meloFeedback: 'Observe antes de escolher por onde sair.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z3_M03',
        title: 'Desembarque na Orla',
        description: 'Evite abrir porta ou desembarcar sem observar ciclistas.',
        sceneText:
            'Voc\u00ea est\u00e1 no banco do passageiro e h\u00e1 ciclovia ao lado.',
        question: 'Como desembarcar com seguran\u00e7a?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Olho para tr\u00e1s e para o espelho antes de abrir a porta.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea percebe o ciclista e espera sua passagem.',
            meloFeedback:
                'Boa. Uma porta aberta sem observa\u00e7\u00e3o pode virar uma barreira repentina.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text: 'Abro a porta enquanto termino de olhar o celular.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea n\u00e3o percebe quem se aproxima.',
            meloFeedback:
                'Ao desembarcar, sua aten\u00e7\u00e3o precisa estar no entorno.',
          ),
          MissionOption(
            id: 'teen_wrong_quick',
            text:
                'Abro rapidamente para sair antes que algu\u00e9m se aproxime.',
            isCorrect: false,
            consequenceText:
                'A rapidez reduz sua capacidade de verificar o risco.',
            meloFeedback: 'Primeiro observe, depois abra.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z3_M03',
        title: 'Desembarque na Orla',
        description:
            'Escolha ponto de parada que n\u00e3o crie conflito com a ciclovia.',
        sceneText:
            'Voc\u00ea vai deixar um passageiro em uma \u00e1rea muito movimentada.',
        question: 'Qual \u00e9 a melhor decis\u00e3o?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Procuro um local adequado e oriento o passageiro a observar antes de abrir a porta.',
            isCorrect: true,
            consequenceText:
                'O desembarque ocorre sem bloquear a circula\u00e7\u00e3o.',
            meloFeedback:
                'Boa escolha. Parada adequada e orienta\u00e7\u00e3o evitam conflitos.',
          ),
          MissionOption(
            id: 'adult_wrong_bike',
            text:
                'Paro rapidamente sobre a ciclovia porque ser\u00e1 s\u00f3 um instante.',
            isCorrect: false,
            consequenceText:
                'Ciclistas precisam desviar para fora de sua rota.',
            meloFeedback:
                'Poucos segundos ainda podem criar risco e obstru\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'adult_wrong_double',
            text: 'Paro em fila dupla com alerta ligado.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea cria conflito para outros ve\u00edculos e passageiros.',
            meloFeedback:
                'Sinalizar n\u00e3o transforma um local inadequado em seguro.',
          ),
        ],
      );
  }
}
