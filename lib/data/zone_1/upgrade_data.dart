import '../../models/upgrade_definition.dart';

const zone1Upgrades = <UpgradeDefinition>[
  UpgradeDefinition(
    id: 'FAIXA_SEGURA',
    zoneId: 'ZONE_1',
    title: 'Faixa Segura',
    description:
        'Refor\u00e7a a travessia de pedestres e torna o caminho '
        'escolar mais vis\u00edvel.',
    cost: 50,
  ),
  UpgradeDefinition(
    id: 'ILUMINACAO_ESCOLAR',
    zoneId: 'ZONE_1',
    title: 'Ilumina\u00e7\u00e3o Escolar',
    description:
        'Melhora a visibilidade do entorno da escola e dos pontos '
        'de travessia.',
    cost: 70,
  ),
  UpgradeDefinition(
    id: 'TRECHO_CICLOVIARIO',
    zoneId: 'ZONE_1',
    title: 'Trecho Ciclovi\u00e1rio',
    description:
        'Cria um trecho dedicado para tornar a rota de bicicleta '
        'mais organizada e segura.',
    cost: 100,
  ),
];
