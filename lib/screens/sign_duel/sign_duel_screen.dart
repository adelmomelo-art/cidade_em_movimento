import 'dart:async';

import 'package:flutter/material.dart';

import '../../controllers/player_controller.dart';
import '../../core/enums/player_type.dart';
import '../../data/sign_duel/sign_duel_catalog.dart';
import '../../models/sign_duel_question.dart';
import '../../widgets/approved_artwork_page.dart';
import '../../widgets/sign_duel_art.dart';
import '../../widgets/zone_1_approved_art.dart';

class SignDuelScreen extends StatefulWidget {
  const SignDuelScreen({super.key, required this.controller});
  final PlayerController controller;

  @override
  State<SignDuelScreen> createState() => _SignDuelScreenState();
}

class _SignDuelScreenState extends State<SignDuelScreen>
    with WidgetsBindingObserver {
  Timer? _timer;
  int _lastTick = 0;
  late final int _limit;
  late int _remaining;
  bool _visible = true;
  bool _foreground = true;
  int _index = 0;
  int _score = 0;
  int _correct = 0;
  int? _selectedIndex;
  bool _resolved = false;
  bool _timedOut = false;
  bool _finished = false;
  bool _saving = false;
  bool _saveFailed = false;
  int _knowledgeGain = 0;

  SignDuelQuestion get _question => signDuelQuestions[_index];

  @override
  void initState() {
    super.initState();
    _limit = switch (widget.controller.profile?.type ?? PlayerType.child) {
      PlayerType.child => 20,
      PlayerType.teen => 15,
      PlayerType.adult => 10,
    };
    _remaining = _limit;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.isCurrentOf(context) ?? true);
    _syncTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _syncTimer();
  }

  void _syncTimer() {
    if (!_visible || !_foreground || _resolved || _finished || _saving) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    if (_timer != null) {
      return;
    }
    _lastTick = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() {
        _remaining -= timer.tick - _lastTick;
        _lastTick = timer.tick;
        if (_remaining <= 0) {
          _remaining = 0;
          _resolved = true;
          _timedOut = true;
          // An unconfirmed choice never earns points.
          _selectedIndex = null;
        }
      });
      _syncTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _select(int index) {
    if (_resolved || _finished || _saving) {
      return;
    }
    setState(() => _selectedIndex = index);
  }

  void _confirm() {
    if (_resolved || _selectedIndex == null || _remaining <= 0) {
      return;
    }
    setState(() {
      _resolved = true;
      if (_selectedIndex == _question.correctIndex) {
        _score += 100;
        _correct++;
      }
    });
    _syncTimer();
  }

  Future<void> _continue() async {
    if (!_resolved || _saving || _saveFailed || _finished) {
      return;
    }
    if (_index < signDuelQuestions.length - 1) {
      setState(() {
        _index++;
        _selectedIndex = null;
        _resolved = false;
        _timedOut = false;
        _remaining = _limit;
      });
      _syncTimer();
      return;
    }
    setState(() => _saving = true);
    _syncTimer();
    try {
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
    } catch (_) {
      if (!mounted) {
        return;
      }
      // The existing controller updates memory before saving. Do not submit
      // this result twice after a storage failure.
      setState(() {
        _saving = false;
        _saveFailed = true;
      });
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _score = 0;
      _correct = 0;
      _selectedIndex = null;
      _resolved = false;
      _timedOut = false;
      _finished = false;
      _saveFailed = false;
      _knowledgeGain = 0;
      _remaining = _limit;
    });
    _syncTimer();
  }

  Widget _at(double x, double y, double w, double h, Widget child) =>
      Positioned(left: x, top: y, width: w, height: h, child: child);

  Widget _text(
    String value, {
    double size = 34,
    Color color = duelInk,
    Key? textKey,
    int? lines,
    TextAlign align = TextAlign.center,
  }) => Zone1ArtText(
    value,
    fontSize: size,
    color: color,
    textKey: textKey,
    maxLines: lines,
    align: align,
  );

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: ApprovedArtworkPage(
      asset: duelArtwork,
      size: const Size(1672, 941),
      prefix: 'duel',
      description: 'Duelo das Placas com Melo em uma rua de Fortaleza',
      actions: [
        _at(
          130,
          88,
          105,
          82,
          DuelButton(
            key: const Key('duel-back'),
            label: 'Voltar ao mapa',
            icon: Icons.arrow_back_rounded,
            onPressed: _saving ? null : () => Navigator.of(context).maybePop(),
          ),
        ),
        _at(
          260,
          90,
          755,
          80,
          _text('DUELO DAS PLACAS', size: 64, color: Colors.white, lines: 1),
        ),
        _at(
          1040,
          99,
          310,
          65,
          DuelPanel(
            color: duelInk,
            child: Row(
              children: [
                Expanded(
                  child: _text(
                    'Rodada ${_index + 1} de ${signDuelQuestions.length}',
                    size: 25,
                    color: Colors.white,
                    lines: 1,
                  ),
                ),
                const VerticalDivider(color: Colors.white54),
                Expanded(
                  child: _text(
                    'Pontos: $_score',
                    size: 26,
                    color: Colors.yellow,
                    lines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        _at(
          1380,
          88,
          195,
          85,
          DuelPanel(
            color: duelInk,
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white, size: 45),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _text('TEMPO', size: 19, color: Colors.white),
                      ),
                      Expanded(
                        flex: 2,
                        child: _text(
                          '00:${_remaining.toString().padLeft(2, '0')}',
                          size: 42,
                          color: _remaining <= 5
                              ? const Color(0xFFFFD54F)
                              : Colors.white,
                          textKey: const Key('duel-timer'),
                          lines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_finished) ..._result() else ..._round(),
      ],
    ),
  );

  List<Widget> _round() => [
    _at(
      505,
      305,
      360,
      360,
      DuelSign(key: Key('duel-sign-${_question.code}'), code: _question.code),
    ),
    _at(585, 700, 190, 48, _text(_question.code, size: 28, lines: 1)),
    _at(
      590,
      780,
      190,
      12,
      LinearProgressIndicator(
        key: const Key('duel-progress'),
        value: (_index + 1) / signDuelQuestions.length,
        color: const Color(0xFF0057B8),
        backgroundColor: const Color(0xFFD0E8FF),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    if (_resolved)
      ..._feedback()
    else ...[
      _at(
        910,
        245,
        585,
        120,
        _text(
          _question.prompt,
          size: 38,
          textKey: const Key('duel-question-card'),
        ),
      ),
      for (var i = 0; i < _question.options.length; i++)
        _at(
          910,
          380 + i * 110,
          585,
          96,
          DuelButton(
            key: Key('duel-option-$i'),
            label: _question.options[i],
            prefix: String.fromCharCode(65 + i),
            selected: _selectedIndex == i,
            light: _selectedIndex != i,
            fontSize: 31,
            onPressed: () => _select(i),
          ),
        ),
      _at(
        910,
        738,
        585,
        94,
        DuelButton(
          key: const Key('duel-confirm'),
          label: 'CONFIRMAR',
          green: true,
          fontSize: 46,
          onPressed: _selectedIndex == null ? null : _confirm,
        ),
      ),
      _at(
        915,
        842,
        575,
        38,
        _text('Escolha uma resposta e confirme.', size: 26),
      ),
    ],
  ];

  List<Widget> _feedback() {
    final correct = !_timedOut && _selectedIndex == _question.correctIndex;
    return [
      _at(
        910,
        250,
        585,
        70,
        _text(
          _timedOut
              ? 'Tempo esgotado'
              : correct
              ? 'Boa decisao!'
              : 'Observe esta regra',
          size: 43,
          textKey: const Key('duel-feedback'),
        ),
      ),
      _at(
        910,
        340,
        585,
        135,
        DuelPanel(
          child: _text(
            'Resposta correta:\n${_question.options[_question.correctIndex]}',
            size: 32,
            textKey: const Key('duel-correct-answer'),
          ),
        ),
      ),
      _at(910, 492, 585, 56, _text('MELO EXPLICA', size: 34)),
      _at(
        910,
        555,
        585,
        165,
        _text(_question.explanation, size: 32, align: TextAlign.left),
      ),
      if (_saveFailed)
        _at(
          910,
          730,
          585,
          140,
          _text(
            'Não foi possível confirmar o salvamento. Volte ao mapa e confira seu progresso.',
            size: 30,
            textKey: const Key('duel-save-error'),
          ),
        )
      else
        _at(
          910,
          750,
          585,
          95,
          DuelButton(
            key: const Key('duel-continue'),
            label: _saving
                ? 'SALVANDO...'
                : _index == signDuelQuestions.length - 1
                ? 'VER RESULTADO'
                : 'PROXIMA PLACA',
            green: true,
            fontSize: 40,
            onPressed: _saving ? null : _continue,
          ),
        ),
    ];
  }

  List<Widget> _result() {
    final progress = widget.controller.progress;
    return [
      _at(
        560,
        285,
        280,
        300,
        const Icon(
          Icons.emoji_events_rounded,
          size: 250,
          color: Color(0xFFFFB900),
        ),
      ),
      _at(900, 245, 595, 70, _text('Duelo concluido', size: 48)),
      _at(
        900,
        330,
        595,
        65,
        _text(
          '$_correct de ${signDuelQuestions.length} respostas corretas',
          size: 36,
          textKey: const Key('duel-final-correct'),
        ),
      ),
      _at(
        900,
        405,
        595,
        60,
        _text(
          'Pontuacao: $_score',
          size: 40,
          textKey: const Key('duel-final-score'),
        ),
      ),
      _at(
        900,
        480,
        595,
        90,
        _text(
          _knowledgeGain > 0
              ? '+$_knowledgeGain Conhecimento por novo recorde'
              : 'Seu melhor desempenho foi preservado.',
          size: 32,
          textKey: Key(
            _knowledgeGain > 0
                ? 'duel-knowledge-gain'
                : 'duel-no-new-knowledge',
          ),
        ),
      ),
      _at(
        900,
        585,
        595,
        85,
        _text(
          'Recorde: ${progress.signDuelBestScore}  •  Melhor: ${progress.signDuelBestCorrect}/6\nDuelos: ${progress.signDuelPlays}',
          size: 29,
        ),
      ),
      _at(
        910,
        690,
        585,
        85,
        DuelButton(
          key: const Key('duel-restart'),
          label: 'JOGAR NOVAMENTE',
          green: true,
          fontSize: 36,
          onPressed: _restart,
        ),
      ),
      _at(
        910,
        790,
        585,
        80,
        DuelButton(
          label: 'VOLTAR AO MAPA',
          fontSize: 34,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
    ];
  }
}
