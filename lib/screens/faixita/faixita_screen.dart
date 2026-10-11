import 'package:flutter/material.dart';

import '../../controllers/player_controller.dart';
import '../../models/faixita_response.dart';
import '../../models/mission_result.dart';
import '../../services/faixita_service.dart';

class FaixitaScreen extends StatefulWidget {
  const FaixitaScreen({
    super.key,
    required this.controller,
    required this.service,
    this.missionResult,
  });

  final PlayerController controller;
  final FaixitaService service;
  final MissionResult? missionResult;

  @override
  State<FaixitaScreen> createState() => _FaixitaScreenState();
}

class _FaixitaScreenState extends State<FaixitaScreen> {
  final _questionController = TextEditingController();
  final _messages = <_FaixitaMessage>[];
  bool _sending = false;

  static const _quickQuestions = <String>[
    'O que devo estudar agora?',
    'Como melhorar meu desempenho?',
    'Explique minhas estrelas.',
    'Como estou no Duelo das Placas?',
  ];

  @override
  void initState() {
    super.initState();

    _messages.add(
      const _FaixitaMessage(
        text:
            'Oi! Eu sou a Faixita. Posso ajudar voce a entender seu progresso, '
            'revisar missoes e aprender mais sobre seguranca no transito.',
        fromFaixita: true,
        source: FaixitaResponseSource.local,
      ),
    );

    if (widget.missionResult != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _ask('Como posso melhorar meu resultado nesta missao?');
      });
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _ask(String question) async {
    final profile = widget.controller.profile;
    final trimmed = question.trim();

    if (profile == null || trimmed.isEmpty || _sending) {
      return;
    }

    setState(() {
      _sending = true;
      _messages.add(
        _FaixitaMessage(
          text: trimmed,
          fromFaixita: false,
          source: FaixitaResponseSource.local,
        ),
      );
    });

    _questionController.clear();

    final response = await widget.service.ask(
      question: trimmed,
      profile: profile,
      progress: widget.controller.progress,
      missionResult: widget.missionResult,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _sending = false;
      _messages.add(
        _FaixitaMessage(
          text: response.text,
          fromFaixita: true,
          source: response.source,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faixita'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Chip(
                key: const Key('faixita-mode'),
                avatar: Icon(
                  widget.service.remoteConfigured
                      ? Icons.cloud_done_rounded
                      : Icons.offline_bolt_rounded,
                  size: 18,
                ),
                label: Text(
                  widget.service.remoteConfigured
                      ? 'IA conectada'
                      : 'Modo local',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                key: const Key('faixita-messages'),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                children: [
                  _MentorHeader(
                    remoteConfigured: widget.service.remoteConfigured,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final question in _quickQuestions)
                        ActionChip(
                          label: Text(question),
                          onPressed: _sending ? null : () => _ask(question),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (final message in _messages)
                    _MessageBubble(message: message),
                  if (_sending)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('faixita-question'),
                      controller: _questionController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sending ? null : _ask,
                      decoration: const InputDecoration(
                        labelText: 'Pergunte a Faixita',
                        hintText: 'Ex.: O que devo revisar?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    key: const Key('faixita-send'),
                    tooltip: 'Enviar',
                    onPressed: _sending
                        ? null
                        : () => _ask(_questionController.text),
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MentorHeader extends StatelessWidget {
  const _MentorHeader({required this.remoteConfigured});

  final bool remoteConfigured;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('faixita-header'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 28,
              child: Icon(Icons.support_agent_rounded, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Faixita - Mentora Pedagogica',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    remoteConfigured
                        ? 'Respostas com IA remota e fallback local seguro.'
                        : 'Funciona offline com orientacoes pedagogicas locais.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _FaixitaMessage message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Align(
      alignment: message.fromFaixita
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        key: message.fromFaixita ? const Key('faixita-answer') : null,
        constraints: const BoxConstraints(maxWidth: 620),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: message.fromFaixita
              ? scheme.secondaryContainer
              : scheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.text),
            if (message.fromFaixita) ...[
              const SizedBox(height: 7),
              Text(
                message.source == FaixitaResponseSource.remote
                    ? 'Fonte: IA conectada'
                    : 'Fonte: orientacao local',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FaixitaMessage {
  const _FaixitaMessage({
    required this.text,
    required this.fromFaixita,
    required this.source,
  });

  final String text;
  final bool fromFaixita;
  final FaixitaResponseSource source;
}
