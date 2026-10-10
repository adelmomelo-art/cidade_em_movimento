import '../../models/upgrade_definition.dart';

const zone5Upgrades = <UpgradeDefinition>[
  UpgradeDefinition(
    id: 'TRAVESSIA_GRANDE_VIA',
    zoneId: 'ZONE_5',
    title: 'Travessia Protegida',
    description:
        'Refor\u00e7a pontos de travessia em corredores de maior velocidade.',
    cost: 60,
  ),
  UpgradeDefinition(
    id: 'ILUMINACAO_CORREDOR',
    zoneId: 'ZONE_5',
    title: 'Ilumina\u00e7\u00e3o do Corredor',
    description:
        'Melhora a visibilidade em trechos de grande fluxo e travessia.',
    cost: 80,
  ),
  UpgradeDefinition(
    id: 'REFUGIO_PEDESTRE',
    zoneId: 'ZONE_5',
    title: 'Ref\u00fagio de Pedestres',
    description:
        'Cria uma \u00e1rea intermedi\u00e1ria de prote\u00e7\u00e3o em travessias extensas.',
    cost: 100,
  ),
];
