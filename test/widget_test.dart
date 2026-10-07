import 'package:cidade_em_movimento/app/app.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('abre tela inicial do Cidade em Movimento', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final preferences = await SharedPreferences.getInstance();
    final storage = StorageService(preferences);
    final controller = PlayerController(storage);

    await controller.initialize();

    await tester.pumpWidget(CidadeEmMovimentoApp(controller: controller));

    await tester.pumpAndSettle();

    expect(find.text('CIDADE EM MOVIMENTO'), findsOneWidget);
    expect(find.text('JOGAR'), findsOneWidget);
    expect(find.text('Melo'), findsOneWidget);
  });
}
