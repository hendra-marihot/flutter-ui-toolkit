/// A function type matching Flutter's [FormField] validator signature.
typedef Validator = String? Function(String?);

/// A collection of composable form validators for use with [TextFormField].
///
/// Validators return `null` on success and an error string on failure.
///
/// Combine validators with [compose]:
/// ```dart
/// TextFormField(
///   validator: FlavorValidators.compose([
///     FlavorValidators.required(),
///     FlavorValidators.email(),
///   ]),
/// )
/// ```
abstract final class FlavorValidators {
  static final _emailRegex = RegExp(r'^[\w\-\.\+]+@([\w\-]+\.)+[\w]{2,}$');

  /// Fails when the value is null, empty, or whitespace-only.
  static Validator required([String message = 'This field is required']) {
    return (value) {
      if (value == null || value.trim().isEmpty) return message;
      return null;
    };
  }

  /// Fails when the value is not a valid email address.
  /// Passes for null/empty values — combine with [required] when needed.
  static Validator email([String message = 'Enter a valid email']) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!_emailRegex.hasMatch(value)) return message;
      return null;
    };
  }

  /// Fails when the value is shorter than [length] characters.
  /// Passes for null/empty values — combine with [required] when needed.
  static Validator minLength(int length, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }

  /// Fails when the value exceeds [length] characters.
  static Validator maxLength(int length, [String? message]) {
    return (value) {
      if (value != null && value.length > length) {
        return message ?? 'Must be at most $length characters';
      }
      return null;
    };
  }

  /// Fails when the value cannot be parsed as a number.
  /// Passes for null/empty values — combine with [required] when needed.
  static Validator numeric([String message = 'Enter a valid number']) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (double.tryParse(value) == null) return message;
      return null;
    };
  }

  /// Returns the first non-null error from [validators], or null if all pass.
  static Validator compose(List<Validator> validators) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
