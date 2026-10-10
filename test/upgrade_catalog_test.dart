import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo generico contem as doze melhorias oficiais', () {
    expect(upgradeCatalog.length, 12);
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
      'TRAVESSIA_EVENTO_SEGURA',
      'SINALIZACAO_TEMPORARIA',
      'EMBARQUE_EVENTO_ORGANIZADO',
    });
  });

  test('Zona 1 preserva tres melhorias e custo total 220', () {
    final upgrades = upgradesForZone('ZONE_1');
    expect(upgrades.length, 3);
    expect(upgrades.fold<int>(0, (sum, item) => sum + item.cost), 220);
  });

  test('Zona 2 possui tres melhorias e custo total 240', () {
    final upgrades = upgradesForZone('ZONE_2');
    expect(upgrades.length, 3);
    expect(upgrades.fold<int>(0, (sum, item) => sum + item.cost), 240);
  });

  test('Zona 3 possui tres melhorias e custo total 240', () {
    final upgrades = upgradesForZone('ZONE_3');
    expect(upgrades.length, 3);
    expect(upgrades.fold<int>(0, (sum, item) => sum + item.cost), 240);
  });

  test('Zona 4 possui tres melhorias e custo total 240', () {
    final upgrades = upgradesForZone('ZONE_4');
    expect(upgrades.length, 3);
    expect(upgrades.fold<int>(0, (sum, item) => sum + item.cost), 240);
  });

  test('busca generica localiza melhorias por id', () {
    expect(findUpgradeById('FAIXA_SEGURA')?.cost, 50);
    expect(findUpgradeById('TRAVESSIA_ACESSIVEL')?.cost, 60);
    expect(findUpgradeById('TRAVESSIA_ORLA_SEGURA')?.cost, 60);
    expect(findUpgradeById('TRAVESSIA_EVENTO_SEGURA')?.cost, 60);
    expect(findUpgradeById('SINALIZACAO_TEMPORARIA')?.cost, 80);
    expect(findUpgradeById('EMBARQUE_EVENTO_ORGANIZADO')?.cost, 100);
    expect(findUpgradeById('MELHORIA_INEXISTENTE'), isNull);
  });
}
