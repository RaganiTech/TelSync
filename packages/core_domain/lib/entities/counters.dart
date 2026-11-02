import 'package:meta/meta.dart';

@immutable
class ReportCounters {
  final int tgReceived;
  final int tgNoNumber;
  final int numbersExtracted;
  final int numbersInvalid;
  final int numbersAmbiguous;
  final int numbersAnonymous;
  final int numbersValid;
  final int numbersDupInsideTelegram;
  final int uniqueValid;
  final int numbersAlreadyInPhone;
  final int numbersProbablyInPhone;
  final int numbersNew;
  final int phoneBookContacts;
  final int phoneBookNumbers;
  final int candidatesNew;
  final int candidatesRelated;
  final int candidatesReview;
  final int selected;
  final int added;
  final int failed;
  final int skippedAtWrite;

  const ReportCounters({
    this.tgReceived = 0,
    this.tgNoNumber = 0,
    this.numbersExtracted = 0,
    this.numbersInvalid = 0,
    this.numbersAmbiguous = 0,
    this.numbersAnonymous = 0,
    this.numbersValid = 0,
    this.numbersDupInsideTelegram = 0,
    this.uniqueValid = 0,
    this.numbersAlreadyInPhone = 0,
    this.numbersProbablyInPhone = 0,
    this.numbersNew = 0,
    this.phoneBookContacts = 0,
    this.phoneBookNumbers = 0,
    this.candidatesNew = 0,
    this.candidatesRelated = 0,
    this.candidatesReview = 0,
    this.selected = 0,
    this.added = 0,
    this.failed = 0,
    this.skippedAtWrite = 0,
  });

  /// Validates all mathematical identities specified in SRS §7.6.
  /// Throws [StateError] if any identity fails.
  void assertIdentities({bool validateWrite = false}) {
    // 1. numbersExtracted = numbersInvalid + numbersAmbiguous + numbersAnonymous + numbersValid
    final extractedSum = numbersInvalid + numbersAmbiguous + numbersAnonymous + numbersValid;
    if (numbersExtracted != extractedSum) {
      throw StateError(
        'Identity 1 failed: numbersExtracted ($numbersExtracted) != sum ($extractedSum)',
      );
    }

    // 2. uniqueValid = numbersValid - numbersDupInsideTelegram
    final expectedUnique = numbersValid - numbersDupInsideTelegram;
    if (uniqueValid != expectedUnique) {
      throw StateError(
        'Identity 2 failed: uniqueValid ($uniqueValid) != valid - dup ($expectedUnique)',
      );
    }

    // 3. uniqueValid = numbersAlreadyInPhone + numbersProbablyInPhone + numbersNew
    final partitionSum = numbersAlreadyInPhone + numbersProbablyInPhone + numbersNew;
    if (uniqueValid != partitionSum) {
      throw StateError(
        'Identity 3 failed: uniqueValid ($uniqueValid) != sum of partitions ($partitionSum)',
      );
    }

    // 4. selected = added + failed + skippedAtWrite (only when write phase completed)
    if (validateWrite) {
      final writeSum = added + failed + skippedAtWrite;
      if (selected != writeSum) {
        throw StateError(
          'Identity 4 failed: selected ($selected) != added+failed+skipped ($writeSum)',
        );
      }
    }
  }

  ReportCounters copyWith({
    int? tgReceived,
    int? tgNoNumber,
    int? numbersExtracted,
    int? numbersInvalid,
    int? numbersAmbiguous,
    int? numbersAnonymous,
    int? numbersValid,
    int? numbersDupInsideTelegram,
    int? uniqueValid,
    int? numbersAlreadyInPhone,
    int? numbersProbablyInPhone,
    int? numbersNew,
    int? phoneBookContacts,
    int? phoneBookNumbers,
    int? candidatesNew,
    int? candidatesRelated,
    int? candidatesReview,
    int? selected,
    int? added,
    int? failed,
    int? skippedAtWrite,
  }) {
    return ReportCounters(
      tgReceived: tgReceived ?? this.tgReceived,
      tgNoNumber: tgNoNumber ?? this.tgNoNumber,
      numbersExtracted: numbersExtracted ?? this.numbersExtracted,
      numbersInvalid: numbersInvalid ?? this.numbersInvalid,
      numbersAmbiguous: numbersAmbiguous ?? this.numbersAmbiguous,
      numbersAnonymous: numbersAnonymous ?? this.numbersAnonymous,
      numbersValid: numbersValid ?? this.numbersValid,
      numbersDupInsideTelegram: numbersDupInsideTelegram ?? this.numbersDupInsideTelegram,
      uniqueValid: uniqueValid ?? this.uniqueValid,
      numbersAlreadyInPhone: numbersAlreadyInPhone ?? this.numbersAlreadyInPhone,
      numbersProbablyInPhone: numbersProbablyInPhone ?? this.numbersProbablyInPhone,
      numbersNew: numbersNew ?? this.numbersNew,
      phoneBookContacts: phoneBookContacts ?? this.phoneBookContacts,
      phoneBookNumbers: phoneBookNumbers ?? this.phoneBookNumbers,
      candidatesNew: candidatesNew ?? this.candidatesNew,
      candidatesRelated: candidatesRelated ?? this.candidatesRelated,
      candidatesReview: candidatesReview ?? this.candidatesReview,
      selected: selected ?? this.selected,
      added: added ?? this.added,
      failed: failed ?? this.failed,
      skippedAtWrite: skippedAtWrite ?? this.skippedAtWrite,
    );
  }
}
