import '../../models/sign_duel_question.dart';

const signDuelQuestions = <SignDuelQuestion>[
  SignDuelQuestion(
    id: 'DUEL_R1',
    code: 'R-1',
    title: 'Parada obrigatoria',
    prompt: 'Ao encontrar a placa R-1, qual deve ser a conduta?',
    options: <String>[
      'Reduzir um pouco e seguir sem parar',
      'Parar antes de prosseguir com seguranca',
      'Apenas dar preferencia a veiculos maiores',
    ],
    correctIndex: 1,
    explanation:
        'A R-1 determina parada obrigatoria. O condutor deve parar e so depois seguir quando houver seguranca.',
    level: 1,
  ),
  SignDuelQuestion(
    id: 'DUEL_R2',
    code: 'R-2',
    title: 'De a preferencia',
    prompt: 'O que a placa R-2 exige do condutor?',
    options: <String>[
      'Dar preferencia ao fluxo da via que sera acessada ou cruzada',
      'Parar sempre, mesmo sem conflito',
      'Aumentar a velocidade para liberar o cruzamento',
    ],
    correctIndex: 0,
    explanation:
        'A R-2 indica que o condutor deve dar preferencia e prosseguir somente quando a manobra puder ser feita com seguranca.',
    level: 1,
  ),
  SignDuelQuestion(
    id: 'DUEL_R6A',
    code: 'R-6a',
    title: 'Proibido estacionar',
    prompt: 'Qual e o significado da placa R-6a?',
    options: <String>[
      'Proibido parar e estacionar',
      'Estacionamento regulamentado',
      'Proibido estacionar',
    ],
    correctIndex: 2,
    explanation:
        'A R-6a proibe o estacionamento. Ela nao deve ser confundida com a proibicao de parar e estacionar.',
    level: 2,
  ),
  SignDuelQuestion(
    id: 'DUEL_R19',
    code: 'R-19',
    title: 'Velocidade maxima permitida',
    prompt: 'Uma placa R-19 com o numero 40 indica o que?',
    options: <String>[
      'Velocidade minima de 40 km/h',
      'Velocidade maxima permitida de 40 km/h',
      'Distancia obrigatoria de 40 metros',
    ],
    correctIndex: 1,
    explanation:
        'A R-19 informa a velocidade maxima permitida no trecho, expressa em km/h.',
    level: 2,
  ),
  SignDuelQuestion(
    id: 'DUEL_A18',
    code: 'A-18',
    title: 'Saliencia ou lombada',
    prompt: 'A placa de advertencia A-18 alerta para qual situacao?',
    options: <String>[
      'Saliencia ou lombada na via',
      'Ponte estreita',
      'Pista escorregadia',
    ],
    correctIndex: 0,
    explanation:
        'A A-18 adverte sobre a existencia de saliencia ou lombada, exigindo reducao preventiva da velocidade.',
    level: 3,
  ),
  SignDuelQuestion(
    id: 'DUEL_A32B',
    code: 'A-32b',
    title: 'Passagem sinalizada de pedestres',
    prompt:
        'Ao perceber a placa A-32b, qual atitude combina com direcao segura?',
    options: <String>[
      'Acelerar para passar antes dos pedestres',
      'Manter atencao e estar pronto para reduzir ou parar',
      'Usar a buzina continuamente',
    ],
    correctIndex: 1,
    explanation:
        'A sinalizacao alerta para passagem sinalizada de pedestres. A atitude segura e ampliar a atencao e ajustar a velocidade.',
    level: 3,
  ),
];
