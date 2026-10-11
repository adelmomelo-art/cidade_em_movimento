import 'package:cidade_em_movimento/data/upgrades/upgrade_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalogo oficial preserva 18 e expandido inclui Construa o Bairro', () {
    expect(upgradeCatalog.length, 18);
    expect(allUpgradeCatalog.length, 21);

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
