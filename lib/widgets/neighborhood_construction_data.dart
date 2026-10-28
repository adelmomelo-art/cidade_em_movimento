import 'package:flutter/material.dart';

// Registered game layers; references are studies, never comparison panels.
class ConstructionPiece {
  const ConstructionPiece(this.id, this.kind, this.ground, this.patches, this.posts, this.object);
  final String id;
  final String kind;
  final List<Offset> ground;
  final List<List<Offset>> patches;
  final List<Offset> posts;
  final Rect? object;
}
class ConstructionZone {
  const ConstructionZone(this.initial, this.original, this.pieces, this.mapForeground, this.permanent, this.sceneForeground);
  final String initial;
  final String original;
  final List<ConstructionPiece> pieces;
  final List<Rect> mapForeground;
  final List<List<Offset>> permanent;
  final List<Rect> sceneForeground;
}
const constructionZones = <String, ConstructionZone>{
  'ZONE_2': ConstructionZone('assets/build_neighborhood/r43_7/zone_2_initial.webp', 'assets/zone_2/r30/cenario_centro.webp', <ConstructionPiece>[
    ConstructionPiece('TRAVESSIA_ACESSIVEL', 'restore', <Offset>[Offset(720.0, 701.0),Offset(840.0, 763.0),Offset(605.0, 864.0),Offset(491.0, 800.0)], <List<Offset>>[<Offset>[Offset(720.0, 701.0),Offset(840.0, 763.0),Offset(605.0, 864.0),Offset(491.0, 800.0)]], <Offset>[], null),
    ConstructionPiece('PONTO_SEGURO', 'restore', <Offset>[Offset(477, 496),Offset(597, 535),Offset(594, 606),Offset(478, 571)], <List<Offset>>[<Offset>[Offset(475, 492),Offset(600, 532),Offset(600, 609),Offset(475, 574)]], <Offset>[], null),
    ConstructionPiece('ROTA_COMPARTILHADA', 'shared', <Offset>[Offset(1356, 449),Offset(1407, 472),Offset(1394, 489),Offset(1343, 465)], <List<Offset>>[], <Offset>[], null),
    ConstructionPiece('ILUMINACAO_TRAVESSIAS_CENTRO', 'lamp', <Offset>[Offset(623, 622),Offset(831, 714),Offset(838, 721),Offset(630, 629)], <List<Offset>>[<Offset>[Offset(614, 516),Offset(631, 516),Offset(631, 624),Offset(614, 624)],<Offset>[Offset(822, 606),Offset(840, 606),Offset(840, 716),Offset(822, 716)]], <Offset>[Offset(623, 622),Offset(831, 714)], null),
    ConstructionPiece('PRACA_CONVIVENCIA_CENTRO', 'restore', <Offset>[Offset(920, 644),Offset(972, 644),Offset(972, 682),Offset(920, 682)], <List<Offset>>[<Offset>[Offset(920, 644),Offset(972, 644),Offset(972, 682),Offset(920, 682)]], <Offset>[], null),
  ], <Rect>[Rect.fromLTWH(710.0,624.0,245.0,116.0),Rect.fromLTWH(425.0,448.0,208.0,96.0),Rect.fromLTWH(648.0,323.0,255.0,111.0),Rect.fromLTWH(1356.0,355.0,252.0,112.0),Rect.fromLTWH(1244.0,549.0,278.0,109.0),Rect.fromLTWH(1325.0,727.0,286.0,129.0),Rect.fromLTWH(500,804,114,72)], <List<Offset>>[], <Rect>[Rect.fromLTWH(650,716,22,48),Rect.fromLTWH(690,700,20,45),Rect.fromLTWH(701,752,23,56),Rect.fromLTWH(752,756,24,60),Rect.fromLTWH(602,776,24,65),Rect.fromLTWH(777,786,24,60),Rect.fromLTWH(1300,411,80,52),Rect.fromLTWH(1410,455,90,65)]),
  'ZONE_3': ConstructionZone('assets/build_neighborhood/r43_7/zone_3_initial.webp', 'assets/zone_3/r31/cenario_orla.webp', <ConstructionPiece>[
    ConstructionPiece('TRAVESSIA_ORLA_SEGURA', 'restore', <Offset>[Offset(540.0, 678.0),Offset(650.0, 729.0),Offset(541.0, 780.0),Offset(435.0, 728.0)], <List<Offset>>[<Offset>[Offset(540.0, 678.0),Offset(650.0, 729.0),Offset(541.0, 780.0),Offset(435.0, 728.0)]], <Offset>[], null),
    ConstructionPiece('CICLOVIA_CONECTADA', 'restore', <Offset>[Offset(736, 408),Offset(1002, 536),Offset(978, 553),Offset(712, 426)], <List<Offset>>[<Offset>[Offset(736, 408),Offset(1002, 536),Offset(978, 553),Offset(712, 426)]], <Offset>[], null),
    ConstructionPiece('EMBARQUE_ORGANIZADO', 'bay', <Offset>[Offset(977, 683),Offset(1061, 723),Offset(1095, 706),Offset(1011, 666)], <List<Offset>>[], <Offset>[], Rect.fromLTWH(1097,652,27,39)),
    ConstructionPiece('ACESSO_CALCADAO_ORLA', 'ramp', <Offset>[Offset(783, 425),Offset(810, 438),Offset(805, 450),Offset(778, 436)], <List<Offset>>[], <Offset>[], null),
    ConstructionPiece('BICICLETARIO_ORLA', 'rack', <Offset>[Offset(1423, 615),Offset(1483, 615),Offset(1483, 655),Offset(1423, 655)], <List<Offset>>[], <Offset>[], Rect.fromLTWH(1423,615,60,40)),
  ], <Rect>[Rect.fromLTWH(471.0,525.0,229.0,110.0),Rect.fromLTWH(714.0,372.0,224.0,108.0),Rect.fromLTWH(871.0,549.0,227.0,110.0),Rect.fromLTWH(996.0,335.0,224.0,108.0),Rect.fromLTWH(1389.0,444.0,240.0,114.0),Rect.fromLTWH(1307.0,667.0,290.0,135.0),Rect.fromLTWH(354,743,110,67)], <List<Offset>>[<Offset>[Offset(968, 644),Offset(1100, 644),Offset(1100, 733),Offset(968, 733)]], <Rect>[Rect.fromLTWH(501,681,18,80),Rect.fromLTWH(725,395,40,58),Rect.fromLTWH(811,446,44,59),Rect.fromLTWH(865,450,18,60),Rect.fromLTWH(935,497,51,65),Rect.fromLTWH(970,643,130,87),Rect.fromLTWH(1100,700,40,55),Rect.fromLTWH(1435,565,38,60)]),
  'ZONE_4': ConstructionZone('assets/build_neighborhood/r43_7/zone_4_initial.webp', 'assets/zone_4/r32/cenario_eventos.webp', <ConstructionPiece>[
    ConstructionPiece('TRAVESSIA_EVENTO_SEGURA', 'restore', <Offset>[Offset(622.0, 493.0),Offset(899.0, 552.0),Offset(772.0, 610.0),Offset(500.0, 547.0)], <List<Offset>>[<Offset>[Offset(622.0, 493.0),Offset(899.0, 552.0),Offset(772.0, 610.0),Offset(500.0, 547.0)]], <Offset>[], null),
    ConstructionPiece('SINALIZACAO_TEMPORARIA', 'restore', <Offset>[Offset(1250, 385),Offset(1448, 404),Offset(1448, 454),Offset(1250, 435)], <List<Offset>>[<Offset>[Offset(1250, 385),Offset(1448, 385),Offset(1448, 454),Offset(1250, 454)]], <Offset>[], Rect.fromLTWH(1450,398,30,30)),
    ConstructionPiece('EMBARQUE_EVENTO_ORGANIZADO', 'bay', <Offset>[Offset(824, 731),Offset(937, 680),Offset(958, 690),Offset(845, 743)], <List<Offset>>[], <Offset>[], Rect.fromLTWH(797,626,25,38)),
    ConstructionPiece('ROTA_ACESSIVEL_EVENTO', 'ramp', <Offset>[Offset(584, 731),Offset(615, 716),Offset(630, 724),Offset(600, 740)], <List<Offset>>[], <Offset>[], null),
    ConstructionPiece('ILUMINACAO_ACESSOS_EVENTO', 'lamp', <Offset>[Offset(630, 706),Offset(757, 665),Offset(764, 672),Offset(637, 713)], <List<Offset>>[], <Offset>[Offset(630, 706),Offset(757, 665)], null),
  ], <Rect>[Rect.fromLTWH(492.0,570.0,218.0,120.0),Rect.fromLTWH(631.0,359.0,212.0,111.0),Rect.fromLTWH(936.0,537.0,205.0,114.0),Rect.fromLTWH(1204.0,273.0,235.0,115.0),Rect.fromLTWH(1454.0,433.0,207.0,114.0),Rect.fromLTWH(1334.0,649.0,294.0,146.0),Rect.fromLTWH(324,818,108,60)], <List<Offset>>[], <Rect>[Rect.fromLTWH(677,472,24,66),Rect.fromLTWH(700,469,25,74),Rect.fromLTWH(760,451,25,69),Rect.fromLTWH(808,498,25,65),Rect.fromLTWH(831,506,25,58),Rect.fromLTWH(847,511,24,64),Rect.fromLTWH(765,540,24,70),Rect.fromLTWH(783,532,24,70),Rect.fromLTWH(831,667,110,70),Rect.fromLTWH(937,674,28,65)]),
  'ZONE_5': ConstructionZone('assets/build_neighborhood/r43_7/zone_5_initial.webp', 'assets/zone_5/r33/cenario_grandes_vias.webp', <ConstructionPiece>[
    ConstructionPiece('TRAVESSIA_GRANDE_VIA', 'restore', <Offset>[Offset(581.0, 575.0),Offset(779.0, 604.0),Offset(688.0, 674.0),Offset(498.0, 646.0)], <List<Offset>>[<Offset>[Offset(581.0, 575.0),Offset(779.0, 604.0),Offset(688.0, 674.0),Offset(498.0, 646.0)]], <Offset>[], null),
    ConstructionPiece('ILUMINACAO_CORREDOR', 'lamp', <Offset>[Offset(473, 651),Offset(1135, 750),Offset(1142, 757),Offset(480, 658)], <List<Offset>>[], <Offset>[Offset(473, 651),Offset(1135, 750)], null),
    ConstructionPiece('REFUGIO_PEDESTRE', 'restore', <Offset>[Offset(795.0, 643.0),Offset(876.0, 656.0),Offset(858.0, 680.0),Offset(777.0, 666.0)], <List<Offset>>[<Offset>[Offset(795.0, 643.0),Offset(876.0, 656.0),Offset(858.0, 680.0),Offset(777.0, 666.0)]], <Offset>[], null),
    ConstructionPiece('PONTO_ACESSIVEL_CORREDOR', 'ramp', <Offset>[Offset(1198.0, 494.0),Offset(1220.0, 413.0),Offset(1245.0, 417.0),Offset(1223.0, 501.0)], <List<Offset>>[<Offset>[Offset(1198.0, 494.0),Offset(1220.0, 413.0),Offset(1245.0, 417.0),Offset(1223.0, 501.0)]], <Offset>[], null),
    ConstructionPiece('CALCADA_CONTINUA_CORREDOR', 'paving', <Offset>[Offset(343.0, 755.0),Offset(471.0, 826.0),Offset(452.0, 849.0),Offset(323.0, 777.0)], <List<Offset>>[], <Offset>[], null),
  ], <Rect>[Rect.fromLTWH(562.0,478.0,244.0,118.0),Rect.fromLTWH(635.0,247.0,190.0,116.0),Rect.fromLTWH(958.0,213.0,194.0,113.0),Rect.fromLTWH(1281.0,213.0,211.0,113.0),Rect.fromLTWH(1403.0,383.0,225.0,116.0),Rect.fromLTWH(1344.0,639.0,300.0,151.0),Rect.fromLTWH(330,812,112,62)], <List<Offset>>[], <Rect>[Rect.fromLTWH(1198,415,22,45),Rect.fromLTWH(1215,415,20,43),Rect.fromLTWH(523,588,30,58)]),
  'ZONE_6': ConstructionZone('assets/build_neighborhood/r43_7/zone_6_initial.webp', 'assets/zone_6/r34/cenario_castelao.webp', <ConstructionPiece>[
    ConstructionPiece('CORREDOR_PEDESTRE_CASTELAO', 'corridor', <Offset>[Offset(326, 706),Offset(332, 709),Offset(289, 805),Offset(283, 802)], <List<Offset>>[], <Offset>[], Rect.fromLTWH(310,668,24,37)),
    ConstructionPiece('ILUMINACAO_ENTORNO_CASTELAO', 'lamp', <Offset>[Offset(308, 777),Offset(579, 877),Offset(586, 884),Offset(315, 784)], <List<Offset>>[], <Offset>[Offset(308, 777),Offset(579, 877)], null),
    ConstructionPiece('EMBARQUE_INTEGRADO_CASTELAO', 'bay', <Offset>[Offset(960, 484),Offset(1060, 530),Offset(1043, 539),Offset(944, 494)], <List<Offset>>[], <Offset>[], Rect.fromLTWH(1133,480,25,38)),
    ConstructionPiece('ROTA_ACESSIVEL_CASTELAO', 'ramp', <Offset>[Offset(453, 594),Offset(479, 612),Offset(464, 629),Offset(438, 610)], <List<Offset>>[], <Offset>[], null),
    ConstructionPiece('BICICLETARIO_CASTELAO', 'rack', <Offset>[Offset(332, 845),Offset(397, 845),Offset(397, 889),Offset(332, 889)], <List<Offset>>[], <Offset>[], Rect.fromLTWH(332,845,65,44)),
  ], <Rect>[Rect.fromLTWH(444.0,550.0,216.0,116.0),Rect.fromLTWH(483.0,315.0,190.0,112.0),Rect.fromLTWH(814.0,286.0,211.0,111.0),Rect.fromLTWH(1199.0,235.0,205.0,113.0),Rect.fromLTWH(1400.0,431.0,240.0,114.0),Rect.fromLTWH(1350.0,644.0,302.0,150.0),Rect.fromLTWH(334,818,112,60)], <List<Offset>>[], <Rect>[Rect.fromLTWH(413,600,25,45),Rect.fromLTWH(951,467,125,83)]),
};
