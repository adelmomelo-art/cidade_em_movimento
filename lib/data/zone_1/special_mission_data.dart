import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone1SpecialMission(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z1_SPECIAL',
        title: 'Sa\u00edda da Escola',
        description:
            'Use tudo o que aprendeu para ajudar a tornar a sa\u00edda '
            'da escola mais segura.',
        sceneText:
            'O sinal toca e muitas crian\u00e7as saem ao mesmo tempo. '
            'H\u00e1 carros chegando, bicicletas passando e estudantes '
            'se aproximando da faixa de pedestres.',
        question:
            'Qual conjunto de atitudes ajuda mais a manter todos seguros?',
        maxCitizenship: 50,
        maxKnowledge: 30,
        maxCoins: 50,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Caminho com calma, uso a faixa, observo antes de atravessar '
                'e mantenho dist\u00e2ncia dos ve\u00edculos.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea se movimenta de forma previs\u00edvel, usa o local '
                'adequado de travessia e ajuda a organizar a sa\u00edda.',
            meloFeedback:
                'Excelente! Voc\u00ea reuniu as principais escolhas desta zona: '
                'calma, observa\u00e7\u00e3o, visibilidade e respeito aos espa\u00e7os.',
          ),
          MissionOption(
            id: 'child_wrong_rush',
            text:
                'Corro para sair primeiro e atravesso entre os carros parados.',
            isCorrect: false,
            consequenceText:
                'Entre os carros, sua visibilidade diminui e os condutores '
                'podem ter dificuldade para perceber sua travessia.',
            meloFeedback:
                'Na sa\u00edda da escola, pressa e pouca visibilidade aumentam '
                'o risco. Use a faixa e atravesse com aten\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'child_wrong_follow',
            text:
                'Sigo o grupo sem observar porque os outros j\u00e1 est\u00e3o atravessando.',
            isCorrect: false,
            consequenceText:
                'O movimento do tr\u00e2nsito pode mudar enquanto o grupo atravessa.',
            meloFeedback:
                'Mesmo em grupo, cada pessoa precisa observar o ambiente '
                'e confirmar que a travessia continua segura.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z1_SPECIAL',
        title: 'Sa\u00edda da Escola',
        description:
            'Aplique as escolhas de seguran\u00e7a e cidadania aprendidas '
            'durante toda a Zona 1.',
        sceneText:
            'A escola acaba de liberar os estudantes. Pedestres, ciclistas '
            'e ve\u00edculos dividem o entorno, e alguns respons\u00e1veis '
            'tentam parar o mais perto poss\u00edvel da entrada.',
        question:
            'Qual comportamento contribui para uma sa\u00edda mais segura?',
        maxCitizenship: 50,
        maxKnowledge: 30,
        maxCoins: 50,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Mantenho aten\u00e7\u00e3o, uso travessias adequadas, evito '
                'atalhos arriscados e respeito pedestres e ciclistas.',
            isCorrect: true,
            consequenceText:
                'Seu deslocamento fica previs\u00edvel e voc\u00ea evita criar '
                'novos conflitos em uma \u00e1rea j\u00e1 movimentada.',
            meloFeedback:
                'Muito bem! Seguran\u00e7a no tr\u00e2nsito nasce de v\u00e1rias '
                'boas escolhas feitas em conjunto.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text:
                'Uso o celular enquanto caminho porque os carros est\u00e3o lentos.',
            isCorrect: false,
            consequenceText:
                'Sua aten\u00e7\u00e3o fica dividida justamente no momento '
                'de maior movimenta\u00e7\u00e3o.',
            meloFeedback:
                'Velocidade baixa n\u00e3o elimina conflitos. '
                'Na sa\u00edda da escola, mantenha aten\u00e7\u00e3o total ao ambiente.',
          ),
          MissionOption(
            id: 'teen_wrong_shortcut',
            text:
                'Corto caminho entre os ve\u00edculos para sair mais r\u00e1pido.',
            isCorrect: false,
            consequenceText:
                'Sua trajet\u00f3ria fica menos vis\u00edvel e menos previs\u00edvel '
                'para quem dirige ou pedala.',
            meloFeedback:
                'Evite trocar alguns segundos por um risco maior. '
                'Prefira trajetos vis\u00edveis e previs\u00edveis.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z1_SPECIAL',
        title: 'Sa\u00edda da Escola',
        description:
            'Integre velocidade segura, aten\u00e7\u00e3o, respeito ao pedestre '
            'e escolha correta do local de parada.',
        sceneText:
            'Voc\u00ea chega de carro no hor\u00e1rio de sa\u00edda. '
            'H\u00e1 crian\u00e7as atravessando, ciclistas circulando e '
            'outros ve\u00edculos procurando espa\u00e7o para parar.',
        question: 'Qual \u00e9 a melhor conduta para proteger todos ao redor?',
        maxCitizenship: 50,
        maxKnowledge: 30,
        maxCoins: 50,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo a velocidade, preservo a faixa, respeito ciclistas '
                'e paro somente em local adequado.',
            isCorrect: true,
            consequenceText:
                'A circula\u00e7\u00e3o fica mais previs\u00edvel, a faixa permanece '
                'vis\u00edvel e os usu\u00e1rios vulner\u00e1veis ganham mais prote\u00e7\u00e3o.',
            meloFeedback:
                'Excelente decis\u00e3o. Na \u00e1rea escolar, seguran\u00e7a depende '
                'de antecipar riscos e colocar a vida acima da conveni\u00eancia.',
          ),
          MissionOption(
            id: 'adult_wrong_stop',
            text:
                'Paro junto da faixa com o pisca-alerta para buscar rapidamente.',
            isCorrect: false,
            consequenceText:
                'O carro reduz a visibilidade e interfere diretamente '
                'na \u00e1rea de travessia.',
            meloFeedback:
                'O pisca-alerta n\u00e3o torna adequado um local inseguro. '
                'Procure um ponto correto para parar.',
          ),
          MissionOption(
            id: 'adult_wrong_hurry',
            text: 'Mantenho o ritmo para sair logo da \u00e1rea movimentada.',
            isCorrect: false,
            consequenceText:
                'Com menos tempo para reagir, qualquer mudan\u00e7a repentina '
                'de pedestres ou ciclistas se torna mais perigosa.',
            meloFeedback:
                'Em \u00e1rea escolar, reduza antes do conflito. '
                'A pressa diminui sua margem de seguran\u00e7a.',
          ),
        ],
      );
  }
}
