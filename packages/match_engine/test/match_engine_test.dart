import 'package:core_domain/entities/candidate.dart';
import 'package:core_domain/entities/source_contact.dart';
import 'package:core_domain/ports/match_engine.dart';
import 'package:match_engine/match_engine_impl.dart';
import 'package:test/test.dart';

void main() {
  const engine = MatchEngineImpl();

  group('MatchEngine - All 14 Scenarios from SRS §17.2', () {
    test('Scenario 1: Same number in both lists (any formatting) -> skipped as ALREADY', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: 'Reza',
            lastName: 'Tehrani',
            rawPhoneNumbers: ['989121111111'], // Telegram format (no +)
          ),
        ],
        phoneContacts: [
          const PhoneBookContactInput(
            contactId: 'p1',
            displayName: 'Reza Phone',
            rawPhoneNumbers: ['0912-111-1111'], // Phone format with formatting
          ),
        ],
      );

      final result = engine.analyze(input);
      expect(result.candidates, isEmpty);
      expect(result.counters.numbersAlreadyInPhone, equals(1));
      expect(result.counters.numbersNew, equals(0));
    });

    test('Scenario 2: Number only in Telegram -> NEW_CONTACT selected by default', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: 'Sara',
            lastName: 'Rad',
            rawPhoneNumbers: ['989122222222'],
          ),
        ],
        phoneContacts: [],
      );

      final result = engine.analyze(input);
      expect(result.candidates.length, equals(1));
      final c = result.candidates.first;
      expect(c.kind, equals(CandidateKind.newContact));
      expect(c.selected, isTrue);
      expect(c.displayName, equals('Sara Rad'));
      expect(c.numbers.first.e164, equals('+989122222222'));
      expect(result.counters.numbersNew, equals(1));
    });

    test('Scenario 3: The Ali Case (D-06): Multi-number with one in phone, one new -> RELATED_TO_EXISTING', () {
      // Telegram: contact "علی" with numbers A (in phone as "Ali Rezaei") and B (not in phone).
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 10,
            firstName: 'علی',
            lastName: '',
            rawPhoneNumbers: [
              '989123333333', // Number A (in phone)
              '989124444444', // Number B (NOT in phone)
            ],
          ),
        ],
        phoneContacts: [
          const PhoneBookContactInput(
            contactId: 'p_ali',
            displayName: 'Ali Rezaei',
            rawPhoneNumbers: ['09123333333'],
          ),
        ],
      );

      final result = engine.analyze(input);
      expect(result.candidates.length, equals(1));
      final c = result.candidates.first;
      expect(c.displayName, equals('علی'));
      expect(c.kind, equals(CandidateKind.relatedToExisting));
      expect(c.selected, isFalse); // Unchecked by default (D-07)
      expect(c.warnings.contains(CandidateWarning.siblingNumber), isTrue);
      expect(c.numbers.length, equals(1));
      expect(c.numbers.first.e164, equals('+989124444444'));
      expect(c.relatedPhoneContacts.first.displayName, equals('Ali Rezaei'));

      expect(result.counters.numbersAlreadyInPhone, equals(1));
      expect(result.counters.numbersNew, equals(1));
      expect(result.counters.candidatesRelated, equals(1));
    });

    test('Scenario 4: Telegram contact with two new numbers, none in phone -> one candidate with both numbers', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 20,
            firstName: 'Mamad',
            lastName: 'Karimi',
            rawPhoneNumbers: ['989125555555', '989126666666'],
          ),
        ],
        phoneContacts: [],
      );

      final result = engine.analyze(input);
      expect(result.candidates.length, equals(1));
      final c = result.candidates.first;
      expect(c.numbers.length, equals(2));
      expect(c.kind, equals(CandidateKind.newContact));
      expect(result.counters.numbersNew, equals(2));
    });

    test('Scenario 5: Two Telegram contacts sharing one new number -> one candidate with owner rule', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 100,
            firstName: 'Hassan',
            lastName: '',
            rawPhoneNumbers: ['989127777777'],
          ),
          const SourceContact(
            userId: 101,
            firstName: 'Hassan',
            lastName: 'Hassani', // More complete name -> owner
            rawPhoneNumbers: ['989127777777'],
          ),
        ],
        phoneContacts: [],
      );

      final result = engine.analyze(input);
      expect(result.candidates.length, equals(1));
      final c = result.candidates.first;
      expect(c.displayName, equals('Hassan Hassani'));
      expect(c.alternativeNames, contains('Hassan'));
      expect(result.counters.numbersDupInsideTelegram, equals(1));
      expect(result.counters.uniqueValid, equals(1));
    });

    test('Scenario 6: Same number twice in Telegram -> counted in numbersDupInsideTelegram', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: 'A',
            lastName: '1',
            rawPhoneNumbers: ['989128888888'],
          ),
          const SourceContact(
            userId: 2,
            firstName: 'A',
            lastName: '2',
            rawPhoneNumbers: ['989128888888'],
          ),
        ],
        phoneContacts: [],
      );

      final result = engine.analyze(input);
      expect(result.counters.numbersValid, equals(2));
      expect(result.counters.numbersDupInsideTelegram, equals(1));
      expect(result.counters.uniqueValid, equals(1));
    });

    test('Scenario 7: Different names, same number -> name never matters, treated as duplicate', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: 'Doctor',
            lastName: 'Ghadimi',
            rawPhoneNumbers: ['989129999999'],
          ),
        ],
        phoneContacts: [
          const PhoneBookContactInput(
            contactId: 'p_doc',
            displayName: 'Mechanic Mehdi', // Completely different name
            rawPhoneNumbers: ['+989129999999'],
          ),
        ],
      );

      final result = engine.analyze(input);
      expect(result.candidates, isEmpty);
      expect(result.counters.numbersAlreadyInPhone, equals(1));
    });

    test('Scenario 8: Phone-book number assumed region matching suffix9 -> Tier 2 probable duplicate', () {
      // In phonebook: saved without country code or incomplete format matching last 9 digits
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: 'Farhad',
            lastName: 'Aslani',
            rawPhoneNumbers: ['989120001122'],
          ),
        ],
        phoneContacts: [
          const PhoneBookContactInput(
            contactId: 'p_incomplete',
            displayName: 'Farhad Phone',
            rawPhoneNumbers: ['00000000000120001122'], // Suffix9 matches 120001122
          ),
        ],
      );

      final result = engine.analyze(input);
      expect(result.candidates.length, equals(1));
      final c = result.candidates.first;
      expect(c.kind, equals(CandidateKind.needsReview));
      expect(c.selected, isFalse);
      expect(c.warnings.contains(CandidateWarning.probableMatch), isTrue);
      expect(result.counters.numbersProbablyInPhone, equals(1));
    });

    test('Scenario 9: Invalid or ambiguous numbers -> never candidates', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: 'Bad',
            lastName: 'Number',
            rawPhoneNumbers: ['110', '09123', '98912 345 6789 ext 12'],
          ),
        ],
        phoneContacts: [],
      );

      final result = engine.analyze(input);
      expect(result.candidates, isEmpty);
      expect(result.counters.numbersInvalid, equals(2));
      expect(result.counters.numbersAmbiguous, equals(1));
      expect(result.counters.numbersValid, equals(0));
    });

    test('Scenario 10: Telegram contact without number -> counted, not added', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: 'No',
            lastName: 'Phone',
            rawPhoneNumbers: [],
          ),
        ],
        phoneContacts: [],
      );

      final result = engine.analyze(input);
      expect(result.candidates, isEmpty);
      expect(result.counters.tgNoNumber, equals(1));
    });

    test('Scenario 11: Empty name -> unselected, requires user input', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: '   ',
            lastName: '',
            rawPhoneNumbers: ['989121234567'],
          ),
        ],
        phoneContacts: [],
      );

      final result = engine.analyze(input);
      expect(result.candidates.length, equals(1));
      final c = result.candidates.first;
      expect(c.displayName, equals(''));
      expect(c.selected, isFalse);
      expect(c.warnings.contains(CandidateWarning.nameMissing), isTrue);
    });

    test('Scenario 12: Name with RLO character -> sanitized', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: '\u202EEvil',
            lastName: 'User\u202C',
            rawPhoneNumbers: ['989121234567'],
          ),
        ],
        phoneContacts: [],
      );

      final result = engine.analyze(input);
      final c = result.candidates.first;
      expect(c.displayName, equals('Evil User'));
      expect(c.displayName.contains('\u202E'), isFalse);
    });

    test('Scenario 13: A phone number appearing in several phone contacts -> nothing deleted, TG copy skipped', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: 'Shared',
            lastName: 'Number',
            rawPhoneNumbers: ['989121112233'],
          ),
        ],
        phoneContacts: [
          const PhoneBookContactInput(
            contactId: 'p1',
            displayName: 'Contact 1',
            rawPhoneNumbers: ['09121112233'],
          ),
          const PhoneBookContactInput(
            contactId: 'p2',
            displayName: 'Contact 2',
            rawPhoneNumbers: ['09121112233'],
          ),
        ],
      );

      final result = engine.analyze(input);
      expect(result.candidates, isEmpty);
      expect(result.counters.numbersAlreadyInPhone, equals(1));
    });

    test('Scenario 14: All §7.6 identities hold across comprehensive mixed inputs', () {
      final input = AnalysisInput(
        telegramContacts: [
          const SourceContact(
            userId: 1,
            firstName: 'Ali',
            lastName: 'A',
            rawPhoneNumbers: ['989121111111', '989122222222'],
          ),
          const SourceContact(
            userId: 2,
            firstName: 'Sara',
            lastName: 'B',
            rawPhoneNumbers: ['989123333333', 'invalid_num'],
          ),
          const SourceContact(
            userId: 3,
            firstName: 'Duplicate',
            lastName: 'User',
            rawPhoneNumbers: ['989122222222'], // duplicate of Ali's second number
          ),
          const SourceContact(
            userId: 4,
            firstName: 'Empty',
            lastName: 'User',
            rawPhoneNumbers: [],
          ),
        ],
        phoneContacts: [
          const PhoneBookContactInput(
            contactId: 'p1',
            displayName: 'Ali in Phone',
            rawPhoneNumbers: ['+989121111111'],
          ),
        ],
      );

      final result = engine.analyze(input);
      expect(() => result.counters.assertIdentities(validateWrite: false), returnsNormally);
    });
  });
}
