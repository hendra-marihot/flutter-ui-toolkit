// Smoke test: ensure the barrel export compiles correctly.
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('barrel export is importable', () {
    // If this file compiles the barrel export is working correctly.
    expect(ScreenSize.values, isNotEmpty);
  });
}
