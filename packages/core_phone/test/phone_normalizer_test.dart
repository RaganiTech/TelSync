import 'package:core_domain/entities/normalized_number.dart';
import 'package:core_domain/ports/phone_normalizer.dart';
import 'package:core_phone/phone_normalizer_impl.dart';
import 'package:test/test.dart';

void main() {
  const normalizer = PhoneNormalizerImpl();

  group('PhoneNormalizer - Golden Vectors from SRS §17.2', () {
    test('09123456789 (phonebook / IR)', () {
      final res = normalizer.normalize('09123456789', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+989123456789'));
      expect(res.assumedRegion, isTrue);
    });

    test('+989123456789 (any)', () {
      final res = normalizer.normalize('+989123456789', source: NumberSource.phonebook);
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+989123456789'));
      expect(res.assumedRegion, isFalse);
    });

    test('00989123456789 (phonebook / IR)', () {
      final res = normalizer.normalize('00989123456789', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+989123456789'));
      expect(res.assumedRegion, isFalse);
    });

    test('9123456789 (phonebook / IR)', () {
      final res = normalizer.normalize('9123456789', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+989123456789'));
      expect(res.assumedRegion, isTrue);
    });

    test('۰۹۱۲۳۴۵۶۷۸۹ (Persian digits)', () {
      final res = normalizer.normalize('۰۹۱۲۳۴۵۶۷۸۹', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+989123456789'));
    });

    test('٠٩١٢٣٤٥٦٧٨٩ (Arabic-Indic digits)', () {
      final res = normalizer.normalize('٠٩١٢٣٤٥٦٧٨٩', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+989123456789'));
    });

    test('0912-345-6789, (0912) 345 6789, 0912 345 6789 formatting variations', () {
      for (final input in ['0912-345-6789', '(0912) 345 6789', '0912 345 6789']) {
        final res = normalizer.normalize(input, source: NumberSource.phonebook, defaultRegion: 'IR');
        expect(res.status, equals(NumberStatus.valid));
        expect(res.e164, equals('+989123456789'));
      }
    });

    test('+98 (0) 912 345 6789 (fix-up rule)', () {
      final res = normalizer.normalize('+98 (0) 912 345 6789', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+989123456789'));
    });

    test('+989123456789 plus trailing LRM or NBSP', () {
      final res = normalizer.normalize('+989123456789\u200E\u00A0', source: NumberSource.phonebook);
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+989123456789'));
    });

    test('989123456789 (telegram source: digits without +)', () {
      final res = normalizer.normalize('989123456789', source: NumberSource.telegram);
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+989123456789'));
      expect(res.assumedRegion, isFalse);
    });

    test('09123 -> INVALID', () {
      final res = normalizer.normalize('09123', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.invalid));
    });

    test('110 -> INVALID', () {
      final res = normalizer.normalize('110', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.invalid));
    });

    test('0912345678 -> INVALID (10 digits starting with 09)', () {
      final res = normalizer.normalize('0912345678', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.invalid));
    });

    test('+98912345678 -> INVALID', () {
      final res = normalizer.normalize('+98912345678', source: NumberSource.phonebook);
      expect(res.status, equals(NumberStatus.invalid));
    });

    test('02112345678 (fixed line)', () {
      final res = normalizer.normalize('02112345678', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+982112345678'));
      expect(res.type, equals(NumberType.fixedLine));
    });

    test('0912 345 6789 ext 12 -> AMBIGUOUS (has extension)', () {
      final res = normalizer.normalize('0912 345 6789 ext 12', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.ambiguous));
      expect(res.hasExtension, isTrue);
    });

    test('+442071838750 -> VALID', () {
      final res = normalizer.normalize('+442071838750', source: NumberSource.phonebook);
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+442071838750'));
    });

    test('07911 123456 (GB) -> VALID', () {
      final res = normalizer.normalize('07911 123456', source: NumberSource.phonebook, defaultRegion: 'GB');
      expect(res.status, equals(NumberStatus.valid));
      expect(res.e164, equals('+447911123456'));
    });

    test('07911 123456 (IR) -> INVALID', () {
      final res = normalizer.normalize('07911 123456', source: NumberSource.phonebook, defaultRegion: 'IR');
      expect(res.status, equals(NumberStatus.invalid));
    });

    test('+8881234567 (telegram) -> ANONYMOUS_TG', () {
      final res = normalizer.normalize('8881234567', source: NumberSource.telegram);
      expect(res.status, equals(NumberStatus.anonymousTg));
      expect(res.e164, equals('+8881234567'));
    });

    test('empty or whitespace -> NO_NUMBER', () {
      final res = normalizer.normalize('   ', source: NumberSource.phonebook);
      expect(res.status, equals(NumberStatus.noNumber));
    });
  });
}
