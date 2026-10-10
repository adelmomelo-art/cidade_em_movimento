import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone4SpecialMission(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z4_SPECIAL',
        title: 'Cidade em Festa',
        description:
            'Use tudo o que aprendeu para circular em um grande evento.',
        sceneText:
            'A cidade recebe um grande evento cultural com bloqueios, travessias e pontos de embarque.',
        question: 'Qual conjunto de atitudes ajuda mais?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Fico com meu grupo, respeito barreiras e uso os caminhos indicados.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea participa do evento com seguran\u00e7a.',
            meloFeedback:
                'Excelente. Organiza\u00e7\u00e3o e aten\u00e7\u00e3o ajudam todos.',
          ),
          MissionOption(
            id: 'child_wrong_hurry',
            text: 'Procuro sempre o caminho mais r\u00e1pido.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea pode sair das rotas seguras.',
            meloFeedback: 'Mais r\u00e1pido nem sempre \u00e9 mais seguro.',
          ),
          MissionOption(
            id: 'child_wrong_follow',
            text: 'Sigo qualquer grupo que pare\u00e7a saber onde ir.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea pode se separar de quem acompanha.',
            meloFeedback:
                'Permane\u00e7a com seu grupo e siga a orienta\u00e7\u00e3o.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z4_SPECIAL',
        title: 'Cidade em Festa',
        description:
            'Integre sinaliza\u00e7\u00e3o, travessia, embarque e conviv\u00eancia.',
        sceneText:
            'Voc\u00ea circula por um grande evento com fluxos tempor\u00e1rios.',
        question: 'Qual postura representa melhor a cidadania?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Adapto minha rota, respeito as orienta\u00e7\u00f5es e evito improvisos.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea se integra ao evento sem criar novos conflitos.',
            meloFeedback:
                'Muito bem. Mobilidade em eventos exige adapta\u00e7\u00e3o e respeito ao coletivo.',
          ),
          MissionOption(
            id: 'teen_wrong_shortcut',
            text: 'Uso atalhos porque conhe\u00e7o a regi\u00e3o.',
            isCorrect: false,
            consequenceText:
                'A organiza\u00e7\u00e3o tempor\u00e1ria mudou os fluxos habituais.',
            meloFeedback:
                'Conhecer a regi\u00e3o n\u00e3o substitui observar a opera\u00e7\u00e3o atual.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text: 'Vou usando o celular para acompanhar meus amigos.',
            isCorrect: false,
            consequenceText: 'Sua aten\u00e7\u00e3o ao fluxo cai.',
            meloFeedback: 'Use o celular parado em local seguro.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z4_SPECIAL',
        title: 'Cidade em Festa',
        description:
            'Integre condu\u00e7\u00e3o defensiva e respeito \u00e0 opera\u00e7\u00e3o tempor\u00e1ria.',
        sceneText:
            'Voc\u00ea circula no entorno de um grande evento em Fortaleza.',
        question:
            'Qual postura resume melhor uma condu\u00e7\u00e3o cidad\u00e3?',
        maxCitizenship: 50,
        maxKnowledge: 35,
        maxCoins: 60,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Respeito bloqueios, reduzo em \u00e1reas de pedestres e uso pontos permitidos de parada.',
            isCorrect: true,
            consequenceText:
                'Sua condu\u00e7\u00e3o se integra \u00e0 opera\u00e7\u00e3o do evento.',
            meloFeedback:
                'Excelente. Conduzir bem em eventos \u00e9 adaptar-se ao ambiente real.',
          ),
          MissionOption(
            id: 'adult_wrong_convenience',
            text:
                'Fa\u00e7o paradas r\u00e1pidas se isso ajudar meus passageiros.',
            isCorrect: false,
            consequenceText:
                'A conveni\u00eancia cria novos pontos de conflito.',
            meloFeedback: 'Use sempre locais permitidos.',
          ),
          MissionOption(
            id: 'adult_wrong_app',
            text:
                'Sigo meu aplicativo mesmo com sinaliza\u00e7\u00e3o diferente.',
            isCorrect: false,
            consequenceText: 'A rota pode estar desatualizada.',
            meloFeedback:
                'A sinaliza\u00e7\u00e3o local orienta a condi\u00e7\u00e3o atual.',
          ),
        ],
      );
  }
}
