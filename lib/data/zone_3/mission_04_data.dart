import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone3Mission04(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z3_M04',
        title: 'Olhos na Orla',
        description: 'Perceba por que distra\u00e7\u00e3o aumenta o risco.',
        sceneText:
            'Voc\u00ea caminha perto de ciclovia, quiosques e travessias.',
        question: 'Como manter-se seguro?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Presto aten\u00e7\u00e3o ao caminho e paro em local seguro se precisar olhar algo.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea percebe os fluxos antes de mudar de dire\u00e7\u00e3o.',
            meloFeedback:
                'Muito bem. Aten\u00e7\u00e3o ajuda voc\u00ea a prever o que acontece ao redor.',
          ),
          MissionOption(
            id: 'child_wrong_screen',
            text: 'Continuo andando enquanto olho uma tela.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea se aproxima da ciclovia sem perceber.',
            meloFeedback:
                'Pare em local seguro antes de desviar sua aten\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'child_wrong_friend',
            text: 'Sigo meu amigo e deixo ele olhar por n\u00f3s dois.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea deixa de perceber mudan\u00e7as no ambiente.',
            meloFeedback:
                'Cada pessoa precisa observar o pr\u00f3prio caminho.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z3_M04',
        title: 'Olhos na Orla',
        description:
            'Reduza distra\u00e7\u00f5es em um ambiente de muitos fluxos.',
        sceneText:
            'Uma notifica\u00e7\u00e3o chega enquanto voc\u00ea caminha perto da ciclovia.',
        question: 'Qual atitude \u00e9 mais segura?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text: 'Espero chegar a um ponto seguro antes de usar o celular.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea mant\u00e9m aten\u00e7\u00e3o nos fluxos ao redor.',
            meloFeedback:
                'Boa. Aten\u00e7\u00e3o plena vale mais que responder imediatamente.',
          ),
          MissionOption(
            id: 'teen_wrong_voice',
            text: 'Respondo rapidamente sem parar de andar.',
            isCorrect: false,
            consequenceText:
                'Sua aten\u00e7\u00e3o diminui no momento em que cruza outros fluxos.',
            meloFeedback:
                'Mesmo uma resposta r\u00e1pida divide sua aten\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'teen_wrong_one_eye',
            text: 'Olho para frente de vez em quando enquanto uso o celular.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea perde informa\u00e7\u00f5es entre uma olhada e outra.',
            meloFeedback:
                'Ambiente din\u00e2mico exige aten\u00e7\u00e3o cont\u00ednua.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z3_M04',
        title: 'Olhos na Orla',
        description:
            'Evite distra\u00e7\u00f5es ao conduzir em \u00e1rea tur\u00edstica.',
        sceneText: 'Seu celular toca enquanto voc\u00ea dirige pela orla.',
        question: 'Qual decis\u00e3o preserva melhor a seguran\u00e7a?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'N\u00e3o manuseio o celular e paro em local seguro se precisar atend\u00ea-lo.',
            isCorrect: true,
            consequenceText:
                'Sua aten\u00e7\u00e3o permanece no tr\u00e2nsito.',
            meloFeedback:
                'Correto. Em ambiente complexo, distra\u00e7\u00e3o reduz muito sua margem de rea\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'adult_wrong_quick',
            text: 'Olho rapidamente para ver quem ligou.',
            isCorrect: false,
            consequenceText:
                'Nesse instante, um pedestre muda de dire\u00e7\u00e3o.',
            meloFeedback:
                'Poucos segundos de distra\u00e7\u00e3o podem ser decisivos.',
          ),
          MissionOption(
            id: 'adult_wrong_slow',
            text: 'Reduzo a velocidade e uso o celular por alguns segundos.',
            isCorrect: false,
            consequenceText:
                'Velocidade menor n\u00e3o elimina a perda de aten\u00e7\u00e3o.',
            meloFeedback: 'Se precisar usar o aparelho, pare em local seguro.',
          ),
        ],
      );
  }
}
