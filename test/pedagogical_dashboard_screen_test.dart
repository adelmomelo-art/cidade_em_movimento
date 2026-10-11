import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/core/enums/player_type.dart';
import 'package:cidade_em_movimento/screens/pedagogical_dashboard/pedagogical_dashboard_screen.dart';
import 'package:cidade_em_movimento/services/pedagogical_sync_service.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('dashboard exibe leitura e fila offline', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final controller = PlayerController(
      StorageService(prefs),
      pedagogicalSync: PedagogicalSyncService(prefs, baseUrl: ''),
    );
    await controller.initialize();
    await controller.createProfile(
      type: PlayerType.adult,
      avatarId: 'adult_default',
    );
    await tester.pumpWidget(
      MaterialApp(home: PedagogicalDashboardScreen(controller: controller)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Leitura Pedagogica'), findsOneWidget);
    expect(find.text('0% das missoes concluidas'), findsOneWidget);
    expect(find.text('1 snapshot pendente'), findsOneWidget);
  });
}
