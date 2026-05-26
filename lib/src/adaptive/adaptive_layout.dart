import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// A widget that renders different layouts based on the available screen width.
///
/// Uses [FlavorBreakpoints] to determine which layout to display.
/// Falls back to [compact] when no more specific layout is provided.
///
/// ```dart
/// AdaptiveLayout(
///   compact: const MobileView(),
///   medium: const TabletView(),
///   expanded: const DesktopView(),
/// )
/// ```
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    required this.compact,
    super.key,
    this.medium,
    this.expanded,
    this.large,
  });

  /// Widget displayed on compact (mobile) screens.
  final Widget compact;

  /// Widget displayed on medium (tablet) screens. Falls back to [compact].
  final Widget? medium;

  /// Widget displayed on expanded screens. Falls back to [medium] or [compact].
  final Widget? expanded;

  /// Widget displayed on large screens. Falls back to [expanded], [medium], or [compact].
  final Widget? large;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = FlavorBreakpoints.of(constraints.maxWidth);
        return switch (size) {
          ScreenSize.large => large ?? expanded ?? medium ?? compact,
          ScreenSize.expanded => expanded ?? medium ?? compact,
          ScreenSize.medium => medium ?? compact,
          ScreenSize.compact => compact,
        };
      },
    );
  }
}
