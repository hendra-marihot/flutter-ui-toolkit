import 'package:flutter/material.dart';
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flavor UI – Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ComponentGallery(),
    );
  }
}

class ComponentGallery extends StatelessWidget {
  const ComponentGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Flavor UI'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: const [
          _SectionHeader('Adaptive Layout'),
          _AdaptiveLayoutDemo(),
          _SectionHeader('Shimmer / Skeleton Loading'),
          _ShimmerDemo(),
          _SectionHeader('Empty State'),
          _EmptyStateDemo(),
          _SectionHeader('Error State'),
          _ErrorStateDemo(),
          _SectionHeader('Async Button'),
          _AsyncButtonDemo(),
          _SectionHeader('Form Validators'),
          _ValidatorsDemo(),
          _SectionHeader('Pull to Refresh'),
          _PullToRefreshDemo(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header helper
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AdaptiveLayout demo
// ---------------------------------------------------------------------------

class _AdaptiveLayoutDemo extends StatelessWidget {
  const _AdaptiveLayoutDemo();

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: AdaptiveLayout(
          compact: _DemoChip('Compact layout'),
          medium: _DemoChip('Medium layout'),
          expanded: _DemoChip('Expanded layout'),
          large: _DemoChip('Large layout'),
        ),
      ),
    );
  }
}

class _DemoChip extends StatelessWidget {
  const _DemoChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer / Skeleton demo
// ---------------------------------------------------------------------------

class _ShimmerDemo extends StatelessWidget {
  const _ShimmerDemo();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 200, child: SkeletonLoader(itemCount: 3));
  }
}

// ---------------------------------------------------------------------------
// EmptyState demo
// ---------------------------------------------------------------------------

class _EmptyStateDemo extends StatelessWidget {
  const _EmptyStateDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: EmptyState(
        title: 'No items yet',
        description: 'Add your first item to get started.',
        icon: Icons.inbox_outlined,
        actionLabel: 'Add item',
        onAction: () {},
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ErrorState demo
// ---------------------------------------------------------------------------

class _ErrorStateDemo extends StatelessWidget {
  const _ErrorStateDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ErrorState(
        message: 'Something went wrong. Please try again.',
        onRetry: () {},
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AsyncButton demo
// ---------------------------------------------------------------------------

class _AsyncButtonDemo extends StatelessWidget {
  const _AsyncButtonDemo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AsyncButton(
        onPressed: () async {
          await Future<void>.delayed(const Duration(seconds: 2));
        },
        child: const Text('Save (simulates 2s delay)'),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Validators demo
// ---------------------------------------------------------------------------

class _ValidatorsDemo extends StatelessWidget {
  const _ValidatorsDemo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email (required)'),
              validator: FlavorValidators.compose([
                FlavorValidators.required(),
                FlavorValidators.email(),
              ]),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username (min 3 chars)',
              ),
              validator: FlavorValidators.compose([
                FlavorValidators.required(),
                FlavorValidators.minLength(3),
                FlavorValidators.maxLength(20),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PullToRefresh demo
// ---------------------------------------------------------------------------

class _PullToRefreshDemo extends StatefulWidget {
  const _PullToRefreshDemo();

  @override
  State<_PullToRefreshDemo> createState() => _PullToRefreshDemoState();
}

class _PullToRefreshDemoState extends State<_PullToRefreshDemo> {
  int _refreshCount = 0;

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _refreshCount++);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PullToRefresh(
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: Text('Pull down to refresh (count: $_refreshCount)'),
            ),
          ],
        ),
      ),
    );
  }
}
