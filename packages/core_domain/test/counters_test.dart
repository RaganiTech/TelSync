import 'package:core_domain/entities/counters.dart';
import 'package:test/test.dart';

void main() {
  group('ReportCounters', () {
    test('satisfies all 4 identities with valid data', () {
      // 100 extracted: 5 invalid, 3 ambiguous, 2 anonymous, 90 valid
      // 90 valid, 10 internal duplicates => 80 unique valid
      // 80 unique valid: 50 already, 5 probable, 25 new
      // selected = 25 new: 23 added, 1 failed, 1 skippedAtWrite
      final counters = const ReportCounters(
        tgReceived: 110,
        tgNoNumber: 10,
        numbersExtracted: 100,
        numbersInvalid: 5,
        numbersAmbiguous: 3,
        numbersAnonymous: 2,
        numbersValid: 90,
        numbersDupInsideTelegram: 10,
        uniqueValid: 80,
        numbersAlreadyInPhone: 50,
        numbersProbablyInPhone: 5,
        numbersNew: 25,
        selected: 25,
        added: 23,
        failed: 1,
        skippedAtWrite: 1,
      );

      expect(() => counters.assertIdentities(validateWrite: true), returnsNormally);
    });

    test('fails identity 1 if extracted sum does not match', () {
      final counters = const ReportCounters(
        numbersExtracted: 100,
        numbersInvalid: 5,
        numbersAmbiguous: 3,
        numbersAnonymous: 2,
        numbersValid: 85, // sum is 95 != 100
        numbersDupInsideTelegram: 5,
        uniqueValid: 80,
        numbersAlreadyInPhone: 50,
        numbersProbablyInPhone: 5,
        numbersNew: 25,
      );

      expect(() => counters.assertIdentities(), throwsStateError);
    });

    test('fails identity 2 if uniqueValid does not equal valid minus dups', () {
      final counters = const ReportCounters(
        numbersExtracted: 100,
        numbersInvalid: 5,
        numbersAmbiguous: 3,
        numbersAnonymous: 2,
        numbersValid: 90,
        numbersDupInsideTelegram: 10,
        uniqueValid: 79, // should be 80
        numbersAlreadyInPhone: 50,
        numbersProbablyInPhone: 5,
        numbersNew: 24,
      );

      expect(() => counters.assertIdentities(), throwsStateError);
    });

    test('fails identity 3 if uniqueValid does not equal partition sum', () {
      final counters = const ReportCounters(
        numbersExtracted: 100,
        numbersInvalid: 5,
        numbersAmbiguous: 3,
        numbersAnonymous: 2,
        numbersValid: 90,
        numbersDupInsideTelegram: 10,
        uniqueValid: 80,
        numbersAlreadyInPhone: 50,
        numbersProbablyInPhone: 5,
        numbersNew: 20, // sum is 75 != 80
      );

      expect(() => counters.assertIdentities(), throwsStateError);
    });

    test('fails identity 4 if selected does not match write outcomes when validateWrite=true', () {
      final counters = const ReportCounters(
        numbersExtracted: 100,
        numbersInvalid: 5,
        numbersAmbiguous: 3,
        numbersAnonymous: 2,
        numbersValid: 90,
        numbersDupInsideTelegram: 10,
        uniqueValid: 80,
        numbersAlreadyInPhone: 50,
        numbersProbablyInPhone: 5,
        numbersNew: 25,
        selected: 25,
        added: 20,
        failed: 1,
        skippedAtWrite: 1, // sum is 22 != 25
      );

      expect(() => counters.assertIdentities(validateWrite: true), throwsStateError);
    });
  });
}
