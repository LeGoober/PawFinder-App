/// Collection of reusable form-field validators.
class Validators {
  const Validators._();

  /// Returns an error string when [value] is not a valid email address,
  /// otherwise returns `null`.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  /// Returns an error string when [value] is not a valid phone number,
  /// otherwise returns `null`.
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final regex = RegExp(r'^\+?[\d\s\-()]{7,15}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid phone number';
    return null;
  }

  /// Returns an error string when [value] is `null` or empty,
  /// otherwise returns `null`.
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  /// Returns an error string when [value] is not a valid password
  /// (min 8 chars, at least one letter and one digit),
  /// otherwise returns `null`.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    return null;
  }

  /// Returns an error string when [value] is not a positive number,
  /// otherwise returns `null`.
  static String? positiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Value is required';
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Enter a valid number';
    if (parsed <= 0) return 'Value must be greater than zero';
    return null;
  }
}
