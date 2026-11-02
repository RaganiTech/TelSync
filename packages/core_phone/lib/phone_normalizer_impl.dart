import 'package:core_domain/entities/normalized_number.dart';
import 'package:core_domain/ports/phone_normalizer.dart';

class PhoneNormalizerImpl implements PhoneNormalizer {
  const PhoneNormalizerImpl();

  static const _invisibleChars = {
    0x200B, 0x200C, 0x200D, 0x200E, 0x200F,
    0x202A, 0x202B, 0x202C, 0x202D, 0x202E,
    0x2066, 0x2067, 0x2068, 0x2069,
    0xFEFF,
  };

  @override
  NormalizedNumber normalize(
    String raw, {
    required NumberSource source,
    String defaultRegion = 'IR',
  }) {
    // Step 1: Trim and replace NBSP (U+00A0) with space, remove invisible chars
    final sb = StringBuffer();
    for (final rune in raw.runes) {
      if (_invisibleChars.contains(rune)) {
        continue;
      }
      if (rune == 0x00A0) {
        sb.write(' ');
      } else {
        sb.writeCharCode(rune);
      }
    }
    final trimmed = sb.toString().trim();
    if (trimmed.isEmpty) {
      return NormalizedNumber(
        raw: raw,
        digitsOnly: '',
        assumedRegion: false,
        status: NumberStatus.noNumber,
      );
    }

    // Step 2: Digit folding
    final folded = _foldDigits(trimmed);

    // Step 3: Extension detection
    final extMatch = RegExp(r'(?:ext|x|#|,|;)\s*(\d+)', caseSensitive: false).firstMatch(folded);
    final hasExtension = extMatch != null;
    String baseNumber = folded;
    if (hasExtension) {
      baseNumber = folded.substring(0, extMatch.start).trim();
    }

    // Step 4 & 5: Parsing according to Source Rule and Region
    return _parseAndValidate(
      raw: raw,
      cleanedInput: baseNumber,
      source: source,
      defaultRegion: defaultRegion.toUpperCase(),
      hasExtension: hasExtension,
    );
  }

  String _foldDigits(String input) {
    final sb = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 0x06F0 && rune <= 0x06F9) {
        // Persian digits ۰..۹ -> 0..9
        sb.writeCharCode(0x30 + (rune - 0x06F0));
      } else if (rune >= 0x0660 && rune <= 0x0669) {
        // Arabic-Indic digits ٠..٩ -> 0..9
        sb.writeCharCode(0x30 + (rune - 0x0660));
      } else if (rune >= 0xFF10 && rune <= 0xFF19) {
        // Full-width digits ０..９ -> 0..9
        sb.writeCharCode(0x30 + (rune - 0xFF10));
      } else {
        sb.writeCharCode(rune);
      }
    }
    return sb.toString();
  }

  NormalizedNumber _parseAndValidate({
    required String raw,
    required String cleanedInput,
    required NumberSource source,
    required String defaultRegion,
    required bool hasExtension,
  }) {
    String s = cleanedInput;

    // Step 6: Iran fix-up: "+98 (0) 912..." -> "+98912..."
    s = s.replaceAll(RegExp(r'\+98\s*\(0\)\s*'), '+98');
    s = s.replaceAll(RegExp(r'0098\s*\(0\)\s*'), '0098');

    bool assumedRegion = false;
    String digitsOnly = s.replaceAll(RegExp(r'\D'), '');

    if (source == NumberSource.telegram) {
      // Telegram numbers are digits without "+", always international
      assumedRegion = false;
    } else {
      // Phonebook numbers
      if (s.startsWith('+')) {
        assumedRegion = false;
      } else if (s.startsWith('00')) {
        // 00 prefix treated as +
        s = '+${s.substring(2)}';
        digitsOnly = digitsOnly.substring(2);
        assumedRegion = false;
      } else {
        assumedRegion = true;
      }
    }

    // Anonymous Telegram numbers: +888...
    if (source == NumberSource.telegram && digitsOnly.startsWith('888')) {
      return NormalizedNumber(
        raw: raw,
        e164: '+$digitsOnly',
        nsn: digitsOnly.substring(3),
        digitsOnly: digitsOnly,
        assumedRegion: assumedRegion,
        status: NumberStatus.anonymousTg,
      );
    }
    if (s.startsWith('+888')) {
      return NormalizedNumber(
        raw: raw,
        e164: '+$digitsOnly',
        nsn: digitsOnly.length >= 3 ? digitsOnly.substring(3) : '',
        digitsOnly: digitsOnly,
        assumedRegion: assumedRegion,
        status: NumberStatus.anonymousTg,
      );
    }

    if (hasExtension) {
      return NormalizedNumber(
        raw: raw,
        digitsOnly: digitsOnly,
        assumedRegion: assumedRegion,
        status: NumberStatus.ambiguous,
        hasExtension: true,
      );
    }

    // Now validate and construct E.164
    if (assumedRegion) {
      if (defaultRegion == 'IR') {
        return _validateIranNational(raw, digitsOnly);
      } else if (defaultRegion == 'GB') {
        return _validateGbNational(raw, digitsOnly);
      } else {
        // Fallback generic
        if (digitsOnly.length < 7 || digitsOnly.length > 15) {
          return NormalizedNumber(
            raw: raw,
            digitsOnly: digitsOnly,
            assumedRegion: true,
            status: NumberStatus.invalid,
          );
        }
        return NormalizedNumber(
          raw: raw,
          digitsOnly: digitsOnly,
          assumedRegion: true,
          status: NumberStatus.valid,
        );
      }
    } else {
      // International parsing
      return _validateInternational(raw, digitsOnly);
    }
  }

  static const _validIranAreaCodes = {
    '021', '025', '026', '028',
    '031', '034', '035', '038',
    '041', '044', '045',
    '051', '054', '056', '058',
    '061', '066',
    '071', '074', '077',
    '081', '083', '084', '086', '087',
  };

  NormalizedNumber _validateIranNational(String raw, String digitsOnly) {
    // In Iran:
    // Mobile: 11 digits starting with 09... -> NSN: 9... (10 digits)
    // Mobile without leading 0: 10 digits starting with 9... -> NSN: 9... (10 digits)
    // Fixed line: 11 digits starting with valid 3-digit area code (e.g. 02112345678) -> NSN: 2112345678 (10 digits)
    if (digitsOnly.length == 11 && digitsOnly.startsWith('09')) {
      final nsn = digitsOnly.substring(1); // 10 digits
      return NormalizedNumber(
        raw: raw,
        e164: '+98$nsn',
        nsn: nsn,
        digitsOnly: digitsOnly,
        assumedRegion: true,
        status: NumberStatus.valid,
        type: NumberType.mobile,
      );
    }
    if (digitsOnly.length == 10 && digitsOnly.startsWith('9')) {
      return NormalizedNumber(
        raw: raw,
        e164: '+98$digitsOnly',
        nsn: digitsOnly,
        digitsOnly: digitsOnly,
        assumedRegion: true,
        status: NumberStatus.valid,
        type: NumberType.mobile,
      );
    }
    if (digitsOnly.length == 11 && digitsOnly.startsWith('0')) {
      final areaCode = digitsOnly.substring(0, 3);
      if (_validIranAreaCodes.contains(areaCode)) {
        final nsn = digitsOnly.substring(1);
        return NormalizedNumber(
          raw: raw,
          e164: '+98$nsn',
          nsn: nsn,
          digitsOnly: digitsOnly,
          assumedRegion: true,
          status: NumberStatus.valid,
          type: NumberType.fixedLine,
        );
      }
    }

    // Incomplete, invalid area codes, or invalid lengths (e.g. 09123, 110, 0912345678, 07911123456)
    return NormalizedNumber(
      raw: raw,
      digitsOnly: digitsOnly,
      assumedRegion: true,
      status: NumberStatus.invalid,
    );
  }

  NormalizedNumber _validateGbNational(String raw, String digitsOnly) {
    if (digitsOnly.length == 11 && digitsOnly.startsWith('07')) {
      final nsn = digitsOnly.substring(1);
      return NormalizedNumber(
        raw: raw,
        e164: '+44$nsn',
        nsn: nsn,
        digitsOnly: digitsOnly,
        assumedRegion: true,
        status: NumberStatus.valid,
        type: NumberType.mobile,
      );
    }
    return NormalizedNumber(
      raw: raw,
      digitsOnly: digitsOnly,
      assumedRegion: true,
      status: NumberStatus.invalid,
    );
  }

  NormalizedNumber _validateInternational(String raw, String digitsOnly) {
    // E.164: +<CC><NSN>, max 15 digits total, min 8 digits
    if (digitsOnly.startsWith('98')) {
      // Iran international: +98 + 10 digits = 12 digits
      if (digitsOnly.length == 12) {
        final nsn = digitsOnly.substring(2);
        final isMobile = nsn.startsWith('9');
        return NormalizedNumber(
          raw: raw,
          e164: '+$digitsOnly',
          nsn: nsn,
          digitsOnly: digitsOnly,
          assumedRegion: false,
          status: NumberStatus.valid,
          type: isMobile ? NumberType.mobile : NumberType.fixedLine,
        );
      } else {
        // e.g. +98912345678 (only 11 digits - invalid Iran number)
        return NormalizedNumber(
          raw: raw,
          digitsOnly: digitsOnly,
          assumedRegion: false,
          status: NumberStatus.invalid,
        );
      }
    }

    if (digitsOnly.startsWith('44')) {
      // UK international (12 digits)
      if (digitsOnly.length == 12) {
        final nsn = digitsOnly.substring(2);
        return NormalizedNumber(
          raw: raw,
          e164: '+$digitsOnly',
          nsn: nsn,
          digitsOnly: digitsOnly,
          assumedRegion: false,
          status: NumberStatus.valid,
        );
      }
    }

    // Generic international length check
    if (digitsOnly.length >= 8 && digitsOnly.length <= 15) {
      return NormalizedNumber(
        raw: raw,
        e164: '+$digitsOnly',
        digitsOnly: digitsOnly,
        assumedRegion: false,
        status: NumberStatus.valid,
      );
    }

    return NormalizedNumber(
      raw: raw,
      digitsOnly: digitsOnly,
      assumedRegion: false,
      status: NumberStatus.invalid,
    );
  }
}
