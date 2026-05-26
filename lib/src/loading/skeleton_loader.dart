import 'package:flutter/material.dart';

import 'shimmer_container.dart';

/// A shimmer-animated skeleton placeholder for list content.
///
/// Renders [itemCount] placeholder rows inside a [ShimmerContainer].
/// Provide a custom [itemBuilder] to override the default card-style skeleton.
///
/// ```dart
/// SkeletonLoader(itemCount: 8)
/// ```
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key, this.itemCount = 5, this.itemBuilder});

  /// Number of skeleton rows to render.
  final int itemCount;

  /// Custom builder for each skeleton row. Uses a default card layout when null.
  final Widget Function(BuildContext context, int index)? itemBuilder;

  static const _avatarRadius = BorderRadius.all(Radius.circular(8));
  static const _barRadius = BorderRadius.all(Radius.circular(4));

  @override
  Widget build(BuildContext context) {
    var builder = itemBuilder;
    if (builder == null) {
      final placeholderColor = Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest;
      builder = (_, index) => _defaultItem(placeholderColor);
    }
    return ShimmerContainer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: builder,
      ),
    );
  }

  static Widget _defaultItem(Color placeholderColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: _avatarRadius,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: _barRadius,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 150,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: _barRadius,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
