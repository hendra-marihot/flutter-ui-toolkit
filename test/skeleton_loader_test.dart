import 'package:flutter/material.dart';
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('SkeletonLoader', () {
    testWidgets('renders default itemCount children', (tester) async {
      await tester.pumpWidget(buildApp(const SkeletonLoader()));

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders specified itemCount children', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SkeletonLoader(
            itemCount: 3,
            itemBuilder: (context, index) =>
                SizedBox(key: ValueKey('skeleton_$index'), height: 30),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('skeleton_0')), findsOneWidget);
      expect(find.byKey(const ValueKey('skeleton_1')), findsOneWidget);
      expect(find.byKey(const ValueKey('skeleton_2')), findsOneWidget);
    });

    testWidgets('accepts a custom itemBuilder', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SkeletonLoader(
            itemCount: 2,
            itemBuilder: (context, index) =>
                Container(key: ValueKey(index), height: 30),
          ),
        ),
      );

      expect(find.byKey(const ValueKey(0)), findsOneWidget);
      expect(find.byKey(const ValueKey(1)), findsOneWidget);
    });

    testWidgets('default item uses theme surfaceContainerHighest color', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(const SkeletonLoader(itemCount: 1)));

      final theme = Theme.of(tester.element(find.byType(SkeletonLoader)));
      final expectedColor = theme.colorScheme.surfaceContainerHighest;

      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => c.decoration != null)
          .toList();

      expect(containers, isNotEmpty);
      for (final container in containers) {
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, expectedColor);
      }
    });

    testWidgets('wraps content in ShimmerContainer', (tester) async {
      await tester.pumpWidget(buildApp(const SkeletonLoader()));

      expect(find.byType(ShimmerContainer), findsOneWidget);
    });
  });
}
