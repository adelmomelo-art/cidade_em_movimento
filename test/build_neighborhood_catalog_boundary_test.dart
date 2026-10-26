import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo oficial possui 30 e expandido inclui Construa o Bairro', () {
    expect(upgradeCatalog.length, 30);
    expect(allUpgradeCatalog.length, 33);

    expect(
      upgradeCatalog.any((item) => item.zoneId == 'BUILD_NEIGHBORHOOD'),
      isFalse,
    );

    expect(
      allUpgradeCatalog.any((item) => item.id == 'BAIRRO_CALCADA_ACESSIVEL'),
      isTrue,
    );
    expect(
      allUpgradeCatalog.any((item) => item.id == 'BAIRRO_PRACA_CONVIVENCIA'),
      isTrue,
    );
    expect(
      allUpgradeCatalog.any((item) => item.id == 'BAIRRO_BICICLETARIO'),
      isTrue,
    );
  });
}
