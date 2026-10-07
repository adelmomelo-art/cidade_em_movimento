import 'package:flutter/material.dart';

import '../controllers/mission_controller.dart';
import '../controllers/player_controller.dart';
import '../core/enums/player_type.dart';
import '../data/zone_1/mission_01_data.dart';
import '../data/zone_1/mission_02_data.dart';
import '../data/zone_1/mission_03_data.dart';
import '../models/mission.dart';
import '../models/mission_result.dart';
import '../screens/avatar/avatar_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/intro/intro_screen.dart';
import '../screens/mission/mission_screen.dart';
import '../screens/mission_result/mission_result_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/zone_1_map/zone_1_map_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const profile = '/profile';
  static const avatar = '/avatar';
  static const intro = '/intro';
  static const zone1 = '/zone-1';
  static const mission1 = '/zone-1/mission-1';
  static const mission2 = '/zone-1/mission-2';
  static const mission3 = '/zone-1/mission-3';
  static const missionResult = '/mission-result';

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
    PlayerController controller,
  ) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => HomeScreen(controller: controller),
        );

      case profile:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );

      case avatar:
        final type = settings.arguments;

        if (type is! PlayerType) {
          return _invalidRoute(settings);
        }

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => AvatarScreen(controller: controller, type: type),
        );

      case intro:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => IntroScreen(controller: controller),
        );

      case zone1:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => Zone1MapScreen(controller: controller),
        );

      case mission1:
        final profile = controller.profile;

        if (profile == null) {
          return _invalidRoute(settings);
        }

        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone1Mission01(profile.type),
          nextMissionId: 'Z1_M02',
        );

      case mission2:
        final profile = controller.profile;

        if (profile == null) {
          return _invalidRoute(settings);
        }

        if (!controller.progress.unlockedMissions.contains('Z1_M02')) {
          return _invalidRoute(settings);
        }

        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone1Mission02(profile.type),
          nextMissionId: 'Z1_M03',
        );

      case mission3:
        final profile = controller.profile;

        if (profile == null) {
          return _invalidRoute(settings);
        }

        if (!controller.progress.unlockedMissions.contains('Z1_M03')) {
          return _invalidRoute(settings);
        }

        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone1Mission03(profile.type),
          nextMissionId: 'Z1_M04',
        );

      case missionResult:
        final result = settings.arguments;

        if (result is! MissionResult) {
          return _invalidRoute(settings);
        }

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => MissionResultScreen(result: result),
        );

      default:
        return _invalidRoute(settings);
    }
  }

  static Route<dynamic> _missionRoute({
    required RouteSettings settings,
    required PlayerController controller,
    required Mission mission,
    required String nextMissionId,
  }) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => MissionScreen(
        mission: mission,
        onMissionCompleted: (MissionController missionController) async {
          final result = missionController.result;

          if (result == null) {
            return;
          }

          await controller.completeMission(
            result: result,
            nextMissionId: nextMissionId,
          );

          final navigator = rootNavigatorKey.currentState;

          if (navigator == null) {
            return;
          }

          await navigator.pushNamed(missionResult, arguments: result);
        },
      ),
    );
  }

  static Route<dynamic> _invalidRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Rota inv\u00e1lida.'))),
    );
  }
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
