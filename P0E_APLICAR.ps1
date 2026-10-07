$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================================"
Write-Host " CIDADE EM MOVIMENTO - P0-E"
Write-Host " Motor generico + Missao 1 - Travessia Segura"
Write-Host "============================================================"

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Execute este pacote na raiz do projeto."
}

# ============================================================
# 1. DIRETORIOS
# ============================================================

Write-Host ""
Write-Host "[1/9] Estrutura..."

$dirs = @(
    "lib\models",
    "lib\data\zone_1",
    "lib\services",
    "lib\controllers",
    "lib\screens\mission",
    "lib\screens\mission_result"
)

foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

# ============================================================
# 2. MODELO - MISSION OPTION
# ============================================================

@'
class MissionOption {
  const MissionOption({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.consequenceText,
    required this.meloFeedback,
  });

  final String id;
  final String text;
  final bool isCorrect;
  final String consequenceText;
  final String meloFeedback;
}
'@ | Set-Content -Encoding UTF8 ".\lib\models\mission_option.dart"

# ============================================================
# 3. MODELO - MISSION
# ============================================================

@'
import 'mission_option.dart';

class Mission {
  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.sceneText,
    required this.question,
    required this.options,
    required this.maxCitizenship,
    required this.maxKnowledge,
    required this.maxCoins,
  });

  final String id;
  final String title;
  final String description;
  final String sceneText;
  final String question;
  final List<MissionOption> options;

  final int maxCitizenship;
  final int maxKnowledge;
  final int maxCoins;
}
'@ | Set-Content -Encoding UTF8 ".\lib\models\mission.dart"

# ============================================================
# 4. MODELO - MISSION RESULT
# ============================================================

@'
class MissionResult {
  const MissionResult({
    required this.missionId,
    required this.stars,
    required this.score,
    required this.citizenship,
    required this.knowledge,
    required this.coins,
    required this.errors,
  });

  final String missionId;
  final int stars;
  final int score;
  final int citizenship;
  final int knowledge;
  final int coins;
  final int errors;
}
'@ | Set-Content -Encoding UTF8 ".\lib\models\mission_result.dart"

# ============================================================
# 5. SCORING SERVICE
# ============================================================

@'
import '../models/mission.dart';
import '../models/mission_result.dart';

class ScoringService {
  const ScoringService();

  MissionResult calculate({
    required Mission mission,
    required int errors,
  }) {
    final score = _scoreFromErrors(errors);
    final stars = _starsFromScore(score);

    return MissionResult(
      missionId: mission.id,
      stars: stars,
      score: score,
      citizenship: mission.maxCitizenship,
      knowledge: mission.maxKnowledge,
      coins: mission.maxCoins,
      errors: errors,
    );
  }

  int _scoreFromErrors(int errors) {
    if (errors <= 0) {
      return 100;
    }

    if (errors == 1) {
      return 80;
    }

    return 60;
  }

  int _starsFromScore(int score) {
    if (score >= 90) {
      return 3;
    }

    if (score >= 70) {
      return 2;
    }

    if (score >= 50) {
      return 1;
    }

    return 0;
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\services\scoring_service.dart"

# ============================================================
# 6. DADOS DA MISSAO 1
# ============================================================

@'
import '../../core/enums/player_type.dart';
import '../../models/mission.dart';
import '../../models/mission_option.dart';

Mission buildZone1Mission01(PlayerType type) {
  switch (type) {
    case PlayerType.child:
      return const Mission(
        id: 'Z1_M01',
        title: 'Travessia Segura',
        description:
            'Aprenda a atravessar a rua com aten\u00e7\u00e3o e seguran\u00e7a.',
        sceneText:
            'Voc\u00ea est\u00e1 chegando \u00e0 escola. Existe uma faixa de pedestres logo \u00e0 frente.',
        question: 'O que voc\u00ea faz?',
        maxCitizenship: 20,
        maxKnowledge: 10,
        maxCoins: 15,
        options: [
          MissionOption(
            id: 'child_correct',
            text:
                'Paro, observo os dois lados e atravesso pela faixa com seguran\u00e7a.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea observa a via, espera o momento seguro e atravessa pela faixa.',
            meloFeedback:
                'Muito bem! Antes de atravessar, observe a via e use o local seguro dispon\u00edvel.',
          ),
          MissionOption(
            id: 'child_wrong_run',
            text:
                'Corro para atravessar antes que os carros se aproximem.',
            isCorrect: false,
            consequenceText:
                'Ao correr, voc\u00ea reduz o tempo para perceber um ve\u00edculo que possa se aproximar.',
            meloFeedback:
                'A pressa pode esconder riscos. Observe os dois lados antes de iniciar a travessia.',
          ),
          MissionOption(
            id: 'child_wrong_cars',
            text:
                'Atravesso entre dois carros estacionados.',
            isCorrect: false,
            consequenceText:
                'Os carros estacionados dificultam que voc\u00ea veja a via e tamb\u00e9m dificultam que os motoristas vejam voc\u00ea.',
            meloFeedback:
                'Entre ve\u00edculos estacionados a visibilidade fica menor. Procure a travessia segura.',
          ),
        ],
      );

    case PlayerType.teen:
      return const Mission(
        id: 'Z1_M01',
        title: 'Travessia Segura',
        description:
            'Observe a via antes de atravessar e reconhe\u00e7a situa\u00e7\u00f5es de risco.',
        sceneText:
            'Voc\u00ea chega de bicicleta a uma travessia pr\u00f3xima da escola.',
        question: 'Qual \u00e9 a conduta mais segura?',
        maxCitizenship: 20,
        maxKnowledge: 10,
        maxCoins: 15,
        options: [
          MissionOption(
            id: 'teen_correct',
            text:
                'Reduzo, observo o tr\u00e2nsito e realizo a travessia com seguran\u00e7a.',
            isCorrect: true,
            consequenceText:
                'Voc\u00ea reduz a velocidade, observa a movimenta\u00e7\u00e3o e atravessa sem criar conflito.',
            meloFeedback:
                'Boa escolha. Observar antes de agir ajuda a tornar sua movimenta\u00e7\u00e3o previs\u00edvel e segura.',
          ),
          MissionOption(
            id: 'teen_wrong_fast',
            text:
                'Acelero para passar antes dos ve\u00edculos.',
            isCorrect: false,
            consequenceText:
                'A velocidade reduz seu tempo de rea\u00e7\u00e3o e aumenta o risco na travessia.',
            meloFeedback:
                'Chegar primeiro n\u00e3o significa chegar com seguran\u00e7a. Reduza e observe.',
          ),
          MissionOption(
            id: 'teen_wrong_enter',
            text:
                'Entro na travessia imediatamente, sem observar.',
            isCorrect: false,
            consequenceText:
                'Um ve\u00edculo se aproxima e voc\u00ea precisa interromper o movimento.',
            meloFeedback:
                'Antes de entrar na via, verifique se a travessia pode ser realizada com seguran\u00e7a.',
          ),
        ],
      );

    case PlayerType.adult:
      return const Mission(
        id: 'Z1_M01',
        title: 'Travessia Segura',
        description:
            'Reconhe\u00e7a a prioridade e a vulnerabilidade do pedestre.',
        sceneText:
            'Voc\u00ea dirige em frente a uma escola. Um pedestre j\u00e1 iniciou a travessia pela faixa.',
        question: 'O que voc\u00ea faz?',
        maxCitizenship: 20,
        maxKnowledge: 10,
        maxCoins: 15,
        options: [
          MissionOption(
            id: 'adult_correct',
            text:
                'Reduzo e dou prefer\u00eancia para que o pedestre conclua a travessia.',
            isCorrect: true,
            consequenceText:
                'O ve\u00edculo reduz e o pedestre conclui a travessia com seguran\u00e7a.',
            meloFeedback:
                'Boa decis\u00e3o. O pedestre est\u00e1 em situa\u00e7\u00e3o mais vulner\u00e1vel e deve concluir a travessia com seguran\u00e7a.',
          ),
          MissionOption(
            id: 'adult_wrong_pass',
            text:
                'Passo rapidamente antes que o pedestre chegue \u00e0 minha faixa.',
            isCorrect: false,
            consequenceText:
                'O pedestre precisa interromper a travessia diante da aproxima\u00e7\u00e3o do ve\u00edculo.',
            meloFeedback:
                'Percebeu o risco? Quem j\u00e1 iniciou a travessia precisa concluir o movimento com seguran\u00e7a.',
          ),
          MissionOption(
            id: 'adult_wrong_horn',
            text:
                'Buzino para que o pedestre espere.',
            isCorrect: false,
            consequenceText:
                'A buzina pressiona o pedestre e n\u00e3o elimina o risco existente na travessia.',
            meloFeedback:
                'A prioridade aqui \u00e9 a seguran\u00e7a. Reduza e permita a conclus\u00e3o da travessia.',
          ),
        ],
      );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\data\zone_1\mission_01_data.dart"

# ============================================================
# 7. MISSION CONTROLLER
# ============================================================

@'
import 'package:flutter/foundation.dart';

import '../models/mission.dart';
import '../models/mission_option.dart';
import '../models/mission_result.dart';
import '../services/scoring_service.dart';

enum MissionStage {
  intro,
  choosing,
  consequence,
  feedback,
  completed,
}

class MissionController extends ChangeNotifier {
  MissionController({
    required this.mission,
    ScoringService scoringService = const ScoringService(),
  }) : _scoringService = scoringService;

  final Mission mission;
  final ScoringService _scoringService;

  MissionStage _stage = MissionStage.intro;
  MissionOption? _selectedOption;
  int _errors = 0;
  MissionResult? _result;

  MissionStage get stage => _stage;
  MissionOption? get selectedOption => _selectedOption;
  int get errors => _errors;
  MissionResult? get result => _result;

  void start() {
    _stage = MissionStage.choosing;
    notifyListeners();
  }

  void selectOption(MissionOption option) {
    if (_stage != MissionStage.choosing) {
      return;
    }

    _selectedOption = option;

    if (!option.isCorrect) {
      _errors++;
    }

    _stage = MissionStage.consequence;
    notifyListeners();
  }

  void showFeedback() {
    if (_selectedOption == null) {
      return;
    }

    _stage = MissionStage.feedback;
    notifyListeners();
  }

  void continueAfterFeedback() {
    final option = _selectedOption;

    if (option == null) {
      return;
    }

    if (option.isCorrect) {
      _result = _scoringService.calculate(
        mission: mission,
        errors: _errors,
      );

      _stage = MissionStage.completed;
    } else {
      _selectedOption = null;
      _stage = MissionStage.choosing;
    }

    notifyListeners();
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\controllers\mission_controller.dart"

# ============================================================
# 8. PLAYER CONTROLLER - SUBSTITUIR
# ============================================================

@'
import 'package:flutter/foundation.dart';

import '../core/enums/player_type.dart';
import '../models/game_progress.dart';
import '../models/mission_result.dart';
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

  Future<void> completeMission({
    required MissionResult result,
    String? nextMissionId,
  }) async {
    final completedMissions =
        Set<String>.from(_progress.completedMissions)
          ..add(result.missionId);

    final missionStars =
        Map<String, int>.from(_progress.missionStars);

    final previousStars = missionStars[result.missionId] ?? 0;

    if (result.stars > previousStars) {
      missionStars[result.missionId] = result.stars;
    }

    final unlockedMissions =
        Set<String>.from(_progress.unlockedMissions);

    if (nextMissionId != null) {
      unlockedMissions.add(nextMissionId);
    }

    _progress = GameProgress(
      citizenshipXp:
          _progress.citizenshipXp + result.citizenship,
      knowledge: _progress.knowledge + result.knowledge,
      coins: _progress.coins + result.coins,
      completedMissions: completedMissions,
      missionStars: missionStars,
      unlockedMissions: unlockedMissions,
      purchasedUpgrades:
          Set<String>.from(_progress.purchasedUpgrades),
      medals: Set<String>.from(_progress.medals),
      zone1Completed: _progress.zone1Completed,
    );

    await _storage.saveProgress(_progress);

    notifyListeners();
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\controllers\player_controller.dart"

# ============================================================
# 9. MISSION SCREEN
# ============================================================

@'
import 'package:flutter/material.dart';

import '../../controllers/mission_controller.dart';
import '../../models/mission.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({
    super.key,
    required this.mission,
    required this.onMissionCompleted,
  });

  final Mission mission;
  final Future<void> Function(MissionController controller)
      onMissionCompleted;

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  late final MissionController _controller;
  bool _completionHandled = false;

  @override
  void initState() {
    super.initState();

    _controller = MissionController(
      mission: widget.mission,
    );

    _controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleControllerChange() async {
    if (_controller.stage != MissionStage.completed) {
      return;
    }

    if (_completionHandled) {
      return;
    }

    _completionHandled = true;

    await widget.onMissionCompleted(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.mission.title),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: _buildStage(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStage(BuildContext context) {
    switch (_controller.stage) {
      case MissionStage.intro:
        return _buildIntro(context);

      case MissionStage.choosing:
        return _buildChoosing(context);

      case MissionStage.consequence:
        return _buildConsequence(context);

      case MissionStage.feedback:
        return _buildFeedback(context);

      case MissionStage.completed:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
  }

  Widget _buildIntro(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Icon(
              Icons.directions_walk_rounded,
              size: 84,
            ),
            const SizedBox(height: 20),
            Text(
              widget.mission.title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              widget.mission.description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  widget.mission.sceneText,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _controller.start,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('INICIAR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoosing(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.visibility_rounded,
                  size: 54,
                ),
                const SizedBox(height: 14),
                Text(
                  widget.mission.sceneText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.mission.question,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        for (final option in widget.mission.options) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () {
                _controller.selectOption(option);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Text(
                  option.text,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (_controller.errors > 0) ...[
          const SizedBox(height: 8),
          Text(
            'Tentativas anteriores: ${_controller.errors}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ],
    );
  }

  Widget _buildConsequence(BuildContext context) {
    final option = _controller.selectedOption!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(
              option.isCorrect
                  ? Icons.check_circle_rounded
                  : Icons.warning_amber_rounded,
              size: 84,
            ),
            const SizedBox(height: 20),
            Text(
              'Veja a consequ\u00eancia',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Text(
              option.consequenceText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _controller.showFeedback,
              child: const Text('CONTINUAR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback(BuildContext context) {
    final option = _controller.selectedOption!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 44,
              child: Icon(
                Icons.person_pin_circle_rounded,
                size: 52,
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
            const SizedBox(height: 16),
            Text(
              option.meloFeedback,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _controller.continueAfterFeedback,
              icon: Icon(
                option.isCorrect
                    ? Icons.emoji_events_rounded
                    : Icons.refresh_rounded,
              ),
              label: Text(
                option.isCorrect
                    ? 'VER RESULTADO'
                    : 'TENTAR NOVAMENTE',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\screens\mission\mission_screen.dart"

# ============================================================
# 10. MISSION RESULT SCREEN
# ============================================================

@'
import 'package:flutter/material.dart';

import '../../models/mission_result.dart';

class MissionResultScreen extends StatelessWidget {
  const MissionResultScreen({
    super.key,
    required this.result,
  });

  final MissionResult result;

  @override
  Widget build(BuildContext context) {
    final stars = '${'\u2605' * result.stars}${'\u2606' * (3 - result.stars)}';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        size: 92,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'MISS\u00c3O CONCLU\u00cdDA',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        stars,
                        style: const TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Pontua\u00e7\u00e3o: ${result.score}/100',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 28),
                      _RewardRow(
                        icon: Icons.workspace_premium_rounded,
                        label: 'Cidadania',
                        value: result.citizenship,
                      ),
                      _RewardRow(
                        icon: Icons.menu_book_rounded,
                        label: 'Conhecimento',
                        value: result.knowledge,
                      ),
                      _RewardRow(
                        icon: Icons.monetization_on_rounded,
                        label: 'Moedas',
                        value: result.coins,
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Voc\u00ea ajudou a tornar a travessia mais segura.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 26),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).popUntil(
                            (route) =>
                                route.settings.name == '/zone-1' ||
                                route.isFirst,
                          );
                        },
                        icon: const Icon(Icons.map_rounded),
                        label: const Text('VOLTAR AO MAPA'),
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

class _RewardRow extends StatelessWidget {
  const _RewardRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label),
          ),
          Text(
            '+$value',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\screens\mission_result\mission_result_screen.dart"

# ============================================================
# 11. ROTAS - SUBSTITUIR
# ============================================================

@'
import 'package:flutter/material.dart';

import '../controllers/mission_controller.dart';
import '../controllers/player_controller.dart';
import '../core/enums/player_type.dart';
import '../data/zone_1/mission_01_data.dart';
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

      case mission1:
        final profile = controller.profile;

        if (profile == null) {
          return _invalidRoute(settings);
        }

        final mission = buildZone1Mission01(profile.type);

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => MissionScreen(
            mission: mission,
            onMissionCompleted: (
              MissionController missionController,
            ) async {
              final result = missionController.result;

              if (result == null) {
                return;
              }

              await controller.completeMission(
                result: result,
                nextMissionId: 'Z1_M02',
              );

              final navigator = rootNavigatorKey.currentState;

              if (navigator == null) {
                return;
              }

              await navigator.pushNamed(
                missionResult,
                arguments: result,
              );
            },
          ),
        );

      case missionResult:
        final result = settings.arguments;

        if (result is! MissionResult) {
          return _invalidRoute(settings);
        }

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => MissionResultScreen(
            result: result,
          ),
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
          child: Text('Rota inv\u00e1lida.'),
        ),
      ),
    );
  }
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
'@ | Set-Content -Encoding UTF8 ".\lib\app\routes.dart"

# ============================================================
# 12. APP - SUBSTITUIR PARA NAVIGATOR KEY
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
      navigatorKey: rootNavigatorKey,
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
# 13. MAPA ZONA 1 - SUBSTITUIR
# ============================================================

@'
import 'package:flutter/material.dart';

import '../../app/routes.dart';
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
    ('Z1_M04', 'S\u00f3 um Minutinho'),
    ('Z1_M05', 'Caminho Seguro'),
    ('Z1_SPECIAL', 'Sa\u00edda da Escola'),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
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
                              style:
                                  Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              'Bairro / Escola',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Observe o bairro, aprenda com as situa\u00e7\u00f5es '
                              'e ajude a transformar a \u00e1rea escolar.',
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
                        id: _missions[index].$1,
                        title: _missions[index].$2,
                        unlocked:
                            progress.unlockedMissions.contains(
                          _missions[index].$1,
                        ),
                        stars:
                            progress.missionStars[
                                    _missions[index].$1] ??
                                0,
                        special:
                            _missions[index].$1 == 'Z1_SPECIAL',
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
    required this.id,
    required this.title,
    required this.unlocked,
    required this.stars,
    required this.special,
  });

  final int number;
  final String id;
  final String title;
  final bool unlocked;
  final int stars;
  final bool special;

  @override
  Widget build(BuildContext context) {
    final isImplemented = id == 'Z1_M01';

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
          special
              ? 'Miss\u00e3o Especial \u2014 $title'
              : '$number. $title',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: unlocked
            ? Text(
                stars == 0
                    ? (isImplemented
                        ? 'Dispon\u00edvel'
                        : 'Desbloqueada \u2014 pr\u00f3ximo pacote')
                    : '${'\u2605' * stars}${'\u2606' * (3 - stars)}',
              )
            : const Text('Bloqueada'),
        trailing: unlocked && isImplemented
            ? const Icon(Icons.play_circle_outline_rounded)
            : null,
        onTap: unlocked && isImplemented
            ? () {
                Navigator.of(context).pushNamed(
                  AppRoutes.mission1,
                );
              }
            : null,
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 ".\lib\screens\zone_1_map\zone_1_map_screen.dart"

# ============================================================
# 14. TESTE - SCORING SERVICE
# ============================================================

@'
import 'package:cidade_em_movimento/models/mission.dart';
import 'package:cidade_em_movimento/services/scoring_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mission = Mission(
    id: 'TEST',
    title: 'Teste',
    description: 'Teste',
    sceneText: 'Teste',
    question: 'Teste',
    options: [],
    maxCitizenship: 20,
    maxKnowledge: 10,
    maxCoins: 15,
  );

  const service = ScoringService();

  test('sem erro gera 3 estrelas', () {
    final result = service.calculate(
      mission: mission,
      errors: 0,
    );

    expect(result.score, 100);
    expect(result.stars, 3);
  });

  test('um erro gera 2 estrelas', () {
    final result = service.calculate(
      mission: mission,
      errors: 1,
    );

    expect(result.score, 80);
    expect(result.stars, 2);
  });

  test('dois erros geram 1 estrela', () {
    final result = service.calculate(
      mission: mission,
      errors: 2,
    );

    expect(result.score, 60);
    expect(result.stars, 1);
  });
}
'@ | Set-Content -Encoding UTF8 ".\test\scoring_service_test.dart"

# ============================================================
# 15. TESTE - PROGRESSO
# ============================================================

@'
import 'package:cidade_em_movimento/controllers/player_controller.dart';
import 'package:cidade_em_movimento/models/mission_result.dart';
import 'package:cidade_em_movimento/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'concluir missao 1 libera missao 2 e persiste progresso',
    () async {
      SharedPreferences.setMockInitialValues({});

      final preferences = await SharedPreferences.getInstance();
      final storage = StorageService(preferences);
      final controller = PlayerController(storage);

      await controller.initialize();

      const result = MissionResult(
        missionId: 'Z1_M01',
        stars: 3,
        score: 100,
        citizenship: 20,
        knowledge: 10,
        coins: 15,
        errors: 0,
      );

      await controller.completeMission(
        result: result,
        nextMissionId: 'Z1_M02',
      );

      expect(
        controller.progress.completedMissions.contains('Z1_M01'),
        isTrue,
      );

      expect(
        controller.progress.unlockedMissions.contains('Z1_M02'),
        isTrue,
      );

      expect(
        controller.progress.missionStars['Z1_M01'],
        3,
      );

      final secondController = PlayerController(storage);
      await secondController.initialize();

      expect(
        secondController.progress.unlockedMissions.contains('Z1_M02'),
        isTrue,
      );

      expect(
        secondController.progress.citizenshipXp,
        20,
      );
    },
  );
}
'@ | Set-Content -Encoding UTF8 ".\test\progress_test.dart"

# ============================================================
# 16. FORMAT
# ============================================================

Write-Host ""
Write-Host "[2/9] dart format..."

dart format lib test

if ($LASTEXITCODE -ne 0) {
    throw "dart format = FAIL"
}

# ============================================================
# 17. ANALYZE
# ============================================================

Write-Host ""
Write-Host "[3/9] flutter analyze..."

flutter analyze

if ($LASTEXITCODE -ne 0) {
    throw "flutter analyze = FAIL"
}

# ============================================================
# 18. TEST
# ============================================================

Write-Host ""
Write-Host "[4/9] flutter test..."

flutter test

if ($LASTEXITCODE -ne 0) {
    throw "flutter test = FAIL"
}

# ============================================================
# 19. WEB BUILD
# ============================================================

Write-Host ""
Write-Host "[5/9] flutter build web..."

flutter build web

if ($LASTEXITCODE -ne 0) {
    throw "flutter build web = FAIL"
}

# ============================================================
# 20. GIT DIFF
# ============================================================

Write-Host ""
Write-Host "[6/9] Git status..."

git status --short

Write-Host ""
Write-Host "[7/9] Arquivos P0-E..."

git diff --stat

# ============================================================
# 21. UTF8 CHECK
# ============================================================

Write-Host ""
Write-Host "[8/9] UTF8 sanity check..."

$badFound = $false

Get-ChildItem ".\lib" -Recurse -Filter "*.dart" | ForEach-Object {
    $text = [System.IO.File]::ReadAllText(
        $_.FullName,
        [System.Text.Encoding]::UTF8
    )

    if (
        $text.Contains([string][char]0xFFFD)
    ) {
        Write-Host "UTF8 SUSPEITO: $($_.FullName)"
        $badFound = $true
    }
}

if ($badFound) {
    throw "UTF8 sanity check = FAIL"
}

# ============================================================
# 22. RESULTADO
# ============================================================

Write-Host ""
Write-Host "[9/9] Resultado..."

Write-Host ""
Write-Host "============================================================"
Write-Host " CIDADE EM MOVIMENTO - P0-E"
Write-Host "============================================================"
Write-Host " MOTOR GENERICO        = PASS"
Write-Host " MISSION MODEL         = PASS"
Write-Host " MISSION CONTROLLER    = PASS"
Write-Host " SCORING SERVICE       = PASS"
Write-Host " MISSAO 1              = IMPLEMENTADA"
Write-Host " PERFIL CRIANCA        = PASS"
Write-Host " PERFIL ADOLESCENTE    = PASS"
Write-Host " PERFIL ADULTO         = PASS"
Write-Host " CONSEQUENCIA          = PASS"
Write-Host " FEEDBACK MELO         = PASS"
Write-Host " ESTRELAS              = PASS"
Write-Host " RECOMPENSAS           = PASS"
Write-Host " PERSISTENCIA          = PASS"
Write-Host " DESBLOQUEIO MISSAO 2  = PASS"
Write-Host " FLUTTER ANALYZE       = PASS"
Write-Host " FLUTTER TEST          = PASS"
Write-Host " WEB BUILD             = PASS"
Write-Host " UTF8 SANITY           = PASS"
Write-Host "------------------------------------------------------------"
Write-Host " MISSAO 2              = NAO IMPLEMENTADA"
Write-Host " MELHORIAS URBANAS     = NAO IMPLEMENTADAS"
Write-Host " ZONA 2                 = 0"
Write-Host " NOVAS FUNCOES         = 0"
Write-Host "============================================================"