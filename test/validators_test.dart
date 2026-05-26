import 'package:flutter_flavor_ui/flutter_flavor_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlavorValidators', () {
    group('required', () {
      test('returns error for null', () {
        expect(FlavorValidators.required()(null), isNotNull);
      });
      test('returns error for empty string', () {
        expect(FlavorValidators.required()(''), isNotNull);
      });
      test('returns error for whitespace only', () {
        expect(FlavorValidators.required()('   '), isNotNull);
      });
      test('returns null for valid input', () {
        expect(FlavorValidators.required()('hello'), isNull);
      });
    });

    group('email', () {
      test('returns null for null (not required)', () {
        expect(FlavorValidators.email()(null), isNull);
      });
      test('returns error for invalid email', () {
        expect(FlavorValidators.email()('notanemail'), isNotNull);
      });
      test('returns null for valid email', () {
        expect(FlavorValidators.email()('test@example.com'), isNull);
      });
      test('accepts plus addressing', () {
        expect(FlavorValidators.email()('user+tag@example.com'), isNull);
      });
      test('accepts long TLDs', () {
        expect(FlavorValidators.email()('user@example.photography'), isNull);
      });
      test('accepts multi-part domains', () {
        expect(FlavorValidators.email()('user@example.co.uk'), isNull);
      });
      test('accepts two-char TLDs', () {
        expect(FlavorValidators.email()('user@x.io'), isNull);
      });
    });

    group('minLength', () {
      test('returns error for short string', () {
        expect(FlavorValidators.minLength(5)('abc'), isNotNull);
      });
      test('returns null for valid length', () {
        expect(FlavorValidators.minLength(3)('abc'), isNull);
      });
    });

    group('numeric', () {
      test('returns error for non-numeric', () {
        expect(FlavorValidators.numeric()('abc'), isNotNull);
      });
      test('returns null for integer', () {
        expect(FlavorValidators.numeric()('42'), isNull);
      });
      test('returns null for decimal', () {
        expect(FlavorValidators.numeric()('3.14'), isNull);
      });
    });

    group('maxLength', () {
      test('returns error when value exceeds limit', () {
        expect(FlavorValidators.maxLength(5)('toolong'), isNotNull);
      });
      test('returns null at exactly the limit', () {
        expect(FlavorValidators.maxLength(5)('hello'), isNull);
      });
      test('returns null for null value', () {
        expect(FlavorValidators.maxLength(5)(null), isNull);
      });
    });

    group('compose', () {
      test('returns first error from multiple validators', () {
        final validator = FlavorValidators.compose([
          FlavorValidators.required(),
          FlavorValidators.minLength(5),
        ]);
        expect(validator(''), equals('This field is required'));
      });
      test('returns null when all pass', () {
        final validator = FlavorValidators.compose([
          FlavorValidators.required(),
          FlavorValidators.minLength(3),
        ]);
        expect(validator('hello'), isNull);
      });
    });
  });
}
