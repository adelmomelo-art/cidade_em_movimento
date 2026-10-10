import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone2Mission05(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z2_M05',
        title: 'Rotas que se Encontram',
        description:
            'Observe como diferentes pessoas e ve\u00edculos compartilham o mesmo espa\u00e7o.',
        sceneText:
            'Voc\u00ea chega a um trecho onde passam bicicletas, \u00f4nibus, carros e pedestres.',
        question: 'O que ajuda voc\u00ea a se movimentar com seguran\u00e7a?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Observo cada dire\u00e7\u00e3o, uso os espa\u00e7os seguros e evito movimentos inesperados.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea consegue prever melhor de onde podem surgir conflitos.',
            meloFeedback:
                'Muito bem. Quando muitas rotas se encontram, observar antes de agir faz toda a diferen\u00e7a.',
          ),
          MissionOption(
            id: 'child_wrong_follow',
            text: 'Sigo rapidamente quem estiver na minha frente.',
            isCorrect: false,
            consequenceText:
                'A pessoa muda de dire\u00e7\u00e3o e voc\u00ea fica sem tempo para avaliar o restante do fluxo.',
            meloFeedback: 'Fa\u00e7a sua pr\u00f3pria leitura do ambiente.',
          ),
          MissionOption(
            id: 'child_wrong_shortcut',
            text:
                'Escolho o caminho mais curto, mesmo atravessando entre os fluxos.',
            isCorrect: false,
            consequenceText:
                'O atalho coloca voc\u00ea em uma \u00e1rea com movimentos vindos de v\u00e1rias dire\u00e7\u00f5es.',
            meloFeedback:
                'O caminho mais curto nem sempre \u00e9 o mais seguro.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z2_M05',
        title: 'Rotas que se Encontram',
        description:
            'Pratique conviv\u00eancia entre bicicleta, pedestre e transporte coletivo.',
        sceneText:
            'Voc\u00ea pedala em um trecho de grande movimento e se aproxima de um ponto de \u00f4nibus com pedestres.',
        question: 'Qual atitude melhora a conviv\u00eancia?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Reduzo, observo os pedestres e mantenho uma trajet\u00f3ria previs\u00edvel.',
            isCorrect: true,
            consequenceText:
                'Os demais conseguem perceber sua aproxima\u00e7\u00e3o e o espa\u00e7o \u00e9 compartilhado com menos conflito.',
            meloFeedback:
                'Boa escolha. Previsibilidade e velocidade compat\u00edvel ajudam todos a dividir o espa\u00e7o.',
          ),
          MissionOption(
            id: 'teen_wrong_fast',
            text: 'Acelero para passar antes do embarque come\u00e7ar.',
            isCorrect: false,
            consequenceText:
                'Sua velocidade aumenta justamente quando mais pessoas podem mudar de dire\u00e7\u00e3o.',
            meloFeedback:
                'Antecipe movimentos de pedestres e reduza antes do conflito.',
          ),
          MissionOption(
            id: 'teen_wrong_bell',
            text:
                'Uso a campainha e mantenho a velocidade para abrir passagem.',
            isCorrect: false,
            consequenceText:
                'O aviso n\u00e3o garante que todos tenham percebido ou entendido sua trajet\u00f3ria.',
            meloFeedback:
                'Sinalizar ajuda, mas n\u00e3o substitui reduzir e observar.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z2_M05',
        title: 'Rotas que se Encontram',
        description:
            'Antecipe o comportamento de usu\u00e1rios vulner\u00e1veis em um ambiente complexo.',
        sceneText:
            'Voc\u00ea dirige em um trecho com \u00f4nibus, ciclista e pedestres pr\u00f3ximos ao mesmo ponto de conflito.',
        question:
            'Qual estrat\u00e9gia oferece maior margem de seguran\u00e7a?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo, amplio a observa\u00e7\u00e3o e deixo espa\u00e7o para movimentos inesperados.',
            isCorrect: true,
            consequenceText:
                'Com maior margem, voc\u00ea consegue reagir sem pressionar os outros usu\u00e1rios.',
            meloFeedback:
                'Excelente. Em ambiente complexo, antecipa\u00e7\u00e3o e margem de seguran\u00e7a valem mais que pressa.',
          ),
          MissionOption(
            id: 'adult_wrong_priority',
            text: 'Mantenho o ritmo porque estou seguindo meu trajeto normal.',
            isCorrect: false,
            consequenceText:
                'O comportamento dos demais muda e sua margem de rea\u00e7\u00e3o diminui.',
            meloFeedback:
                'Mesmo quando sua trajet\u00f3ria parece clara, observe quem est\u00e1 mais vulner\u00e1vel.',
          ),
          MissionOption(
            id: 'adult_wrong_horn',
            text: 'Buzino para que todos percebam minha aproxima\u00e7\u00e3o.',
            isCorrect: false,
            consequenceText:
                'O aviso sonoro n\u00e3o organiza todos os movimentos ao mesmo tempo.',
            meloFeedback:
                'A melhor prote\u00e7\u00e3o vem de reduzir, observar e manter espa\u00e7o.',
          ),
        ],
      );
  }
}
