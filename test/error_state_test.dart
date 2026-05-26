import 'package:flutter/material.dart';
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('ErrorState', () {
    testWidgets('shows message', (tester) async {
      await tester.pumpWidget(
        buildApp(const ErrorState(message: 'Something went wrong')),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('shows default icon', (tester) async {
      await tester.pumpWidget(buildApp(const ErrorState(message: 'Error')));

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows custom icon', (tester) async {
      await tester.pumpWidget(
        buildApp(const ErrorState(message: 'Offline', icon: Icons.wifi_off)),
      );

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('hides retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(buildApp(const ErrorState(message: 'Error')));

      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('fires onRetry callback when button is tapped', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        buildApp(
          ErrorState(message: 'Failed to load', onRetry: () => retried = true),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.byType(OutlinedButton));
      expect(retried, isTrue);
    });

    testWidgets('shows custom retry label', (tester) async {
      await tester.pumpWidget(
        buildApp(
          ErrorState(message: 'Error', retryLabel: 'Try again', onRetry: () {}),
        ),
      );

      expect(find.text('Try again'), findsOneWidget);
    });
  });
}
