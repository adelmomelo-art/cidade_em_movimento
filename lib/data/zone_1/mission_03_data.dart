import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone1Mission03(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z1_M03',
        title: 'Bicicleta na Rota Escolar',
        description:
            'Aprenda a pedalar com aten\u00e7\u00e3o, previsibilidade e '
            'seguran\u00e7a no caminho para a escola.',
        sceneText:
            'Voc\u00ea est\u00e1 de bicicleta a caminho da escola. '
            'Mais \u00e0 frente h\u00e1 uma esquina com movimento de '
            'pedestres e ve\u00edculos.',
        question: 'Qual \u00e9 a atitude mais segura?',
        maxCitizenship: 25,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Reduzo a velocidade, observo a esquina e sigo de forma '
                'previs\u00edvel.',
            isCorrect: true,
            consequenceText:
                'Ao reduzir e observar, voc\u00ea percebe melhor o movimento '
                'e consegue seguir com mais seguran\u00e7a.',
            meloFeedback:
                'Muito bem! Na bicicleta, ser previs\u00edvel e observar '
                'antes de mudar de dire\u00e7\u00e3o ajuda todos a entender '
                'seu movimento.',
          ),
          MissionOption(
            id: 'child_wrong_fast',
            text: 'Acelero para passar pela esquina antes dos outros.',
            isCorrect: false,
            consequenceText:
                'Com mais velocidade, sobra menos tempo para perceber '
                'pedestres, ve\u00edculos ou algum obst\u00e1culo.',
            meloFeedback:
                'A pressa reduz seu tempo de rea\u00e7\u00e3o. '
                'Reduza a velocidade e observe antes de seguir.',
          ),
          MissionOption(
            id: 'child_wrong_unpredictable',
            text:
                'Mudo de dire\u00e7\u00e3o de repente para desviar do movimento.',
            isCorrect: false,
            consequenceText:
                'A mudan\u00e7a repentina surpreende quem est\u00e1 '
                'compartilhando o espa\u00e7o com voc\u00ea.',
            meloFeedback:
                'Movimentos previs\u00edveis ajudam a evitar conflitos. '
                'Observe, reduza e sinalize sua inten\u00e7\u00e3o quando puder.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z1_M03',
        title: 'Bicicleta na Rota Escolar',
        description:
            'Pratique uma condu\u00e7\u00e3o previs\u00edvel e segura da bicicleta '
            'no deslocamento escolar.',
        sceneText:
            'Voc\u00ea pedala para a escola e se aproxima de um trecho '
            'com cruzamento, pedestres e outros ve\u00edculos.',
        question: 'Como voc\u00ea deve agir?',
        maxCitizenship: 25,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Reduzo, observo o fluxo e mantenho uma trajet\u00f3ria '
                'previs\u00edvel.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea entra no trecho com mais controle e os demais '
                'usu\u00e1rios conseguem compreender melhor sua trajet\u00f3ria.',
            meloFeedback:
                'Boa escolha. Na bicicleta, previsibilidade, observa\u00e7\u00e3o '
                'e velocidade compat\u00edvel s\u00e3o fundamentais para '
                'compartilhar a via com seguran\u00e7a.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text: 'Continuo pedalando enquanto olho rapidamente o celular.',
            isCorrect: false,
            consequenceText:
                'Sua aten\u00e7\u00e3o deixa a via por alguns segundos e '
                'voc\u00ea demora mais para perceber uma mudan\u00e7a no fluxo.',
            meloFeedback:
                'Durante o deslocamento, sua aten\u00e7\u00e3o precisa estar '
                'no ambiente. Pare em local seguro antes de usar o celular.',
          ),
          MissionOption(
            id: 'teen_wrong_weave',
            text:
                'Fa\u00e7o movimentos r\u00e1pidos entre os espa\u00e7os para '
                'passar mais depressa.',
            isCorrect: false,
            consequenceText:
                'Os movimentos sucessivos tornam sua trajet\u00f3ria dif\u00edcil '
                'de prever para os demais.',
            meloFeedback:
                'Ser previs\u00edvel aumenta sua seguran\u00e7a. '
                'Evite mudan\u00e7as bruscas e observe antes de agir.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z1_M03',
        title: 'Bicicleta na Rota Escolar',
        description:
            'Reconhe\u00e7a a vulnerabilidade do ciclista e compartilhe '
            'a via com dist\u00e2ncia e aten\u00e7\u00e3o.',
        sceneText:
            'Voc\u00ea dirige pr\u00f3ximo \u00e0 escola. '
            'Um ciclista segue \u00e0 frente pelo mesmo trecho da via.',
        question: 'Qual \u00e9 a conduta mais segura?',
        maxCitizenship: 25,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo, mantenho dist\u00e2ncia segura e s\u00f3 ultrapasso '
                'quando houver espa\u00e7o adequado.',
            isCorrect: true,
            consequenceText:
                'A dist\u00e2ncia preservada permite que o ciclista siga '
                'com estabilidade e oferece mais margem para rea\u00e7\u00e3o.',
            meloFeedback:
                'Boa decis\u00e3o. O ciclista \u00e9 mais vulner\u00e1vel. '
                'Mantenha dist\u00e2ncia lateral e longitudinal segura e '
                'espere uma condi\u00e7\u00e3o adequada para ultrapassar.',
          ),
          MissionOption(
            id: 'adult_wrong_close',
            text:
                'Aproximo o carro para incentivar o ciclista a sair da frente.',
            isCorrect: false,
            consequenceText:
                'A proximidade excessiva reduz a margem de seguran\u00e7a '
                'e pode assustar o ciclista.',
            meloFeedback:
                'Pressionar um ciclista aumenta o risco. '
                'Mantenha dist\u00e2ncia e respeite o espa\u00e7o necess\u00e1rio.',
          ),
          MissionOption(
            id: 'adult_wrong_pass',
            text:
                'Ultrapasso imediatamente, mesmo com pouco espa\u00e7o lateral.',
            isCorrect: false,
            consequenceText:
                'A passagem muito pr\u00f3xima deixa pouca margem para qualquer '
                'movimento do ciclista ou do seu ve\u00edculo.',
            meloFeedback:
                'Espere uma condi\u00e7\u00e3o segura. '
                'Uma ultrapassagem s\u00f3 deve ocorrer com espa\u00e7o '
                'suficiente e velocidade compat\u00edvel.',
          ),
        ],
      );
  }
}
