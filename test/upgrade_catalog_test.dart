import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo generico contem as nove melhorias oficiais', () {
    expect(upgradeCatalog.length, 9);
    expect(upgradeCatalog.map((upgrade) => upgrade.id).toSet(), {
      'FAIXA_SEGURA',
      'ILUMINACAO_ESCOLAR',
      'TRECHO_CICLOVIARIO',
      'TRAVESSIA_ACESSIVEL',
      'PONTO_SEGURO',
      'ROTA_COMPARTILHADA',
      'TRAVESSIA_ORLA_SEGURA',
      'CICLOVIA_CONECTADA',
      'EMBARQUE_ORGANIZADO',
    });
  });

  test('Zona 1 preserva tres melhorias e custo total 220', () {
    final upgrades = upgradesForZone('ZONE_1');

    expect(upgrades.length, 3);
    expect(upgrades.every((upgrade) => upgrade.zoneId == 'ZONE_1'), isTrue);
    expect(upgrades.fold<int>(0, (sum, item) => sum + item.cost), 220);
  });

  test('Zona 2 possui tres melhorias e custo total 240', () {
    final upgrades = upgradesForZone('ZONE_2');

    expect(upgrades.length, 3);
    expect(upgrades.every((upgrade) => upgrade.zoneId == 'ZONE_2'), isTrue);
    expect(upgrades.fold<int>(0, (sum, item) => sum + item.cost), 240);
  });

  test('Zona 3 possui tres melhorias e custo total 240', () {
    final upgrades = upgradesForZone('ZONE_3');

    expect(upgrades.length, 3);
    expect(upgrades.every((upgrade) => upgrade.zoneId == 'ZONE_3'), isTrue);
    expect(upgrades.fold<int>(0, (sum, item) => sum + item.cost), 240);
  });

  test('busca generica localiza melhorias por id', () {
    expect(findUpgradeById('FAIXA_SEGURA')?.cost, 50);

    expect(findUpgradeById('TRAVESSIA_ACESSIVEL')?.cost, 60);
    expect(findUpgradeById('PONTO_SEGURO')?.cost, 80);
    expect(findUpgradeById('ROTA_COMPARTILHADA')?.cost, 100);

    expect(findUpgradeById('TRAVESSIA_ORLA_SEGURA')?.cost, 60);
    expect(findUpgradeById('CICLOVIA_CONECTADA')?.cost, 80);
    expect(findUpgradeById('EMBARQUE_ORGANIZADO')?.cost, 100);

    expect(findUpgradeById('MELHORIA_INEXISTENTE'), isNull);
  });
}
