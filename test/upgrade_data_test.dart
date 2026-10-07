import 'package:cidade_em_movimento/data/zone_1/upgrade_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo possui somente as tres melhorias aprovadas', () {
    expect(zone1Upgrades.length, 3);

    expect(zone1Upgrades.map((upgrade) => upgrade.id).toSet(), {
      'FAIXA_SEGURA',
      'ILUMINACAO_ESCOLAR',
      'TRECHO_CICLOVIARIO',
    });
  });

  test('custos oficiais das melhorias sao preservados', () {
    final costs = {
      for (final upgrade in zone1Upgrades) upgrade.id: upgrade.cost,
    };

    expect(costs['FAIXA_SEGURA'], 50);
    expect(costs['ILUMINACAO_ESCOLAR'], 70);
    expect(costs['TRECHO_CICLOVIARIO'], 100);
  });
}
