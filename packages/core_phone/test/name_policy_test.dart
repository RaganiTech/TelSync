import 'package:core_phone/name_policy_impl.dart';
import 'package:test/test.dart';

void main() {
  const policy = DefaultNamePolicy();

  group('DefaultNamePolicy', () {
    test('preserves Persian ZWNJ (نیم‌فاصله) and ZWJ', () {
      const nameWithZwnj = 'می\u200Cبینم'; // می بینم with ZWNJ
      final res = policy.sanitize(nameWithZwnj);
      expect(res.name, equals(nameWithZwnj));
      expect(res.name.contains('\u200C'), isTrue);
    });

    test('preserves emojis in contact names', () {
      const emojiName = 'Ali Rezaei 🌟🚀';
      final res = policy.sanitize(emojiName);
      expect(res.name, equals(emojiName));
    });

    test('strips bidi overrides and C0/C1 control characters', () {
      const maliciousName = '\u202E\u0007Hacked Name\u202C';
      final res = policy.sanitize(maliciousName);
      expect(res.name, equals('Hacked Name'));
      expect(res.name.contains('\u202E'), isFalse);
    });

    test('collapses multiple whitespace runs and trims', () {
      const messyName = '   Ali    Rezaei   Tehrani   ';
      final res = policy.sanitize(messyName);
      expect(res.name, equals('Ali Rezaei Tehrani'));
    });

    test('truncates names longer than 255 code units', () {
      final longName = 'A' * 300;
      final res = policy.sanitize(longName);
      expect(res.name.length, equals(255));
      expect(res.isTruncated, isTrue);
    });

    test('buildDisplayName merges first and last names cleanly', () {
      expect(policy.buildDisplayName('Ali', 'Rezaei'), equals('Ali Rezaei'));
      expect(policy.buildDisplayName('Ali', ''), equals('Ali'));
      expect(policy.buildDisplayName('', 'Rezaei'), equals('Rezaei'));
      expect(policy.buildDisplayName('  ', '  '), equals(''));
    });
  });
}
