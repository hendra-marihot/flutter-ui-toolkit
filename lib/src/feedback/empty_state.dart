import 'package:flutter/material.dart';

/// A centered empty-state widget with an icon, title, optional description,
/// and an optional call-to-action button.
///
/// ```dart
/// EmptyState(
///   title: 'No results found',
///   description: 'Try adjusting your search filters.',
///   icon: Icons.search_off,
///   actionLabel: 'Clear filters',
///   onAction: () => clearFilters(),
/// )
/// ```
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    super.key,
    this.description,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  /// Primary heading displayed below the icon.
  final String title;

  /// Optional supporting text displayed below [title].
  final String? description;

  /// Icon to display. Defaults to [Icons.inbox_outlined].
  final IconData? icon;

  /// Label for the call-to-action button. Requires [onAction] to be visible.
  final String? actionLabel;

  /// Callback invoked when the action button is pressed.
  final VoidCallback? onAction;

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
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
