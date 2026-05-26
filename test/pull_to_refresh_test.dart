import 'package:flutter/material.dart';
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  Widget buildScrollableChild() {
    return ListView(
      children: List.generate(20, (i) => ListTile(title: Text('Item $i'))),
    );
  }

  group('PullToRefresh', () {
    testWidgets('wraps child in a RefreshIndicator', (tester) async {
      await tester.pumpWidget(
        buildApp(
          PullToRefresh(onRefresh: () async {}, child: buildScrollableChild()),
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        buildApp(
          PullToRefresh(onRefresh: () async {}, child: buildScrollableChild()),
        ),
      );

      expect(find.text('Item 0'), findsOneWidget);
    });

    testWidgets('keeps RefreshIndicator in tree when canRefresh is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          PullToRefresh(
            onRefresh: () async {},
            canRefresh: false,
            child: buildScrollableChild(),
          ),
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
    });

    testWidgets('suppresses refresh gesture when canRefresh is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          PullToRefresh(
            onRefresh: () async {},
            canRefresh: false,
            child: buildScrollableChild(),
          ),
        ),
      );

      final indicator = tester.widget<RefreshIndicator>(
        find.byType(RefreshIndicator),
      );
      // When canRefresh is false the widget replaces the predicate with one
      // that always returns false — it must not be the framework default.
      expect(
        indicator.notificationPredicate,
        isNot(equals(defaultScrollNotificationPredicate)),
      );
    });

    testWidgets('accepts custom color and backgroundColor', (tester) async {
      await tester.pumpWidget(
        buildApp(
          PullToRefresh(
            onRefresh: () async {},
            color: Colors.red,
            backgroundColor: Colors.blue,
            child: buildScrollableChild(),
          ),
        ),
      );

      final indicator = tester.widget<RefreshIndicator>(
        find.byType(RefreshIndicator),
      );
      expect(indicator.color, Colors.red);
      expect(indicator.backgroundColor, Colors.blue);
    });

    testWidgets('passes strokeWidth and triggerMode to RefreshIndicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          PullToRefresh(
            onRefresh: () async {},
            strokeWidth: 3.0,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            child: buildScrollableChild(),
          ),
        ),
      );

      final indicator = tester.widget<RefreshIndicator>(
        find.byType(RefreshIndicator),
      );
      expect(indicator.strokeWidth, 3.0);
      expect(indicator.triggerMode, RefreshIndicatorTriggerMode.anywhere);
    });
  });
}
