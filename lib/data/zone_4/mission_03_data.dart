import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone4Mission03(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z4_M03',
        title: 'Embarque Organizado',
        description:
            'Aprenda a embarcar sem entrar em \u00e1rea de ve\u00edculos.',
        sceneText: 'Sua fam\u00edlia vai embora e procura o ponto de embarque.',
        question: 'O que fazer?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'child_correct',
            text: 'Espero no local indicado at\u00e9 o ve\u00edculo chegar.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea permanece fora do fluxo de ve\u00edculos.',
            meloFeedback:
                'Muito bem. Embarque organizado reduz risco e confus\u00e3o.',
          ),
          MissionOption(
            id: 'child_wrong_street',
            text: 'Vou para a rua procurar o carro.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea entra em uma \u00e1rea de circula\u00e7\u00e3o.',
            meloFeedback: 'Espere em local seguro.',
          ),
          MissionOption(
            id: 'child_wrong_run',
            text: 'Corro quando vejo o carro chegando.',
            isCorrect: false,
            consequenceText:
                'Outros ve\u00edculos tamb\u00e9m est\u00e3o circulando.',
            meloFeedback: 'Aguarde o ve\u00edculo parar no ponto adequado.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z4_M03',
        title: 'Embarque Organizado',
        description: 'Use pontos de encontro e embarque seguros.',
        sceneText: 'Voc\u00ea vai encontrar um transporte ap\u00f3s o evento.',
        question: 'Qual decis\u00e3o reduz conflitos?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'teen_correct',
            text: 'Combino um ponto permitido e aguardo fora da pista.',
            isCorrect: true,
            consequenceText: 'O encontro ocorre sem ocupar a via.',
            meloFeedback:
                'Boa. Planejar o ponto de encontro evita paradas improvisadas.',
          ),
          MissionOption(
            id: 'teen_wrong_message',
            text: 'Pe\u00e7o para o motorista parar onde eu estiver.',
            isCorrect: false,
            consequenceText: 'O ve\u00edculo pode bloquear o fluxo.',
            meloFeedback: 'Use um ponto adequado de embarque.',
          ),
          MissionOption(
            id: 'teen_wrong_cross',
            text:
                'Atravesso fora do local indicado para chegar mais r\u00e1pido.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea entra em conflito com o fluxo de sa\u00edda.',
            meloFeedback: 'N\u00e3o transforme pressa em risco.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z4_M03',
        title: 'Embarque Organizado',
        description: 'Evite paradas improvisadas em grandes eventos.',
        sceneText: 'Voc\u00ea vai buscar passageiros ap\u00f3s o evento.',
        question: 'Qual estrat\u00e9gia \u00e9 melhor?',
        maxCitizenship: 25,
        maxKnowledge: 20,
        maxCoins: 25,
        options: [
          MissionOption(
            id: 'adult_correct',
            text: 'Combino um ponto permitido de embarque e aguardo ali.',
            isCorrect: true,
            consequenceText: 'O embarque acontece sem bloquear o fluxo.',
            meloFeedback:
                'Correto. Organiza\u00e7\u00e3o evita fila dupla e conflitos.',
          ),
          MissionOption(
            id: 'adult_wrong_double',
            text: 'Paro em fila dupla por poucos segundos.',
            isCorrect: false,
            consequenceText: 'O fluxo atr\u00e1s precisa desviar.',
            meloFeedback: 'Poucos segundos ainda podem gerar risco.',
          ),
          MissionOption(
            id: 'adult_wrong_corner',
            text: 'Paro perto da esquina para facilitar o encontro.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea reduz a visibilidade e o espa\u00e7o de manobra.',
            meloFeedback: 'Prefira sempre o ponto planejado.',
          ),
        ],
      );
  }
}
