import 'package:core_domain/entities/candidate.dart';
import 'package:core_domain/ports/match_engine.dart';
import 'package:core_domain/ports/phone_book_reader.dart';
import 'package:core_domain/ports/phone_book_writer.dart';
import 'src/contacts_api.g.dart';

class PhoneBookAdapter implements PhoneBookReader, PhoneBookWriter {
  final ContactsHostApi _api;

  PhoneBookAdapter({ContactsHostApi? api}) : _api = api ?? ContactsHostApi();

  @override
  Future<ContactsPermissionStatus> checkPermission() async {
    final status = await _api.getPermissionStatus();
    return _mapPermissionStatus(status);
  }

  @override
  Future<ContactsPermissionStatus> requestPermission() async {
    final status = await _api.requestPermission();
    return _mapPermissionStatus(status);
  }

  @override
  Future<List<PhoneBookContactInput>> readAllContacts() async {
    final nativeList = await _api.readAllContacts();
    return nativeList.map((nc) {
      final numbers = (nc.phoneNumbers)
          .whereType<String>()
          .where((s) => s.trim().isNotEmpty)
          .toList();

      return PhoneBookContactInput(
        contactId: nc.contactId,
        displayName: nc.displayName,
        rawPhoneNumbers: numbers,
        accountLabel: nc.accountLabel,
      );
    }).toList();
  }

  @override
  Future<WriteResult> writeBatch({
    required List<ImportCandidate> candidates,
    required String? destinationAccount,
    void Function(int processed, int total)? onProgress,
  }) async {
    const batchSize = 50;
    final successfullyAdded = <String>[];
    final failedIds = <String>[];
    final createdRecordIds = <String>[];

    // Destination account parsing (format: "name:type" or null)
    String? accountName;
    String? accountType;
    if (destinationAccount != null && destinationAccount.contains(':')) {
      final parts = destinationAccount.split(':');
      accountName = parts[0];
      accountType = parts[1];
    } else {
      accountName = destinationAccount;
    }

    int processed = 0;
    for (int i = 0; i < candidates.length; i += batchSize) {
      final chunk = candidates.sublist(
        i,
        (i + batchSize > candidates.length) ? candidates.length : i + batchSize,
      );

      final nativeCandidates = chunk.map((c) {
        return NativeCandidate(
          id: c.id,
          displayName: c.displayName,
          numbers: c.numbers.map((n) => n.e164 ?? n.raw).toList(),
        );
      }).toList();

      try {
        final result = await _api.writeContactsBatch(
          nativeCandidates,
          accountName,
          accountType,
        );

        for (final id in result.successfullyAddedIds.whereType<String>()) {
          successfullyAdded.add(id);
        }
        for (final id in result.failedCandidateIds.whereType<String>()) {
          failedIds.add(id);
        }
        for (final recId in result.createdRecordIds.whereType<String>()) {
          createdRecordIds.add(recId);
        }
      } catch (e) {
        // Fallback: report batch as failed
        for (final c in chunk) {
          failedIds.add(c.id);
        }
      }

      processed += chunk.length;
      onProgress?.call(processed, candidates.length);
    }

    return WriteResult(
      successfullyAddedIds: successfullyAdded,
      failedCandidateIds: failedIds,
      skippedDuplicateCandidateIds: const [],
    );
  }

  @override
  Future<int> undoCreatedContacts(List<String> contactIds) async {
    if (contactIds.isEmpty) return 0;
    return await _api.undoCreatedContacts(contactIds);
  }

  Future<List<NativeAccount>> getAvailableAccounts() async {
    return await _api.getAvailableAccounts();
  }

  ContactsPermissionStatus _mapPermissionStatus(NativePermissionStatus status) {
    switch (status) {
      case NativePermissionStatus.granted:
        return ContactsPermissionStatus.granted;
      case NativePermissionStatus.denied:
        return ContactsPermissionStatus.denied;
      case NativePermissionStatus.permanentlyDenied:
        return ContactsPermissionStatus.permanentlyDenied;
      case NativePermissionStatus.limitedIos:
        return ContactsPermissionStatus.limitedIos;
    }
  }
}
