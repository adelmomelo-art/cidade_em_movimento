import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone1Mission04(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z1_M04',
        title: 'S\u00f3 um Minutinho',
        description:
            'Perceba como pequenas escolhas perto da escola podem '
            'afetar a seguran\u00e7a de quem caminha.',
        sceneText:
            'Na sa\u00edda da escola, um carro para bem perto da faixa '
            'de pedestres. O motorista diz que ser\u00e1 s\u00f3 por um minuto.',
        question: 'O que torna essa situa\u00e7\u00e3o mais segura?',
        maxCitizenship: 25,
        maxKnowledge: 15,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'O carro deve parar em local adequado, deixando a faixa '
                'e a visibilidade livres.',
            isCorrect: true,
            consequenceText:
                'Com a faixa livre, pedestres e motoristas conseguem '
                'se enxergar melhor.',
            meloFeedback:
                'Muito bem! Mesmo uma parada curta pode criar risco '
                'quando ocupa um local importante para a travessia.',
          ),
          MissionOption(
            id: 'child_wrong_short',
            text: 'Pode ficar ali porque ser\u00e1 apenas por um minuto.',
            isCorrect: false,
            consequenceText:
                'Mesmo em pouco tempo, o carro pode esconder quem vai '
                'atravessar e atrapalhar a passagem.',
            meloFeedback:
                'O tempo curto n\u00e3o elimina o risco. '
                'O importante \u00e9 manter a travessia vis\u00edvel e livre.',
          ),
          MissionOption(
            id: 'child_wrong_between',
            text: 'Os pedestres podem passar por tr\u00e1s do carro parado.',
            isCorrect: false,
            consequenceText:
                'Ao surgir de tr\u00e1s do carro, o pedestre pode ficar '
                'menos vis\u00edvel para quem vem pela via.',
            meloFeedback:
                'Desviar por tr\u00e1s de um ve\u00edculo parado pode reduzir '
                'a visibilidade. O melhor \u00e9 manter a faixa desobstru\u00edda.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z1_M04',
        title: 'S\u00f3 um Minutinho',
        description:
            'Entenda como uma parada irregular pode comprometer '
            'visibilidade e seguran\u00e7a na \u00e1rea escolar.',
        sceneText:
            'Um respons\u00e1vel para o carro perto da faixa para buscar '
            'um estudante. Ele diz que n\u00e3o h\u00e1 problema porque '
            'ficar\u00e1 ali por pouco tempo.',
        question: 'Qual atitude \u00e9 mais segura?',
        maxCitizenship: 25,
        maxKnowledge: 15,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Usar um local adequado de parada, sem bloquear a faixa '
                'nem prejudicar a visibilidade.',
            isCorrect: true,
            consequenceText:
                'O embarque ocorre sem ocupar a \u00e1rea de travessia '
                'e o campo de vis\u00e3o permanece melhor.',
            meloFeedback:
                'Boa escolha. Em \u00e1reas escolares, uma parada aparentemente '
                'r\u00e1pida pode gerar conflito se ocupar um ponto sens\u00edvel.',
          ),
          MissionOption(
            id: 'teen_wrong_hazard',
            text: 'Ligar o pisca-alerta torna a parada segura mesmo ali.',
            isCorrect: false,
            consequenceText:
                'O sinal luminoso n\u00e3o remove o ve\u00edculo do ponto '
                'que prejudica a travessia e a visibilidade.',
            meloFeedback:
                'Sinalizar n\u00e3o corrige uma escolha insegura de local. '
                'Procure um ponto adequado para parar.',
          ),
          MissionOption(
            id: 'teen_wrong_quick',
            text:
                'Se for r\u00e1pido, o risco \u00e9 pequeno e pode permanecer.',
            isCorrect: false,
            consequenceText:
                'Durante esse intervalo, pedestres podem precisar atravessar '
                'e outros condutores podem ter sua vis\u00e3o reduzida.',
            meloFeedback:
                'O risco depende da situa\u00e7\u00e3o criada, n\u00e3o apenas '
                'do tempo de perman\u00eancia.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z1_M04',
        title: 'S\u00f3 um Minutinho',
        description:
            'Escolha um ponto de parada que preserve a travessia, '
            'a visibilidade e a organiza\u00e7\u00e3o da \u00e1rea escolar.',
        sceneText:
            'Voc\u00ea chega para buscar um estudante. O local mais pr\u00f3ximo '
            'fica junto da faixa de pedestres, mas h\u00e1 outro ponto '
            'adequado um pouco mais adiante.',
        question: 'Qual \u00e9 a conduta mais segura?',
        maxCitizenship: 25,
        maxKnowledge: 15,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Sigo at\u00e9 o local adequado, mesmo que precise caminhar '
                'um pouco mais.',
            isCorrect: true,
            consequenceText:
                'A faixa permanece livre e a movimenta\u00e7\u00e3o escolar '
                'fica mais previs\u00edvel e organizada.',
            meloFeedback:
                'Boa decis\u00e3o. Conveni\u00eancia n\u00e3o deve superar '
                'a seguran\u00e7a. Preserve os espa\u00e7os de travessia '
                'e a visibilidade de todos.',
          ),
          MissionOption(
            id: 'adult_wrong_minute',
            text:
                'Paro junto da faixa porque vou permanecer s\u00f3 um minuto.',
            isCorrect: false,
            consequenceText:
                'O ve\u00edculo ocupa uma \u00e1rea importante para a leitura '
                'do tr\u00e2nsito e pode esconder pedestres.',
            meloFeedback:
                'Uma parada curta ainda pode criar um conflito importante. '
                'Escolha um ponto que n\u00e3o interfira na travessia.',
          ),
          MissionOption(
            id: 'adult_wrong_hazard',
            text:
                'Paro ali e aciono o pisca-alerta para mostrar que ser\u00e1 r\u00e1pido.',
            isCorrect: false,
            consequenceText:
                'O alerta indica sua presen\u00e7a, mas n\u00e3o devolve '
                'a visibilidade nem libera o espa\u00e7o de travessia.',
            meloFeedback:
                'O pisca-alerta n\u00e3o transforma um local inadequado '
                'em um local seguro. Procure outro ponto.',
          ),
        ],
      );
  }
}
