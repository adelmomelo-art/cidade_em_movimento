import 'package:flutter/material.dart';
import '../../controllers/player_controller.dart';
import '../../data/upgrades/upgrade_catalog.dart';
import '../../models/upgrade_definition.dart';
import '../../widgets/neighborhood_upgrade_layer.dart';
import '../../widgets/zone_1_construction_art.dart' show zone1InitialConstructionArt;
import '../../widgets/zone_2_approved_art.dart' show Zone2ArtText;

class BuildNeighborhoodScreen extends StatefulWidget {
  const BuildNeighborhoodScreen({
    super.key,
    required this.controller,
    this.initialZoneId = 'ZONE_1',
  });
  final PlayerController controller;
  final String initialZoneId;

  @override
  State<BuildNeighborhoodScreen> createState() =>
      _BuildNeighborhoodScreenState();
}

class _BuildNeighborhoodScreenState extends State<BuildNeighborhoodScreen> {
  static const _ink = Color(0xFF062565);
  static const _names = [
    'Escola',
    'Centro',
    'Orla',
    'Cultura e Eventos',
    'Grandes Vias',
    'Castelão',
    'Meu Bairro',
  ];
  static const _scenes = [
    'assets/zone_1/r29/cenario_bairro.webp',
    'assets/zone_2/r30/cenario_centro.webp',
    'assets/zone_3/r31/cenario_orla.webp',
    'assets/zone_4/r32/cenario_eventos.webp',
    'assets/zone_5/r33/cenario_grandes_vias.webp',
    'assets/zone_6/r34/cenario_castelao.webp',
    'assets/zone_1/r29/cenario_bairro.webp',
  ];
  late int _zone;
  int _selected = 0;
  bool _confirming = false;
  bool _busy = false;
  bool _night = false;
  String? _message;
  PlayerController get controller => widget.controller;
  String get _zoneId => _zone == 6 ? 'BUILD_NEIGHBORHOOD' : 'ZONE_${_zone + 1}';
  bool get _unlocked => _zone == 6 || controller.isZoneUnlocked(_zoneId);

  @override
  void initState() {
    super.initState();
    _zone = widget.initialZoneId == 'BUILD_NEIGHBORHOOD'
        ? 6
        : ((int.tryParse(widget.initialZoneId.split('_').last) ?? 1) - 1).clamp(
            0,
            5,
          );
  }

  void _changeZone(int value) {
    if (_busy) {
      return;
    }
    setState(() {
      _zone = value;
      _selected = 0;
      _confirming = false;
      _message = null;
    });
  }

  Future<void> _buy(UpgradeDefinition upgrade) async {
    if (_busy || !_unlocked) {
      return;
    }
    setState(() {
      _busy = true;
    });
    try {
      final ok = await controller.purchaseUpgrade(upgrade.id);
      if (!mounted) {
        return;
      }
      setState(() {
        _confirming = false;
        _message = ok
            ? 'Melo: ${upgrade.description}'
            : 'Compra não realizada. Confira o saldo e as melhorias construídas.';
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _message = 'Não foi possível salvar. Tente novamente.';
          _confirming = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Widget _text(String text, {double size = 30, Color color = _ink}) =>
      Zone2ArtText(text, fontSize: size, color: color);
  Widget _at(double x, double y, double w, double h, Widget child) =>
      Positioned(left: x, top: y, width: w, height: h, child: child);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      final items = upgradesForZone(_zoneId);
      final selected = items[_selected];
      final progress = controller.progress;
      final purchased = progress.purchasedUpgrades.contains(selected.id);
      final count = items
          .where((u) => progress.purchasedUpgrades.contains(u.id))
          .length;
      final missing = selected.cost - progress.coins;
      final complete = count == items.length;
      final guidance =
          _message ??
          (complete
              ? 'Melo: Parabéns! Você concluiu todas as melhorias deste bairro.'
              : selected.description);
      return Scaffold(
        backgroundColor: _ink,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              _zone == 0 ? zone1InitialConstructionArt : _scenes[_zone],
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
            const ColoredBox(color: Color(0x66062565)),
            SafeArea(
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: 1672,
                    height: 941,
                    child: Stack(
                      key: const Key('r43-board'),
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            _scenes[_zone],
                            fit: BoxFit.fill,
                            excludeFromSemantics: true,
                          ),
                        ),
                        if (_night)
                          const Positioned.fill(
                            child: ColoredBox(color: Color(0x88051C44)),
                          ),
                        Positioned.fill(
                          child: NeighborhoodUpgradeLayer(
                            zoneId: _zoneId,
                            purchased: progress.purchasedUpgrades,
                            previewId: purchased || !_unlocked
                                ? null
                                : selected.id,
                            night: _night,
                          ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Stack(children: [
                              Positioned.fill(child: ClipPath(
                                clipper: const _ConstructionFrameClipper(),
                                child: Image.asset(
                                  'assets/build_neighborhood/r43/moldura_melo.png',
                                  fit: BoxFit.fill,
                                  excludeFromSemantics: true,
                                ),
                              )),
                              Positioned(
                                left: 0, top: 735, width: 240, height: 206,
                                child: ClipRect(child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: SizedBox(width: 585, height: 501,
                                    child: Stack(children: [Positioned(
                                      left: 0, top: -440,
                                      width: 1672, height: 941,
                                      child: Image.asset(
                                        'assets/build_neighborhood/r43/moldura_melo.png',
                                        fit: BoxFit.fill,
                                        excludeFromSemantics: true,
                                      ),
                                    )]),
                                  ),
                                )),
                              ),
                            ]),
                          ),
                        ),
                        _at(
                          54,
                          30,
                          116,
                          100,
                          IconButton(
                            key: const Key('r43-back'),
                            tooltip: 'Voltar ao mapa',
                            onPressed: _busy
                                ? null
                                : () => Navigator.of(context).maybePop(),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        _at(
                          380,
                          30,
                          900,
                          67,
                          _text(
                            'CONSTRUA O BAIRRO',
                            size: 58,
                            color: Colors.white,
                          ),
                        ),
                        _at(
                          380,
                          99,
                          900,
                          35,
                          _text(
                            'Use suas moedas para melhorar a cidade.',
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                        _at(
                          1380,
                          41,
                          250,
                          70,
                          Row(
                            children: [
                              const Icon(
                                Icons.monetization_on_rounded,
                                color: Color(0xFFFFD54F),
                                size: 54,
                              ),
                              Expanded(
                                child: _text(
                                  '${progress.coins}',
                                  size: 49,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _at(
                          425,
                          159,
                          645,
                          67,
                          Container(
                            decoration: BoxDecoration(
                              color: _ink,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.cyanAccent,
                                width: 3,
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  key: const Key('r43-zone-previous'),
                                  tooltip: 'Zona anterior',
                                  onPressed: _zone > 0 && !_busy
                                      ? () => _changeZone(_zone - 1)
                                      : null,
                                  icon: const Icon(
                                    Icons.chevron_left,
                                    size: 38,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: _text(
                                    _zone == 6
                                        ? 'Meu Bairro • compras anteriores'
                                        : 'Zona ${_zone + 1} • ${_names[_zone]}',
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  key: const Key('r43-zone-next'),
                                  tooltip: 'Próxima zona',
                                  onPressed: _zone < 6 && !_busy
                                      ? () => _changeZone(_zone + 1)
                                      : null,
                                  icon: const Icon(
                                    Icons.chevron_right,
                                    size: 38,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _at(
                          620,
                          237,
                          450,
                          49,
                          Container(
                            color: _ink,
                            child: _text(
                              !_unlocked
                                  ? 'Conclua a zona anterior para construir'
                                  : purchased
                                  ? 'CONSTRUÍDO • $count/${items.length}'
                                  : 'PRÉVIA • selecione e confirme',
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        _at(
                          1118,
                          178,
                          520,
                          60,
                          _text('ESCOLHA UMA MELHORIA', size: 37),
                        ),
                        for (var i = 0; i < items.length; i++)
                          _at(
                            1124,
                            246 + i * 109,
                            514,
                            100,
                            _option(items[i], i),
                          ),
                        _at(
                          48,
                          180,
                          340,
                          160,
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xF0062565),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.cyanAccent,
                                width: 2,
                              ),
                            ),
                            child: _text(
                              guidance,
                              size: 27,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        _at(
                          606,
                          887,
                          450,
                          42,
                          _text(
                            _zone == 6
                                ? 'Compras anteriores preservadas'
                                : 'Conclusão da zona: +130 moedas, uma vez',
                            size: 23,
                            color: Colors.white,
                          ),
                        ),
                        _at(
                          48,
                          355,
                          245,
                          57,
                          TextButton.icon(
                            onPressed: () => setState(() => _night = !_night),
                            icon: Icon(
                              _night ? Icons.light_mode : Icons.dark_mode,
                              color: Colors.white,
                            ),
                            label: _text(
                              _night ? 'Ver de dia' : 'Ver à noite',
                              size: 23,
                              color: Colors.white,
                            ),
                            style: TextButton.styleFrom(backgroundColor: _ink),
                          ),
                        ),
                        _at(
                          1126,
                          805,
                          510,
                          39,
                          _text(
                            purchased
                                ? '$count/${items.length} melhorias construídas'
                                : !_unlocked
                                ? 'Zona bloqueada'
                                : missing > 0
                                ? 'Faltam $missing moedas. Continue as missões.'
                                : 'Custo: ${selected.cost} • saldo após: ${progress.coins - selected.cost}',
                            size: 24,
                          ),
                        ),
                        _at(
                          1126,
                          849,
                          510,
                          62,
                          FilledButton(
                            key: const Key('r43-build'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF009C25),
                              disabledBackgroundColor: const Color(0xFF7B8D9B),
                            ),
                            onPressed:
                                purchased || missing > 0 || !_unlocked || _busy
                                ? null
                                : () => setState(() => _confirming = true),
                            child: _text(
                              purchased
                                  ? 'CONSTRUÍDO'
                                  : 'CONSTRUIR • ${selected.cost}',
                              size: 34,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (_confirming)
                          Positioned.fill(
                            child: ColoredBox(
                              color: const Color(0xCC031633),
                              child: Center(
                                child: Container(
                                  width: 810,
                                  height: 405,
                                  padding: const EdgeInsets.all(28),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: Colors.cyan,
                                      width: 5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: _text(
                                          'Construir ${selected.title}?',
                                          size: 38,
                                        ),
                                      ),
                                      Expanded(
                                        child: _text(
                                          'Custo: ${selected.cost} moedas\nSaldo após a compra: ${progress.coins - selected.cost}',
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height: 76,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                key: const Key('r43-cancel'),
                                                onPressed: _busy
                                                    ? null
                                                    : () => setState(
                                                        () =>
                                                            _confirming = false,
                                                      ),
                                                child: _text(
                                                  'CANCELAR',
                                                  size: 28,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: FilledButton(
                                                key: const Key('r43-confirm'),
                                                onPressed: _busy
                                                    ? null
                                                    : () => _buy(selected),
                                                style: FilledButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF009C25,
                                                  ),
                                                ),
                                                child: _text(
                                                  _busy
                                                      ? 'SALVANDO...'
                                                      : 'CONFIRMAR',
                                                  size: 28,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  IconData _upgradeIcon(String id) {
    if (id.contains('ILUMINACAO')) {
      return Icons.lightbulb_rounded;
    }
    if (id.contains('BICICLETARIO') ||
        id.contains('CICLO') ||
        id.contains('COMPARTILHADA')) {
      return Icons.directions_bike_rounded;
    }
    if (id.contains('PONTO') || id.contains('EMBARQUE')) {
      return Icons.directions_bus_rounded;
    }
    if (id.contains('PRACA')) {
      return Icons.park_rounded;
    }
    if (id.contains('ACESS') || id.contains('CALCADA')) {
      return Icons.accessible_rounded;
    }
    if (id.contains('SINALIZACAO')) {
      return Icons.traffic_rounded;
    }
    return Icons.directions_walk_rounded;
  }

  Widget _option(UpgradeDefinition u, int index) {
    final built = controller.progress.purchasedUpgrades.contains(u.id);
    final active = index == _selected;
    return Semantics(
      selected: active,
      child: Material(
        color: active ? const Color(0xFF008DE5) : const Color(0xFFF5F8FC),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          key: Key('r43-select-${u.id}'),
          borderRadius: BorderRadius.circular(20),
          onTap: _busy
              ? null
              : () => setState(() {
                  _selected = index;
                  _confirming = false;
                  _message = null;
                }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: active ? Colors.cyanAccent : const Color(0xFFC8DEEF),
                width: 3,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  built ? Icons.check_circle_rounded : _upgradeIcon(u.id),
                  size: 45,
                  color: built
                      ? const Color(0xFF00B33C)
                      : active
                      ? Colors.white
                      : _ink,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _text(
                    u.title,
                    size: 29,
                    color: active ? Colors.white : _ink,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: _text(
                    built ? 'Construído' : '${u.cost}',
                    size: built ? 19 : 30,
                    color: active ? Colors.white : _ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConstructionFrameClipper extends CustomClipper<Path> {
  const _ConstructionFrameClipper();
  @override
  Path getClip(Size size) => Path()
    ..addRect(Rect.fromLTWH(0, 0, size.width, size.height * 160 / 941))
    ..addRect(Rect.fromLTWH(size.width * 1090 / 1672,
        size.height * 150 / 941, size.width * 582 / 1672,
        size.height * 791 / 941));
  @override
  bool shouldReclip(covariant _ConstructionFrameClipper oldClipper) => false;
}
