import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'controllers/player_controller.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final storage = StorageService(preferences);
  final controller = PlayerController(storage);

  await controller.initialize();

  runApp(CidadeEmMovimentoApp(controller: controller));
}
