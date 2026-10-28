import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<({int width, int height, Uint8List pixels})> decode(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  try {
    final frame = await codec.getNextFrame();
    try {
      final data = await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (data == null) throw StateError('Decoder returned no pixels');
      return (
        width: frame.image.width,
        height: frame.image.height,
        pixels: data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } finally {
      frame.image.dispose();
    }
  } finally {
    codec.dispose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const backup = String.fromEnvironment('R46_ORIGINALS_BACKUP');
  final entries = (jsonDecode(File('test/support/r46_lossless_images.json').readAsStringSync()) as List)
      .cast<Map<String, dynamic>>();

  for (final entry in entries) {
    final before = entry['before'] as String;
    final after = entry['after'] as String;
    test('R46 decode dimensions: $after', () async {
      final data = await rootBundle.load(after);
      final image = await decode(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      expect(image.width, entry['width']);
      expect(image.height, entry['height']);
    });
    test('R46 Flutter pixels equal original: $after', () async {
      final original = File('$backup/$before');
      expect(original.existsSync(), isTrue, reason: 'Original PNG must be preserved in backup');
      final old = await decode(await original.readAsBytes());
      final data = await rootBundle.load(after);
      final current = await decode(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      expect(current.width, old.width);
      expect(current.height, old.height);
      expect(listEquals(current.pixels, old.pixels), isTrue,
        reason: 'Flutter-decoded premultiplied RGBA pixels must match');
    }, skip: backup.isEmpty ? 'Run with --dart-define=R46_ORIGINALS_BACKUP=<backup>' : false);
  }
}
