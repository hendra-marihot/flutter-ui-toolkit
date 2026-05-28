import 'package:flutter/material.dart';

/// A [FilledButton] that manages its own loading state while an async operation runs.
///
/// Disables the button and shows [loadingChild] (or a [CircularProgressIndicator])
/// while [onPressed] is awaited. Safe against widget disposal mid-flight.
///
/// ```dart
/// AsyncButton(
///   onPressed: () async {
///     await submitForm();
///   },
///   child: const Text('Submit'),
/// )
/// ```
class AsyncButton extends StatefulWidget {
  const AsyncButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.loadingChild,
    this.style,
    this.onError,
  });

  /// Async callback invoked when the button is pressed.
  final Future<void> Function() onPressed;

  /// Button label shown in idle state.
  final Widget child;

  /// Widget shown while [onPressed] is pending. Defaults to a small
  /// [CircularProgressIndicator].
  final Widget? loadingChild;

  /// Optional [ButtonStyle] passed to the underlying [FilledButton].
  final ButtonStyle? style;

  /// Called when [onPressed] throws. Receives the error and stack trace.
  final void Function(Object error, StackTrace stackTrace)? onError;

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await widget.onPressed();
    } catch (error, stackTrace) {
      if (widget.onError != null) {
        widget.onError!.call(error, stackTrace);
      } else {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'flutter_flavor_ui',
            context: ErrorDescription('while handling AsyncButton press'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: _isLoading ? null : _handlePress,
      style: widget.style,
      child: _isLoading
          ? widget.loadingChild ??
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
          : widget.child,
    );
  }
}
