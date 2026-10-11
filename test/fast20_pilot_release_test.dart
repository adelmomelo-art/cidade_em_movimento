import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FAST-20 possui configuracao oficial do piloto Fortaleza', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final webManifest = File('web/manifest.json').readAsStringSync();
    final mainSource = File('lib/main.dart').readAsStringSync();

    expect(pubspec, contains('version: 1.0.0+3'));
    expect(
      gradle,
      contains('applicationId = "br.com.flybuddies.cidadeemmovimento"'),
    );
    expect(
      gradle,
      contains('signingConfig = signingConfigs.getByName("debug")'),
    );
    expect(manifest, contains('android:label="Cidade em Movimento"'));
    expect(webManifest, contains('"name": "Cidade em Movimento"'));
    expect(
      mainSource,
      contains("defaultValue: ''"),
      reason: 'Backends devem continuar opcionais no piloto offline-first.',
    );
  });
}
