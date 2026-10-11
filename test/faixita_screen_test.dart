import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/screens/faixita/faixita_screen.dart';
import 'package:cidade_em_movimento/services/faixita_service.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Faixita abre em modo local e responde pergunta rapida', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    final controller = PlayerController(StorageService(preferences));
    await controller.initialize();
    await controller.createProfile(
      type: PlayerType.adult,
      avatarId: 'adult_default',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: FaixitaScreen(
          controller: controller,
          service: FaixitaService(baseUrl: ''),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Faixita'), findsOneWidget);
    expect(find.text('Modo local'), findsOneWidget);
    expect(find.byKey(const Key('faixita-header')), findsOneWidget);

    final quickQuestion = find.text('O que devo estudar agora?');
    expect(quickQuestion, findsOneWidget);

    await tester.ensureVisible(quickQuestion);
    await tester.pumpAndSettle();
    await tester.tap(quickQuestion);
    await tester.pumpAndSettle();

    expect(find.textContaining('primeira zona'), findsOneWidget);
  });
}
