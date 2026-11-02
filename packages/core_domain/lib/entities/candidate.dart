import 'package:meta/meta.dart';
import 'normalized_number.dart';
import 'phone_contact_ref.dart';

enum CandidateKind {
  newContact,
  relatedToExisting,
  needsReview,
}

enum CandidateWarning {
  nameMissing,
  nameTruncated,
  siblingNumber,
  probableMatch,
  multipleAlternativeNames,
}

@immutable
class ImportCandidate {
  final String id;
  final String displayName;
  final List<NormalizedNumber> numbers;
  final CandidateKind kind;
  final List<int> sourceTgUserIds;
  final List<PhoneContactRef> relatedPhoneContacts;
  final List<String> alternativeNames;
  final Set<CandidateWarning> warnings;
  final bool selected;

  const ImportCandidate({
    required this.id,
    required this.displayName,
    required this.numbers,
    required this.kind,
    required this.sourceTgUserIds,
    this.relatedPhoneContacts = const [],
    this.alternativeNames = const [],
    this.warnings = const {},
    required this.selected,
  });

  ImportCandidate copyWith({
    String? displayName,
    List<NormalizedNumber>? numbers,
    CandidateKind? kind,
    List<int>? sourceTgUserIds,
    List<PhoneContactRef>? relatedPhoneContacts,
    List<String>? alternativeNames,
    Set<CandidateWarning>? warnings,
    bool? selected,
  }) {
    return ImportCandidate(
      id: id,
      displayName: displayName ?? this.displayName,
      numbers: numbers ?? this.numbers,
      kind: kind ?? this.kind,
      sourceTgUserIds: sourceTgUserIds ?? this.sourceTgUserIds,
      relatedPhoneContacts: relatedPhoneContacts ?? this.relatedPhoneContacts,
      alternativeNames: alternativeNames ?? this.alternativeNames,
      warnings: warnings ?? this.warnings,
      selected: selected ?? this.selected,
    );
  }
}
