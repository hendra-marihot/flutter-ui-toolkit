# CLAUDE.md — flutter_flavor_ui

## Project overview

`flutter_flavor_ui` is a publishable Dart/Flutter package (`pub.dev` target) that provides
production-grade, Material 3-aware reusable widgets. It is **a package, not an app** — there
is no `lib/main.dart`. The single public entry point is the barrel file:

```
lib/flutter_flavor_ui.dart
```

All public symbols are re-exported from that file. Consumers import one path:

```dart
import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
```

Package name: `flutter_flavor_ui`
Repository: https://github.com/hendramarihot/flutter-ui-toolkit

## Directory layout

```
lib/
  flutter_flavor_ui.dart          ← barrel export (the only public surface)
  src/
    adaptive/
      adaptive_layout.dart        ← AdaptiveLayout widget
      breakpoints.dart            ← FlavorBreakpoints + ScreenSize enum
    buttons/
      async_button.dart           ← AsyncButton
    feedback/
      empty_state.dart            ← EmptyState
      error_state.dart            ← ErrorState
    form/
      validators.dart             ← FlavorValidators
    loading/
      shimmer_container.dart      ← ShimmerContainer
      skeleton_loader.dart        ← SkeletonLoader
    pull_refresh/
      pull_to_refresh.dart        ← PullToRefresh
example/
  lib/main.dart                   ← component gallery (runnable app)
  pubspec.yaml
test/
  adaptive_layout_test.dart
  async_button_test.dart
  empty_state_test.dart
  error_state_test.dart
  flutter_flavor_ui_test.dart     ← barrel smoke test
  pull_to_refresh_test.dart
  shimmer_container_test.dart
  skeleton_loader_test.dart
  validators_test.dart
```

## Build commands

```bash
# Run the full test suite
flutter test

# Analyze for lint and type errors
flutter analyze

# Auto-format all Dart files
dart format .

# Dry-run publish check (runs pana scoring and validates pubspec)
dart pub publish --dry-run

# Run a single test file
flutter test test/validators_test.dart
```

Run `flutter analyze` and `flutter test` before every commit. Both must pass clean.

## Code conventions

These are enforced by `analysis_options.yaml` (extends `package:flutter_lints/flutter.yaml`):

- **`const` constructors everywhere** — every widget that can be `const` must be.
- **Single quotes** for all string literals.
- **`super.key`** — never write `Key? key` + `super(key: key)`; use `super.key` directly.
- **`final` locals** — prefer immutable bindings; `var` only when reassignment is needed.
- **No hardcoded colors** — always use `Theme.of(context).colorScheme.*` or
  `Theme.of(context).textTheme.*`. Never reference `Colors.*` in widget builds
  (exception: `Colors.transparent` is acceptable).
- **Public Flutter API only** — do not reach into Flutter framework internals or rely on
  implementation details not part of the stable public API.
- **Every widget accepts `Key? key` via `super.key`** — add `super.key` to every widget
  constructor.
- **Barrel discipline** — every new file added under `lib/src/` must be re-exported from
  `lib/flutter_flavor_ui.dart` before the PR is merged.

## This is a package — key constraints

- No `main()` entry point in `lib/`.
- No platform-specific code (`android/`, `ios/`, etc.) unless adding a plugin channel,
  which is out of scope for this package.
- `pubspec.yaml` must not contain `publish_to: 'none'`. (The example app's pubspec
  **must** contain `publish_to: 'none'`.)
- `pubspec.yaml` must include a `topics:` list for pub.dev discoverability.
- Keep dependencies minimal. The only allowed runtime dependency is `flutter` SDK.

## Testing requirements

Every widget must have widget tests. Every public function must have unit tests.

- Test files live in `test/`, mirroring the `lib/src/` structure.
- Use `testWidgets` (not `test`) for any code that touches `BuildContext` or widget trees.
- Use `tester.view.physicalSize` + `tester.view.devicePixelRatio` + `addTearDown` to
  control viewport size in layout tests — do not use `MediaQuery` overrides.
- Wrap widget tests in a `MaterialApp` (or `MaterialApp.router`) to provide theme and
  navigation context.

## CI

GitHub Actions runs on every push/PR to `main`: analyze, format check
(`dart format --set-exit-if-changed .`), test, and publish dry-run.

## SDK constraints

Dart `^3.8.0`, Flutter `>=3.27.0`. All Dart 3.x features (sealed classes, records, patterns) are available.

## Publishing checklist

Before running `dart pub publish`:

1. `dart pub publish --dry-run` passes with no errors.
2. `flutter analyze` is clean.
3. `flutter test` passes (all green).
4. `CHANGELOG.md` entry added for the new version.
5. Version bumped in `pubspec.yaml` following semver.
6. `topics:` present in `pubspec.yaml`.
7. Example app `pubspec.yaml` has `publish_to: 'none'`.
