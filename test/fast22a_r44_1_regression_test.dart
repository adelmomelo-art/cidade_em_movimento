import 'package:cidade_em_movimento/app/routes.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/data/zone_1/mission_01_data.dart';
import 'package:cidade_em_movimento/data/zone_1/mission_02_data.dart';
import 'package:cidade_em_movimento/data/zone_1/mission_03_data.dart';
import 'package:cidade_em_movimento/data/zone_1/mission_04_data.dart';
import 'package:cidade_em_movimento/data/zone_1/mission_05_data.dart';
import 'package:cidade_em_movimento/data/zone_1/special_mission_data.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/fortaleza_map/fortaleza_map_screen.dart';
import 'package:cidade_em_movimento/screens/player_progress/player_progress_screen.dart';
import 'package:cidade_em_movimento/screens/zone_1_map/zone_1_map_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:cidade_em_movimento/widgets/zone_1_approved_art.dart';
import 'package:cidade_em_movimento/widgets/zone_1_construction_art.dart';
import 'package:cidade_em_movimento/widgets/zone_1_mission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> _player() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(prefs));
  await controller.initialize();
  await controller.createProfile(type: PlayerType.adult, avatarId: 'adult_default');
  return controller;
}

void main() {
  testWidgets('reparo de B continua no mapa aprovado', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(
      body: Zone1ArtworkBoard(asset: zone1MapArtwork,
        captureKey: Key('map-frame'), children: []),
    )));
    await tester.pumpAndSettle();
    expect(find.byType(Zone1GroundRepair), findsOneWidget);
    expect(tester.widget<Zone1GroundRepair>(find.byType(Zone1GroundRepair)).mapArtwork,
      zone1MapArtwork);
    expect(tester.takeException(), isNull);
  });

  for (final buildMission in [buildZone1Mission01, buildZone1Mission02,
    buildZone1Mission03, buildZone1Mission04, buildZone1Mission05,
    buildZone1SpecialMission]) {
    final mission = buildMission(PlayerType.adult);
    testWidgets('${mission.id}: reparo do mapa nao invade Melo na pergunta', (tester) async {
      final c = await _player();
      addTearDown(c.dispose);
      final before = c.progress.toJson();
      await tester.pumpWidget(MaterialApp(home: Zone1MissionDialog(
        mission: mission, player: c,
      )));
      await tester.pumpAndSettle();
      // Other missions still repair the ground inside their scene crop only.
      final expected = mission.id == 'Z1_M01' ? 0 : 1;
      expect(find.byType(Zone1GroundRepair), findsNWidgets(expected));
      if (expected == 1) {
        expect(find.ancestor(of: find.byType(Zone1GroundRepair),
          matching: find.byType(Zone1MissionScene)), findsOneWidget);
      }
      await tester.tap(find.text('INICIAR'));
      await tester.pumpAndSettle();
      expect(find.byType(Zone1GroundRepair), findsNWidgets(expected));
      expect(c.progress.toJson(), before);
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in [const Size(844, 390), const Size(1280, 800)]) {
    for (final medals in [true, false]) {
      testWidgets('${medals ? "medalhas" : "progresso"}: arte, dados e retorno $size', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final c = await _player();
        addTearDown(c.dispose);
        await c.completeMission(result: const MissionResult(
          missionId: 'R44_1_TEST', stars: 3, score: 100,
          citizenship: 20, knowledge: 10, coins: 15, errors: 0,
        ));
        final before = c.progress.toJson();
        await tester.pumpWidget(MaterialApp(
          home: medals ? FortalezaMapScreen(controller: c) : Zone1MapScreen(controller: c),
          routes: {
            AppRoutes.playerProgress: (_) => PlayerProgressScreen(controller: c),
            AppRoutes.pedagogicalDashboard: (_) => Scaffold(
              appBar: AppBar(title: const Text('Painel de teste'))),
          },
        ));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key(medals ? 'fortaleza-medals-button' : 'zone1-open-progress')));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('player-progress-city-background')), findsOneWidget);
        for (final text in ['20', '10', '15', '3', 'Cidadania', 'Conhecimento', 'Moedas', 'Estrelas']) {
          expect(find.text(text), findsOneWidget);
        }
        await tester.tap(find.byKey(const Key('open-pedagogical-dashboard')));
        await tester.pumpAndSettle();
        expect(find.text('Painel de teste'), findsOneWidget);
        await tester.pageBack();
        await tester.pumpAndSettle();
        final last = find.text('Nenhuma melhoria instalada ainda.');
        await tester.scrollUntilVisible(last, 200,
          scrollable: find.descendant(of: find.byKey(const Key('player-progress-scroll')),
            matching: find.byType(Scrollable)));
        await tester.pumpAndSettle();
        expect(last.hitTestable(), findsOneWidget);
        await tester.tap(find.byKey(const Key('player-progress-back')));
        await tester.pumpAndSettle();
        expect(find.byType(PlayerProgressScreen), findsNothing);
        expect(c.progress.toJson(), before);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
