import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone2Mission02(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z2_M02',
        title: 'Ponto Certo',
        description:
            'Aprenda a esperar e embarcar no transporte coletivo com seguran\u00e7a.',
        sceneText:
            'Um \u00f4nibus se aproxima do ponto. Algumas pessoas avan\u00e7am para a borda antes da parada completa.',
        question: 'Como voc\u00ea deve agir?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Espero em local seguro e me aproximo somente depois da parada do \u00f4nibus.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea espera com calma e embarca quando o ve\u00edculo est\u00e1 parado.',
            meloFeedback:
                'Muito bem. Esperar alguns segundos ajuda a manter dist\u00e2ncia segura do ve\u00edculo em movimento.',
          ),
          MissionOption(
            id: 'child_wrong_edge',
            text: 'Fico bem perto da borda para ser um dos primeiros a entrar.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea fica muito pr\u00f3ximo do ve\u00edculo durante a aproxima\u00e7\u00e3o.',
            meloFeedback:
                'N\u00e3o precisamos disputar o embarque. Espere a parada completa.',
          ),
          MissionOption(
            id: 'child_wrong_run',
            text: 'Corro ao lado do \u00f4nibus para acompanhar a porta.',
            isCorrect: false,
            consequenceText:
                'Seu movimento fica imprevis\u00edvel perto de um ve\u00edculo grande.',
            meloFeedback:
                'Mantenha dist\u00e2ncia e espere o ve\u00edculo parar.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z2_M02',
        title: 'Ponto Certo',
        description:
            'Pratique embarque organizado e aten\u00e7\u00e3o no transporte coletivo.',
        sceneText:
            'O ponto est\u00e1 cheio e o \u00f4nibus chega enquanto voc\u00ea conversa com amigos.',
        question: 'Qual comportamento reduz conflitos no embarque?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Aguardo a parada, deixo o fluxo se organizar e embarco com aten\u00e7\u00e3o.',
            isCorrect: true,
            consequenceText:
                'O embarque acontece de forma mais previs\u00edvel e sem empurr\u00f5es.',
            meloFeedback:
                'Boa escolha. Organiza\u00e7\u00e3o e aten\u00e7\u00e3o fazem parte da seguran\u00e7a no transporte coletivo.',
          ),
          MissionOption(
            id: 'teen_wrong_push',
            text: 'Avan\u00e7o antes para garantir meu lugar.',
            isCorrect: false,
            consequenceText:
                'A pressa cria disputa e movimentos inesperados perto da porta.',
            meloFeedback: 'Seguran\u00e7a vem antes da disputa por lugar.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text: 'Continuo no celular e acompanho o movimento sem olhar.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea perde informa\u00e7\u00f5es importantes sobre o ve\u00edculo e as pessoas ao redor.',
            meloFeedback:
                'No embarque, mantenha aten\u00e7\u00e3o ao ambiente.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z2_M02',
        title: 'Ponto Certo',
        description:
            'Reconhe\u00e7a como uma parada irregular interfere no transporte coletivo.',
        sceneText:
            'Voc\u00ea precisa parar rapidamente e encontra um espa\u00e7o junto a um ponto de \u00f4nibus.',
        question: 'Qual decis\u00e3o preserva melhor a circula\u00e7\u00e3o?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Procuro outro local adequado para n\u00e3o bloquear o ponto e o embarque.',
            isCorrect: true,
            consequenceText:
                'O ponto permanece livre e o \u00f4nibus consegue se aproximar com previsibilidade.',
            meloFeedback:
                'Boa decis\u00e3o. Uma parada r\u00e1pida pode afetar muitas pessoas quando ocupa uma \u00e1rea de embarque.',
          ),
          MissionOption(
            id: 'adult_wrong_flash',
            text: 'Paro por pouco tempo com o pisca-alerta ligado.',
            isCorrect: false,
            consequenceText:
                'O \u00f4nibus precisa ajustar sua aproxima\u00e7\u00e3o e o embarque fica mais confuso.',
            meloFeedback:
                'O pisca-alerta n\u00e3o elimina o impacto da obstru\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'adult_wrong_half',
            text: 'Fico parcialmente no ponto para deixar algum espa\u00e7o.',
            isCorrect: false,
            consequenceText:
                'Mesmo parcialmente, o espa\u00e7o de aproxima\u00e7\u00e3o fica comprometido.',
            meloFeedback:
                'Procure um local adequado e mantenha a \u00e1rea de embarque livre.',
          ),
        ],
      );
  }
}
