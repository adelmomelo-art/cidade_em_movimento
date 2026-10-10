import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone4Mission02(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z4_M02',
        title: 'Travessia com Multid\u00e3o',
        description:
            'Aprenda a atravessar com seguran\u00e7a em grandes grupos.',
        sceneText: 'Muitas pessoas se aproximam da mesma travessia.',
        question: 'O que ajuda voc\u00ea a atravessar melhor?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Espero a orienta\u00e7\u00e3o e atravesso no local indicado.',
            isCorrect: true,
            consequenceText: 'O grupo atravessa de forma organizada.',
            meloFeedback:
                'Muito bem. Em multid\u00f5es, organize-se pelo fluxo indicado.',
          ),
          MissionOption(
            id: 'child_wrong_follow',
            text: 'Entro na rua porque todo mundo est\u00e1 indo.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea deixa de observar se a travessia est\u00e1 liberada.',
            meloFeedback:
                'Multid\u00e3o n\u00e3o substitui sinaliza\u00e7\u00e3o e aten\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'child_wrong_edge',
            text: 'Saio pelo lado do grupo para andar mais r\u00e1pido.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea se aproxima de uma \u00e1rea de ve\u00edculos.',
            meloFeedback: 'Mantenha-se no fluxo seguro.',
          ),
        ],
      );
    case PlayerType.teen:
      return const Mission(
        id: 'Z4_M02',
        title: 'Travessia com Multid\u00e3o',
        description:
            'Mantenha aten\u00e7\u00e3o mesmo quando o grupo \u00e9 grande.',
        sceneText:
            'A sa\u00edda do evento concentra muita gente na mesma travessia.',
        question: 'Qual comportamento \u00e9 mais seguro?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Sigo o fluxo indicado e continuo observando a sinaliza\u00e7\u00e3o.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea acompanha o grupo sem perder sua leitura do ambiente.',
            meloFeedback: 'Boa. Mesmo em grupo, continue observando.',
          ),
          MissionOption(
            id: 'teen_wrong_phone',
            text: 'Aproveito que todos est\u00e3o juntos para olhar o celular.',
            isCorrect: false,
            consequenceText:
                'Voc\u00ea deixa de perceber mudan\u00e7as no fluxo.',
            meloFeedback: 'Multid\u00e3o exige ainda mais aten\u00e7\u00e3o.',
          ),
          MissionOption(
            id: 'teen_wrong_fast',
            text: 'Passo por fora do grupo para ganhar tempo.',
            isCorrect: false,
            consequenceText: 'Voc\u00ea sai da \u00e1rea protegida.',
            meloFeedback: 'O fluxo organizado existe para reduzir conflitos.',
          ),
        ],
      );
    case PlayerType.adult:
      return const Mission(
        id: 'Z4_M02',
        title: 'Travessia com Multid\u00e3o',
        description:
            'Antecipe a movimenta\u00e7\u00e3o de grandes grupos de pedestres.',
        sceneText:
            'Voc\u00ea se aproxima de uma travessia cheia ap\u00f3s o evento.',
        question: 'Qual atitude protege melhor o grupo?',
        maxCitizenship: 20,
        maxKnowledge: 15,
        maxCoins: 20,
        options: [
          MissionOption(
            id: 'adult_correct',
            text: 'Reduzo cedo e aguardo a conclus\u00e3o da travessia.',
            isCorrect: true,
            consequenceText: 'O grupo conclui a travessia com margem.',
            meloFeedback:
                'Excelente. Grandes grupos exigem mais tempo e previsibilidade.',
          ),
          MissionOption(
            id: 'adult_wrong_gap',
            text: 'Aproveito uma abertura entre os grupos.',
            isCorrect: false,
            consequenceText: 'A abertura fecha rapidamente.',
            meloFeedback:
                'Em multid\u00f5es, pequenas brechas n\u00e3o s\u00e3o margem segura.',
          ),
          MissionOption(
            id: 'adult_wrong_horn',
            text: 'Buzino para que abram passagem.',
            isCorrect: false,
            consequenceText:
                'O som aumenta a press\u00e3o sem organizar o fluxo.',
            meloFeedback: 'Reduza e aguarde.',
          ),
        ],
      );
  }
}
