import '../../models/upgrade_definition.dart';

const buildNeighborhoodUpgrades = <UpgradeDefinition>[
  UpgradeDefinition(
    id: 'BAIRRO_CALCADA_ACESSIVEL',
    zoneId: 'BUILD_NEIGHBORHOOD',
    title: 'Calcada Acessivel',
    description:
        'Cria uma rota de caminhada mais continua, acessivel e segura para moradores.',
    cost: 40,
  ),
  UpgradeDefinition(
    id: 'BAIRRO_PRACA_CONVIVENCIA',
    zoneId: 'BUILD_NEIGHBORHOOD',
    title: 'Praca de Convivencia',
    description:
        'Transforma um espaco ocioso em area de encontro, descanso e cidadania.',
    cost: 60,
  ),
  UpgradeDefinition(
    id: 'BAIRRO_BICICLETARIO',
    zoneId: 'BUILD_NEIGHBORHOOD',
    title: 'Bicicletario Comunitario',
    description:
        'Incentiva deslocamentos curtos de bicicleta com um ponto seguro de apoio.',
    cost: 80,
  ),
];
