import 'package:flutter/material.dart';

/// Wraps [child] with an animated shimmer loading effect.
///
/// Uses [MaterialTheme] colors by default, overridable via [baseColor]
/// and [highlightColor].
///
/// ```dart
/// ShimmerContainer(
///   child: Container(width: 200, height: 20, color: Colors.white),
/// )
/// ```
class ShimmerContainer extends StatefulWidget {
  const ShimmerContainer({
    required this.child,
    super.key,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  /// The widget to apply the shimmer effect to.
  final Widget child;

  /// Base shimmer color. Defaults to [ColorScheme.surfaceContainerHighest].
  final Color? baseColor;

  /// Highlight shimmer color. Defaults to [ColorScheme.surface].
  final Color? highlightColor;

  /// Duration of one shimmer animation cycle. Defaults to 1500ms.
  final Duration duration;

  @override
  State<ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<ShimmerContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(ShimmerContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = widget.baseColor ?? theme.colorScheme.surfaceContainerHighest;
    final highlight = widget.highlightColor ?? theme.colorScheme.surface;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
