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
      Offset(720, 701),
      Offset(840, 763),
      Offset(605, 864),
      Offset(491, 800),
    ),
    'PONTO_SEGURO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.busBay,
      Offset(289, 616),
      Offset(455, 694),
      Offset(486, 679),
      Offset(320, 601),
    ),
    'ROTA_COMPARTILHADA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.cycleLane,
      Offset(1018, 714),
      Offset(1312, 574),
      Offset(1332, 589),
      Offset(1038, 732),
    ),
    'ILUMINACAO_TRAVESSIAS_CENTRO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.lighting,
      Offset(489, 762),
      Offset(822, 678),
      Offset(842, 696),
      Offset(508, 783),
    ),
    'PRACA_CONVIVENCIA_CENTRO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.plaza,
      Offset(924, 620),
      Offset(963, 608),
      Offset(1005, 628),
      Offset(967, 641),
    ),
  },
  'ZONE_3': {
    'TRAVESSIA_ORLA_SEGURA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.crosswalk,
      Offset(540, 678),
      Offset(650, 729),
      Offset(541, 780),
      Offset(435, 728),
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
      Offset(1160, 802),
      Offset(1219, 828),
      Offset(1263, 809),
      Offset(1206, 783),
    ),
    'ACESSO_CALCADAO_ORLA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.sidewalk,
      Offset(849, 467),
      Offset(884, 482),
      Offset(853, 501),
      Offset(819, 486),
    ),
    'BICICLETARIO_ORLA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.bicycleRack,
      Offset(913, 431),
      Offset(968, 453),
      Offset(948, 470),
      Offset(893, 448),
    ),
  },
  'ZONE_4': {
    'TRAVESSIA_EVENTO_SEGURA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.crosswalk,
      Offset(622, 493),
      Offset(899, 552),
      Offset(772, 610),
      Offset(500, 547),
    ),
    'SINALIZACAO_TEMPORARIA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.trafficCones,
      Offset(1253, 408),
      Offset(1363, 439),
      Offset(1347, 455),
      Offset(1236, 425),
    ),
    'EMBARQUE_EVENTO_ORGANIZADO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.busBay,
      Offset(931, 746),
      Offset(1036, 698),
      Offset(1067, 712),
      Offset(961, 761),
    ),
    'ROTA_ACESSIVEL_EVENTO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.sidewalk,
      Offset(477, 749),
      Offset(608, 695),
      Offset(638, 711),
      Offset(506, 767),
    ),
    'ILUMINACAO_ACESSOS_EVENTO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.lighting,
      Offset(468, 769),
      Offset(652, 706),
      Offset(668, 719),
      Offset(485, 783),
    ),
  },
  'ZONE_5': {
    'TRAVESSIA_GRANDE_VIA': NeighborhoodSurface(
      NeighborhoodSurfaceKind.crosswalk,
      Offset(581, 575),
      Offset(779, 604),
      Offset(688, 674),
      Offset(498, 646),
    ),
    'ILUMINACAO_CORREDOR': NeighborhoodSurface(
      NeighborhoodSurfaceKind.lighting,
      Offset(450, 640),
      Offset(1111, 741),
      Offset(1126, 765),
      Offset(464, 665),
    ),
    'REFUGIO_PEDESTRE': NeighborhoodSurface(
      NeighborhoodSurfaceKind.refuge,
      Offset(795, 643),
      Offset(876, 656),
      Offset(858, 680),
      Offset(777, 666),
    ),
    'PONTO_ACESSIVEL_CORREDOR': NeighborhoodSurface(
      NeighborhoodSurfaceKind.busBay,
      Offset(1198, 494),
      Offset(1220, 413),
      Offset(1245, 417),
      Offset(1223, 501),
    ),
    'CALCADA_CONTINUA_CORREDOR': NeighborhoodSurface(
      NeighborhoodSurfaceKind.sidewalk,
      Offset(343, 755),
      Offset(471, 826),
      Offset(452, 849),
      Offset(323, 777),
    ),
  },
  'ZONE_6': {
    'CORREDOR_PEDESTRE_CASTELAO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.crosswalk,
      Offset(412, 488),
      Offset(601, 482),
      Offset(573, 527),
      Offset(385, 538),
    ),
    'ILUMINACAO_ENTORNO_CASTELAO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.lighting,
      Offset(407, 635),
      Offset(727, 389),
      Offset(745, 407),
      Offset(423, 653),
    ),
    'EMBARQUE_INTEGRADO_CASTELAO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.busBay,
      Offset(945, 492),
      Offset(1051, 541),
      Offset(1036, 554),
      Offset(929, 506),
    ),
    'ROTA_ACESSIVEL_CASTELAO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.sidewalk,
      Offset(384, 742),
      Offset(481, 735),
      Offset(483, 756),
      Offset(386, 764),
    ),
    'BICICLETARIO_CASTELAO': NeighborhoodSurface(
      NeighborhoodSurfaceKind.bicycleRack,
      Offset(628, 374),
      Offset(682, 354),
      Offset(703, 366),
      Offset(649, 387),
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
