import 'package:flutter/material.dart';

import '../controllers/mission_controller.dart';
import '../controllers/player_controller.dart';
import '../core/enums/player_type.dart';
import '../data/zone_1/mission_01_data.dart';
import '../data/zone_1/mission_02_data.dart';
import '../data/zone_1/mission_03_data.dart';
import '../data/zone_1/mission_04_data.dart';
import '../data/zone_1/mission_05_data.dart';
import '../data/zone_1/special_mission_data.dart';
import '../data/zone_2/mission_01_data.dart';
import '../data/zone_2/mission_02_data.dart';
import '../data/zone_2/mission_03_data.dart';
import '../data/zone_2/mission_04_data.dart';
import '../data/zone_2/mission_05_data.dart';
import '../data/zone_2/special_mission_data.dart';
import '../data/zone_3/mission_01_data.dart';
import '../data/zone_3/mission_02_data.dart';
import '../data/zone_3/mission_03_data.dart';
import '../data/zone_3/mission_04_data.dart';
import '../data/zone_3/mission_05_data.dart';
import '../data/zone_3/special_mission_data.dart';
import '../data/zone_4/mission_01_data.dart';
import '../data/zone_4/mission_02_data.dart';
import '../data/zone_4/mission_03_data.dart';
import '../data/zone_4/mission_04_data.dart';
import '../data/zone_4/mission_05_data.dart';
import '../data/zone_4/special_mission_data.dart';
import '../models/mission.dart';
import '../models/mission_result.dart';
import '../screens/avatar/avatar_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/intro/intro_screen.dart';
import '../screens/mission/mission_screen.dart';
import '../screens/mission_result/mission_result_screen.dart';
import '../screens/player_progress/player_progress_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/zone_1_map/zone_1_map_screen.dart';
import '../screens/zone_2_map/zone_2_map_screen.dart';
import '../screens/zone_3_map/zone_3_map_screen.dart';
import '../screens/zone_4_map/zone_4_map_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const profile = '/profile';
  static const avatar = '/avatar';
  static const intro = '/intro';
  static const zone1 = '/zone-1';
  static const zone2 = '/zone-2';
  static const zone2Mission1 = '/zone-2/mission-1';
  static const zone2Mission2 = '/zone-2/mission-2';
  static const zone2Mission3 = '/zone-2/mission-3';
  static const zone2Mission4 = '/zone-2/mission-4';
  static const zone2Mission5 = '/zone-2/mission-5';
  static const zone2SpecialMission = '/zone-2/special';
  static const zone3 = '/zone-3';
  static const zone3Mission1 = '/zone-3/mission-1';
  static const zone3Mission2 = '/zone-3/mission-2';
  static const zone3Mission3 = '/zone-3/mission-3';
  static const zone3Mission4 = '/zone-3/mission-4';
  static const zone3Mission5 = '/zone-3/mission-5';
  static const zone3SpecialMission = '/zone-3/special';
  static const zone4 = '/zone-4';
  static const zone4Mission1 = '/zone-4/mission-1';
  static const zone4Mission2 = '/zone-4/mission-2';
  static const zone4Mission3 = '/zone-4/mission-3';
  static const zone4Mission4 = '/zone-4/mission-4';
  static const zone4Mission5 = '/zone-4/mission-5';
  static const zone4SpecialMission = '/zone-4/special';
  static const playerProgress = '/player-progress';
  static const mission1 = '/zone-1/mission-1';
  static const mission2 = '/zone-1/mission-2';
  static const mission3 = '/zone-1/mission-3';
  static const mission4 = '/zone-1/mission-4';
  static const mission5 = '/zone-1/mission-5';
  static const specialMission = '/zone-1/special';
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

      case zone2:
        if (!controller.isZoneUnlocked('ZONE_2')) {
          return _invalidRoute(settings);
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => Zone2MapScreen(controller: controller),
        );
      case zone3:
        if (!controller.isZoneUnlocked('ZONE_3')) {
          return _invalidRoute(settings);
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => Zone3MapScreen(controller: controller),
        );

      case zone3Mission1:
        final profile = controller.profile;
        if (profile == null ||
            !controller.isZoneUnlocked('ZONE_3') ||
            !controller.progress.unlockedMissions.contains('Z3_M01')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone3Mission01(profile.type),
          nextMissionId: 'Z3_M02',
        );

      case zone3Mission2:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z3_M02')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone3Mission02(profile.type),
          nextMissionId: 'Z3_M03',
        );

      case zone3Mission3:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z3_M03')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone3Mission03(profile.type),
          nextMissionId: 'Z3_M04',
        );

      case zone3Mission4:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z3_M04')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone3Mission04(profile.type),
          nextMissionId: 'Z3_M05',
        );

      case zone3Mission5:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z3_M05')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone3Mission05(profile.type),
        );

      case zone3SpecialMission:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z3_SPECIAL')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone3SpecialMission(profile.type),
        );
      case zone4:
        if (!controller.isZoneUnlocked('ZONE_4')) {
          return _invalidRoute(settings);
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => Zone4MapScreen(controller: controller),
        );

      case zone4Mission1:
        final profile = controller.profile;
        if (profile == null ||
            !controller.isZoneUnlocked('ZONE_4') ||
            !controller.progress.unlockedMissions.contains('Z4_M01')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone4Mission01(profile.type),
          nextMissionId: 'Z4_M02',
        );

      case zone4Mission2:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z4_M02')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone4Mission02(profile.type),
          nextMissionId: 'Z4_M03',
        );

      case zone4Mission3:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z4_M03')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone4Mission03(profile.type),
          nextMissionId: 'Z4_M04',
        );

      case zone4Mission4:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z4_M04')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone4Mission04(profile.type),
          nextMissionId: 'Z4_M05',
        );

      case zone4Mission5:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z4_M05')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone4Mission05(profile.type),
        );

      case zone4SpecialMission:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z4_SPECIAL')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone4SpecialMission(profile.type),
        );
      case playerProgress:
        if (!controller.hasProfile) {
          return _invalidRoute(settings);
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => PlayerProgressScreen(controller: controller),
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

      case mission4:
        final profile = controller.profile;
        if (profile == null) {
          return _invalidRoute(settings);
        }
        if (!controller.progress.unlockedMissions.contains('Z1_M04')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone1Mission04(profile.type),
          nextMissionId: 'Z1_M05',
        );

      case mission5:
        final profile = controller.profile;
        if (profile == null) {
          return _invalidRoute(settings);
        }
        if (!controller.progress.unlockedMissions.contains('Z1_M05')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone1Mission05(profile.type),
        );

      case specialMission:
        final profile = controller.profile;
        if (profile == null) {
          return _invalidRoute(settings);
        }
        if (!controller.progress.unlockedMissions.contains('Z1_SPECIAL')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone1SpecialMission(profile.type),
        );

      case zone2Mission1:
        final profile = controller.profile;
        if (profile == null ||
            !controller.isZoneUnlocked('ZONE_2') ||
            !controller.progress.unlockedMissions.contains('Z2_M01')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone2Mission01(profile.type),
          nextMissionId: 'Z2_M02',
        );

      case zone2Mission2:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z2_M02')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone2Mission02(profile.type),
          nextMissionId: 'Z2_M03',
        );

      case zone2Mission3:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z2_M03')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone2Mission03(profile.type),
          nextMissionId: 'Z2_M04',
        );

      case zone2Mission4:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z2_M04')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone2Mission04(profile.type),
          nextMissionId: 'Z2_M05',
        );

      case zone2Mission5:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z2_M05')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone2Mission05(profile.type),
        );

      case zone2SpecialMission:
        final profile = controller.profile;
        if (profile == null ||
            !controller.progress.unlockedMissions.contains('Z2_SPECIAL')) {
          return _invalidRoute(settings);
        }
        return _missionRoute(
          settings: settings,
          controller: controller,
          mission: buildZone2SpecialMission(profile.type),
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
    String? nextMissionId,
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
