import '../entities/candidate.dart';

class WriteResult {
  final List<String> successfullyAddedIds;
  final List<String> failedCandidateIds;
  final List<String> skippedDuplicateCandidateIds;

  const WriteResult({
    required this.successfullyAddedIds,
    required this.failedCandidateIds,
    required this.skippedDuplicateCandidateIds,
  });
}

abstract interface class PhoneBookWriter {
  Future<WriteResult> writeBatch({
    required List<ImportCandidate> candidates,
    required String? destinationAccount,
    void Function(int processed, int total)? onProgress,
  });

  /// Deletes only in-session records created in this run, identified by IDs held in RAM.
  Future<int> undoCreatedContacts(List<String> contactIds);
}
