import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone3Mission01(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z3_M01',
        title: 'Travessia na Beira-Mar',
        description:
            'Aprenda a atravessar com aten\u00e7\u00e3o em uma orla movimentada.',
        sceneText:
            'Voc\u00ea est\u00e1 no cal\u00e7ad\u00e3o e precisa atravessar uma via '
            'com bicicletas e ve\u00edculos pr\u00f3ximos.',
        question: 'Qual \u00e9 a atitude mais segura antes de atravessar?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Paro, observo todos os sentidos e uso o local indicado para a travessia.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea identifica os diferentes fluxos antes de entrar na via.',
            meloFeedback:
                'Muito bem. Na orla, pedestres, ciclistas e ve\u00edculos podem vir de dire\u00e7\u00f5es diferentes.',
          ),
          MissionOption(
            id: 'child_wrong_follow',
            text: 'Atravesso junto com outras pessoas sem olhar.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea depende da decis\u00e3o de outras pessoas e deixa de observar o ambiente.',
            meloFeedback:
                'Fa\u00e7a sempre sua pr\u00f3pria leitura antes de atravessar.',
          ),
          MissionOption(
            id: 'child_wrong_run',
            text: 'Corro para passar antes dos ve\u00edculos.',
            isCorrect: false,
            consequenceText:
                'A pressa reduz seu tempo para perceber mudan\u00e7as no fluxo.',
            meloFeedback:
                'Seguran\u00e7a vem de observar e escolher o momento correto.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z3_M01',
        title: 'Travessia na Beira-Mar',
        description:
            'Pratique aten\u00e7\u00e3o total ao atravessar em uma \u00e1rea tur\u00edstica.',
        sceneText:
            'Voc\u00ea se aproxima da travessia enquanto recebe uma mensagem no celular.',
        question: 'Qual atitude reduz melhor o risco?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Guardo o celular, observo os fluxos e atravesso apenas quando estiver seguro.',
            isCorrect: true,
            consequenceText:
                'Sua aten\u00e7\u00e3o volta completamente para o ambiente.',
            meloFeedback:
                'Boa escolha. Em travessias movimentadas, aten\u00e7\u00e3o dividida aumenta o risco.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text: 'Continuo lendo a mensagem porque a travessia parece livre.',
            isCorrect: false,
            consequenceText:
                'Uma bicicleta se aproxima pelo lado que voc\u00ea deixou de observar.',
            meloFeedback:
                'A orla tem fluxos diferentes. Olhe para o ambiente, n\u00e3o para a tela.',
          ),
          MissionOption(
            id: 'teen_wrong_group',
            text: 'Sigo o grupo que est\u00e1 atravessando.',
            isCorrect: false,
            consequenceText:
                'O grupo muda de ritmo e voc\u00ea fica sem refer\u00eancia pr\u00f3pria.',
            meloFeedback:
                'Sua seguran\u00e7a depende da sua pr\u00f3pria observa\u00e7\u00e3o.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z3_M01',
        title: 'Travessia na Beira-Mar',
        description:
            'Antecipe conflitos com pedestres em uma travessia de grande movimento.',
        sceneText:
            'Voc\u00ea dirige pela orla e se aproxima de uma travessia com muitos pedestres.',
        question: 'Qual conduta oferece maior margem de seguran\u00e7a?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo com anteced\u00eancia e deixo claro que vou respeitar a travessia.',
            isCorrect: true,
            consequenceText:
                'Pedestres percebem sua aproxima\u00e7\u00e3o de forma previs\u00edvel.',
            meloFeedback:
                'Excelente. Previsibilidade e redu\u00e7\u00e3o antecipada protegem quem est\u00e1 mais vulner\u00e1vel.',
          ),
          MissionOption(
            id: 'adult_wrong_gap',
            text: 'Passo antes que o grupo chegue totalmente \u00e0 faixa.',
            isCorrect: false,
            consequenceText:
                'A margem diminui e um pedestre pode mudar de ritmo.',
            meloFeedback: 'Evite transformar uma pequena brecha em risco.',
          ),
          MissionOption(
            id: 'adult_wrong_horn',
            text: 'Buzino para avisar que estou passando.',
            isCorrect: false,
            consequenceText:
                'O aviso sonoro n\u00e3o substitui a redu\u00e7\u00e3o.',
            meloFeedback:
                'Na aproxima\u00e7\u00e3o de pedestres, reduza e torne sua inten\u00e7\u00e3o previs\u00edvel.',
          ),
        ],
      );
  }
}
