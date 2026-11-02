import 'flow_event.dart';
import 'flow_state.dart';
import '../entities/candidate.dart';

FlowState reduce(FlowState state, FlowEvent event) {
  // Global cancel event always transitions to CleanupState
  if (event is CancelFlowEvent) {
    return CleanupState(
      errorNotice: event.reason,
      nextState: const WelcomeState(),
    );
  }

  if (event is CleanupFinishedEvent && state is CleanupState) {
    return state.nextState ?? const WelcomeState();
  }

  switch (state) {
    case WelcomeState():
      if (event is StartFlowEvent) {
        return const AuthChooseState();
      }

    case AuthChooseState():
      if (event is ChooseAuthMethodEvent) {
        if (event.method == AuthMethod.qr) {
          return AuthQrState(
            link: '',
            expiresAt: DateTime.now().add(const Duration(seconds: 30)),
          );
        } else {
          return const AuthPhoneState();
        }
      }

    case AuthQrState():
      if (event is QrLinkUpdatedEvent) {
        return AuthQrState(link: event.link, expiresAt: event.expiresAt);
      }
      if (event is AuthSuccessEvent) {
        return const FetchingTelegramState();
      }

    case AuthPhoneState():
      if (event is SubmitPhoneEvent) {
        return AuthCodeState(phoneNumber: event.phoneNumber);
      }

    case AuthCodeState():
      if (event is SubmitCodeEvent) {
        // Can transition to password (2FA) or fetching
        return const FetchingTelegramState();
      }

    case AuthPasswordState():
      if (event is SubmitPasswordEvent) {
        return const FetchingTelegramState();
      }

    case FetchingTelegramState():
      if (event is TelegramProgressEvent) {
        return FetchingTelegramState(
          progress: event.progress,
          count: event.count,
        );
      }
      if (event is TelegramContactsReadyEvent) {
        return const PermissionRationaleState();
      }

    case PermissionRationaleState():
      if (event is RequestPermissionEvent) {
        return const ReadingPhoneBookState();
      }
      if (event is PermissionResultEvent) {
        if (event.granted) {
          return const ReadingPhoneBookState();
        } else {
          return PermissionDeniedState(
            permanent: event.permanent,
            isLimitedIos: event.isLimitedIos,
          );
        }
      }

    case PermissionDeniedState():
      if (event is PermissionResultEvent && event.granted) {
        return const ReadingPhoneBookState();
      }

    case ReadingPhoneBookState():
      if (event is PhoneBookProgressEvent) {
        return ReadingPhoneBookState(
          progress: event.progress,
          count: event.count,
        );
      }
      if (event is AnalysisCompleteEvent) {
        return SummaryState(counters: event.counters);
      }

    case AnalyzingState():
      if (event is AnalysisCompleteEvent) {
        return SummaryState(counters: event.counters);
      }

    case SummaryState():
      if (event is StartFlowEvent || event is TelegramContactsReadyEvent) {
        // Transition to preview
        return PreviewState(
          candidates: const [],
          counters: state.counters,
        );
      }
      if (event is AnalysisCompleteEvent) {
        return PreviewState(
          candidates: event.candidates,
          counters: event.counters,
        );
      }

    case PreviewState():
      if (event is ToggleCandidateEvent) {
        final updated = state.candidates.map((c) {
          if (c.id == event.candidateId) {
            // Cannot select missing-name candidate without a name
            if (!c.selected && c.warnings.contains(CandidateWarning.nameMissing)) {
              return c;
            }
            return c.copyWith(selected: !c.selected);
          }
          return c;
        }).toList();
        return state.copyWith(candidates: updated);
      }
      if (event is SelectAllEvent) {
        final updated = state.candidates.map((c) {
          if (event.kind == null || c.kind == event.kind) {
            if (event.select && c.warnings.contains(CandidateWarning.nameMissing)) {
              return c;
            }
            return c.copyWith(selected: event.select);
          }
          return c;
        }).toList();
        return state.copyWith(candidates: updated);
      }
      if (event is UpdateCandidateNameEvent) {
        final updated = state.candidates.map((c) {
          if (c.id == event.candidateId) {
            final trimmed = event.newName.trim();
            final newWarnings = Set<CandidateWarning>.from(c.warnings);
            if (trimmed.isEmpty) {
              newWarnings.add(CandidateWarning.nameMissing);
            } else {
              newWarnings.remove(CandidateWarning.nameMissing);
            }
            return c.copyWith(
              displayName: trimmed,
              warnings: newWarnings,
              selected: trimmed.isNotEmpty ? c.selected : false,
            );
          }
          return c;
        }).toList();
        return state.copyWith(candidates: updated);
      }
      if (event is SetDestinationEvent) {
        return state.copyWith(selectedDestination: event.destination);
      }
      if (event is OpenConfirmSheetEvent) {
        return ConfirmSheetState(preview: state);
      }

    case ConfirmSheetState():
      if (event is CloseConfirmSheetEvent) {
        return state.preview;
      }
      if (event is ConfirmWriteEvent) {
        return WritingState(
          total: state.preview.selectedCount,
        );
      }

    case WritingState():
      if (event is WriteProgressEvent) {
        return WritingState(
          total: event.total,
          processed: event.processed,
          isCancelled: state.isCancelled,
        );
      }
      if (event is CancelWriteEvent) {
        return WritingState(
          total: state.total,
          processed: state.processed,
          isCancelled: true,
        );
      }
      if (event is WriteCompleteEvent) {
        return ReportState(
          counters: event.counters,
          undoAvailable: event.createdContactIds.isNotEmpty,
          createdContactIds: event.createdContactIds,
        );
      }

    case VerifyingState():
      if (event is WriteCompleteEvent) {
        return ReportState(
          counters: event.counters,
          undoAvailable: event.createdContactIds.isNotEmpty,
          createdContactIds: event.createdContactIds,
        );
      }

    case ReportState():
      if (event is FinishFlowEvent) {
        return const CleanupState(
          nextState: DoneState(),
        );
      }
      if (event is RequestUndoEvent) {
        return const CleanupState(
          nextState: DoneState(),
        );
      }

    case CleanupState():
      if (event is CleanupFinishedEvent) {
        return state.nextState ?? const WelcomeState();
      }

    case DoneState():
      if (event is StartFlowEvent) {
        return const WelcomeState();
      }

    case RecoveryCleanupState():
      if (event is CleanupFinishedEvent) {
        return const WelcomeState();
      }
  }

  return state;
}
