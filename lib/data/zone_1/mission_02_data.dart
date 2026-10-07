import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone1Mission02(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z1_M02',
        title: 'Embarque Seguro',
        description:
            'Aprenda a entrar e sair do transporte escolar com calma, '
            'aten\u00e7\u00e3o e seguran\u00e7a.',
        sceneText:
            'O transporte escolar chegou em frente \u00e0 escola. '
            'Algumas crian\u00e7as se aproximam enquanto o ve\u00edculo '
            'ainda termina de parar.',
        question: 'Qual \u00e9 a atitude mais segura?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Espero o ve\u00edculo parar completamente e embarco com calma.',
            isCorrect: true,
            consequenceText:
                'O ve\u00edculo para completamente e voc\u00ea embarca '
                'de forma organizada e segura.',
            meloFeedback:
                'Muito bem! Espere sempre o ve\u00edculo parar por completo. '
                'Calma e organiza\u00e7\u00e3o tornam o embarque mais seguro.',
          ),
          MissionOption(
            id: 'child_wrong_running',
            text: 'Corro at\u00e9 o ve\u00edculo para entrar antes dos outros.',
            isCorrect: false,
            consequenceText:
                'Ao correr perto do ve\u00edculo, voc\u00ea pode trope\u00e7ar '
                'ou entrar em uma \u00e1rea de pouca visibilidade.',
            meloFeedback:
                'N\u00e3o precisamos disputar o embarque. '
                'Espere a parada completa e aproxime-se com calma.',
          ),
          MissionOption(
            id: 'child_wrong_moving',
            text:
                'Tento subir enquanto o ve\u00edculo ainda est\u00e1 parando.',
            isCorrect: false,
            consequenceText:
                'O movimento do ve\u00edculo pode causar desequil\u00edbrio '
                'e aumentar o risco de queda.',
            meloFeedback:
                'Embarque somente depois da parada completa do ve\u00edculo.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z1_M02',
        title: 'Embarque Seguro',
        description:
            'Reconhe\u00e7a comportamentos seguros no embarque e '
            'desembarque do transporte escolar.',
        sceneText:
            'O transporte escolar aproxima-se do ponto de embarque. '
            'Alguns estudantes avan\u00e7am em dire\u00e7\u00e3o \u00e0 porta '
            'antes da parada completa.',
        question: 'Como voc\u00ea deve agir?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text: 'Aguardo a parada completa e mantenho o embarque organizado.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea espera em local seguro e embarca somente '
                'depois da imobiliza\u00e7\u00e3o do ve\u00edculo.',
            meloFeedback:
                'Boa escolha. Uma atitude previs\u00edvel e organizada '
                'reduz conflitos e riscos durante o embarque.',
          ),
          MissionOption(
            id: 'teen_wrong_door',
            text: 'Fico junto \u00e0 porta antes de o ve\u00edculo parar.',
            isCorrect: false,
            consequenceText:
                'Permanecer muito perto de um ve\u00edculo ainda em movimento '
                'aumenta o risco durante a aproxima\u00e7\u00e3o.',
            meloFeedback:
                'Mantenha uma posi\u00e7\u00e3o segura e aguarde '
                'a parada completa antes de se aproximar.',
          ),
          MissionOption(
            id: 'teen_wrong_push',
            text: 'Avan\u00e7o rapidamente para garantir lugar primeiro.',
            isCorrect: false,
            consequenceText:
                'A disputa pelo embarque provoca empurr\u00f5es e '
                'movimentos imprevis\u00edveis pr\u00f3ximos ao ve\u00edculo.',
            meloFeedback:
                'Seguran\u00e7a vem antes da pressa. '
                'Embarque de forma organizada.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z1_M02',
        title: 'Embarque Seguro',
        description:
            'Identifique os cuidados do condutor em uma \u00e1rea '
            'de embarque e desembarque escolar.',
        sceneText:
            'Voc\u00ea dirige pr\u00f3ximo \u00e0 escola. '
            'Um transporte escolar est\u00e1 realizando embarque '
            'e h\u00e1 estudantes pr\u00f3ximos \u00e0 via.',
        question: 'Qual \u00e9 a conduta mais segura?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo a velocidade, aumento a aten\u00e7\u00e3o e '
                'observo a movimenta\u00e7\u00e3o dos estudantes.',
            isCorrect: true,
            consequenceText:
                'Com velocidade reduzida, voc\u00ea consegue observar '
                'melhor o ambiente e reagir com mais seguran\u00e7a.',
            meloFeedback:
                '\u00c1reas escolares exigem aten\u00e7\u00e3o redobrada. '
                'Reduzir a velocidade aumenta seu tempo para perceber '
                'e responder a movimentos inesperados.',
          ),
          MissionOption(
            id: 'adult_wrong_fast',
            text:
                'Mantenho a velocidade porque os estudantes est\u00e3o '
                'pr\u00f3ximos ao transporte.',
            isCorrect: false,
            consequenceText:
                'Um estudante muda de dire\u00e7\u00e3o inesperadamente '
                'e o tempo dispon\u00edvel para reagir fica menor.',
            meloFeedback:
                'Perto de escolas, antecipe riscos. '
                'A presen\u00e7a de estudantes exige velocidade compat\u00edvel '
                'e aten\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'adult_wrong_horn',
            text: 'Buzino para avisar que vou passar e sigo normalmente.',
            isCorrect: false,
            consequenceText:
                'A buzina n\u00e3o substitui a redu\u00e7\u00e3o de velocidade '
                'nem elimina os riscos da movimenta\u00e7\u00e3o escolar.',
            meloFeedback:
                'Avisar n\u00e3o elimina o risco. '
                'A conduta segura \u00e9 reduzir, observar e estar preparado '
                'para reagir.',
          ),
        ],
      );
  }
}
