import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo generico contem trinta melhorias oficiais', () {
    expect(upgradeCatalog.length, 30);
  });
  for (final row in <(String, int)>[
    ('ZONE_1', 320),
    ('ZONE_2', 340),
    ('ZONE_3', 340),
    ('ZONE_4', 340),
    ('ZONE_5', 340),
    ('ZONE_6', 340),
  ]) {
    test('${row.$1} possui cinco melhorias e custo esperado', () {
      final u = upgradesForZone(row.$1);
      expect(u.length, 5);
      expect(u.fold<int>(0, (s, x) => s + x.cost), row.$2);
    });
  }
  test('busca generica localiza melhorias Zona 6', () {
    expect(findUpgradeById('CORREDOR_PEDESTRE_CASTELAO')?.cost, 60);
    expect(findUpgradeById('ILUMINACAO_ENTORNO_CASTELAO')?.cost, 80);
    expect(findUpgradeById('EMBARQUE_INTEGRADO_CASTELAO')?.cost, 100);
  });
}
