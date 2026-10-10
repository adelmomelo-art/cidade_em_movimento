import '../../models/upgrade_definition.dart';

const zone3Upgrades = <UpgradeDefinition>[
  UpgradeDefinition(
    id: 'TRAVESSIA_ORLA_SEGURA',
    zoneId: 'ZONE_3',
    title: 'Travessia da Orla',
    description:
        'Refor\u00e7a a travessia segura entre cal\u00e7ad\u00e3o, ciclovia '
        'e faixa de circula\u00e7\u00e3o.',
    cost: 60,
  ),
  UpgradeDefinition(
    id: 'CICLOVIA_CONECTADA',
    zoneId: 'ZONE_3',
    title: 'Ciclovia Conectada',
    description:
        'Organiza pontos de conflito entre ciclistas, pedestres '
        'e acessos da orla.',
    cost: 80,
  ),
  UpgradeDefinition(
    id: 'EMBARQUE_ORGANIZADO',
    zoneId: 'ZONE_3',
    title: 'Embarque Organizado',
    description:
        'Melhora embarque, desembarque e paradas r\u00e1pidas '
        'em \u00e1reas movimentadas da orla.',
    cost: 100,
  ),
];
