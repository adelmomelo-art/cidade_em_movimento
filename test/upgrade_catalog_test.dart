import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo generico contem quinze melhorias oficiais', () {
    expect(upgradeCatalog.length, 15);
    expect(
      upgradeCatalog.map((u) => u.id).toSet(),
      containsAll(<String>{
        'FAIXA_SEGURA',
        'ILUMINACAO_ESCOLAR',
        'TRECHO_CICLOVIARIO',
        'TRAVESSIA_ACESSIVEL',
        'PONTO_SEGURO',
        'ROTA_COMPARTILHADA',
        'TRAVESSIA_ORLA_SEGURA',
        'CICLOVIA_CONECTADA',
        'EMBARQUE_ORGANIZADO',
        'TRAVESSIA_EVENTO_SEGURA',
        'SINALIZACAO_TEMPORARIA',
        'EMBARQUE_EVENTO_ORGANIZADO',
        'TRAVESSIA_GRANDE_VIA',
        'ILUMINACAO_CORREDOR',
        'REFUGIO_PEDESTRE',
      }),
    );
  });

  for (final row in <(String, int)>[
    ('ZONE_1', 220),
    ('ZONE_2', 240),
    ('ZONE_3', 240),
    ('ZONE_4', 240),
    ('ZONE_5', 240),
  ]) {
    test('${row.$1} possui tres melhorias e custo esperado', () {
      final upgrades = upgradesForZone(row.$1);
      expect(upgrades.length, 3);
      expect(upgrades.fold<int>(0, (s, u) => s + u.cost), row.$2);
    });
  }

  test('busca generica localiza melhorias Zona 5', () {
    expect(findUpgradeById('TRAVESSIA_GRANDE_VIA')?.cost, 60);
    expect(findUpgradeById('ILUMINACAO_CORREDOR')?.cost, 80);
    expect(findUpgradeById('REFUGIO_PEDESTRE')?.cost, 100);
  });
}
