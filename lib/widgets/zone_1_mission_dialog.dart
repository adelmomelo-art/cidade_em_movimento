import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../controllers/mission_controller.dart';
import '../controllers/player_controller.dart';
import '../models/mission.dart';
import '../models/mission_option.dart';
import '../ui/visual_system.dart';
import 'zone_1_art.dart';
import 'zone_1_visual_scene.dart';

/// Uses the existing mission and reward engines while keeping the map mounted.
class Zone1MissionDialog extends StatefulWidget {
  const Zone1MissionDialog({
    super.key,
    required this.mission,
    required this.player,
    this.nextMissionId,
    this.nightPreview = false,
  });

  final Mission mission;
  final PlayerController player;
  final String? nextMissionId;
  final bool nightPreview;

  @override
  State<Zone1MissionDialog> createState() => _Zone1MissionDialogState();
}

class _Zone1MissionDialogState extends State<Zone1MissionDialog> {
  late final MissionController _mission;
  late final bool _alreadyCompleted;
  MissionOption? _pendingOption;
  bool _saving = false;
  bool _saved = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    _alreadyCompleted = widget.player.progress.completedMissions.contains(
      widget.mission.id,
    );
    _mission = MissionController(mission: widget.mission)
      ..addListener(_changed);
  }

  void _changed() {
    if (!mounted) {
      return;
    }
    setState(() {});
    if (_mission.stage == MissionStage.completed &&
        !_saving &&
        !_saved &&
        _saveError == null) {
      _save();
    }
  }

  Future<void> _save() async {
    if (_saving || _saved) return;
    final result = _mission.result;
    if (result == null) return;
    setState(() {
      _saving = true;
      _saveError = null;
    });
    try {
      await widget.player.completeMission(
        result: result,
        nextMissionId: widget.nextMissionId,
      );
      if (mounted) {
        setState(() {
          _saving = false;
          _saved = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _saveError = 'Não foi possível salvar o resultado. Tente novamente.';
        });
      }
    }
  }

  @override
  void dispose() {
    _mission.removeListener(_changed);
    _mission.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view = MediaQuery.sizeOf(context);
    final progress = widget.player.progress;
    final canClose = !_saving && _saveError == null;
    final landscape = view.width > view.height;
    // Reference: map 656 x 439; mission window 206 x 110.
    final sceneWidth = (view.width - (view.width < 1000 ? 8 : 24)).clamp(
      0.0,
      1600.0,
    );
    final horizontalInset = view.width < 720 ? 12.0 : 24.0;
    final availableWidth = view.width - horizontalInset * 2;
    final minimumWidth = 360.0.clamp(0.0, availableWidth);
    final preferredWidth = landscape
        ? (sceneWidth * (206 / 656)).clamp(minimumWidth, availableWidth)
        : availableWidth;
    final freeWidth = availableWidth - preferredWidth;
    final desiredCenter = (view.width - sceneWidth) / 2 + sceneWidth * .37;
    final alignmentX = landscape && freeWidth > 0
        ? ((2 * desiredCenter - view.width) / freeWidth).clamp(-1.0, 1.0)
        : 0.0;
    return PopScope(
      canPop: canClose,
      child: Dialog(
        key: const Key('zone1-mission-dialog'),
        alignment: Alignment(alignmentX, 0),
        insetPadding: EdgeInsets.symmetric(
          horizontal: view.width < 720 ? 12 : 24,
          vertical: 12,
        ),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: preferredWidth,
            maxHeight: view.height * .92,
          ),
          child: LayoutBuilder(
            builder: (context, bounds) {
              final height = landscape
                  ? (bounds.maxWidth / (206 / 110)).clamp(0.0, bounds.maxHeight)
                  : bounds.maxHeight;
              return RepaintBoundary(
                key: const Key('zone1-mission-capture'),
                child: SizedBox(
                  key: const Key('zone1-mission-frame'),
                  width: bounds.maxWidth,
                  height: height,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Zone1NeighborhoodArt(
                            key: const Key('zone1-question-scenario'),
                            crosswalk: progress.purchasedUpgrades.contains(
                              'FAIXA_SEGURA',
                            ),
                            lighting: progress.purchasedUpgrades.contains(
                              'ILUMINACAO_ESCOLAR',
                            ),
                            cyclePath: progress.purchasedUpgrades.contains(
                              'TRECHO_CICLOVIARIO',
                            ),
                            nightPreview: widget.nightPreview,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: DecoratedBox(
                            key: const Key('zone1-question-backdrop'),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  GameColors.navy.withValues(alpha: .5),
                                  const Color(0xFF0B1E45).withValues(alpha: .5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            key: const Key('zone1-mission-header'),
                            color: GameColors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 0,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  key: const Key('zone1-back-mission'),
                                  tooltip: 'Voltar ao bairro',
                                  constraints: const BoxConstraints(
                                    minWidth: 48,
                                    minHeight: 48,
                                  ),
                                  onPressed: canClose
                                      ? () => Navigator.of(context).pop()
                                      : null,
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.mission.title.toUpperCase(),
                                    key: const Key('zone1-mission-title'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: landscape ? 16 : 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  key: const Key('zone1-close-mission'),
                                  tooltip: _saved
                                      ? 'Voltar ao bairro'
                                      : 'Sair da missão',
                                  constraints: const BoxConstraints(
                                    minWidth: 48,
                                    minHeight: 48,
                                  ),
                                  onPressed: canClose
                                      ? () => Navigator.of(context).pop()
                                      : null,
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, body) {
                                final wide = landscape && body.maxWidth >= 320;
                                final heroWidth = wide
                                    ? body.maxWidth * .34
                                    : 180.0;
                                final hero = SizedBox(
                                  key: const Key('zone1-question-melo'),
                                  width: heroWidth,
                                  height: wide ? body.maxHeight : 225,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Image.asset(
                                      'assets/zone_1/melo_perguntas_r19.png',
                                      key: const Key('zone1-mockup-melo'),
                                      fit: BoxFit.contain,
                                      alignment: Alignment.bottomCenter,
                                      cacheWidth: 700,
                                      semanticLabel: 'Melo apresenta a missão',
                                    ),
                                  ),
                                );
                                final content = Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: _FitMissionContent(child: _stage()),
                                );
                                if (wide) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      hero,
                                      Expanded(child: content),
                                    ],
                                  );
                                }
                                return Column(
                                  children: [
                                    hero,
                                    Expanded(child: content),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _bubble(List<Widget> children, {bool question = false}) => Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        key: Key(question ? 'zone1-question-highlight' : 'zone1-stage-balloon'),
        width: double.infinity,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEDAC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: GameColors.yellow, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
      const Positioned(
        left: -10,
        top: 42,
        width: 12,
        height: 20,
        child: IgnorePointer(child: CustomPaint(painter: _QuestionTail())),
      ),
    ],
  );

  Widget _copy(String text, {Key? key, bool strong = false}) => Text(
    text,
    key: key,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: GameColors.navy,
      fontSize:
          MediaQuery.sizeOf(context).width > MediaQuery.sizeOf(context).height
          ? (strong ? 12 : 10)
          : (strong ? 18 : 14),
      height: 1.25,
      fontWeight: strong ? FontWeight.w900 : FontWeight.w600,
    ),
  );

  Widget _button(String label, VoidCallback? onPressed, {Key? key}) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: FilledButton(
      key: key,
      style: FilledButton.styleFrom(
        backgroundColor: GameColors.blue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFF315E91),
        disabledForegroundColor: Colors.white,
        textStyle: TextStyle(
          fontSize:
              MediaQuery.sizeOf(context).width >
                  MediaQuery.sizeOf(context).height
              ? 10
              : 14,
          fontWeight: FontWeight.w900,
        ),
        minimumSize: const Size(double.infinity, 24),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        side: const BorderSide(color: GameColors.yellow, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      onPressed: onPressed,
      child: Text(label, textAlign: TextAlign.center),
    ),
  );

  Widget _question() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _bubble([
        _copy(
          widget.mission.sceneText,
          key: const Key('zone1-question-context'),
        ),
        const SizedBox(height: 6),
        _copy(
          widget.mission.question,
          key: const Key('zone1-question-text'),
          strong: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(
              message: 'Narração do Melo: implementação futura',
              child: IconButton(
                key: const Key('zone1-voice-preview'),
                onPressed: null,
                disabledColor: GameColors.navy.withValues(alpha: .7),
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.volume_up_rounded, size: 18),
              ),
            ),
            const Flexible(
              child: Text(
                'Voz em breve',
                style: TextStyle(color: GameColors.navy, fontSize: 9),
              ),
            ),
          ],
        ),
      ], question: true),
      for (var i = 0; i < widget.mission.options.length; i++)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: OutlinedButton(
            key: Key('zone1-answer-${widget.mission.options[i].id}'),
            style: OutlinedButton.styleFrom(
              backgroundColor: GameColors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(24, 24),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              side: BorderSide(
                color: _pendingOption?.id == widget.mission.options[i].id
                    ? GameColors.yellow
                    : GameColors.sky,
                width: _pendingOption?.id == widget.mission.options[i].id
                    ? 3
                    : 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: () =>
                setState(() => _pendingOption = widget.mission.options[i]),
            child: Semantics(
              selected: _pendingOption?.id == widget.mission.options[i].id,
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: GameColors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      String.fromCharCode(65 + i),
                      style: const TextStyle(
                        fontSize: 12,
                        color: GameColors.navy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.mission.options[i].text,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.sizeOf(context).width >
                                MediaQuery.sizeOf(context).height
                            ? 10
                            : 14,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      if (_mission.errors > 0)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Tentativas anteriores: ${_mission.errors}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      _button(
        'CONFIRMAR RESPOSTA',
        _pendingOption == null
            ? null
            : () {
                final selected = _pendingOption!;
                _pendingOption = null;
                _mission.selectOption(selected);
              },
        key: const Key('zone1-confirm-answer'),
      ),
    ],
  );

  Widget _stage() {
    switch (_mission.stage) {
      case MissionStage.intro:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _bubble([
              _copy(widget.mission.description, strong: true),
              const SizedBox(height: 6),
              _copy(
                widget.mission.sceneText,
                key: const Key('zone1-mission-guidance'),
              ),
            ]),
            _button('INICIAR', _mission.start),
          ],
        );
      case MissionStage.choosing:
        return _question();
      case MissionStage.consequence:
        final option = _mission.selectedOption!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _bubble([
              Icon(
                option.isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.warning_amber_rounded,
                color: option.isCorrect ? GameColors.green : GameColors.orange,
                size: 28,
              ),
              const SizedBox(height: 8),
              _copy('Veja a consequência', strong: true),
              const SizedBox(height: 6),
              _copy(option.consequenceText),
            ]),
            _button('CONTINUAR', _mission.showFeedback),
          ],
        );
      case MissionStage.feedback:
        final option = _mission.selectedOption!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _bubble([
              _copy('Melo explica', strong: true),
              const SizedBox(height: 6),
              _copy(
                option.meloFeedback,
                key: const Key('zone1-mission-guidance'),
              ),
            ]),
            _button(
              option.isCorrect ? 'VER RESULTADO' : 'TENTAR NOVAMENTE',
              _mission.continueAfterFeedback,
            ),
          ],
        );
      case MissionStage.completed:
        if (_saving) {
          return _bubble([
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 6),
            _copy('Salvando seu progresso…'),
          ]);
        }
        if (_saveError != null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _bubble([_copy(_saveError!, strong: true)]),
              _button('TENTAR SALVAR NOVAMENTE', _save),
            ],
          );
        }
        final result = _mission.result!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _bubble([
              const Icon(
                Icons.emoji_events_rounded,
                size: 30,
                color: GameColors.orange,
              ),
              _copy('MISSÃO CONCLUÍDA', strong: true),
              const SizedBox(height: 10),
              Center(child: Zone1MissionStars(stars: result.stars)),
              const SizedBox(height: 10),
              _copy('Pontuação: ${result.score}/100'),
              const SizedBox(height: 10),
              if (_alreadyCompleted)
                _copy(
                  'Recompensas já recebidas. Sua melhor marca fica preservada.',
                )
              else
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _copy('+${result.citizenship} Cidadania'),
                    _copy('+${result.knowledge} Conhecimento'),
                    _copy('+${result.coins} Moedas'),
                  ],
                ),
              const SizedBox(height: 6),
              _copy(
                _mission.selectedOption!.meloFeedback,
                key: const Key('zone1-mission-guidance'),
              ),
            ]),
            if (widget.player.hasProfile)
              _button(
                'PERGUNTAR À FAIXITA',
                () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.faixita, arguments: result),
              ),
            _button(
              'VOLTAR AO BAIRRO',
              () => Navigator.of(context).pop(),
              key: const Key('zone1-finish-mission'),
            ),
          ],
        );
    }
  }
}

class _QuestionTail extends CustomPainter {
  const _QuestionTail();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFEDAC));
    canvas.drawPath(
      path,
      Paint()
        ..color = GameColors.yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _QuestionTail oldDelegate) => false;
}

/// Fits only the copy and actions. The approved window and mentor are not scaled.
class _FitMissionContent extends StatelessWidget {
  const _FitMissionContent({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, space) => SizedBox.expand(
      key: const Key('zone1-mission-content-viewport'),
      child: FittedBox(
        key: const Key('zone1-mission-content-fit'),
        fit: BoxFit.scaleDown,
        alignment: Alignment.topCenter,
        child: SizedBox(width: space.maxWidth, child: child),
      ),
    ),
  );
}
