import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../controllers/mission_controller.dart';
import '../controllers/player_controller.dart';
import '../models/mission.dart';
import '../models/mission_option.dart';
import 'zone_4_approved_art.dart';

/// Uses the existing mission and reward engines while keeping the map mounted.
class Zone4MissionDialog extends StatefulWidget {
  const Zone4MissionDialog({
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
  State<Zone4MissionDialog> createState() => _Zone4MissionDialogState();
}

class _Zone4MissionDialogState extends State<Zone4MissionDialog> {
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
    final canClose = !_saving && _saveError == null;
    final choosing = _mission.stage == MissionStage.choosing;
    final index = widget.mission.id == 'Z4_SPECIAL'
        ? '★'
        : widget.mission.id.substring(widget.mission.id.length - 1);
    return PopScope(
      canPop: canClose,
      child: Dialog.fullscreen(
        key: const Key('zone4-mission-dialog'),
        backgroundColor: zone4Ink,
        child: RepaintBoundary(
          key: const Key('zone4-mission-capture'),
          child: Zone4ArtworkBoard(
            asset: zone4MissionArtwork,
            captureKey: const Key('zone4-mission-frame'),
            children: [
              Positioned(
                left: 340,
                top: 255,
                width: 753,
                height: 651,
                child: Semantics(
                  key: const Key('zone4-question-scenario'),
                  label: 'Cenário ilustrado de ${widget.mission.title}',
                  image: true,
                  child: widget.mission.id == 'Z4_M01'
                      ? const SizedBox.expand()
                      : Zone4MissionScene(missionId: widget.mission.id),
                ),
              ),
              Positioned(
                left: 340,
                top: 255,
                width: 753,
                height: 651,
                child: Zone4NightLayer(
                  key: const Key('zone4-question-night'),
                  night: widget.nightPreview,
                  lighting: false,
                ),
              ),
              Positioned(
                left: 0,
                top: 350,
                width: 350,
                height: 591,
                child: IgnorePointer(
                  child: Semantics(
                    key: const Key('zone4-question-melo'),
                    label: 'Melo, seu guia de trânsito',
                    image: true,
                    child: const SizedBox.expand(key: Key('zone4-mockup-melo')),
                  ),
                ),
              ),
              Positioned(
                left: 448,
                top: 35,
                width: 94,
                height: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF52638),
                    borderRadius: BorderRadius.circular(48),
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Zone4ArtText(index, fontSize: 70),
                ),
              ),
              Positioned(
                left: 562,
                top: 40,
                width: 580,
                height: 98,
                child: Column(
                  key: const Key('zone4-mission-header'),
                  children: [
                    Expanded(
                      flex: 2,
                      child: Zone4ArtText(
                        widget.mission.title.toUpperCase(),
                        textKey: const Key('zone4-mission-title'),
                        fontSize: 49,
                      ),
                    ),
                    const Expanded(
                      child: Zone4ArtText(
                        'Observe. Escolha. Aprenda.',
                        fontSize: 27,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 1166,
                top: 54,
                width: 413,
                height: 81,
                child: AnimatedBuilder(
                  animation: widget.player,
                  builder: (context, _) => Zone4LiveHud(player: widget.player),
                ),
              ),
              Positioned(
                left: 28,
                top: 36,
                width: 70,
                height: 70,
                child: IconButton(
                  key: const Key('zone4-back-mission'),
                  tooltip: 'Voltar ao Evento',
                  iconSize: 40,
                  color: zone4Ink,
                  onPressed: canClose
                      ? () => Navigator.of(context).pop()
                      : null,
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ),
              Positioned(
                left: 1580,
                top: 33,
                width: 76,
                height: 76,
                child: IconButton(
                  key: const Key('zone4-close-mission'),
                  tooltip: 'Sair da missão',
                  iconSize: 44,
                  color: Colors.white,
                  onPressed: canClose
                      ? () => Navigator.of(context).pop()
                      : null,
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              Positioned(
                left: 383,
                top: 164,
                width: 903,
                height: 59,
                child: _steps(),
              ),
              Positioned(
                left: 48,
                top: 232,
                width: 271,
                height: 107,
                child: Zone4ArtText(
                  widget.mission.sceneText,
                  textKey: const Key('zone4-question-context'),
                  color: zone4Ink,
                  fontSize: 31,
                ),
              ),
              Positioned(
                left: 1110,
                top: 257,
                width: 548,
                height: 650,
                child: SizedBox.expand(
                  key: const Key('zone4-mission-content-viewport'),
                  child: choosing ? _question() : _stage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _steps() {
    final active = switch (_mission.stage) {
      MissionStage.intro => 0,
      MissionStage.choosing => 1,
      MissionStage.consequence => 2,
      MissionStage.feedback || MissionStage.completed => 3,
    };
    const labels = ['Observe', 'Decida', 'Consequência', 'Aprenda'];
    return Row(
      key: const Key('zone4-mission-steps'),
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: Semantics(
              selected: active == i,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: active == i ? zone4Gold : zone4Ink,
                  borderRadius: BorderRadius.circular(36),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 38,
                      child: Zone4ArtText(
                        '${i + 1}',
                        color: active == i ? zone4Ink : Colors.white,
                        fontSize: 36,
                      ),
                    ),
                    Expanded(
                      child: Zone4ArtText(
                        labels[i],
                        fontSize: 25,
                        color: active == i ? zone4Ink : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _question() => Stack(
    key: const Key('zone4-question-highlight'),
    children: [
      Positioned(
        left: 28,
        top: 14,
        width: 411,
        height: 91,
        child: Zone4ArtText(
          widget.mission.question,
          textKey: const Key('zone4-question-text'),
          fontSize: 45,
        ),
      ),
      Positioned(
        left: 449,
        top: 15,
        width: 80,
        height: 80,
        child: Tooltip(
          message: 'Voz em breve',
          child: IconButton(
            key: const Key('zone4-voice-preview'),
            onPressed: null,
            disabledColor: Colors.white,
            icon: const Icon(Icons.volume_up_rounded, size: 46),
          ),
        ),
      ),
      for (var i = 0; i < widget.mission.options.length; i++)
        Positioned(
          left: 17,
          top: 116 + i * 134.0,
          width: 514,
          height: 116,
          child: Semantics(
            selected: _pendingOption?.id == widget.mission.options[i].id,
            child: OutlinedButton(
              key: Key('zone4-answer-${widget.mission.options[i].id}'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    _pendingOption?.id == widget.mission.options[i].id
                    ? const Color(0x550084E9)
                    : Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(33),
                ),
                side: BorderSide(
                  color: _pendingOption?.id == widget.mission.options[i].id
                      ? zone4Gold
                      : Colors.transparent,
                  width: 5,
                ),
              ),
              onPressed: () =>
                  setState(() => _pendingOption = widget.mission.options[i]),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Zone4ArtText(
                      String.fromCharCode(65 + i),
                      fontSize: 50,
                      color: zone4Ink,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Zone4ArtText(
                      widget.mission.options[i].text,
                      fontSize: 32,
                      align: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      Positioned(
        left: 24,
        top: 529,
        width: 497,
        height: 94,
        child: FilledButton(
          key: const Key('zone4-confirm-answer'),
          style: FilledButton.styleFrom(
            foregroundColor: zone4Ink,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: const Color(0x77062365),
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(42),
            ),
          ),
          onPressed: _pendingOption == null
              ? null
              : () {
                  final selected = _pendingOption!;
                  _pendingOption = null;
                  _mission.selectOption(selected);
                },
          child: Zone4ArtText(
            'CONFIRMAR RESPOSTA',
            fontSize: 38,
            color: _pendingOption == null ? Colors.white : zone4Ink,
          ),
        ),
      ),
    ],
  );

  Widget _action(String label, VoidCallback? action, {Key? key}) => SizedBox(
    height: 76,
    child: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FilledButton(
        key: key,
        onPressed: action,
        style: FilledButton.styleFrom(
          backgroundColor: zone4Gold,
          foregroundColor: zone4Ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          side: const BorderSide(color: zone4Cyan, width: 3),
        ),
        child: Zone4ArtText(label, color: zone4Ink, fontSize: 31),
      ),
    ),
  );

  Widget _stagePanel({
    required String title,
    required String text,
    required List<Widget> actions,
    IconData? icon,
    Widget? extra,
  }) => Container(
    key: const Key('zone4-stage-balloon'),
    padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0846BE), zone4Ink],
      ),
      border: Border.all(color: zone4Cyan, width: 5),
      borderRadius: BorderRadius.circular(45),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (icon != null) Icon(icon, color: zone4Gold, size: 64),
        SizedBox(height: 76, child: Zone4ArtText(title, fontSize: 42)),
        const SizedBox(height: 16),
        Expanded(
          child: Zone4ArtText(
            text,
            fontSize: 33,
            textKey: const Key('zone4-mission-guidance'),
          ),
        ),
        ?extra,
        const SizedBox(height: 16),
        ...actions,
      ],
    ),
  );

  Widget _stage() {
    switch (_mission.stage) {
      case MissionStage.intro:
        return _stagePanel(
          title: 'Observe o cenário',
          text: widget.mission.description,
          icon: Icons.visibility_rounded,
          actions: [_action('INICIAR', _mission.start)],
        );
      case MissionStage.choosing:
        return _question();
      case MissionStage.consequence:
        final option = _mission.selectedOption!;
        return _stagePanel(
          title: 'Veja a consequência',
          text: option.consequenceText,
          icon: option.isCorrect
              ? Icons.check_circle_rounded
              : Icons.warning_amber_rounded,
          actions: [_action('CONTINUAR', _mission.showFeedback)],
        );
      case MissionStage.feedback:
        final option = _mission.selectedOption!;
        return _stagePanel(
          title: 'Melo explica',
          text: option.meloFeedback,
          icon: Icons.school_rounded,
          actions: [
            _action(
              option.isCorrect ? 'VER RESULTADO' : 'TENTAR NOVAMENTE',
              _mission.continueAfterFeedback,
            ),
          ],
        );
      case MissionStage.completed:
        if (_saving) {
          return _stagePanel(
            title: 'Salvando',
            text: 'Salvando seu progresso…',
            extra: const Center(
              child: CircularProgressIndicator(color: zone4Gold),
            ),
            actions: [],
          );
        }
        if (_saveError != null) {
          return _stagePanel(
            title: 'Vamos tentar de novo',
            text: _saveError!,
            icon: Icons.cloud_off_rounded,
            actions: [_action('TENTAR SALVAR NOVAMENTE', _save)],
          );
        }
        final result = _mission.result!;
        return _stagePanel(
          title: 'MISSÃO CONCLUÍDA',
          text: _alreadyCompleted
              ? 'Recompensas já recebidas. Sua melhor marca fica preservada.'
              : '+${result.citizenship} Cidadania\n+${result.knowledge} Conhecimento\n+${result.coins} Moedas',
          icon: Icons.emoji_events_rounded,
          extra: SizedBox(
            height: 104,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Icon(
                        i < result.stars
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: zone4Gold,
                        size: 57,
                      ),
                  ],
                ),
                Expanded(
                  child: Zone4ArtText(
                    'Pontuação: ${result.score}/100',
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (widget.player.hasProfile)
              _action(
                'PERGUNTAR À FAIXITA',
                () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.faixita, arguments: result),
              ),
            _action(
              'VOLTAR AO EVENTO',
              () => Navigator.of(context).pop(),
              key: const Key('zone4-finish-mission'),
            ),
          ],
        );
    }
  }
}
