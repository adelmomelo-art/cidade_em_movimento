import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone3Mission02(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z3_M02',
        title: 'Ciclovia Compartilhada',
        description:
            'Entenda como caminhar perto de uma ciclovia com seguran\u00e7a.',
        sceneText:
            'Voc\u00ea caminha pelo cal\u00e7ad\u00e3o e precisa cruzar uma ciclovia.',
        question: 'O que fazer antes de cruzar?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Paro, olho para os dois lados e cruzo sem permanecer na ciclovia.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea respeita o espa\u00e7o dos ciclistas e evita conflito.',
            meloFeedback:
                'Muito bem. A ciclovia tamb\u00e9m exige observa\u00e7\u00e3o antes de cruzar.',
          ),
          MissionOption(
            id: 'child_wrong_play',
            text: 'Fico alguns segundos na ciclovia esperando meus amigos.',
            isCorrect: false,
            consequenceText: 'Um ciclista precisa desviar inesperadamente.',
            meloFeedback:
                'Use a ciclovia apenas para cruzar quando for necess\u00e1rio.',
          ),
          MissionOption(
            id: 'child_wrong_run',
            text: 'Corro sem olhar para atravessar mais r\u00e1pido.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea entra na rota de uma bicicleta que se aproxima.',
            meloFeedback: 'Rapidez sem observa\u00e7\u00e3o aumenta o risco.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z3_M02',
        title: 'Ciclovia Compartilhada',
        description: 'Pratique previsibilidade ao pedalar na orla.',
        sceneText:
            'Voc\u00ea pedala e se aproxima de pedestres que podem cruzar a ciclovia.',
        question: 'Qual atitude melhora a conviv\u00eancia?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Reduzo, observo os pedestres e mantenho trajet\u00f3ria previs\u00edvel.',
            isCorrect: true,
            consequenceText: 'Todos conseguem perceber melhor seus movimentos.',
            meloFeedback:
                'Boa. Na ciclovia, velocidade compat\u00edvel e previsibilidade reduzem conflitos.',
          ),
          MissionOption(
            id: 'teen_wrong_fast',
            text: 'Acelero para passar antes que eles cruzem.',
            isCorrect: false,
            consequenceText: 'A margem de rea\u00e7\u00e3o diminui.',
            meloFeedback:
                'Antecipe o conflito, n\u00e3o tente venc\u00ea-lo na velocidade.',
          ),
          MissionOption(
            id: 'teen_wrong_bell',
            text: 'Uso a campainha e mantenho a velocidade.',
            isCorrect: false,
            consequenceText:
                'Nem todos percebem ou entendem sua inten\u00e7\u00e3o.',
            meloFeedback: 'Avisar ajuda, mas reduzir continua essencial.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z3_M02',
        title: 'Ciclovia Compartilhada',
        description:
            'Respeite ciclistas ao acessar ou sair de \u00e1reas da orla.',
        sceneText:
            'Voc\u00ea precisa entrar em um acesso que cruza a ciclovia.',
        question: 'Qual conduta \u00e9 mais segura?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo, verifico a ciclovia e s\u00f3 cruzo quando houver margem segura.',
            isCorrect: true,
            consequenceText:
                'O ciclista mant\u00e9m sua rota sem precisar frear bruscamente.',
            meloFeedback:
                'Excelente. Observe a ciclovia antes de ocupar seu espa\u00e7o.',
          ),
          MissionOption(
            id: 'adult_wrong_nose',
            text: 'Avan\u00e7o a frente do ve\u00edculo para enxergar melhor.',
            isCorrect: false,
            consequenceText: 'A frente do carro invade a rota do ciclista.',
            meloFeedback:
                'Ganhar visibilidade n\u00e3o pode significar bloquear quem j\u00e1 circula.',
          ),
          MissionOption(
            id: 'adult_wrong_horn',
            text: 'Buzino para o ciclista perceber que vou cruzar.',
            isCorrect: false,
            consequenceText: 'O conflito continua existindo.',
            meloFeedback:
                'Priorize observa\u00e7\u00e3o e margem, n\u00e3o press\u00e3o.',
          ),
        ],
      );
  }
}
