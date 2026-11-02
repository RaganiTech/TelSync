import 'package:core_domain/entities/candidate.dart';
import 'package:core_domain/entities/counters.dart';
import 'package:core_domain/entities/normalized_number.dart';
import 'package:core_domain/state/flow_event.dart';
import 'package:core_domain/state/flow_reducer.dart';
import 'package:core_domain/state/flow_state.dart';
import 'package:test/test.dart';

void main() {
  group('FlowReducer State Machine', () {
    test('happy path: full flow from Welcome to Done', () {
      FlowState state = const WelcomeState();

      // Welcome -> AuthChoose
      state = reduce(state, const StartFlowEvent());
      expect(state, isA<AuthChooseState>());

      // AuthChoose -> AuthQr
      state = reduce(state, const ChooseAuthMethodEvent(AuthMethod.qr));
      expect(state, isA<AuthQrState>());

      // AuthQr -> FetchingTelegram
      state = reduce(state, const AuthSuccessEvent());
      expect(state, isA<FetchingTelegramState>());

      // FetchingTelegram -> PermissionRationale
      state = reduce(state, const TelegramContactsReadyEvent());
      expect(state, isA<PermissionRationaleState>());

      // PermissionRationale -> ReadingPhoneBook
      state = reduce(state, const PermissionResultEvent(granted: true));
      expect(state, isA<ReadingPhoneBookState>());

      // ReadingPhoneBook -> Summary
      const counters = ReportCounters();
      state = reduce(
        state,
        const AnalysisCompleteEvent(candidates: [], counters: counters),
      );
      expect(state, isA<SummaryState>());

      // Summary -> Preview
      final candidate = ImportCandidate(
        id: 'c1',
        displayName: 'Test User',
        numbers: const [
          NormalizedNumber(
            raw: '+989123456789',
            e164: '+989123456789',
            digitsOnly: '989123456789',
            assumedRegion: false,
            status: NumberStatus.valid,
          ),
        ],
        kind: CandidateKind.newContact,
        sourceTgUserIds: const [123],
        selected: true,
      );

      state = reduce(
        state,
        AnalysisCompleteEvent(candidates: [candidate], counters: counters),
      );
      expect(state, isA<PreviewState>());
      expect((state as PreviewState).selectedCount, equals(1));

      // Toggle candidate
      state = reduce(state, const ToggleCandidateEvent('c1'));
      expect((state as PreviewState).selectedCount, equals(0));

      // Toggle back
      state = reduce(state, const ToggleCandidateEvent('c1'));
      expect((state as PreviewState).selectedCount, equals(1));

      // Preview -> ConfirmSheet
      state = reduce(state, const OpenConfirmSheetEvent());
      expect(state, isA<ConfirmSheetState>());

      // ConfirmSheet -> Writing
      state = reduce(state, const ConfirmWriteEvent());
      expect(state, isA<WritingState>());

      // Writing -> Report
      state = reduce(
        state,
        const WriteCompleteEvent(counters: counters, createdContactIds: ['rec_1']),
      );
      expect(state, isA<ReportState>());
      expect((state as ReportState).undoAvailable, isTrue);

      // Report -> Cleanup -> Done
      state = reduce(state, const FinishFlowEvent());
      expect(state, isA<CleanupState>());

      state = reduce(state, const CleanupFinishedEvent());
      expect(state, isA<DoneState>());
    });

    test('cancel at any point leads to CleanupState and back to Welcome', () {
      FlowState state = const FetchingTelegramState();
      state = reduce(state, const CancelFlowEvent('user cancelled'));
      expect(state, isA<CleanupState>());
      expect((state as CleanupState).errorNotice, equals('user cancelled'));

      state = reduce(state, const CleanupFinishedEvent());
      expect(state, isA<WelcomeState>());
    });

    test('candidate with missing name cannot be selected until given a name', () {
      final missingNameCandidate = ImportCandidate(
        id: 'c_missing',
        displayName: '',
        numbers: const [
          NormalizedNumber(
            raw: '+989123456789',
            e164: '+989123456789',
            digitsOnly: '989123456789',
            assumedRegion: false,
            status: NumberStatus.valid,
          ),
        ],
        kind: CandidateKind.newContact,
        sourceTgUserIds: const [123],
        warnings: const {CandidateWarning.nameMissing},
        selected: false,
      );

      FlowState state = PreviewState(
        candidates: [missingNameCandidate],
        counters: const ReportCounters(),
      );

      // Attempt to toggle selection without entering a name
      state = reduce(state, const ToggleCandidateEvent('c_missing'));
      expect((state as PreviewState).candidates.first.selected, isFalse);

      // Update name
      state = reduce(
        state,
        const UpdateCandidateNameEvent(
          candidateId: 'c_missing',
          newName: 'Reza Ahmadi',
        ),
      );
      final updated = (state as PreviewState).candidates.first;
      expect(updated.displayName, equals('Reza Ahmadi'));
      expect(updated.warnings.contains(CandidateWarning.nameMissing), isFalse);

      // Now toggle selection succeeds
      state = reduce(state, const ToggleCandidateEvent('c_missing'));
      expect((state as PreviewState).candidates.first.selected, isTrue);
    });
  });
}
