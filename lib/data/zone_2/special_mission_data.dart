import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone2SpecialMission(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z2_SPECIAL',
        title: 'Centro em Harmonia',
        description:
            'Use tudo o que aprendeu para circular por um Centro movimentado.',
        sceneText:
            'No entorno do Mercado Central e da Catedral, pedestres, bicicletas, \u00f4nibus e carros dividem o espa\u00e7o.',
        question:
            'Qual conjunto de atitudes ajuda a cidade a funcionar melhor?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Observo antes de atravessar, respeito a passagem dos outros e uso os espa\u00e7os seguros.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea circula com previsibilidade e ajuda a reduzir conflitos ao seu redor.',
            meloFeedback:
                'Excelente. Cidadania no tr\u00e2nsito aparece em v\u00e1rias pequenas escolhas feitas em conjunto.',
          ),
          MissionOption(
            id: 'child_wrong_hurry',
            text:
                'Fa\u00e7o tudo rapidamente para sair logo da \u00e1rea movimentada.',
            isCorrect: false,
            consequenceText:
                'A pressa faz voc\u00ea perceber menos informa\u00e7\u00f5es do ambiente.',
            meloFeedback:
                'Em locais movimentados, desacelerar a decis\u00e3o ajuda voc\u00ea a enxergar melhor os riscos.',
          ),
          MissionOption(
            id: 'child_wrong_follow',
            text:
                'Sigo quem parece conhecer o caminho e n\u00e3o me preocupo em observar.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea passa a depender das escolhas de outra pessoa.',
            meloFeedback:
                'Observe o ambiente e participe da sua pr\u00f3pria seguran\u00e7a.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z2_SPECIAL',
        title: 'Centro em Harmonia',
        description:
            'Integre aten\u00e7\u00e3o, acessibilidade, transporte coletivo e mobilidade.',
        sceneText:
            'Voc\u00ea atravessa uma regi\u00e3o central com muitos fluxos simult\u00e2neos e pessoas com necessidades diferentes.',
        question:
            'Qual comportamento representa melhor a conviv\u00eancia urbana?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Mantenho aten\u00e7\u00e3o, respeito o espa\u00e7o dos outros e adapto meu ritmo ao ambiente.',
            isCorrect: true,
            consequenceText:
                'Seu deslocamento se integra ao fluxo sem impor riscos ou barreiras desnecess\u00e1rias.',
            meloFeedback:
                'Muito bem. Mobilidade segura tamb\u00e9m \u00e9 saber conviver e ajustar seu comportamento ao espa\u00e7o coletivo.',
          ),
          MissionOption(
            id: 'teen_wrong_self',
            text: 'Escolho sempre a op\u00e7\u00e3o mais r\u00e1pida para mim.',
            isCorrect: false,
            consequenceText:
                'Sua rota interfere em outros usu\u00e1rios e cria novos conflitos.',
            meloFeedback:
                'Cidade compartilhada exige considerar o efeito da sua escolha sobre outras pessoas.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text:
                'Uso o celular enquanto sigo o fluxo porque todos est\u00e3o andando devagar.',
            isCorrect: false,
            consequenceText:
                'Sua aten\u00e7\u00e3o cai justamente em um ambiente com muitos movimentos simult\u00e2neos.',
            meloFeedback:
                'Velocidade baixa n\u00e3o elimina a necessidade de aten\u00e7\u00e3o.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z2_SPECIAL',
        title: 'Centro em Harmonia',
        description:
            'Integre leitura de risco, acessibilidade, parada adequada e respeito aos diferentes modos.',
        sceneText:
            'Voc\u00ea circula pelo Centro em um momento de grande movimento, com pedestres, ciclistas e transporte coletivo.',
        question:
            'Qual postura resume melhor uma condu\u00e7\u00e3o cidad\u00e3?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo quando necess\u00e1rio, preservo os espa\u00e7os dos demais e priorizo previsibilidade e seguran\u00e7a.',
            isCorrect: true,
            consequenceText:
                'Sua condu\u00e7\u00e3o cria margem para que os diferentes usu\u00e1rios se movimentem com menos conflito.',
            meloFeedback:
                'Excelente. Conduzir bem em uma cidade movimentada \u00e9 antecipar, respeitar e compartilhar o espa\u00e7o.',
          ),
          MissionOption(
            id: 'adult_wrong_speed',
            text:
                'Mantenho meu ritmo para n\u00e3o atrapalhar o fluxo de ve\u00edculos.',
            isCorrect: false,
            consequenceText:
                'O foco apenas no fluxo dos carros reduz sua aten\u00e7\u00e3o aos demais usu\u00e1rios.',
            meloFeedback:
                'O tr\u00e2nsito inclui todos. Ajuste sua condu\u00e7\u00e3o ao ambiente completo.',
          ),
          MissionOption(
            id: 'adult_wrong_convenience',
            text:
                'Fa\u00e7o paradas r\u00e1pidas quando precisar, desde que sinalize.',
            isCorrect: false,
            consequenceText:
                'As paradas podem criar barreiras e obrigar outros a mudar de trajet\u00f3ria.',
            meloFeedback:
                'A conveni\u00eancia de um n\u00e3o deve virar dificuldade para muitos.',
          ),
        ],
      );
  }
}
