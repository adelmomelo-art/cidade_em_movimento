import 'package:flutter/material.dart';

import '../../controllers/player_controller.dart';
import '../../data/sign_duel/sign_duel_catalog.dart';
import '../../models/sign_duel_question.dart';

class SignDuelScreen extends StatefulWidget {
  const SignDuelScreen({super.key, required this.controller});

  final PlayerController controller;

  @override
  State<SignDuelScreen> createState() => _SignDuelScreenState();
}

class _SignDuelScreenState extends State<SignDuelScreen> {
  final ScrollController _scrollController = ScrollController();

  int _index = 0;
  int _score = 0;
  int _correct = 0;
  int? _selectedIndex;
  bool _finished = false;
  bool _saving = false;
  int _knowledgeGain = 0;

  SignDuelQuestion get _question => signDuelQuestions[_index];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    });
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  void _select(int optionIndex) {
    if (_selectedIndex != null || _finished) {
      return;
    }

    final correct = optionIndex == _question.correctIndex;

    setState(() {
      _selectedIndex = optionIndex;
      if (correct) {
        _score += 100;
        _correct++;
      }
    });

    _scrollToBottom();
  }

  Future<void> _continue() async {
    if (_selectedIndex == null || _saving) {
      return;
    }

    if (_index < signDuelQuestions.length - 1) {
      setState(() {
        _index++;
        _selectedIndex = null;
      });

      _scrollToTop();
      return;
    }

    setState(() {
      _saving = true;
    });

    final gain = await widget.controller.recordSignDuelResult(
      score: _score,
      correctAnswers: _correct,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _knowledgeGain = gain;
      _saving = false;
      _finished = true;
    });

    _scrollToTop();
  }

  void _restart() {
    setState(() {
      _index = 0;
      _score = 0;
      _correct = 0;
      _selectedIndex = null;
      _finished = false;
      _saving = false;
      _knowledgeGain = 0;
    });

    _scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Duelo das Placas')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: _finished ? _buildResult(context) : _buildRound(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRound(BuildContext context) {
    final question = _question;
    final progress = (_index + 1) / signDuelQuestions.length;

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                LinearProgressIndicator(
                  key: const Key('duel-progress'),
                  value: progress,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rodada ${_index + 1} de ${signDuelQuestions.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text('Pontos: $_score'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          key: const Key('duel-question-card'),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  child: Text(
                    question.code,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  question.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text('Nivel ${question.level}'),
                  avatar: const Icon(Icons.speed_rounded, size: 18),
                ),
                const SizedBox(height: 18),
                Text(
                  question.prompt,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (var index = 0; index < question.options.length; index++) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              key: Key('duel-option-$index'),
              onPressed: _selectedIndex == null ? () => _select(index) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  question.options[index],
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (_selectedIndex != null) ...[
          const SizedBox(height: 8),
          _FeedbackCard(
            correct: _selectedIndex == question.correctIndex,
            explanation: question.explanation,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const Key('duel-continue'),
            onPressed: _saving ? null : _continue,
            icon: Icon(
              _index == signDuelQuestions.length - 1
                  ? Icons.emoji_events_rounded
                  : Icons.arrow_forward_rounded,
            ),
            label: Text(
              _index == signDuelQuestions.length - 1
                  ? 'VER RESULTADO'
                  : 'PROXIMA PLACA',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResult(BuildContext context) {
    final progress = widget.controller.progress;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Icon(Icons.emoji_events_rounded, size: 78),
            const SizedBox(height: 16),
            Text(
              'Duelo concluido',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Text(
              '$_correct de ${signDuelQuestions.length} respostas corretas',
              key: const Key('duel-final-correct'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text('Pontuacao: $_score', key: const Key('duel-final-score')),
            const SizedBox(height: 14),
            if (_knowledgeGain > 0)
              Text(
                '+$_knowledgeGain Conhecimento por novo recorde',
                key: const Key('duel-knowledge-gain'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            else
              const Text(
                'Seu melhor desempenho foi preservado.',
                key: Key('duel-no-new-knowledge'),
              ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                Chip(
                  avatar: const Icon(Icons.military_tech_rounded, size: 18),
                  label: Text('Recorde: ${progress.signDuelBestScore}'),
                ),
                Chip(
                  avatar: const Icon(Icons.menu_book_rounded, size: 18),
                  label: Text('Melhor: ${progress.signDuelBestCorrect}/6'),
                ),
                Chip(
                  avatar: const Icon(Icons.replay_rounded, size: 18),
                  label: Text('Duelos: ${progress.signDuelPlays}'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const Key('duel-restart'),
              onPressed: _restart,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('JOGAR NOVAMENTE'),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.map_rounded),
              label: const Text('VOLTAR AO MAPA'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.correct, required this.explanation});

  final bool correct;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('duel-feedback'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              correct ? Icons.check_circle_rounded : Icons.info_rounded,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    correct ? 'Boa decisao!' : 'Observe esta regra',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(explanation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
