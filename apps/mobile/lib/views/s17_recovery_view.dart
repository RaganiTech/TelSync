import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import '../controllers/providers.dart';

class S17RecoveryView extends ConsumerWidget {
  final String? notice;
  const S17RecoveryView({super.key, this.notice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(importFlowControllerProvider.notifier);

    return AppScaffold(
      title: 'بازیابی و پاکسازی امن',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cleaning_services_rounded,
                size: 36,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              'پاکسازی نشست باقی‌مانده',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.titleSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.space12),
            Text(
              notice ?? 'برنامه قبلاً به‌طور غیرمنتظره بسته شده بود. تمام اطلاعات موقت برای امنیت شما پاک شدند.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.bodySize,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space32),
            PrimaryButton(
              text: 'ورود به صفحه اصلی',
              onPressed: () {
                controller.dispatch(const CleanupFinishedEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}
