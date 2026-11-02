import 'package:collection/collection.dart';
import 'package:core_domain/entities/candidate.dart';
import 'package:core_domain/entities/counters.dart';
import 'package:core_domain/entities/normalized_number.dart';
import 'package:core_domain/entities/phone_contact_ref.dart';
import 'package:core_domain/entities/source_contact.dart';
import 'package:core_domain/ports/match_engine.dart';
import 'package:core_domain/ports/name_policy.dart';
import 'package:core_domain/ports/phone_normalizer.dart';
import 'package:core_phone/name_policy_impl.dart';
import 'package:core_phone/phone_normalizer_impl.dart';

enum NumberMatchState {
  already,
  probable,
  isNew,
}

class PhoneBookIndex {
  final Map<String, List<PhoneContactRef>> exact;
  final Map<String, List<PhoneContactRef>> suffix9;

  const PhoneBookIndex({
    required this.exact,
    required this.suffix9,
  });
}

class MatchEngineImpl implements MatchEngine {
  final PhoneNormalizer normalizer;
  final NamePolicy namePolicy;

  const MatchEngineImpl({
    this.normalizer = const PhoneNormalizerImpl(),
    this.namePolicy = const DefaultNamePolicy(),
  });

  @override
  AnalysisResult analyze(AnalysisInput input) {
    // 1. Build PhoneBookIndex
    final pbIndex = _buildPhoneBookIndex(input.phoneContacts, input.defaultRegion);

    // 2. Normalize and analyze Telegram contacts
    int tgReceived = input.telegramContacts.length;
    int tgNoNumber = 0;
    int numbersExtracted = 0;
    int numbersInvalid = 0;
    int numbersAmbiguous = 0;
    int numbersAnonymous = 0;
    int numbersValid = 0;

    final normalizedTgContacts = <SourceContact>[];
    for (final contact in input.telegramContacts) {
      if (contact.rawPhoneNumbers.isEmpty) {
        tgNoNumber++;
      }
      final normNumbers = <NormalizedNumber>[];
      for (final raw in contact.rawPhoneNumbers) {
        numbersExtracted++;
        final norm = normalizer.normalize(
          raw,
          source: NumberSource.telegram,
          defaultRegion: input.defaultRegion,
        );
        switch (norm.status) {
          case NumberStatus.valid:
            numbersValid++;
            normNumbers.add(norm);
          case NumberStatus.invalid:
            numbersInvalid++;
          case NumberStatus.ambiguous:
            numbersAmbiguous++;
          case NumberStatus.anonymousTg:
            numbersAnonymous++;
          case NumberStatus.noNumber:
            break;
        }
      }
      normalizedTgContacts.add(contact.copyWith(normalizedNumbers: normNumbers));
    }

    // 3. Classify valid numbers and find owners
    final numberStates = <String, NumberMatchState>{};
    final owners = <String, SourceContact>{};
    final alternativeNamesMap = <String, List<String>>{};
    final validNumberOccurrences = <String, int>{};

    final sortedContacts = normalizedTgContacts.sortedBy<num>((c) => c.userId);

    for (final c in sortedContacts) {
      final sanitizedContactName = namePolicy.buildDisplayName(c.firstName, c.lastName);
      for (final n in c.normalizedNumbers) {
        final e164 = n.e164!;
        validNumberOccurrences[e164] = (validNumberOccurrences[e164] ?? 0) + 1;

        // Owner rule (most complete name, then longest, tie-break lowest userId)
        final prevOwner = owners[e164];
        if (prevOwner == null) {
          owners[e164] = c;
        } else if (_isBetterOwner(c, prevOwner)) {
          final prevName = namePolicy.buildDisplayName(prevOwner.firstName, prevOwner.lastName);
          if (prevName.isNotEmpty) {
            alternativeNamesMap.putIfAbsent(e164, () => []).add(prevName);
          }
          owners[e164] = c;
        } else {
          if (sanitizedContactName.isNotEmpty) {
            alternativeNamesMap.putIfAbsent(e164, () => []).add(sanitizedContactName);
          }
        }

        // Tiers matching
        if (!numberStates.containsKey(e164)) {
          if (pbIndex.exact.containsKey(e164)) {
            numberStates[e164] = NumberMatchState.already;
          } else {
            final last9 = _last9(n.digitsOnly);
            if (last9 != null && pbIndex.suffix9.containsKey(last9)) {
              numberStates[e164] = NumberMatchState.probable;
            } else {
              numberStates[e164] = NumberMatchState.isNew;
            }
          }
        }
      }
    }

    // Calculate unique valid and duplicates
    final uniqueValid = numberStates.length;
    int numbersDupInsideTelegram = 0;
    for (final count in validNumberOccurrences.values) {
      if (count > 1) {
        numbersDupInsideTelegram += (count - 1);
      }
    }

    int numbersAlreadyInPhone = 0;
    int numbersProbablyInPhone = 0;
    int numbersNew = 0;
    for (final state in numberStates.values) {
      switch (state) {
        case NumberMatchState.already:
          numbersAlreadyInPhone++;
        case NumberMatchState.probable:
          numbersProbablyInPhone++;
        case NumberMatchState.isNew:
          numbersNew++;
      }
    }

    // 4. Build Candidates
    final candidates = _buildCandidates(
      contacts: sortedContacts,
      owners: owners,
      numberStates: numberStates,
      pbIndex: pbIndex,
      alternativeNamesMap: alternativeNamesMap,
    );

    int candidatesNew = 0;
    int candidatesRelated = 0;
    int candidatesReview = 0;
    for (final c in candidates) {
      switch (c.kind) {
        case CandidateKind.newContact:
          candidatesNew++;
        case CandidateKind.relatedToExisting:
          candidatesRelated++;
        case CandidateKind.needsReview:
          candidatesReview++;
      }
    }

    // 5. Total phone numbers in address book
    int phoneBookNumbers = 0;
    for (final p in input.phoneContacts) {
      phoneBookNumbers += p.rawPhoneNumbers.length;
    }

    final counters = ReportCounters(
      tgReceived: tgReceived,
      tgNoNumber: tgNoNumber,
      numbersExtracted: numbersExtracted,
      numbersInvalid: numbersInvalid,
      numbersAmbiguous: numbersAmbiguous,
      numbersAnonymous: numbersAnonymous,
      numbersValid: numbersValid,
      numbersDupInsideTelegram: numbersDupInsideTelegram,
      uniqueValid: uniqueValid,
      numbersAlreadyInPhone: numbersAlreadyInPhone,
      numbersProbablyInPhone: numbersProbablyInPhone,
      numbersNew: numbersNew,
      phoneBookContacts: input.phoneContacts.length,
      phoneBookNumbers: phoneBookNumbers,
      candidatesNew: candidatesNew,
      candidatesRelated: candidatesRelated,
      candidatesReview: candidatesReview,
      selected: candidates.where((c) => c.selected).length,
    );

    counters.assertIdentities(validateWrite: false);

    return AnalysisResult(candidates: candidates, counters: counters);
  }

  PhoneBookIndex _buildPhoneBookIndex(
    List<PhoneBookContactInput> contacts,
    String defaultRegion,
  ) {
    final exact = <String, List<PhoneContactRef>>{};
    final suffix9 = <String, List<PhoneContactRef>>{};

    for (final contact in contacts) {
      final ref = PhoneContactRef(
        contactId: contact.contactId,
        displayName: contact.displayName,
        accountLabel: contact.accountLabel,
      );

      for (final raw in contact.rawPhoneNumbers) {
        final norm = normalizer.normalize(
          raw,
          source: NumberSource.phonebook,
          defaultRegion: defaultRegion,
        );

        if (norm.isValid && norm.e164 != null) {
          exact.putIfAbsent(norm.e164!, () => []).add(ref);
        }

        // Suffix9 index is built ONLY from phonebook numbers that were INVALID or assumedRegion == true (SRS §7.2)
        if (!norm.isValid || norm.assumedRegion) {
          final s9 = _last9(norm.digitsOnly);
          if (s9 != null) {
            suffix9.putIfAbsent(s9, () => []).add(ref);
          }
        }
      }
    }

    return PhoneBookIndex(exact: exact, suffix9: suffix9);
  }

  bool _isBetterOwner(SourceContact candidate, SourceContact current) {
    final cName = namePolicy.buildDisplayName(candidate.firstName, candidate.lastName);
    final curName = namePolicy.buildDisplayName(current.firstName, current.lastName);

    final cHasBoth = candidate.firstName.isNotEmpty && candidate.lastName.isNotEmpty;
    final curHasBoth = current.firstName.isNotEmpty && current.lastName.isNotEmpty;

    if (cHasBoth && !curHasBoth) return true;
    if (!cHasBoth && curHasBoth) return false;

    if (cName.length > curName.length) return true;
    if (cName.length < curName.length) return false;

    // Tie-break by lowest userId
    return candidate.userId < current.userId;
  }

  String? _last9(String digitsOnly) {
    if (digitsOnly.length < 9) return null;
    return digitsOnly.substring(digitsOnly.length - 9);
  }

  List<ImportCandidate> _buildCandidates({
    required List<SourceContact> contacts,
    required Map<String, SourceContact> owners,
    required Map<String, NumberMatchState> numberStates,
    required PhoneBookIndex pbIndex,
    required Map<String, List<String>> alternativeNamesMap,
  }) {
    // Group NEW and PROBABLE numbers by owner contact
    final ownerNumbers = <int, List<NormalizedNumber>>{};
    for (final entry in owners.entries) {
      final e164 = entry.key;
      final owner = entry.value;
      final state = numberStates[e164];
      if (state == NumberMatchState.isNew || state == NumberMatchState.probable) {
        final norm = owner.normalizedNumbers.firstWhere((n) => n.e164 == e164);
        ownerNumbers.putIfAbsent(owner.userId, () => []).add(norm);
      }
    }

    final candidates = <ImportCandidate>[];
    int candidateCounter = 0;

    for (final c in contacts) {
      final newNumbers = ownerNumbers[c.userId];
      if (newNumbers == null || newNumbers.isEmpty) {
        continue;
      }

      candidateCounter++;
      final id = 'candidate_$candidateCounter';

      // Sanitized name
      final sanitized = namePolicy.sanitize(
        namePolicy.buildDisplayName(c.firstName, c.lastName),
      );

      final warnings = <CandidateWarning>{};
      if (sanitized.isEmpty) {
        warnings.add(CandidateWarning.nameMissing);
      }
      if (sanitized.isTruncated) {
        warnings.add(CandidateWarning.nameTruncated);
      }

      // Check kind rules:
      // RELATED_TO_EXISTING: c has at least one other number with state ALREADY
      final hasAlreadyInPhone = c.normalizedNumbers.any(
        (n) => numberStates[n.e164] == NumberMatchState.already,
      );

      final hasProbableInPhone = newNumbers.any(
        (n) => numberStates[n.e164] == NumberMatchState.probable,
      );

      CandidateKind kind;
      bool selected;
      final relatedPhoneContacts = <PhoneContactRef>[];

      if (hasAlreadyInPhone) {
        kind = CandidateKind.relatedToExisting;
        warnings.add(CandidateWarning.siblingNumber);
        selected = false; // Sibling items unchecked by default (D-07)

        // Find existing phone contact refs
        for (final n in c.normalizedNumbers) {
          if (numberStates[n.e164] == NumberMatchState.already) {
            final refs = pbIndex.exact[n.e164];
            if (refs != null) {
              relatedPhoneContacts.addAll(refs);
            }
          }
        }
      } else if (hasProbableInPhone) {
        kind = CandidateKind.needsReview;
        warnings.add(CandidateWarning.probableMatch);
        selected = false;
      } else {
        kind = CandidateKind.newContact;
        selected = !sanitized.isEmpty; // selected by default if name exists
      }

      // Collect alternative names
      final altNames = <String>{};
      for (final n in newNumbers) {
        final alts = alternativeNamesMap[n.e164];
        if (alts != null) {
          altNames.addAll(alts);
        }
      }
      if (altNames.length > 1) {
        warnings.add(CandidateWarning.multipleAlternativeNames);
      }

      candidates.add(
        ImportCandidate(
          id: id,
          displayName: sanitized.name,
          numbers: newNumbers,
          kind: kind,
          sourceTgUserIds: [c.userId],
          relatedPhoneContacts: relatedPhoneContacts,
          alternativeNames: altNames.toList(),
          warnings: warnings,
          selected: selected,
        ),
      );
    }

    return candidates;
  }
}
