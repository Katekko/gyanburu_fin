/// Shared input validation utilities for endpoint methods.
class Validate {
  static final _monthPattern = RegExp(r'^\d{4}-(0[1-9]|1[0-2])$');
  static final _hexColorPattern = RegExp(r'^#?[0-9a-fA-F]{6}$');

  static void requireNotEmpty(String value, String fieldName) {
    if (value.trim().isEmpty) {
      throw ArgumentError('$fieldName must not be empty');
    }
  }

  static void requireMaxLength(String value, String fieldName,
      [int max = 200]) {
    if (value.length > max) {
      throw ArgumentError('$fieldName must be at most $max characters');
    }
  }

  static void requireFiniteAmount(double value, String fieldName) {
    if (value.isNaN || value.isInfinite) {
      throw ArgumentError('$fieldName must be a finite number');
    }
  }

  static void requirePositiveAmount(double value, String fieldName) {
    requireFiniteAmount(value, fieldName);
    if (value <= 0) {
      throw ArgumentError('$fieldName must be positive');
    }
  }

  static void requireMonthFormat(String value, String fieldName) {
    if (!_monthPattern.hasMatch(value)) {
      throw ArgumentError('$fieldName must be in YYYY-MM format');
    }
  }

  static void requireHexColor(String value, String fieldName) {
    if (!_hexColorPattern.hasMatch(value)) {
      throw ArgumentError('$fieldName must be a hex color (RRGGBB)');
    }
  }

  static void requireString(String value, String fieldName,
      {int maxLength = 200}) {
    requireNotEmpty(value, fieldName);
    requireMaxLength(value, fieldName, maxLength);
  }
}
