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
  final Future<void> Function(MissionController controller) onMissionCompleted;

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  late final MissionController _controller;
  bool _completionHandled = false;

  @override
  void initState() {
    super.initState();

    _controller = MissionController(mission: widget.mission);

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
          appBar: AppBar(title: Text(widget.mission.title)),
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
        return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildIntro(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Icon(Icons.directions_walk_rounded, size: 84),
            const SizedBox(height: 20),
            Text(
              widget.mission.title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(widget.mission.description, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
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
                const Icon(Icons.visibility_rounded, size: 54),
                const SizedBox(height: 14),
                Text(widget.mission.sceneText, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.mission.question,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(option.text, textAlign: TextAlign.center),
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
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Text(option.consequenceText, textAlign: TextAlign.center),
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
              child: Icon(Icons.person_pin_circle_rounded, size: 52),
            ),
            const SizedBox(height: 14),
            Text(
              'Melo',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(option.meloFeedback, textAlign: TextAlign.center),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _controller.continueAfterFeedback,
              icon: Icon(
                option.isCorrect
                    ? Icons.emoji_events_rounded
                    : Icons.refresh_rounded,
              ),
              label: Text(
                option.isCorrect ? 'VER RESULTADO' : 'TENTAR NOVAMENTE',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
