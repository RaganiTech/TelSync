import 'package:core_domain/ports/name_policy.dart';

class DefaultNamePolicy implements NamePolicy {
  const DefaultNamePolicy();

  @override
  SanitizedName sanitize(String raw) {
    if (raw.isEmpty) {
      return const SanitizedName(name: '', isEmpty: true);
    }

    // 1. Strip C0/C1 control characters and Bidi overrides
    // Strip:
    // - Control characters: U+0000..U+001F, U+007F..U+009F (except space, tab/newline trimmed later)
    // - Bidi formatting / overrides: U+200E, U+200F, U+202A..U+202E, U+2066..U+2069, U+FEFF
    // BUT PRESERVE:
    // - ZWNJ: U+200C
    // - ZWJ: U+200D
    final sb = StringBuffer();
    for (final rune in raw.runes) {
      if ((rune >= 0x0000 && rune <= 0x001F) ||
          (rune >= 0x007F && rune <= 0x009F) ||
          rune == 0x200E ||
          rune == 0x200F ||
          (rune >= 0x202A && rune <= 0x202E) ||
          (rune >= 0x2066 && rune <= 0x2069) ||
          rune == 0xFEFF) {
        // Drop control/bidi override character
        continue;
      }
      sb.writeCharCode(rune);
    }

    // 2. Collapse runs of whitespace and trim
    String cleaned = sb.toString().replaceAll(RegExp(r'\s+'), ' ').trim();

    if (cleaned.isEmpty) {
      return const SanitizedName(name: '', isEmpty: true);
    }

    // 3. Cap at 255 UTF-16 code units (FR-NRM-031)
    bool isTruncated = false;
    if (cleaned.length > 255) {
      cleaned = cleaned.substring(0, 255);
      isTruncated = true;
    }

    return SanitizedName(
      name: cleaned,
      isTruncated: isTruncated,
      isEmpty: false,
    );
  }

  @override
  String buildDisplayName(String firstName, String lastName) {
    final sFirst = sanitize(firstName).name;
    final sLast = sanitize(lastName).name;
    final parts = [sFirst, sLast].where((s) => s.isNotEmpty).toList();
    return parts.join(' ');
  }
}
