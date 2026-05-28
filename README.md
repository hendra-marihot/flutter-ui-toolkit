# flutter_flavor_ui

A reusable widget library for Flutter — zero runtime dependencies, Material 3 native, tested at the lifecycle and boundary level.

This is one repo in a portfolio series. Each covers a different fundamental of senior-level Flutter engineering. This one is about **widget-layer design**: building small, composable UI primitives that are theme-aware, lifecycle-safe, and useful without configuration.

## Why this exists

Every Flutter app ends up building the same handful of widgets: a shimmer loader, an async-safe button, a responsive layout wrapper, an empty state screen. They're simple enough that most teams write them inline, but tricky enough that the inline versions accumulate subtle bugs — broken animations on widget rebuild, `setState` after dispose, double-tap race conditions.

I built this library to demonstrate how I think about that widget layer: what's worth extracting, how to design an API that's hard to misuse, and where the real complexity hides in seemingly simple components.

## What's in here

| Widget | What it does | What's interesting about it |
|---|---|---|
| `ShimmerContainer` | Animated shimmer overlay on any widget | Hand-rolled with `ShaderMask` + `LinearGradient` — no dependency on a shimmer package. Handles `didUpdateWidget` correctly when duration changes mid-animation. |
| `SkeletonLoader` | Placeholder list with shimmer | Composes `ShimmerContainer` rather than duplicating the animation. Default layout is theme-aware (`surfaceContainerHighest`), but accepts a custom builder. |
| `AsyncButton` | Button that manages its own loading state | Checks `mounted` before `setState` in the finally block. Prevents double-tap. Two error paths: custom callback or `FlutterError.reportError`. |
| `AdaptiveLayout` | Responsive layout by breakpoint | Dart 3 exhaustive `switch` on a `ScreenSize` enum — the compiler enforces that every breakpoint is handled. Graceful fallback chain when optional sizes aren't provided. |
| `FlavorValidators` | Composable form validators | Individual validators pass on empty/null (they only validate *format*). `required()` is a separate concern. This forces explicit composition — you can't accidentally skip presence checking. |
| `PullToRefresh` | Pull-to-refresh with `canRefresh` toggle | Disables the gesture by swapping the `notificationPredicate`, not by removing the widget. No rebuild, no state loss. |
| `EmptyState` | Empty-state screen with optional CTA | Conditional rendering via collection-if. Button only appears when *both* label and callback are non-null — can't get a dead button. |
| `ErrorState` | Error screen with optional retry | Same pattern as `EmptyState`. Uses `colorScheme.error` for the icon — semantic, not hardcoded. |

## Installation

```bash
flutter pub add flutter_flavor_ui
```

Then import the single barrel file — every widget is exported from it:

```dart
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
```

## Usage

```dart
// Animated shimmer over any widget.
ShimmerContainer(
  child: Container(width: 200, height: 20, color: Colors.white),
)

// Shimmer placeholder list (defaults to 5 rows).
const SkeletonLoader(itemCount: 8)

// Button that owns its loading state and surfaces errors.
AsyncButton(
  onPressed: () async => submitForm(),
  onError: (error, stackTrace) => reportError(error),
  child: const Text('Submit'),
)

// Responsive layout by breakpoint, with a fallback chain.
AdaptiveLayout(
  compact: const MobileView(),
  medium: const TabletView(),
  expanded: const DesktopView(),
)

// Composable, format-only validators (combine with required()).
TextFormField(
  validator: FlavorValidators.compose([
    FlavorValidators.required(),
    FlavorValidators.email(),
  ]),
)

// Pull-to-refresh with a canRefresh toggle.
PullToRefresh(
  onRefresh: () async => fetchData(),
  child: ListView(/* ... */),
)

// Empty state with an optional call-to-action.
EmptyState(
  title: 'No results found',
  description: 'Try adjusting your search filters.',
  icon: Icons.search_off,
  actionLabel: 'Clear filters',
  onAction: clearFilters,
)

// Error state with an optional retry.
ErrorState(
  message: 'Failed to load data. Please check your connection.',
  onRetry: fetchData,
)
```

## Key decisions

### Zero runtime dependencies

The only dependency is the Flutter SDK itself. No transitive packages.

This is deliberate. A foundational UI library sits at the bottom of the dependency graph — every package it pulls in becomes a version constraint on every app that uses it. I wanted to keep the installation cost as close to zero as possible, even if that means building things like shimmer from `ShaderMask` primitives instead of importing a package.

The tradeoff: more implementation work upfront, and I own the maintenance. For a library this size, that's the right call. For something larger, the calculus changes.

### Building shimmer from rendering primitives

I built `ShimmerContainer` from `AnimationController` → `LinearGradient` → `ShaderMask` instead of wrapping the `shimmer` package. The reason is straightforward: assembling packages demonstrates nothing. Building from rendering primitives shows you understand Flutter's compositing pipeline — how `ShaderMask` applies a gradient as a blend operation over a child's alpha channel, how `BlendMode.srcATop` restricts the effect to painted pixels, how gradient stops need clamping at animation boundaries to avoid artifacts.

The implementation also shows attention to the widget lifecycle: `didUpdateWidget` detects duration changes and restarts the animation controller rather than ignoring the update. That's a detail that matters when a parent widget rebuilds with new configuration — the kind of thing that works fine in a demo but breaks in a real app where state changes flow through the tree.

### Composable validators with explicit null semantics

The `FlavorValidators` API makes a design choice that isn't obvious until you think about it: `email()`, `minLength()`, and `numeric()` all **pass** on null/empty input. They only validate format.

This means `email()` alone won't reject an empty field. You need `compose([required(), email()])`. That's intentional — it separates "is this field filled in?" from "is the value well-formed?" and forces the caller to be explicit about which checks apply. A field that's optional but must be a valid email if filled in is just `email()` with no `required()`.

The alternative (every validator rejects empty) is more convenient for the common case but creates an implicit coupling that makes the optional-field case awkward.

### AsyncButton lifecycle safety

Three things that go wrong with naive async buttons:

1. **Double-tap**: User taps twice before the first future resolves. Two requests fire. `AsyncButton` returns early if already loading.
2. **Disposal**: User navigates away while the future is in-flight. `setState` is called on a disposed widget. `AsyncButton` checks `mounted` before calling `setState` in the `finally` block.
3. **Silent failures**: The future throws but nobody handles it. `AsyncButton` offers an `onError` callback; if none is provided, it reports the error through `FlutterError.reportError` so it's visible in logs and error-tracking tools instead of being swallowed.

None of these are hard to implement. The point is recognizing that they need to exist.

## Architecture

```
flutter_flavor_ui.dart               ← single barrel export
  └── src/
        ├── adaptive/                 ← responsive layout
        │     ├── adaptive_layout.dart
        │     └── breakpoints.dart
        ├── buttons/                  ← interaction
        │     └── async_button.dart
        ├── feedback/                 ← state feedback
        │     ├── empty_state.dart
        │     └── error_state.dart
        ├── form/                     ← validation
        │     └── validators.dart
        ├── loading/                  ← shimmer & skeleton
        │     ├── shimmer_container.dart
        │     └── skeleton_loader.dart
        └── pull_refresh/             ← gesture
              └── pull_to_refresh.dart
```

This is a **package, not an app** — no `main()`, no platform directories. One barrel file, one import path for consumers. Every file under `src/` is re-exported through the barrel; nothing is public by accident.

The code uses Dart 3 features where they earn their keep: `abstract final class` for `FlavorValidators` (prevents instantiation at compile time), exhaustive `switch` expressions in `AdaptiveLayout` (the compiler enforces all breakpoints are handled), and the `library;` directive for the barrel export.

Widgets are grouped by concern — `ShimmerContainer` and `SkeletonLoader` live together under `loading/` because they solve the same UX problem, and `SkeletonLoader` composes `ShimmerContainer` internally.

## Non-goals

This repo covers one competency area — widget-layer design. Everything else is deliberately out of scope (and in some cases, covered by other repos in the series):

- **State management** — no Riverpod, no Bloc, no provider wiring.
- **Navigation / routing** — no `go_router`, no deep linking.
- **Theming system** — these widgets *consume* Material 3 themes but don't provide a theming layer or design tokens.
- **Platform channels** — pure Dart/Flutter, no native code.
- **Complex animations** — `ShimmerContainer` uses an `AnimationController`; everything else is stateless or simple boolean state.

## Testing approach

All widget tests use real `MaterialApp` + `Theme` — no mocking of the framework.

What I focused on:
- **Lifecycle edge cases**: `AsyncButton` is tested for disposal mid-flight (future completes after widget is removed from tree — no crash) and double-tap prevention (second tap during loading is ignored).
- **Theme introspection**: `SkeletonLoader` tests extract the `Container` color and verify it matches `colorScheme.surfaceContainerHighest` — confirming dark mode works, not just that "a color exists."
- **Breakpoint boundaries**: `AdaptiveLayout` tests hit the exact boundary values (599, 600, 840, 1200) to verify off-by-one behavior.
- **Conditional rendering**: `EmptyState` and `ErrorState` tests count widgets to verify that optional elements are truly absent, not just invisible.
- **Validator composition**: Validators are tested individually *and* through `compose()`, including the null/empty pass-through behavior that makes composition work.

What's missing: golden tests for visual regression on the shimmer animation. The animation is verified structurally (correct widget tree, correct parameters) but not visually. That's a gap I'd close before calling this complete.

## CI

GitHub Actions runs on every push and PR to `main`:

1. `flutter analyze` — lint and type checking
2. `dart format --set-exit-if-changed .` — formatting is enforced, not optional
3. `flutter test` — full suite
4. `dart pub publish --dry-run` — validates the package is publishable

All four must pass. No optional steps, no "allowed to fail."

## Limitations and what I'd improve

- **No golden tests.** Shimmer animation is verified structurally but not visually. I'd add golden snapshots for light/dark mode across breakpoints.
- **Email regex is practical, not spec-compliant.** The regex handles real-world addresses (plus-addressing, multi-part TLDs) but isn't RFC 5322. A spec-compliant regex is thousands of characters and rejects addresses that actually exist — the practical version is the right call for form validation, but it means there are valid-per-spec addresses this will reject.
- **No accessibility annotations beyond Material 3 defaults.** The widgets inherit Material's semantic labels and contrast ratios, but I haven't added explicit `Semantics` widgets or tested with screen readers. That's the next thing I'd add.
- **Example app is functional, not polished.** It demonstrates every widget but doesn't show advanced composition patterns or theme switching.

## Run it yourself

```bash
# Run the tests
flutter test

# Static analysis
flutter analyze

# Run the example gallery
cd example && flutter run
```

Requires Dart >= 3.8.0, Flutter >= 3.27.0.

## License

Apache 2.0 — see [LICENSE](LICENSE).
