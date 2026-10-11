import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'controllers/player_controller.dart';
import 'services/pedagogical_sync_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final storage = StorageService(preferences);
  final pedagogicalSync = PedagogicalSyncService(
    preferences,
    baseUrl: const String.fromEnvironment(
      'PEDAGOGICAL_API_BASE_URL',
      defaultValue: '',
    ),
  );
  final controller = PlayerController(
    storage,
    pedagogicalSync: pedagogicalSync,
  );

  await controller.initialize();

  runApp(CidadeEmMovimentoApp(controller: controller));
}
