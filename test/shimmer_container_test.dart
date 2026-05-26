import 'package:flutter/material.dart';
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('ShimmerContainer', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const ShimmerContainer(child: SizedBox(width: 200, height: 20)),
        ),
      );

      expect(find.byType(ShimmerContainer), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('accepts baseColor and highlightColor overrides', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const ShimmerContainer(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: SizedBox(width: 200, height: 20),
          ),
        ),
      );

      expect(find.byType(ShimmerContainer), findsOneWidget);
    });

    testWidgets('uses ShaderMask for shimmer effect', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const ShimmerContainer(child: SizedBox(width: 200, height: 20)),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('accepts custom duration', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const ShimmerContainer(
            duration: Duration(milliseconds: 500),
            child: SizedBox(width: 200, height: 20),
          ),
        ),
      );

      expect(find.byType(ShimmerContainer), findsOneWidget);
    });
  });
}
