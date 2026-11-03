import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S18ErrorView extends ConsumerWidget {
  final String? errorMessage;
  final int? floodWaitSeconds;
  final bool isNetworkError;

  const S18ErrorView({
    super.key,
    this.errorMessage,
    this.floodWaitSeconds,
    this.isNetworkError = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

    String message;
    if (floodWaitSeconds != null && floodWaitSeconds! > 0) {
      message = l10n.floodWait(floodWaitSeconds!);
    } else if (isNetworkError) {
      message = l10n.networkError;
    } else {
      message = errorMessage ?? 'خطایی رخ داده است. لطفاً دوباره امتحان کنید.';
    }

    return AppScaffold(
      title: 'خطا',
      showBackButton: true,
      onBack: () => controller.dispatch(const CancelFlowEvent()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              'خطا در برقراری ارتباط',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.titleSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.space12),
            InfoBanner(
              message: message,
              type: BannerType.danger,
            ),
            const SizedBox(height: AppDimensions.space32),
            PrimaryButton(
              text: l10n.retry,
              onPressed: () {
                controller.dispatch(const CancelFlowEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}
