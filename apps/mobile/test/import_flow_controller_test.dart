import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:mobile/controllers/providers.dart';
import 'package:sink_phonebook/sink_phonebook.dart';

class MockPhoneBookAdapter extends Fake implements PhoneBookAdapter {
  final List<String> insertedIds = [];

  @override
  Future<ContactsPermissionStatus> requestPermission() async =>
      ContactsPermissionStatus.granted;

  @override
  Future<List<PhoneBookContactInput>> readAllContacts() async {
    return [
      const PhoneBookContactInput(
        contactId: 'p1',
        displayName: 'مخاطب تستی',
        rawPhoneNumbers: ['+989121111111'],
      ),
    ];
  }

  @override
  Future<WriteResult> writeBatch({
    required List<ImportCandidate> candidates,
    required String? destinationAccount,
    void Function(int processed, int total)? onProgress,
  }) async {
    final ids = candidates.map((c) => c.id).toList();
    insertedIds.addAll(ids);
    onProgress?.call(ids.length, ids.length);
    return WriteResult(
      successfullyAddedIds: ids,
      failedCandidateIds: const [],
      skippedDuplicateCandidateIds: const [],
    );
  }

  @override
  Future<int> undoCreatedContacts(List<String> contactIds) async {
    final count = contactIds.length;
    insertedIds.clear();
    return count;
  }
}

void main() {
  group('ImportFlowController full lifecycle test', () {
    late ProviderContainer container;
    late MockPhoneBookAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockPhoneBookAdapter();
      container = ProviderContainer(
        overrides: [
          phoneBookAdapterProvider.overrideWithValue(mockAdapter),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Transitions from Welcome through Auth to Summary and Preview', () async {
      final controller = container.read(importFlowControllerProvider.notifier);

      expect(container.read(importFlowControllerProvider), isA<WelcomeState>());

      controller.startImport();
      expect(container.read(importFlowControllerProvider), isA<AuthChooseState>());

      controller.chooseAuthMethod(AuthMethod.phone);
      expect(container.read(importFlowControllerProvider), isA<AuthPhoneState>());

      controller.submitPhoneNumber('+989123456789');
      expect(container.read(importFlowControllerProvider), isA<AuthCodeState>());

      controller.submitCode('12345');
      controller.simulateAuthSuccess();
      expect(container.read(importFlowControllerProvider), isA<FetchingTelegramState>());

      await controller.fetchTelegramContacts(mockContacts: [
        const SourceContact(
          userId: 1001,
          firstName: 'مخاطب جدید',
          lastName: 'تلگرام',
          rawPhoneNumbers: ['+989122222222'],
        ),
      ]);
      expect(container.read(importFlowControllerProvider), isA<PermissionRationaleState>());

      await controller.requestPhonePermission(mockGranted: true);
      expect(container.read(importFlowControllerProvider), isA<SummaryState>());

      controller.proceedToPreview();
      final previewState = container.read(importFlowControllerProvider);
      expect(previewState, isA<PreviewState>());

      final preview = previewState as PreviewState;
      expect(preview.candidates.length, equals(1));
      expect(preview.candidates.first.selected, isTrue);

      controller.openConfirmSheet();
      expect(container.read(importFlowControllerProvider), isA<ConfirmSheetState>());

      await controller.confirmAndWrite(adapterOverride: mockAdapter);
      final reportState = container.read(importFlowControllerProvider);
      expect(reportState, isA<ReportState>());
      expect((reportState as ReportState).undoAvailable, isTrue);
      expect(mockAdapter.insertedIds.length, equals(1));

      await controller.undo(adapterOverride: mockAdapter);
      expect(mockAdapter.insertedIds.isEmpty, isTrue);

      await controller.finishFlow();
      expect(container.read(importFlowControllerProvider), isA<DoneState>());

      controller.dispatch(const StartFlowEvent());
      expect(container.read(importFlowControllerProvider), isA<WelcomeState>());
    });
  });
}
