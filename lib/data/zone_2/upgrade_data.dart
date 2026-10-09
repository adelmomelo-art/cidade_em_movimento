import '../../models/upgrade_definition.dart';

const zone2Upgrades = <UpgradeDefinition>[
  UpgradeDefinition(
    id: 'TRAVESSIA_ACESSIVEL',
    zoneId: 'ZONE_2',
    title: 'Travessia Acess\u00edvel',
    description:
        'Organiza a travessia e refor\u00e7a a acessibilidade '
        'para quem circula pelo Centro.',
    cost: 60,
  ),
  UpgradeDefinition(
    id: 'PONTO_SEGURO',
    zoneId: 'ZONE_2',
    title: 'Ponto Seguro',
    description:
        'Melhora a organiza\u00e7\u00e3o do embarque e desembarque '
        'no transporte coletivo.',
    cost: 80,
  ),
  UpgradeDefinition(
    id: 'ROTA_COMPARTILHADA',
    zoneId: 'ZONE_2',
    title: 'Rota Compartilhada',
    description:
        'Organiza a conviv\u00eancia entre bicicletas, pedestres '
        'e outros modos de transporte.',
    cost: 100,
  ),
];
