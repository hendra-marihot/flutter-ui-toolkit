import 'package:flutter/material.dart';
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveLayout', () {
    testWidgets('shows compact widget on small screens', (tester) async {
      // Set the test viewport to a compact width (400 logical px).
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdaptiveLayout(
            compact: Text('compact'),
            medium: Text('medium'),
            expanded: Text('expanded'),
          ),
        ),
      );
      expect(find.text('compact'), findsOneWidget);
    });

    testWidgets('shows medium widget on medium screens', (tester) async {
      tester.view.physicalSize = const Size(700, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdaptiveLayout(
            compact: Text('compact'),
            medium: Text('medium'),
            expanded: Text('expanded'),
          ),
        ),
      );
      expect(find.text('medium'), findsOneWidget);
    });

    testWidgets('falls back to compact when medium is absent', (tester) async {
      tester.view.physicalSize = const Size(700, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: AdaptiveLayout(compact: Text('compact'))),
      );
      expect(find.text('compact'), findsOneWidget);
    });

    testWidgets('shows large widget on large screens', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdaptiveLayout(
            compact: Text('compact'),
            medium: Text('medium'),
            expanded: Text('expanded'),
            large: Text('large'),
          ),
        ),
      );
      expect(find.text('large'), findsOneWidget);
    });
  });

  group('FlavorBreakpoints', () {
    test('width below 600 is compact', () {
      expect(FlavorBreakpoints.of(599), ScreenSize.compact);
    });

    test('width exactly 600 is medium', () {
      expect(FlavorBreakpoints.of(600), ScreenSize.medium);
    });

    test('width below 840 is medium', () {
      expect(FlavorBreakpoints.of(700), ScreenSize.medium);
    });

    test('width exactly 840 is expanded', () {
      expect(FlavorBreakpoints.of(840), ScreenSize.expanded);
    });

    test('width at 1200 is large', () {
      expect(FlavorBreakpoints.of(1200), ScreenSize.large);
    });
  });
}
