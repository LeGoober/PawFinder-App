/// General-purpose helper functions.
class Helpers {
  const Helpers._();

  /// Formats a distance in meters to a human-readable string.
  ///
  /// Returns `"1.2 km"` for values >= 1 000 m, or `"350 m"` for smaller values.
  static String formatDistance(double meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km.toStringAsFixed(km < 10 ? 1 : 0)} km';
    }
    return '${meters.round()} m';
  }

  /// Formats a reward amount with a currency symbol.
  ///
  /// Accepts a [BigDecimal] or any [num] amount and a currency code string
  /// (e.g. `"USD"`, `"EUR"`). Returns a string like `"$100"` or `"€50"`.
  static String formatReward(num amount, String currency) {
    final symbol = _currencySymbol(currency);
    // Whole-number rewards shouldn't show decimals.
    if (amount == amount.roundToDouble()) {
      return '$symbol${amount.toInt()}';
    }
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Returns the first two uppercase initials from [name].
  ///
  /// `"John Doe"` → `"JD"`, `"Alice"` → `"A"`, `""` → `""`.
  static String getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    return parts
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
  }

  // -------------------------------------------------------------------------
  // Private helpers
  // -------------------------------------------------------------------------

  /// Maps common currency codes to their symbols.
  /// Falls back to the code itself when unknown.
  static String _currencySymbol(String currency) {
    const map = <String, String>{
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'ZAR': 'R',
      'JPY': '¥',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'INR': '₹',
      'NGN': '₦',
      'KES': 'KSh',
    };
    return map[currency.toUpperCase()] ?? '$currency ';
  }
}
