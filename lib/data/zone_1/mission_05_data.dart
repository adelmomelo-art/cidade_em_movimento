import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone1Mission05(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z1_M05',
        title: 'Caminho Seguro',
        description:
            'Escolha um caminho para a escola pensando em cal\u00e7ada, '
            'travessia e visibilidade.',
        sceneText:
            'Voc\u00ea vai a p\u00e9 para a escola. Existem dois caminhos: '
            'um \u00e9 um pouco mais longo, com cal\u00e7ada e faixa de '
            'pedestres; o outro \u00e9 mais curto, mas exige passar entre '
            'carros estacionados e atravessar fora da faixa.',
        question: 'Qual caminho \u00e9 mais seguro?',
        maxCitizenship: 30,
        maxKnowledge: 20,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Escolho o caminho com cal\u00e7ada e faixa, mesmo sendo '
                'um pouco mais longo.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea permanece em um espa\u00e7o mais previs\u00edvel '
                'e chega ao ponto de travessia com melhor visibilidade.',
            meloFeedback:
                'Muito bem! Um caminho seguro nem sempre \u00e9 o mais curto. '
                'Cal\u00e7ada, visibilidade e locais adequados de travessia '
                'ajudam a reduzir riscos.',
          ),
          MissionOption(
            id: 'child_wrong_shortcut',
            text:
                'Escolho o atalho entre os carros porque chego mais r\u00e1pido.',
            isCorrect: false,
            consequenceText:
                'Entre os carros, voc\u00ea fica menos vis\u00edvel para '
                'quem circula pela via.',
            meloFeedback:
                'Atalhos podem esconder voc\u00ea dos motoristas. '
                'Prefira caminhos com espa\u00e7os adequados para caminhar '
                'e atravessar.',
          ),
          MissionOption(
            id: 'child_wrong_run',
            text: 'Vou pelo caminho curto e corro para atravessar rapidamente.',
            isCorrect: false,
            consequenceText:
                'Correr n\u00e3o melhora a visibilidade e ainda reduz '
                'o tempo para observar o movimento.',
            meloFeedback:
                'Seguran\u00e7a vem antes da pressa. '
                'Observe e use um local adequado para atravessar.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z1_M05',
        title: 'Caminho Seguro',
        description:
            'Planeje um deslocamento escolar considerando previsibilidade, '
            'travessias e aten\u00e7\u00e3o ao ambiente.',
        sceneText:
            'Voc\u00ea est\u00e1 indo para a escola. Um trajeto possui '
            'cal\u00e7ada cont\u00ednua e travessia sinalizada; outro corta '
            'um estacionamento e exige atravessar em um ponto com '
            'visibilidade limitada.',
        question: 'Qual decis\u00e3o \u00e9 mais segura?',
        maxCitizenship: 30,
        maxKnowledge: 20,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Uso o trajeto com cal\u00e7ada e travessia sinalizada, '
                'mantendo aten\u00e7\u00e3o ao ambiente.',
            isCorrect: true,
            consequenceText:
                'O percurso fica mais previs\u00edvel e voc\u00ea consegue '
                'observar melhor os conflitos antes de atravessar.',
            meloFeedback:
                'Boa escolha. Planejar o caminho tamb\u00e9m faz parte '
                'da seguran\u00e7a: visibilidade, continuidade da cal\u00e7ada '
                'e travessias adequadas importam.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text: 'Escolho o atalho e uso o celular enquanto caminho.',
            isCorrect: false,
            consequenceText:
                'Al\u00e9m da visibilidade limitada do atalho, sua aten\u00e7\u00e3o '
                'fica dividida.',
            meloFeedback:
                'Evite somar riscos. Em deslocamentos, mantenha a aten\u00e7\u00e3o '
                'no ambiente e prefira um percurso mais seguro.',
          ),
          MissionOption(
            id: 'teen_wrong_short',
            text:
                'Vou pelo caminho mais curto porque o tempo de exposi\u00e7\u00e3o '
                'ao tr\u00e2nsito ser\u00e1 menor.',
            isCorrect: false,
            consequenceText:
                'Um trajeto menor pode ter pontos mais perigosos e '
                'menos visibilidade.',
            meloFeedback:
                'Dist\u00e2ncia n\u00e3o \u00e9 o \u00fanico crit\u00e9rio. '
                'Considere onde voc\u00ea caminha, como atravessa e '
                'quanto consegue ver o tr\u00e2nsito.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z1_M05',
        title: 'Caminho Seguro',
        description:
            'Reconhe\u00e7a como sua condu\u00e7\u00e3o influencia a seguran\u00e7a '
            'de quem percorre a rota escolar.',
        sceneText:
            'Voc\u00ea dirige por uma rota escolar. H\u00e1 pedestres '
            'seguindo pela cal\u00e7ada e uma travessia sinalizada mais '
            '\u00e0 frente, onde a movimenta\u00e7\u00e3o aumenta.',
        question: 'Qual \u00e9 a conduta mais segura?',
        maxCitizenship: 30,
        maxKnowledge: 20,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo a velocidade, observo cal\u00e7adas e travessias '
                'e me preparo para ceder passagem quando necess\u00e1rio.',
            isCorrect: true,
            consequenceText:
                'Com velocidade compat\u00edvel, voc\u00ea percebe melhor '
                'pedestres e consegue reagir com anteced\u00eancia.',
            meloFeedback:
                'Boa decis\u00e3o. Na rota escolar, antecipe situa\u00e7\u00f5es '
                'e proteja os usu\u00e1rios mais vulner\u00e1veis.',
          ),
          MissionOption(
            id: 'adult_wrong_speed',
            text:
                'Mantenho a velocidade porque os pedestres ainda est\u00e3o '
                'na cal\u00e7ada.',
            isCorrect: false,
            consequenceText:
                'A situa\u00e7\u00e3o pode mudar rapidamente quando algu\u00e9m '
                'se aproxima da travessia.',
            meloFeedback:
                'A seguran\u00e7a depende de antecipa\u00e7\u00e3o. '
                'Reduza antes do conflito, n\u00e3o apenas quando ele acontecer.',
          ),
          MissionOption(
            id: 'adult_wrong_horn',
            text:
                'Uso a buzina para avisar minha aproxima\u00e7\u00e3o e '
                'continuo no mesmo ritmo.',
            isCorrect: false,
            consequenceText:
                'O aviso sonoro n\u00e3o aumenta sua margem de frenagem '
                'nem garante que todos compreenderam sua inten\u00e7\u00e3o.',
            meloFeedback:
                'Buzinar n\u00e3o substitui velocidade compat\u00edvel '
                'e observa\u00e7\u00e3o. Antecipe e conduza com cautela.',
          ),
        ],
      );
  }
}
