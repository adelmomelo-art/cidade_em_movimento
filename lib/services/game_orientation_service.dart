import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<void> configureGameOrientation() async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    return;
  }
  // Android may decline the request on large displays. The viewport gate
  // still applies, using the actual dimensions delivered by the platform.
  try {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } on PlatformException {
    // Keep startup available; GameOrientationGate handles the viewport.
  }
}
