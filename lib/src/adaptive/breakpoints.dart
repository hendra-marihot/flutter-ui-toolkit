/// Breakpoint definitions for responsive layouts.
abstract final class FlavorBreakpoints {
  /// Maximum width for compact (mobile) screens.
  static const double compact = 600;

  /// Maximum width for medium (tablet) screens.
  static const double medium = 840;

  /// Maximum width for expanded (large tablet/small desktop) screens.
  static const double expanded = 1200;

  /// Returns the [ScreenSize] for the given [width].
  static ScreenSize of(double width) {
    if (width < compact) return ScreenSize.compact;
    if (width < medium) return ScreenSize.medium;
    if (width < expanded) return ScreenSize.expanded;
    return ScreenSize.large;
  }
}

/// Represents the current breakpoint size category.
enum ScreenSize { compact, medium, expanded, large }
