import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo generico contem dezoito melhorias oficiais', () {
    expect(upgradeCatalog.length, 18);
  });
  for (final row in <(String, int)>[
    ('ZONE_1', 220),
    ('ZONE_2', 240),
    ('ZONE_3', 240),
    ('ZONE_4', 240),
    ('ZONE_5', 240),
    ('ZONE_6', 240),
  ]) {
    test('${row.$1} possui tres melhorias e custo esperado', () {
      final u = upgradesForZone(row.$1);
      expect(u.length, 3);
      expect(u.fold<int>(0, (s, x) => s + x.cost), row.$2);
    });
  }
  test('busca generica localiza melhorias Zona 6', () {
    expect(findUpgradeById('CORREDOR_PEDESTRE_CASTELAO')?.cost, 60);
    expect(findUpgradeById('ILUMINACAO_ENTORNO_CASTELAO')?.cost, 80);
    expect(findUpgradeById('EMBARQUE_INTEGRADO_CASTELAO')?.cost, 100);
  });
}
