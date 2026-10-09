import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo generico contem somente as melhorias aprovadas', () {
    expect(upgradeCatalog.length, 3);
    expect(upgradeCatalog.map((upgrade) => upgrade.id).toSet(), {
      'FAIXA_SEGURA',
      'ILUMINACAO_ESCOLAR',
      'TRECHO_CICLOVIARIO',
    });
  });

  test('todas as melhorias atuais pertencem a Zona 1', () {
    final upgrades = upgradesForZone('ZONE_1');
    expect(upgrades.length, 3);
    expect(upgrades.every((upgrade) => upgrade.zoneId == 'ZONE_1'), isTrue);
    expect(upgradesForZone('ZONE_2'), isEmpty);
  });

  test('busca generica localiza melhoria por id', () {
    final faixa = findUpgradeById('FAIXA_SEGURA');
    expect(faixa, isNotNull);
    expect(faixa!.zoneId, 'ZONE_1');
    expect(faixa.cost, 50);
    expect(findUpgradeById('MELHORIA_INEXISTENTE'), isNull);
  });

  test('economia aprovada permanece 50 70 100', () {
    final costs = {
      for (final upgrade in upgradeCatalog) upgrade.id: upgrade.cost,
    };

    expect(costs['FAIXA_SEGURA'], 50);
    expect(costs['ILUMINACAO_ESCOLAR'], 70);
    expect(costs['TRECHO_CICLOVIARIO'], 100);
    expect(upgradeCatalog.fold<int>(0, (sum, item) => sum + item.cost), 220);
  });
}
