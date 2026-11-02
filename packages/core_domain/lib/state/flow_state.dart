import 'package:meta/meta.dart';
import '../entities/candidate.dart';
import '../entities/counters.dart';

@immutable
sealed class FlowState {
  const FlowState();
}

class WelcomeState extends FlowState {
  const WelcomeState();
}

class RecoveryCleanupState extends FlowState {
  final String? notice;
  const RecoveryCleanupState({this.notice});
}

class AuthChooseState extends FlowState {
  const AuthChooseState();
}

class AuthQrState extends FlowState {
  final String link;
  final DateTime expiresAt;
  const AuthQrState({required this.link, required this.expiresAt});
}

class AuthPhoneState extends FlowState {
  final String? phoneNumber;
  final String? error;
  const AuthPhoneState({this.phoneNumber, this.error});
}

class AuthCodeState extends FlowState {
  final String phoneNumber;
  final int? timeoutSeconds;
  final String? error;
  const AuthCodeState({
    required this.phoneNumber,
    this.timeoutSeconds,
    this.error,
  });
}

class AuthPasswordState extends FlowState {
  final String? hint;
  final String? error;
  const AuthPasswordState({this.hint, this.error});
}

class FetchingTelegramState extends FlowState {
  final double progress;
  final int count;
  const FetchingTelegramState({this.progress = 0.0, this.count = 0});
}

class PermissionRationaleState extends FlowState {
  const PermissionRationaleState();
}

class PermissionDeniedState extends FlowState {
  final bool permanent;
  final bool isLimitedIos;
  const PermissionDeniedState({
    required this.permanent,
    this.isLimitedIos = false,
  });
}

class ReadingPhoneBookState extends FlowState {
  final double progress;
  final int count;
  const ReadingPhoneBookState({this.progress = 0.0, this.count = 0});
}

class AnalyzingState extends FlowState {
  final double progress;
  const AnalyzingState({this.progress = 0.0});
}

class SummaryState extends FlowState {
  final ReportCounters counters;
  const SummaryState({required this.counters});
}

class PreviewState extends FlowState {
  final List<ImportCandidate> candidates;
  final ReportCounters counters;
  final String? selectedDestination;
  final String searchQuery;

  const PreviewState({
    required this.candidates,
    required this.counters,
    this.selectedDestination,
    this.searchQuery = '',
  });

  int get selectedCount =>
      candidates.where((c) => c.selected).length;

  PreviewState copyWith({
    List<ImportCandidate>? candidates,
    ReportCounters? counters,
    String? selectedDestination,
    String? searchQuery,
  }) {
    return PreviewState(
      candidates: candidates ?? this.candidates,
      counters: counters ?? this.counters,
      selectedDestination: selectedDestination ?? this.selectedDestination,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ConfirmSheetState extends FlowState {
  final PreviewState preview;
  const ConfirmSheetState({required this.preview});
}

class WritingState extends FlowState {
  final int total;
  final int processed;
  final bool isCancelled;
  const WritingState({
    required this.total,
    this.processed = 0,
    this.isCancelled = false,
  });
}

class VerifyingState extends FlowState {
  const VerifyingState();
}

class ReportState extends FlowState {
  final ReportCounters counters;
  final bool undoAvailable;
  final List<String> createdContactIds;

  const ReportState({
    required this.counters,
    this.undoAvailable = false,
    this.createdContactIds = const [],
  });
}

class CleanupState extends FlowState {
  final String? errorNotice;
  final FlowState? nextState;
  const CleanupState({this.errorNotice, this.nextState});
}

class DoneState extends FlowState {
  const DoneState();
}
