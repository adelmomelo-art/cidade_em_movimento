import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/screens/mission_result/mission_result_screen.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('resultado de missao oferece acesso a Faixita', (tester) async {
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
        home: MissionResultScreen(
          controller: controller,
          result: const MissionResult(
            missionId: 'Z1_M01',
            stars: 2,
            score: 80,
            citizenship: 10,
            knowledge: 5,
            coins: 10,
            errors: 1,
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('mission-result-faixita')), findsOneWidget);
    expect(find.text('PERGUNTAR A FAIXITA'), findsOneWidget);
  });
}
