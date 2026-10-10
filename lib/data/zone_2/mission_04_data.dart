import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone2Mission04(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z2_M04',
        title: 'S\u00f3 Vou Parar Aqui',
        description:
            'Observe como uma parada r\u00e1pida pode atrapalhar outras pessoas.',
        sceneText:
            'Um carro para em uma passagem movimentada e o motorista diz que ser\u00e1 por apenas um minuto.',
        question: 'O que pode acontecer?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Outras pessoas podem ter de desviar e a circula\u00e7\u00e3o fica mais confusa.',
            isCorrect: true,
            consequenceText:
                'Pedestres e ve\u00edculos mudam de trajet\u00f3ria para contornar o obst\u00e1culo.',
            meloFeedback:
                'Isso mesmo. Uma decis\u00e3o pequena pode afetar muitas pessoas ao mesmo tempo.',
          ),
          MissionOption(
            id: 'child_wrong_time',
            text: 'Nada acontece porque um minuto passa muito r\u00e1pido.',
            isCorrect: false,
            consequenceText:
                'Durante esse minuto, v\u00e1rias pessoas chegam ao local e precisam desviar.',
            meloFeedback:
                'O impacto existe enquanto o obst\u00e1culo estiver ali.',
          ),
          MissionOption(
            id: 'child_wrong_flash',
            text: 'Fica seguro se o pisca-alerta estiver ligado.',
            isCorrect: false,
            consequenceText:
                'O pisca-alerta mostra o ve\u00edculo, mas n\u00e3o remove a obstru\u00e7\u00e3o.',
            meloFeedback:
                'Avisar n\u00e3o transforma um local inadequado em seguro.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z2_M04',
        title: 'S\u00f3 Vou Parar Aqui',
        description:
            'Analise como conveni\u00eancia individual pode gerar impacto coletivo.',
        sceneText:
            'Um ve\u00edculo para rapidamente onde reduz a passagem de \u00f4nibus e pedestres.',
        question: 'Qual leitura do cen\u00e1rio \u00e9 mais completa?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Mesmo uma parada curta pode gerar fila, desvio e dificuldade para pedestres.',
            isCorrect: true,
            consequenceText:
                'O bloqueio cria uma sequ\u00eancia de pequenas adapta\u00e7\u00f5es para todos ao redor.',
            meloFeedback:
                'Boa leitura. Tr\u00e2nsito \u00e9 um sistema: uma escolha individual pode produzir efeitos em cadeia.',
          ),
          MissionOption(
            id: 'teen_wrong_onlycars',
            text:
                'O problema atinge apenas os carros que est\u00e3o atr\u00e1s.',
            isCorrect: false,
            consequenceText:
                'Pedestres e transporte coletivo tamb\u00e9m precisam reorganizar seus movimentos.',
            meloFeedback:
                'Observe todos os usu\u00e1rios do espa\u00e7o, n\u00e3o apenas os carros.',
          ),
          MissionOption(
            id: 'teen_wrong_hurry',
            text: 'Se o motorista for r\u00e1pido, o impacto quase desaparece.',
            isCorrect: false,
            consequenceText:
                'O efeito existe desde o momento em que a passagem fica comprometida.',
            meloFeedback:
                'Rapidez n\u00e3o elimina o conflito criado pela escolha do local.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z2_M04',
        title: 'S\u00f3 Vou Parar Aqui',
        description:
            'Escolha um local de parada considerando o impacto sobre os demais.',
        sceneText:
            'Voc\u00ea precisa resolver algo rapidamente e o local mais pr\u00f3ximo interfere na circula\u00e7\u00e3o.',
        question: 'Qual \u00e9 a melhor decis\u00e3o?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Procuro um local adequado, mesmo que precise caminhar um pouco mais.',
            isCorrect: true,
            consequenceText:
                'A circula\u00e7\u00e3o permanece livre e sua conveni\u00eancia n\u00e3o cria um novo conflito.',
            meloFeedback:
                'Boa decis\u00e3o. Conveni\u00eancia pessoal n\u00e3o deve transferir risco e dificuldade aos demais.',
          ),
          MissionOption(
            id: 'adult_wrong_minute',
            text: 'Paro ali porque ficarei somente um minuto.',
            isCorrect: false,
            consequenceText:
                'Nesse intervalo, outros usu\u00e1rios precisam adaptar seus movimentos.',
            meloFeedback:
                'Pouco tempo ainda pode ser tempo suficiente para gerar conflito.',
          ),
          MissionOption(
            id: 'adult_wrong_flash',
            text:
                'Uso o pisca-alerta para mostrar que a parada ser\u00e1 r\u00e1pida.',
            isCorrect: false,
            consequenceText:
                'O ve\u00edculo continua ocupando o espa\u00e7o e afetando a circula\u00e7\u00e3o.',
            meloFeedback:
                'Sinalizar a parada n\u00e3o elimina o impacto do local escolhido.',
          ),
        ],
      );
  }
}
