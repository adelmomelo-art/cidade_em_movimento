import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android usa identidade estavel do piloto', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final activity = File(
      'android/app/src/main/kotlin/br/com/flybuddies/cidadeemmovimento/MainActivity.kt',
    );

    expect(
      gradle,
      contains('namespace = "br.com.flybuddies.cidadeemmovimento"'),
    );
    expect(
      gradle,
      contains('applicationId = "br.com.flybuddies.cidadeemmovimento"'),
    );
    expect(manifest, contains('android:label="Cidade em Movimento"'));
    expect(activity.existsSync(), isTrue);
    expect(
      activity.readAsStringSync(),
      contains('package br.com.flybuddies.cidadeemmovimento'),
    );
  });

  test('versao do piloto esta fixada em 1.0.0+3', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('version: 1.0.0+3'));
  });
}
