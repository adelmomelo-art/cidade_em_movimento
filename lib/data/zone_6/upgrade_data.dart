import '../../models/upgrade_definition.dart';

const zone6Upgrades = <UpgradeDefinition>[
  UpgradeDefinition(
    id: 'CORREDOR_PEDESTRE_CASTELAO',
    zoneId: 'ZONE_6',
    title: 'Corredor de Pedestres',
    description:
        'Organiza o deslocamento a pe entre acessos, travessias e pontos de transporte.',
    cost: 60,
  ),
  UpgradeDefinition(
    id: 'ILUMINACAO_ENTORNO_CASTELAO',
    zoneId: 'ZONE_6',
    title: 'Iluminacao do Entorno',
    description:
        'Reforca a visibilidade nas rotas de chegada e dispersao em eventos noturnos.',
    cost: 80,
  ),
  UpgradeDefinition(
    id: 'EMBARQUE_INTEGRADO_CASTELAO',
    zoneId: 'ZONE_6',
    title: 'Area de Embarque Integrada',
    description:
        'Organiza pontos de embarque e desembarque longe dos principais conflitos de fluxo.',
    cost: 100,
  ),
  UpgradeDefinition(
    id: 'ROTA_ACESSIVEL_CASTELAO',
    zoneId: 'ZONE_6',
    title: 'Rota acessível ao estádio',
    description:
        'Facilita a chegada ao estádio de pessoas com diferentes mobilidades.',
    cost: 40,
  ),
  UpgradeDefinition(
    id: 'BICICLETARIO_CASTELAO',
    zoneId: 'ZONE_6',
    title: 'Bicicletário do estádio',
    description:
        'Oferece estacionamento para bicicletas sem obstruir os acessos.',
    cost: 60,
  ),
];
