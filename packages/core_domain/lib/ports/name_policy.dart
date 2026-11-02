abstract interface class NamePolicy {
  /// Sanitizes raw name according to SRS §13.1 FR-NRM-030..035:
  /// - Unicode NFC
  /// - Trim and collapse whitespace runs
  /// - Strip control chars (C0, C1) and bidi overrides (U+202A..U+202E)
  /// - PRESERVE ZWNJ (U+200C) and ZWJ (U+200D) for Persian
  /// - PRESERVE emoji
  /// - Cap at 255 UTF-16 code units (sets truncated = true)
  SanitizedName sanitize(String raw);

  /// Builds a combined display name from first and last name.
  String buildDisplayName(String firstName, String lastName);
}

class SanitizedName {
  final String name;
  final bool isTruncated;
  final bool isEmpty;

  const SanitizedName({
    required this.name,
    this.isTruncated = false,
    this.isEmpty = false,
  });
}
