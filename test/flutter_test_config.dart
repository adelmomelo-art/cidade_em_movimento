import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

// Functional and pixel tests use the supported reduced-motion setting.
// Motion-specific tests explicitly opt in and advance bounded frames.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    binding.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
  });
  tearDown(() {
    binding.platformDispatcher.clearAccessibilityFeaturesTestValue();
  });
  await testMain();
}
