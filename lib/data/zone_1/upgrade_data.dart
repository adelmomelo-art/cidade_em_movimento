class Zone1Upgrade {
  const Zone1Upgrade({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
  });

  final String id;
  final String title;
  final String description;
  final int cost;
}

const zone1Upgrades = <Zone1Upgrade>[
  Zone1Upgrade(
    id: 'FAIXA_SEGURA',
    title: 'Faixa Segura',
    description:
        'Refor\u00e7a a travessia de pedestres e torna o caminho '
        'escolar mais vis\u00edvel.',
    cost: 50,
  ),
  Zone1Upgrade(
    id: 'ILUMINACAO_ESCOLAR',
    title: 'Ilumina\u00e7\u00e3o Escolar',
    description:
        'Melhora a visibilidade do entorno da escola e dos pontos '
        'de travessia.',
    cost: 70,
  ),
  Zone1Upgrade(
    id: 'TRECHO_CICLOVIARIO',
    title: 'Trecho Ciclovi\u00e1rio',
    description:
        'Cria um trecho dedicado para tornar a rota de bicicleta '
        'mais organizada e segura.',
    cost: 100,
  ),
];
