import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('AsyncButton', () {
    testWidgets('shows child in idle state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AsyncButton(onPressed: () async {}, child: const Text('Submit')),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows loading indicator while pressed', (tester) async {
      final completer = Completer<void>();
      await tester.pumpWidget(
        buildApp(
          AsyncButton(
            onPressed: () => completer.future,
            child: const Text('Submit'),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);

      completer.complete();
      await tester.pumpAndSettle();

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows custom loadingChild', (tester) async {
      final completer = Completer<void>();
      await tester.pumpWidget(
        buildApp(
          AsyncButton(
            onPressed: () => completer.future,
            loadingChild: const Text('Loading...'),
            child: const Text('Submit'),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.text('Loading...'), findsOneWidget);

      completer.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('re-enables after future completes', (tester) async {
      final completer = Completer<void>();
      await tester.pumpWidget(
        buildApp(
          AsyncButton(
            onPressed: () => completer.future,
            child: const Text('Submit'),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);

      completer.complete();
      await tester.pumpAndSettle();

      final enabledButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(enabledButton.onPressed, isNotNull);
    });

    testWidgets('does not throw if widget is disposed mid-flight', (
      tester,
    ) async {
      final completer = Completer<void>();
      await tester.pumpWidget(
        buildApp(
          AsyncButton(
            onPressed: () => completer.future,
            child: const Text('Submit'),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      await tester.pumpWidget(buildApp(const SizedBox()));

      completer.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('ignores taps while loading', (tester) async {
      var callCount = 0;
      final completer = Completer<void>();
      await tester.pumpWidget(
        buildApp(
          AsyncButton(
            onPressed: () {
              callCount++;
              return completer.future;
            },
            child: const Text('Submit'),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(callCount, 1);

      completer.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('calls onError when onPressed throws', (tester) async {
      Object? caughtError;
      StackTrace? caughtStack;

      await tester.pumpWidget(
        buildApp(
          AsyncButton(
            onPressed: () async => throw StateError('fail'),
            onError: (error, stackTrace) {
              caughtError = error;
              caughtStack = stackTrace;
            },
            child: const Text('Submit'),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(caughtError, isA<StateError>());
      expect(caughtStack, isNotNull);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('reports error via FlutterError when onError is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AsyncButton(
            onPressed: () async => throw StateError('fail'),
            child: const Text('Submit'),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      final exception = tester.takeException();
      expect(exception, isA<StateError>());
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('surfaces onError even when disposed mid-flight', (
      tester,
    ) async {
      Object? caughtError;
      final completer = Completer<void>();

      await tester.pumpWidget(
        buildApp(
          AsyncButton(
            onPressed: () => completer.future,
            onError: (error, _) => caughtError = error,
            child: const Text('Submit'),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      await tester.pumpWidget(buildApp(const SizedBox()));
      completer.completeError(StateError('fail'));
      await tester.pumpAndSettle();

      expect(caughtError, isA<StateError>());
    });
  });
}
