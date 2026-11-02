import 'package:core_domain/entities/candidate.dart';
import 'package:core_domain/entities/normalized_number.dart';
import 'package:core_domain/ports/phone_book_reader.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sink_phonebook/phone_book_adapter.dart';
import 'package:sink_phonebook/src/contacts_api.g.dart';

class FakeContactsHostApi implements ContactsHostApi {
  @override
  final BinaryMessenger? pigeonVar_binaryMessenger = null;

  @override
  final String pigeonVar_messageChannelSuffix = '';

  NativePermissionStatus permissionStatus = NativePermissionStatus.granted;
  List<NativeContact> contactsToReturn = [];
  int undoCountToReturn = 0;

  @override
  Future<NativePermissionStatus> getPermissionStatus() async => permissionStatus;

  @override
  Future<NativePermissionStatus> requestPermission() async => permissionStatus;

  @override
  Future<List<NativeContact>> readAllContacts() async => contactsToReturn;

  @override
  Future<List<NativeAccount>> getAvailableAccounts() async => [
        NativeAccount(
          name: 'Device Local',
          type: 'local',
          isDeviceLocal: true,
          syncsToCloud: false,
        ),
      ];

  @override
  Future<NativeWriteResult> writeContactsBatch(
    List<NativeCandidate> candidates,
    String? accountName,
    String? accountType,
  ) async {
    return NativeWriteResult(
      successfullyAddedIds: candidates.map((c) => c.id).toList(),
      failedCandidateIds: [],
      createdRecordIds: candidates.map((c) => 'rec_${c.id}').toList(),
    );
  }

  @override
  Future<int> undoCreatedContacts(List<String> recordIds) async =>
      undoCountToReturn > 0 ? undoCountToReturn : recordIds.length;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeContactsHostApi fakeApi;
  late PhoneBookAdapter adapter;

  setUp(() {
    fakeApi = FakeContactsHostApi();
    adapter = PhoneBookAdapter(api: fakeApi);
  });

  group('PhoneBookAdapter', () {
    test('maps all permission statuses correctly, including limitedIos', () async {
      fakeApi.permissionStatus = NativePermissionStatus.granted;
      expect(await adapter.checkPermission(), equals(ContactsPermissionStatus.granted));

      fakeApi.permissionStatus = NativePermissionStatus.denied;
      expect(await adapter.checkPermission(), equals(ContactsPermissionStatus.denied));

      fakeApi.permissionStatus = NativePermissionStatus.permanentlyDenied;
      expect(await adapter.checkPermission(), equals(ContactsPermissionStatus.permanentlyDenied));

      fakeApi.permissionStatus = NativePermissionStatus.limitedIos;
      expect(await adapter.checkPermission(), equals(ContactsPermissionStatus.limitedIos));
    });

    test('reads contacts and correctly filters empty numbers', () async {
      fakeApi.contactsToReturn = [
        NativeContact(
          contactId: '1',
          displayName: 'Ali',
          phoneNumbers: ['09121111111', '', '  '],
          accountLabel: 'Google',
        ),
      ];

      final result = await adapter.readAllContacts();
      expect(result.length, equals(1));
      expect(result.first.displayName, equals('Ali'));
      expect(result.first.rawPhoneNumbers, equals(['09121111111']));
    });

    test('writes candidates in batches of 50 and fires onProgress', () async {
      // 120 candidates => 3 batches (50, 50, 20)
      final candidates = List.generate(
        120,
        (i) => ImportCandidate(
          id: 'c_$i',
          displayName: 'Contact $i',
          numbers: const [
            NormalizedNumber(
              raw: '+989120000000',
              e164: '+989120000000',
              digitsOnly: '989120000000',
              assumedRegion: false,
              status: NumberStatus.valid,
            ),
          ],
          kind: CandidateKind.newContact,
          sourceTgUserIds: [i],
          selected: true,
        ),
      );

      final progressUpdates = <int>[];
      final res = await adapter.writeBatch(
        candidates: candidates,
        destinationAccount: null,
        onProgress: (processed, total) {
          progressUpdates.add(processed);
        },
      );

      expect(res.successfullyAddedIds.length, equals(120));
      expect(res.failedCandidateIds, isEmpty);
      expect(progressUpdates, equals([50, 100, 120]));
    });

    test('undo delegates to host api', () async {
      fakeApi.undoCountToReturn = 5;
      final undone = await adapter.undoCreatedContacts(['r1', 'r2', 'r3', 'r4', 'r5']);
      expect(undone, equals(5));
    });
  });
}
