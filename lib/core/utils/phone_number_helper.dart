class PhoneNumberHelper {
  /// Strips spaces, hyphens, parentheses, and prefixes to normalize for comparison
  static String normalize(String? raw) {
    if (raw == null) return '';
    // Remove non-digit characters except leading plus
    String cleaned = raw.replaceAll(RegExp(r'[^\d+]'), '');
    return cleaned;
  }

  /// Extracts the core national digits (typically the last 10 or 11 digits)
  static String getComparableKey(String raw) {
    final digitsOnly = raw.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length >= 10) {
      return digitsOnly.substring(digitsOnly.length - 10);
    }
    return digitsOnly;
  }

  /// Checks if two phone numbers match (handles +880, 0, or missing international codes)
  static bool matches(String a, String b) {
    final keyA = getComparableKey(a);
    final keyB = getComparableKey(b);
    if (keyA.isEmpty || keyB.isEmpty) return false;
    return keyA == keyB;
  }

  /// Returns true if number is valid (not null, not empty, not "private", not "unknown")
  static bool isValidCaller(String? raw) {
    if (raw == null) return false;
    final trimmed = raw.trim().toLowerCase();
    if (trimmed.isEmpty ||
        trimmed == 'private' ||
        trimmed == 'unknown' ||
        trimmed == 'restricted' ||
        trimmed == '-1' ||
        trimmed == '-2') {
      return false;
    }
    // Must contain at least 4 digits
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 4;
  }
}

