import 'package:flutter/material.dart';
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('EmptyState', () {
    testWidgets('shows title', (tester) async {
      await tester.pumpWidget(buildApp(const EmptyState(title: 'No items')));

      expect(find.text('No items'), findsOneWidget);
    });

    testWidgets('shows description when provided', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EmptyState(title: 'No items', description: 'Try adding some.'),
        ),
      );

      expect(find.text('Try adding some.'), findsOneWidget);
    });

    testWidgets('hides description when null', (tester) async {
      await tester.pumpWidget(buildApp(const EmptyState(title: 'No items')));

      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('No items'), findsOneWidget);
      final texts = tester.widgetList<Text>(find.byType(Text)).toList();
      expect(texts.length, 1);
    });

    testWidgets('shows default icon', (tester) async {
      await tester.pumpWidget(buildApp(const EmptyState(title: 'No items')));

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('shows custom icon', (tester) async {
      await tester.pumpWidget(
        buildApp(const EmptyState(title: 'No results', icon: Icons.search_off)),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('hides button when onAction is null', (tester) async {
      await tester.pumpWidget(
        buildApp(const EmptyState(title: 'No items', actionLabel: 'Add item')),
      );

      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('shows button and fires callback when onAction is provided', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        buildApp(
          EmptyState(
            title: 'No items',
            actionLabel: 'Add item',
            onAction: () => tapped = true,
          ),
        ),
      );

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Add item'), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      expect(tapped, isTrue);
    });
  });
}
