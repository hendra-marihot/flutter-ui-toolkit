import 'package:flutter/material.dart';

/// An enhanced [RefreshIndicator] wrapper with Material 3 theming defaults
/// and convenience parameters for common pull-to-refresh patterns.
///
/// ```dart
/// PullToRefresh(
///   onRefresh: () async => fetchData(),
///   child: ListView.builder(...),
/// )
/// ```
class PullToRefresh extends StatelessWidget {
  const PullToRefresh({
    required this.onRefresh,
    required this.child,
    super.key,
    this.color,
    this.backgroundColor,
    this.displacement = 40.0,
    this.strokeWidth = 2.5,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.canRefresh = true,
  });

  /// Called when the user pulls down to refresh. Must return a [Future].
  final Future<void> Function() onRefresh;

  /// The scrollable content to wrap.
  final Widget child;

  /// Indicator foreground color. Defaults to [ColorScheme.primary].
  final Color? color;

  /// Indicator background color.
  final Color? backgroundColor;

  /// How far the indicator is displaced from the top. Defaults to 40.0.
  final double displacement;

  /// Width of the indicator's circular stroke.
  final double strokeWidth;

  /// Determines when the refresh gesture is triggered.
  final RefreshIndicatorTriggerMode triggerMode;

  /// Filter which [ScrollNotification]s trigger the refresh.
  final bool Function(ScrollNotification) notificationPredicate;

  /// When false, the pull gesture is suppressed entirely.
  final bool canRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color,
      backgroundColor: backgroundColor,
      displacement: displacement,
      strokeWidth: strokeWidth,
      triggerMode: triggerMode,
      notificationPredicate: canRefresh ? notificationPredicate : (_) => false,
      child: child,
    );
  }
}
