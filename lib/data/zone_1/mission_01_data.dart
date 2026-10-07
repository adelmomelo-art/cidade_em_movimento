import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone1Mission01(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z1_M01',
        title: 'Travessia Segura',
        description:
            'Aprenda a atravessar a rua com aten\u00e7\u00e3o e seguran\u00e7a.',
        sceneText:
            'Voc\u00ea est\u00e1 chegando \u00e0 escola. Existe uma faixa de pedestres logo \u00e0 frente.',
        question: 'O que voc\u00ea faz?',
        maxCitizenship: 20,
        maxKnowledge: 10,
        maxCoins: 15,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Paro, observo os dois lados e atravesso pela faixa com seguran\u00e7a.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea observa a via, espera o momento seguro e atravessa pela faixa.',
            meloFeedback:
                'Muito bem! Antes de atravessar, observe a via e use o local seguro dispon\u00edvel.',
          ),
          MissionOption(
            id: 'child_wrong_run',
            text: 'Corro para atravessar antes que os carros se aproximem.',
            isCorrect: false,
            consequenceText:
                'Ao correr, voc\u00ea reduz o tempo para perceber um ve\u00edculo que possa se aproximar.',
            meloFeedback:
                'A pressa pode esconder riscos. Observe os dois lados antes de iniciar a travessia.',
          ),
          MissionOption(
            id: 'child_wrong_cars',
            text: 'Atravesso entre dois carros estacionados.',
            isCorrect: false,
            consequenceText:
                'Os carros estacionados dificultam que voc\u00ea veja a via e tamb\u00e9m dificultam que os motoristas vejam voc\u00ea.',
            meloFeedback:
                'Entre ve\u00edculos estacionados a visibilidade fica menor. Procure a travessia segura.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z1_M01',
        title: 'Travessia Segura',
        description:
            'Observe a via antes de atravessar e reconhe\u00e7a situa\u00e7\u00f5es de risco.',
        sceneText:
            'Voc\u00ea chega de bicicleta a uma travessia pr\u00f3xima da escola.',
        question: 'Qual \u00e9 a conduta mais segura?',
        maxCitizenship: 20,
        maxKnowledge: 10,
        maxCoins: 15,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Reduzo, observo o tr\u00e2nsito e realizo a travessia com seguran\u00e7a.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea reduz a velocidade, observa a movimenta\u00e7\u00e3o e atravessa sem criar conflito.',
            meloFeedback:
                'Boa escolha. Observar antes de agir ajuda a tornar sua movimenta\u00e7\u00e3o previs\u00edvel e segura.',
          ),
          MissionOption(
            id: 'teen_wrong_fast',
            text: 'Acelero para passar antes dos ve\u00edculos.',
            isCorrect: false,
            consequenceText:
                'A velocidade reduz seu tempo de rea\u00e7\u00e3o e aumenta o risco na travessia.',
            meloFeedback:
                'Chegar primeiro n\u00e3o significa chegar com seguran\u00e7a. Reduza e observe.',
          ),
          MissionOption(
            id: 'teen_wrong_enter',
            text: 'Entro na travessia imediatamente, sem observar.',
            isCorrect: false,
            consequenceText:
                'Um ve\u00edculo se aproxima e voc\u00ea precisa interromper o movimento.',
            meloFeedback:
                'Antes de entrar na via, verifique se a travessia pode ser realizada com seguran\u00e7a.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z1_M01',
        title: 'Travessia Segura',
        description:
            'Reconhe\u00e7a a prioridade e a vulnerabilidade do pedestre.',
        sceneText:
            'Voc\u00ea dirige em frente a uma escola. Um pedestre j\u00e1 iniciou a travessia pela faixa.',
        question: 'O que voc\u00ea faz?',
        maxCitizenship: 20,
        maxKnowledge: 10,
        maxCoins: 15,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo e dou prefer\u00eancia para que o pedestre conclua a travessia.',
            isCorrect: true,
            consequenceText:
                'O ve\u00edculo reduz e o pedestre conclui a travessia com seguran\u00e7a.',
            meloFeedback:
                'Boa decis\u00e3o. O pedestre est\u00e1 em situa\u00e7\u00e3o mais vulner\u00e1vel e deve concluir a travessia com seguran\u00e7a.',
          ),
          MissionOption(
            id: 'adult_wrong_pass',
            text:
                'Passo rapidamente antes que o pedestre chegue \u00e0 minha faixa.',
            isCorrect: false,
            consequenceText:
                'O pedestre precisa interromper a travessia diante da aproxima\u00e7\u00e3o do ve\u00edculo.',
            meloFeedback:
                'Percebeu o risco? Quem j\u00e1 iniciou a travessia precisa concluir o movimento com seguran\u00e7a.',
          ),
          MissionOption(
            id: 'adult_wrong_horn',
            text: 'Buzino para que o pedestre espere.',
            isCorrect: false,
            consequenceText:
                'A buzina pressiona o pedestre e n\u00e3o elimina o risco existente na travessia.',
            meloFeedback:
                'A prioridade aqui \u00e9 a seguran\u00e7a. Reduza e permita a conclus\u00e3o da travessia.',
          ),
        ],
      );
  }
}
