import 'package:meta/meta.dart';
import '../entities/candidate.dart';
import '../entities/counters.dart';

@immutable
sealed class FlowEvent {
  const FlowEvent();
}

class StartFlowEvent extends FlowEvent {
  const StartFlowEvent();
}

class StartDemoFlowEvent extends FlowEvent {
  const StartDemoFlowEvent();
}

class ChooseAuthMethodEvent extends FlowEvent {
  final AuthMethod method;
  const ChooseAuthMethodEvent(this.method);
}

enum AuthMethod { qr, phone }

class QrLinkUpdatedEvent extends FlowEvent {
  final String link;
  final DateTime expiresAt;
  const QrLinkUpdatedEvent({required this.link, required this.expiresAt});
}

class SubmitPhoneEvent extends FlowEvent {
  final String phoneNumber;
  const SubmitPhoneEvent(this.phoneNumber);
}

class SubmitCodeEvent extends FlowEvent {
  final String code;
  const SubmitCodeEvent(this.code);
}

class RequirePasswordEvent extends FlowEvent {
  final String? hint;
  const RequirePasswordEvent({this.hint});
}

class SubmitPasswordEvent extends FlowEvent {
  final String password;
  const SubmitPasswordEvent(this.password);
}

class AuthSuccessEvent extends FlowEvent {
  const AuthSuccessEvent();
}

class TelegramProgressEvent extends FlowEvent {
  final double progress;
  final int count;
  const TelegramProgressEvent({required this.progress, required this.count});
}

class TelegramContactsReadyEvent extends FlowEvent {
  const TelegramContactsReadyEvent();
}

class RequestPermissionEvent extends FlowEvent {
  const RequestPermissionEvent();
}

class PermissionResultEvent extends FlowEvent {
  final bool granted;
  final bool permanent;
  final bool isLimitedIos;
  const PermissionResultEvent({
    required this.granted,
    this.permanent = false,
    this.isLimitedIos = false,
  });
}

class PhoneBookProgressEvent extends FlowEvent {
  final double progress;
  final int count;
  const PhoneBookProgressEvent({required this.progress, required this.count});
}

class AnalysisCompleteEvent extends FlowEvent {
  final List<ImportCandidate> candidates;
  final ReportCounters counters;
  const AnalysisCompleteEvent({
    required this.candidates,
    required this.counters,
  });
}

class ProceedToPreviewEvent extends FlowEvent {
  const ProceedToPreviewEvent();
}

class ToggleCandidateEvent extends FlowEvent {
  final String candidateId;
  const ToggleCandidateEvent(this.candidateId);
}

class SelectAllEvent extends FlowEvent {
  final CandidateKind? kind;
  final bool select;
  const SelectAllEvent({this.kind, required this.select});
}

class UpdateCandidateNameEvent extends FlowEvent {
  final String candidateId;
  final String newName;
  const UpdateCandidateNameEvent({
    required this.candidateId,
    required this.newName,
  });
}

class SetDestinationEvent extends FlowEvent {
  final String destination;
  const SetDestinationEvent(this.destination);
}

class OpenConfirmSheetEvent extends FlowEvent {
  const OpenConfirmSheetEvent();
}

class CloseConfirmSheetEvent extends FlowEvent {
  const CloseConfirmSheetEvent();
}

class ConfirmWriteEvent extends FlowEvent {
  const ConfirmWriteEvent();
}

class WriteProgressEvent extends FlowEvent {
  final int processed;
  final int total;
  const WriteProgressEvent({required this.processed, required this.total});
}

class CancelWriteEvent extends FlowEvent {
  const CancelWriteEvent();
}

class WriteCompleteEvent extends FlowEvent {
  final ReportCounters counters;
  final List<String> createdContactIds;
  const WriteCompleteEvent({
    required this.counters,
    required this.createdContactIds,
  });
}

class RequestUndoEvent extends FlowEvent {
  const RequestUndoEvent();
}

class FinishFlowEvent extends FlowEvent {
  const FinishFlowEvent();
}

class CancelFlowEvent extends FlowEvent {
  final String? reason;
  const CancelFlowEvent([this.reason]);
}

class CleanupFinishedEvent extends FlowEvent {
  const CleanupFinishedEvent();
}
