import 'package:flutter/material.dart';

/// Coordinates were checked against each approved map and scenery asset.
/// Both assets are registered to the same 1672 x 941 reference canvas.
/// Corners describe the ground, never a viewport-relative badge.
enum NeighborhoodSurfaceKind {
  crosswalk,
  cycleLane,
  sidewalk,
  busBay,
  lighting,
  bicycleRack,
  plaza,
  trafficCones,
  refuge,
}

class NeighborhoodSurface {
  const NeighborhoodSurface(this.kind, this.a, this.b, this.c, this.d);
  final NeighborhoodSurfaceKind kind;
  final Offset a;
  final Offset b;
  final Offset c;
  final Offset d;

  Offset point(double u, double v) {
    final top = a + (b - a) * u;
    final bottom = d + (c - d) * u;
    return top + (bottom - top) * v;
  }

  Path get path => Path()
    ..moveTo(a.dx, a.dy)
    ..lineTo(b.dx, b.dy)
    ..lineTo(c.dx, c.dy)
    ..lineTo(d.dx, d.dy)
    ..close();
}

const neighborhoodArtworkSize = Size(1672, 941);
// Approved against the A/B mapping on 26/10/2026: the lateral approach.
// B, in the foreground, is an invalid crossing and is never a build state.
const zone1ApprovedCrossing = NeighborhoodSurface(
  NeighborhoodSurfaceKind.crosswalk,
  Offset(282, 625),
  Offset(323, 650),
  Offset(214, 698),
  Offset(172, 674),
);
const zone1ApprovedRamp = NeighborhoodSurface(
  NeighborhoodSurfaceKind.sidewalk,
  Offset(294, 607),
  Offset(339, 634),
  Offset(324, 653),
  Offset(279, 626),
);
const neighborhoodSurfaces = <String, Map<String, NeighborhoodSurface>>{
  'ZONE_1': {
    'FAIXA_SEGURA': zone1ApprovedCrossing,
    'ILUMINACAO_ESCOLAR': NeighborhoodSurface(
      NeighborhoodSurfaceKind.lighting,
      Offset(666, 480),
      Offset(1010, 432),
      Offset(1026, 446),
      Offset(683, 494),
    ),
    'TRECHO_CICLOVIARIO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.cycleLane,
      Offset(641, 818),
      Offset(1070, 643),
      Offset(1101, 661),
      Offset(667, 839),
    ),
    'CALCADA_ACESSIVEL_ESCOLAR': zone1ApprovedRamp,
    'BICICLETARIO_ESCOLAR': NeighborhoodSurface(
      NeighborhoodSurfaceKind.bicycleRack,
      Offset(850, 468),
      Offset(890, 453),
      Offset(907, 462),
      Offset(867, 478),
    ),
  },
  'ZONE_2': {
    'TRAVESSIA_ACESSIVEL': NeighborhoodSurface(
      NeighborhoodSurfaceKind.crosswalk,
      Offset(720.0, 701.0),
      Offset(840.0, 763.0),
      Offset(605.0, 864.0),
      Offset(491.0, 800.0),
    ),
    'PONTO_SEGURO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.busBay,
      Offset(477, 496),
      Offset(597, 535),
      Offset(594, 606),
      Offset(478, 571),
    ),
    'ROTA_COMPARTILHADA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.cycleLane,
      Offset(1356, 449),
      Offset(1407, 472),
      Offset(1394, 489),
      Offset(1343, 465),
    ),
    'ILUMINACAO_TRAVESSIAS_CENTRO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.lighting,
      Offset(623, 622),
      Offset(831, 714),
      Offset(838, 721),
      Offset(630, 629),
    ),
    'PRACA_CONVIVENCIA_CENTRO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.plaza,
      Offset(920, 644),
      Offset(972, 644),
      Offset(972, 682),
      Offset(920, 682),
    ),
  },
  'ZONE_3': {
    'TRAVESSIA_ORLA_SEGURA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.crosswalk,
      Offset(540.0, 678.0),
      Offset(650.0, 729.0),
      Offset(541.0, 780.0),
      Offset(435.0, 728.0),
    ),
    'CICLOVIA_CONECTADA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.cycleLane,
      Offset(736, 408),
      Offset(1002, 536),
      Offset(978, 553),
      Offset(712, 426),
    ),
    'EMBARQUE_ORGANIZADO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.busBay,
      Offset(977, 683),
      Offset(1061, 723),
      Offset(1095, 706),
      Offset(1011, 666),
    ),
    'ACESSO_CALCADAO_ORLA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.sidewalk,
      Offset(783, 425),
      Offset(810, 438),
      Offset(805, 450),
      Offset(778, 436),
    ),
    'BICICLETARIO_ORLA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.bicycleRack,
      Offset(1423, 615),
      Offset(1483, 615),
      Offset(1483, 655),
      Offset(1423, 655),
    ),
  },
  'ZONE_4': {
    'TRAVESSIA_EVENTO_SEGURA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.crosswalk,
      Offset(622.0, 493.0),
      Offset(899.0, 552.0),
      Offset(772.0, 610.0),
      Offset(500.0, 547.0),
    ),
    'SINALIZACAO_TEMPORARIA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.trafficCones,
      Offset(1250, 385),
      Offset(1448, 404),
      Offset(1448, 454),
      Offset(1250, 435),
    ),
    'EMBARQUE_EVENTO_ORGANIZADO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.busBay,
      Offset(824, 731),
      Offset(937, 680),
      Offset(958, 690),
      Offset(845, 743),
    ),
    'ROTA_ACESSIVEL_EVENTO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.sidewalk,
      Offset(584, 731),
      Offset(615, 716),
      Offset(630, 724),
      Offset(600, 740),
    ),
    'ILUMINACAO_ACESSOS_EVENTO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.lighting,
      Offset(630, 706),
      Offset(757, 665),
      Offset(764, 672),
      Offset(637, 713),
    ),
  },
  'ZONE_5': {
    'TRAVESSIA_GRANDE_VIA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.crosswalk,
      Offset(581.0, 575.0),
      Offset(779.0, 604.0),
      Offset(688.0, 674.0),
      Offset(498.0, 646.0),
    ),
    'ILUMINACAO_CORREDOR': NeighborhoodSurface(
      NeighborhoodSurfaceKind.lighting,
      Offset(473, 651),
      Offset(1135, 750),
      Offset(1142, 757),
      Offset(480, 658),
    ),
    'REFUGIO_PEDESTRE': NeighborhoodSurface(
      NeighborhoodSurfaceKind.refuge,
      Offset(795.0, 643.0),
      Offset(876.0, 656.0),
      Offset(858.0, 680.0),
      Offset(777.0, 666.0),
    ),
    'PONTO_ACESSIVEL_CORREDOR': NeighborhoodSurface(
      NeighborhoodSurfaceKind.busBay,
      Offset(1198.0, 494.0),
      Offset(1220.0, 413.0),
      Offset(1245.0, 417.0),
      Offset(1223.0, 501.0),
    ),
    'CALCADA_CONTINUA_CORREDOR': NeighborhoodSurface(
      NeighborhoodSurfaceKind.sidewalk,
      Offset(343.0, 755.0),
      Offset(471.0, 826.0),
      Offset(452.0, 849.0),
      Offset(323.0, 777.0),
    ),
  },
  'ZONE_6': {
    'CORREDOR_PEDESTRE_CASTELAO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.sidewalk,
      Offset(326, 706),
      Offset(332, 709),
      Offset(289, 805),
      Offset(283, 802),
    ),
    'ILUMINACAO_ENTORNO_CASTELAO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.lighting,
      Offset(308, 777),
      Offset(579, 877),
      Offset(586, 884),
      Offset(315, 784),
    ),
    'EMBARQUE_INTEGRADO_CASTELAO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.busBay,
      Offset(960, 484),
      Offset(1060, 530),
      Offset(1043, 539),
      Offset(944, 494),
    ),
    'ROTA_ACESSIVEL_CASTELAO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.sidewalk,
      Offset(453, 594),
      Offset(479, 612),
      Offset(464, 629),
      Offset(438, 610),
    ),
    'BICICLETARIO_CASTELAO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.bicycleRack,
      Offset(332, 845),
      Offset(397, 845),
      Offset(397, 889),
      Offset(332, 889),
    ),
  },
  'BUILD_NEIGHBORHOOD': {
    'BAIRRO_CALCADA_ACESSIVEL': NeighborhoodSurface(
      NeighborhoodSurfaceKind.sidewalk,
      Offset(475, 616),
      Offset(578, 575),
      Offset(600, 589),
      Offset(495, 632),
    ),
    'BAIRRO_PRACA_CONVIVENCIA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.plaza,
      Offset(1265, 503),
      Offset(1336, 478),
      Offset(1372, 497),
      Offset(1300, 522),
    ),
    'BAIRRO_BICICLETARIO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.bicycleRack,
      Offset(850, 468),
      Offset(890, 453),
      Offset(907, 462),
      Offset(867, 478),
    ),
  },
};
