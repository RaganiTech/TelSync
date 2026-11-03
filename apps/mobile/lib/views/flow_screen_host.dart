import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import '../controllers/providers.dart';
import 's1_welcome_view.dart';
import 's2_auth_choose_view.dart';
import 's3_auth_phone_view.dart';
import 's4_auth_code_view.dart';
import 's5_auth_password_view.dart';
import 's6_auth_qr_view.dart';
import 's7_fetching_view.dart';
import 's8_permission_view.dart';
import 's9_analyzing_view.dart';
import 's10_summary_view.dart';
import 's11_preview_view.dart';
import 's12_confirm_sheet.dart';
import 's13_writing_view.dart';
import 's14_report_view.dart';
import 's17_recovery_view.dart';

class FlowScreenHost extends ConsumerWidget {
  const FlowScreenHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowState = ref.watch(importFlowControllerProvider);

    return switch (flowState) {
      WelcomeState() => const S1WelcomeView(),
      AuthChooseState() => const S2AuthChooseView(),
      AuthPhoneState() => const S3AuthPhoneView(),
      AuthCodeState() => S4AuthCodeView(state: flowState),
      AuthPasswordState() => S5AuthPasswordView(state: flowState),
      AuthQrState() => S6AuthQrView(state: flowState),
      FetchingTelegramState() => S7FetchingView(state: flowState),
      PermissionRationaleState() => const S8PermissionView(),
      PermissionDeniedState() => S8PermissionView(
          isDenied: true,
          isLimited: flowState.isLimitedIos,
          isPermanent: flowState.permanent,
        ),
      ReadingPhoneBookState() => S9AnalyzingView(
          progress: flowState.progress,
          count: flowState.count,
        ),
      AnalyzingState() => S9AnalyzingView(progress: flowState.progress),
      SummaryState() => S10SummaryView(state: flowState),
      PreviewState() => S11PreviewView(state: flowState),
      ConfirmSheetState() => S12ConfirmSheet(state: flowState),
      WritingState() => S13WritingView(state: flowState),
      VerifyingState() => const S13WritingView(
          state: WritingState(total: 0, processed: 0),
        ),
      ReportState() => S14ReportView(state: flowState),
      RecoveryCleanupState() => S17RecoveryView(notice: flowState.notice),
      CleanupState() => S17RecoveryView(notice: flowState.errorNotice),
      DoneState() => const S1WelcomeView(),
    };
  }
}
