import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone4Mission05(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z4_M05',
        title: 'Sa\u00edda Segura',
        description: 'Organize sua sa\u00edda de um grande evento.',
        sceneText:
            'O evento termina e milhares de pessoas come\u00e7am a sair.',
        question: 'Qual comportamento ajuda mais?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'child_correct',
            text: 'Fico com meu grupo e sigo os corredores de sa\u00edda.',
            isCorrect: true,
            consequenceText: 'Voc\u00ea sai pelo fluxo organizado.',
            meloFeedback:
                'Excelente. Sa\u00edda segura tamb\u00e9m depende de calma e organiza\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'child_wrong_run',
            text: 'Corro para sair antes de todo mundo.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea pode se separar do grupo.',
            meloFeedback: 'Mantenha-se com seu grupo.',
          ),
          MissionOption(
            id: 'child_wrong_side',
            text: 'Saio por uma lateral onde tem menos gente.',
            isCorrect: false,
            consequenceText:
                'Essa lateral pode levar a uma \u00e1rea de ve\u00edculos.',
            meloFeedback: 'Use as rotas oficiais.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z4_M05',
        title: 'Sa\u00edda Segura',
        description:
            'Evite decis\u00f5es impulsivas na dispers\u00e3o do p\u00fablico.',
        sceneText:
            'Voc\u00ea encontra muita gente e tr\u00e2nsito lento na sa\u00edda.',
        question: 'Qual atitude \u00e9 mais segura?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Sigo o fluxo indicado e uso um ponto seguro para encontrar meu transporte.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea reduz conflitos e n\u00e3o ocupa a via.',
            meloFeedback:
                'Boa. Planejamento evita improvisos no momento mais cheio.',
          ),
          MissionOption(
            id: 'teen_wrong_cross',
            text: 'Corto caminho por entre os carros parados.',
            isCorrect: false,
            consequenceText:
                'Um ve\u00edculo pode voltar a se mover sem perceber voc\u00ea.',
            meloFeedback:
                'Carro parado pode voltar a andar. Evite circular entre ve\u00edculos.',
          ),
          MissionOption(
            id: 'teen_wrong_ride',
            text: 'Pe\u00e7o para o transporte me buscar exatamente na porta.',
            isCorrect: false,
            consequenceText:
                'Isso aumenta as paradas no ponto mais congestionado.',
            meloFeedback:
                'Use um ponto de encontro fora do conflito principal.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z4_M05',
        title: 'Sa\u00edda Segura',
        description: 'Conduza com previsibilidade na dispers\u00e3o do evento.',
        sceneText:
            'Voc\u00ea dirige enquanto milhares de pessoas deixam o local.',
        question: 'Qual estrat\u00e9gia oferece maior margem?',
        maxCitizenship: 30,
        maxKnowledge: 25,
        maxCoins: 30,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo, amplio a observa\u00e7\u00e3o e aceito o ritmo mais lento.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea ganha margem para movimentos inesperados.',
            meloFeedback:
                'Excelente. Na dispers\u00e3o, paci\u00eancia e margem valem mais que velocidade.',
          ),
          MissionOption(
            id: 'adult_wrong_gap',
            text: 'Aproveito pequenas brechas para ganhar posi\u00e7\u00e3o.',
            isCorrect: false,
            consequenceText: 'Pedestres podem surgir entre os ve\u00edculos.',
            meloFeedback:
                'N\u00e3o transforme congestionamento em disputa por espa\u00e7o.',
          ),
          MissionOption(
            id: 'adult_wrong_horn',
            text: 'Buzino para agilizar o fluxo.',
            isCorrect: false,
            consequenceText:
                'O som n\u00e3o resolve a limita\u00e7\u00e3o de espa\u00e7o.',
            meloFeedback: 'Mantenha calma e previsibilidade.',
          ),
        ],
      );
  }
}
