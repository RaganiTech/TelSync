import '../entities/candidate.dart';
import '../entities/counters.dart';
import '../entities/phone_contact_ref.dart';
import '../entities/source_contact.dart';

class AnalysisInput {
  final List<SourceContact> telegramContacts;
  final List<PhoneBookContactInput> phoneContacts;
  final String defaultRegion;

  const AnalysisInput({
    required this.telegramContacts,
    required this.phoneContacts,
    this.defaultRegion = 'IR',
  });
}

class PhoneBookContactInput {
  final String contactId;
  final String displayName;
  final List<String> rawPhoneNumbers;
  final String? accountLabel;

  const PhoneBookContactInput({
    required this.contactId,
    required this.displayName,
    required this.rawPhoneNumbers,
    this.accountLabel,
  });
}

class AnalysisResult {
  final List<ImportCandidate> candidates;
  final ReportCounters counters;

  const AnalysisResult({
    required this.candidates,
    required this.counters,
  });
}

abstract interface class MatchEngine {
  AnalysisResult analyze(AnalysisInput input);
}
