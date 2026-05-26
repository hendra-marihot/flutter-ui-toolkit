import 'package:flutter/material.dart';

/// A centered error-state widget with an icon, message, and optional retry button.
///
/// ```dart
/// ErrorState(
///   message: 'Failed to load data. Please check your connection.',
///   onRetry: () => fetchData(),
/// )
/// ```
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message,
    super.key,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.icon,
  });

  /// Error message to display.
  final String message;

  /// Callback invoked when the retry button is pressed. Hides button when null.
  final VoidCallback? onRetry;

  /// Label for the retry button. Defaults to 'Retry'.
  final String retryLabel;

  /// Icon to display. Defaults to [Icons.error_outline].
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
