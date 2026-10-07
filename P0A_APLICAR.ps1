$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================================"
Write-Host " CIDADE EM MOVIMENTO - P0-A"
Write-Host " Base funcional da Zona 1"
Write-Host "============================================================"

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Execute na raiz de C:\Projetos\cidade_em_movimento"
}

# ============================================================
# 1. DEPENDENCIA
# ============================================================

Write-Host ""
Write-Host "[1/8] Persistencia local..."

flutter pub add shared_preferences

if ($LASTEXITCODE -ne 0) {
    throw "flutter pub add shared_preferences = FAIL"
}

# ============================================================
# 2. ESTRUTURA
# ============================================================

Write-Host ""
Write-Host "[2/8] Estrutura..."

$dirs = @(
    "lib\app",
    "lib\core\enums",
    "lib\models",
    "lib\services",
    "lib\controllers",
    "lib\screens\home",
    "lib\screens\profile",
    "lib\screens\avatar",
    "lib\screens\intro",
    "lib\screens\zone_1_map"
)

foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

# ============================================================
# 3. ENUM
# ============================================================

@'
enum PlayerType {
  child,
  teen,
  adult,
}

extension PlayerTypeX on PlayerType {
  String get label {
    switch (this) {
      case PlayerType.child:
        return 'Criança';
      case PlayerType.teen:
        return 'Adolescente';
      case PlayerType.adult:
        return 'Adulto';
    }
  }

  String get initialTitle {
    switch (this) {
      case PlayerType.child:
        return 'Explorador(a) da Cidade';
      case PlayerType.teen:
        return 'Cidadão(ã) em Formação';
      case PlayerType.adult:
        return 'Condutor(a) Consciente';
    }
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\core\enums\player_type.dart"

# ============================================================
# 4. MODELOS
# ============================================================

@'
import '../core/enums/player_type.dart';

class PlayerProfile {
  const PlayerProfile({
    required this.type,
    required this.avatarId,
  });

  final PlayerType type;
  final String avatarId;

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'avatarId': avatarId,
    };
  }

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String? ?? PlayerType.child.name;

    final type = PlayerType.values.firstWhere(
      (value) => value.name == typeName,
      orElse: () => PlayerType.child,
    );

    return PlayerProfile(
      type: type,
      avatarId: json['avatarId'] as String? ?? 'child_boy',
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\models\player_profile.dart"

@'
class GameProgress {
  const GameProgress({
    required this.citizenshipXp,
    required this.knowledge,
    required this.coins,
    required this.completedMissions,
    required this.missionStars,
    required this.unlockedMissions,
    required this.purchasedUpgrades,
    required this.medals,
    required this.zone1Completed,
  });

  final int citizenshipXp;
  final int knowledge;
  final int coins;

  final Set<String> completedMissions;
  final Map<String, int> missionStars;
  final Set<String> unlockedMissions;
  final Set<String> purchasedUpgrades;
  final Set<String> medals;

  final bool zone1Completed;

  factory GameProgress.initial() {
    return const GameProgress(
      citizenshipXp: 0,
      knowledge: 0,
      coins: 0,
      completedMissions: <String>{},
      missionStars: <String, int>{},
      unlockedMissions: <String>{'Z1_M01'},
      purchasedUpgrades: <String>{},
      medals: <String>{},
      zone1Completed: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'citizenshipXp': citizenshipXp,
      'knowledge': knowledge,
      'coins': coins,
      'completedMissions': completedMissions.toList(),
      'missionStars': missionStars,
      'unlockedMissions': unlockedMissions.toList(),
      'purchasedUpgrades': purchasedUpgrades.toList(),
      'medals': medals.toList(),
      'zone1Completed': zone1Completed,
    };
  }

  factory GameProgress.fromJson(Map<String, dynamic> json) {
    final starsRaw =
        (json['missionStars'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};

    return GameProgress(
      citizenshipXp: (json['citizenshipXp'] as num?)?.toInt() ?? 0,
      knowledge: (json['knowledge'] as num?)?.toInt() ?? 0,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      completedMissions: _stringSet(json['completedMissions']),
      missionStars: starsRaw.map(
        (key, value) => MapEntry(key, (value as num).toInt()),
      ),
      unlockedMissions: _stringSet(
        json['unlockedMissions'],
        fallback: const <String>{'Z1_M01'},
      ),
      purchasedUpgrades: _stringSet(json['purchasedUpgrades']),
      medals: _stringSet(json['medals']),
      zone1Completed: json['zone1Completed'] as bool? ?? false,
    );
  }

  static Set<String> _stringSet(
    dynamic value, {
    Set<String> fallback = const <String>{},
  }) {
    if (value is! List) {
      return Set<String>.from(fallback);
    }

    return value.whereType<String>().toSet();
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\models\game_progress.dart"

# ============================================================
# 5. STORAGE
# ============================================================

@'
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_progress.dart';
import '../models/player_profile.dart';

class StorageService {
  StorageService(this._preferences);

  static const _profileKey = 'cidade_em_movimento.player_profile.v1';
  static const _progressKey = 'cidade_em_movimento.game_progress.v1';

  final SharedPreferences _preferences;

  PlayerProfile? loadProfile() {
    final raw = _preferences.getString(_profileKey);

    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      return PlayerProfile.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(PlayerProfile profile) async {
    await _preferences.setString(
      _profileKey,
      jsonEncode(profile.toJson()),
    );
  }

  GameProgress loadProgress() {
    final raw = _preferences.getString(_progressKey);

    if (raw == null || raw.isEmpty) {
      return GameProgress.initial();
    }

    try {
      return GameProgress.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return GameProgress.initial();
    }
  }

  Future<void> saveProgress(GameProgress progress) async {
    await _preferences.setString(
      _progressKey,
      jsonEncode(progress.toJson()),
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\services\storage_service.dart"

# ============================================================
# 6. CONTROLLER
# ============================================================

@'
import 'package:flutter/foundation.dart';

import '../core/enums/player_type.dart';
import '../models/game_progress.dart';
import '../models/player_profile.dart';
import '../services/storage_service.dart';

class PlayerController extends ChangeNotifier {
  PlayerController(this._storage);

  final StorageService _storage;

  PlayerProfile? _profile;
  GameProgress _progress = GameProgress.initial();

  PlayerProfile? get profile => _profile;
  GameProgress get progress => _progress;

  bool get hasProfile => _profile != null;

  Future<void> initialize() async {
    _profile = _storage.loadProfile();
    _progress = _storage.loadProgress();
  }

  Future<void> createProfile({
    required PlayerType type,
    required String avatarId,
  }) async {
    _profile = PlayerProfile(
      type: type,
      avatarId: avatarId,
    );

    await _storage.saveProfile(_profile!);
    await _storage.saveProgress(_progress);

    notifyListeners();
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\controllers\player_controller.dart"

# ============================================================
# 7. TEMA
# ============================================================

@'
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const blue = Color(0xFF1565C0);
  static const yellow = Color(0xFFFFC107);
  static const green = Color(0xFF2E7D32);
  static const red = Color(0xFFD32F2F);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: blue,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF6F8FC),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\app\theme.dart"

# ============================================================
# 8. HOME
# ============================================================

@'
import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.controller,
  });

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const Icon(
                    Icons.traffic_rounded,
                    size: 96,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'CIDADE EM MOVIMENTO',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aprenda. Decida. Transforme a cidade.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 36),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 38,
                            child: Icon(
                              Icons.person_pin_circle_rounded,
                              size: 46,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Melo',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Agente de Trânsito e guia da sua jornada.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        controller.hasProfile
                            ? AppRoutes.zone1
                            : AppRoutes.profile,
                      );
                    },
                    icon: Icon(
                      controller.hasProfile
                          ? Icons.play_arrow_rounded
                          : Icons.sports_esports_rounded,
                    ),
                    label: Text(
                      controller.hasProfile ? 'CONTINUAR' : 'JOGAR',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\screens\home\home_screen.dart"

# ============================================================
# 9. PERFIL
# ============================================================

@'
import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/enums/player_type.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha seu perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ProfileCard(
            type: PlayerType.child,
            icon: Icons.child_care_rounded,
            subtitle: 'Travessia, bicicleta, escola e segurança.',
          ),
          _ProfileCard(
            type: PlayerType.teen,
            icon: Icons.directions_bike_rounded,
            subtitle: 'Mobilidade, convivência e cidadania.',
          ),
          _ProfileCard(
            type: PlayerType.adult,
            icon: Icons.directions_car_rounded,
            subtitle: 'Legislação, direção defensiva e responsabilidade.',
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.type,
    required this.icon,
    required this.subtitle,
  });

  final PlayerType type;
  final IconData icon;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.avatar,
            arguments: type,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                child: Icon(icon, size: 34),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(type.initialTitle),
                    const SizedBox(height: 6),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\screens\profile\profile_screen.dart"

# ============================================================
# 10. AVATAR
# ============================================================

@'
import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({
    super.key,
    required this.controller,
    required this.type,
  });

  final PlayerController controller;
  final PlayerType type;

  @override
  Widget build(BuildContext context) {
    final options = switch (type) {
      PlayerType.child => const [
          _AvatarOption(
            id: 'child_boy',
            label: 'Menino',
            icon: Icons.boy_rounded,
          ),
          _AvatarOption(
            id: 'child_girl',
            label: 'Menina',
            icon: Icons.girl_rounded,
          ),
        ],
      PlayerType.teen => const [
          _AvatarOption(
            id: 'teen_default',
            label: 'Adolescente',
            icon: Icons.person_rounded,
          ),
        ],
      PlayerType.adult => const [
          _AvatarOption(
            id: 'adult_default',
            label: 'Adulto',
            icon: Icons.person_rounded,
          ),
        ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha seu avatar'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: GridView.count(
            padding: const EdgeInsets.all(24),
            crossAxisCount: options.length == 1 ? 1 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: options.length == 1 ? 1.8 : 0.9,
            children: [
              for (final option in options)
                Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      await controller.createProfile(
                        type: type,
                        avatarId: option.id,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.intro,
                        (route) => route.isFirst,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(option.icon, size: 76),
                          const SizedBox(height: 16),
                          Text(
                            option.label,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarOption {
  const _AvatarOption({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}
'@ | Set-Content -Encoding UTF8 ".\lib\screens\avatar\avatar_screen.dart"

# ============================================================
# 11. INTRO MELO
# ============================================================

@'
import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../controllers/player_controller.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({
    super.key,
    required this.controller,
  });

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final profile = controller.profile;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 54,
                        child: Icon(
                          Icons.person_pin_circle_rounded,
                          size: 66,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Olá! Eu sou o Melo.',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Nossa cidade precisa de pessoas que saibam fazer '
                        'boas escolhas. Aqui você não ganha apenas acertando '
                        'perguntas: suas decisões ajudam a tornar o trânsito '
                        'mais seguro e a transformar o bairro.',
                        textAlign: TextAlign.center,
                      ),
                      if (profile != null) ...[
                        const SizedBox(height: 20),
                        Text(
                          profile.type.initialTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                      const SizedBox(height: 30),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                            AppRoutes.zone1,
                          );
                        },
                        icon: const Icon(Icons.map_rounded),
                        label: const Text('COMEÇAR'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\screens\intro\intro_screen.dart"

# ============================================================
# 12. MAPA ZONA 1
# ============================================================

@'
import 'package:flutter/material.dart';

import '../../controllers/player_controller.dart';

class Zone1MapScreen extends StatelessWidget {
  const Zone1MapScreen({
    super.key,
    required this.controller,
  });

  final PlayerController controller;

  static const _missions = [
    ('Z1_M01', 'Travessia Segura'),
    ('Z1_M02', 'Embarque Seguro'),
    ('Z1_M03', 'Bicicleta na Rota Escolar'),
    ('Z1_M04', 'Só um Minutinho'),
    ('Z1_M05', 'Caminho Seguro'),
    ('Z1_SPECIAL', 'Saída da Escola'),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = controller.progress;

    final totalStars = progress.missionStars.values.fold<int>(
      0,
      (total, value) => total + value,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bairro / Escola'),
      ),
      body: Column(
        children: [
          _ScoreBar(
            citizenship: progress.citizenshipXp,
            knowledge: progress.knowledge,
            coins: progress.coins,
            stars: totalStars,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.school_rounded,
                          size: 72,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'ZONA 1',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          'Bairro / Escola',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Observe o bairro, aprenda com as situações '
                          'e ajude a transformar a área escolar.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                for (var index = 0;
                    index < _missions.length;
                    index++)
                  _MissionTile(
                    number: index + 1,
                    title: _missions[index].$2,
                    unlocked: progress.unlockedMissions.contains(
                      _missions[index].$1,
                    ),
                    stars:
                        progress.missionStars[_missions[index].$1] ?? 0,
                    special: _missions[index].$1 == 'Z1_SPECIAL',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.citizenship,
    required this.knowledge,
    required this.coins,
    required this.stars,
  });

  final int citizenship;
  final int knowledge;
  final int coins;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        child: Row(
          children: [
            _ScoreItem(
              icon: Icons.workspace_premium_rounded,
              value: citizenship,
              label: 'Cidadania',
            ),
            _ScoreItem(
              icon: Icons.menu_book_rounded,
              value: knowledge,
              label: 'Conhecimento',
            ),
            _ScoreItem(
              icon: Icons.monetization_on_rounded,
              value: coins,
              label: 'Moedas',
            ),
            _ScoreItem(
              icon: Icons.star_rounded,
              value: stars,
              label: 'Estrelas',
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  const _ScoreItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 2),
          Text(
            '$value',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _MissionTile extends StatelessWidget {
  const _MissionTile({
    required this.number,
    required this.title,
    required this.unlocked,
    required this.stars,
    required this.special,
  });

  final int number;
  final String title;
  final bool unlocked;
  final int stars;
  final bool special;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: CircleAvatar(
          child: Icon(
            unlocked
                ? (special
                    ? Icons.flag_rounded
                    : Icons.location_on_rounded)
                : Icons.lock_rounded,
          ),
        ),
        title: Text(
          special ? 'Missão Especial — $title' : '$number. $title',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: unlocked
            ? Text(
                stars == 0
                    ? 'Disponível'
                    : '${'★' * stars}${'☆' * (3 - stars)}',
              )
            : const Text('Bloqueada'),
        trailing: unlocked
            ? const Icon(Icons.play_circle_outline_rounded)
            : null,
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\screens\zone_1_map\zone_1_map_screen.dart"

# ============================================================
# 13. ROTAS
# ============================================================

@'
import 'package:flutter/material.dart';

import '../controllers/player_controller.dart';
import '../core/enums/player_type.dart';
import '../screens/avatar/avatar_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/intro/intro_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/zone_1_map/zone_1_map_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const profile = '/profile';
  static const avatar = '/avatar';
  static const intro = '/intro';
  static const zone1 = '/zone-1';

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
          builder: (_) => AvatarScreen(
            controller: controller,
            type: type,
          ),
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

      default:
        return _invalidRoute(settings);
    }
  }

  static Route<dynamic> _invalidRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Rota inválida.'),
        ),
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\app\routes.dart"

# ============================================================
# 14. APP
# ============================================================

@'
import 'package:flutter/material.dart';

import '../controllers/player_controller.dart';
import 'routes.dart';
import 'theme.dart';

class CidadeEmMovimentoApp extends StatelessWidget {
  const CidadeEmMovimentoApp({
    super.key,
    required this.controller,
  });

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cidade em Movimento',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        return AppRoutes.onGenerateRoute(
          settings,
          controller,
        );
      },
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\app\app.dart"

# ============================================================
# 15. MAIN
# ============================================================

@'
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

  runApp(
    CidadeEmMovimentoApp(
      controller: controller,
    ),
  );
}
'@ | Set-Content -Encoding UTF8 ".\lib\main.dart"

# ============================================================
# 16. TESTE
# ============================================================

@'
import 'package:cidade_em_movimento/app/app.dart';
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'abre tela inicial do Cidade em Movimento',
    (tester) async {
      SharedPreferences.setMockInitialValues({});

      final preferences = await SharedPreferences.getInstance();
      final storage = StorageService(preferences);
      final controller = PlayerController(storage);

      await controller.initialize();

      await tester.pumpWidget(
        CidadeEmMovimentoApp(
          controller: controller,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('CIDADE EM MOVIMENTO'), findsOneWidget);
      expect(find.text('JOGAR'), findsOneWidget);
      expect(find.text('Melo'), findsOneWidget);
    },
  );
}
'@ | Set-Content -Encoding UTF8 ".\test\widget_test.dart"

# ============================================================
# 17. FORMAT
# ============================================================

Write-Host ""
Write-Host "[3/8] dart format..."

dart format lib test

if ($LASTEXITCODE -ne 0) {
    throw "dart format = FAIL"
}

# ============================================================
# 18. ANALYZE
# ============================================================

Write-Host ""
Write-Host "[4/8] flutter analyze..."

flutter analyze

if ($LASTEXITCODE -ne 0) {
    throw "flutter analyze = FAIL"
}

# ============================================================
# 19. TEST
# ============================================================

Write-Host ""
Write-Host "[5/8] flutter test..."

flutter test

if ($LASTEXITCODE -ne 0) {
    throw "flutter test = FAIL"
}

# ============================================================
# 20. WEB BUILD
# ============================================================

Write-Host ""
Write-Host "[6/8] flutter build web..."

flutter build web

if ($LASTEXITCODE -ne 0) {
    throw "flutter build web = FAIL"
}

# ============================================================
# 21. GIT
# ============================================================

Write-Host ""
Write-Host "[7/8] Git..."

git branch -M main

Write-Host ""
git status --short

# ============================================================
# 22. RESULTADO
# ============================================================

Write-Host ""
Write-Host "============================================================"
Write-Host " CIDADE EM MOVIMENTO - P0-A"
Write-Host "============================================================"
Write-Host " APP BASE             = PASS"
Write-Host " PERFIL               = IMPLEMENTADO"
Write-Host " AVATAR CRIANCA       = MENINO / MENINA"
Write-Host " MELO INTRO           = IMPLEMENTADO"
Write-Host " MAPA ZONA 1 BASE     = IMPLEMENTADO"
Write-Host " PERSISTENCIA LOCAL   = IMPLEMENTADA"
Write-Host " FLUTTER ANALYZE      = PASS"
Write-Host " FLUTTER TEST         = PASS"
Write-Host " WEB BUILD            = PASS"
Write-Host " GIT BRANCH           = main"
Write-Host "------------------------------------------------------------"
Write-Host " MISSAO 1             = NAO IMPLEMENTADA"
Write-Host " NOVAS FUNCOES        = 0"
Write-Host "============================================================"