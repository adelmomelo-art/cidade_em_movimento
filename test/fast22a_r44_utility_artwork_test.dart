import 'package:cidade_em_movimento/app/routes.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/screens/fortaleza_map/fortaleza_map_screen.dart';
import 'package:cidade_em_movimento/screens/global_progress/global_progress_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:cidade_em_movimento/widgets/city_utility_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PlayerController> player() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final controller = PlayerController(StorageService(prefs));
  await controller.initialize();
  return controller;
}

void main() {
  for (final size in [const Size(844,390),const Size(1280,800),const Size(640,360)]) {
    testWidgets('mais opções tem arte, quatro destinos e fecha sem alterar save: $size', (tester) async {
      tester.view.physicalSize=size;
      tester.view.devicePixelRatio=1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c=await player();
      final before=c.progress.toJson();
      await tester.pumpWidget(MaterialApp(
        builder:(context,child)=>MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaler:const TextScaler.linear(1.4)),
          child:child!,
        ),
        home:FortalezaMapScreen(controller:c),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('fortaleza-menu-button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('more-options-city-background')),findsOneWidget);
      for(final id in ['fortaleza-faixita','fortaleza-sign-duel',
        'fortaleza-global-progress','fortaleza-menu-home']) {
        expect(find.byKey(Key(id)).hitTestable(),findsOneWidget);
      }
      expect(find.byType(Scrollable),findsNothing);
      await tester.tap(find.text('FECHAR'));
      await tester.pumpAndSettle();
      expect(find.byType(CityUtilityPage),findsNothing);
      expect(c.progress.toJson(),before);
      expect(tester.takeException(),isNull);
    });

    testWidgets('progresso global usa arte e conserva todos os indicadores: $size', (tester) async {
      tester.view.physicalSize=size;
      tester.view.devicePixelRatio=1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c=await player();
      final before=c.progress.toJson();
      await tester.pumpWidget(MaterialApp(home:GlobalProgressScreen(controller:c)));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('global-progress-city-background')),findsOneWidget);
      expect(find.text('0% da jornada principal'),findsOneWidget);
      for(final id in ['global-core-progress','global-extra-pillars','global-achievements']) {
        expect(find.byKey(Key(id)),findsOneWidget);
      }
      expect(c.progress.toJson(),before);
      expect(tester.takeException(),isNull);
    });
  }

  testWidgets('menu abre a rota de progresso global e permite voltar ao mapa', (tester) async {
    final c=await player();
    await tester.pumpWidget(MaterialApp(home:FortalezaMapScreen(controller:c),
      routes:{AppRoutes.globalProgress:(_)=>GlobalProgressScreen(controller:c)}));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('fortaleza-menu-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('fortaleza-global-progress')));
    await tester.pumpAndSettle();
    expect(find.byType(GlobalProgressScreen),findsOneWidget);
    await tester.tap(find.byKey(const Key('global-progress-back')));
    await tester.pumpAndSettle();
    expect(find.byType(GlobalProgressScreen),findsNothing);
    expect(find.byKey(const Key('fortaleza-menu-button')),findsOneWidget);
    expect(tester.takeException(),isNull);
  });
}
