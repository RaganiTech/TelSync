import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/providers.dart';

class S6AuthQrView extends ConsumerWidget {
  final AuthQrState state;
  const S6AuthQrView({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);
    final theme = Theme.of(context);

    final isRealQr = state.link.isNotEmpty &&
        state.link.startsWith('tg://login?token=') &&
        !state.link.contains('simulated_token') &&
        !state.link.contains('auth_token_');
    final link = isRealQr ? state.link : '';

    return AppScaffold(
      title: l10n.isPersian ? 'اسکن کد QR با دستگاه دیگر' : 'Scan QR with Another Device',
      showBackButton: true,
      onBack: () => controller.dispatch(const StartFlowEvent()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space16),

            // Instruction Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.camera_alt_outlined, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.isPersian
                            ? 'مراحل اسکن با کامپیوتر یا گوشی دوم:'
                            : 'Steps to scan with second device:',
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.isPersian
                        ? '۱. در دستگاه دیگر، وارد برنامه تلگرام شوید.\n'
                          '۲. به بخش Settings > Devices > Link Desktop Device بروید.\n'
                          '۳. دوربین آن دستگاه را روی بارکد زیر بگیرید تا اتصال تایید شود.'
                        : '1. Open Telegram on your second device or computer.\n'
                          '2. Go to Settings > Devices > Link Desktop Device.\n'
                          '3. Scan this QR code with the camera to link your session.',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 12,
                      height: 1.7,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.space16),

            // QR Code Widget or Loading Container
            Center(
              child: Container(
                width: 250,
                height: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isRealQr
                        ? const Color(AppColors.telegramBlue)
                        : theme.colorScheme.outline.withValues(alpha: 0.5),
                    width: isRealQr ? 2.0 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isRealQr
                          ? const Color(AppColors.telegramBlue).withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: isRealQr
                    ? QrImageView(
                        data: link,
                        version: QrVersions.auto,
                        size: 210.0,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF1E3A8A),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF0F172A),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 38,
                            height: 38,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(AppColors.telegramBlue)),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            l10n.isPersian
                                ? 'در حال دریافت کد QR معتبر از تلگرام…'
                                : 'Fetching official QR code from Telegram…',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.isPersian
                                ? '(فیلترشکن باید روشن باشد)'
                                : '(VPN must be connected)',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: AppDimensions.space12),

            // Refresh QR Button
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  l10n.isPersian ? 'دریافت مجدد کد QR' : 'Refresh QR Code',
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  controller.refreshQrCode();
                },
              ),
            ),

            const SizedBox(height: AppDimensions.space16),

            // If Telegram is on THIS phone button
            PrimaryButton(
              text: l10n.isPersian
                  ? 'تلگرام روی همین گوشی است؟ (ورود با شماره)'
                  : 'Telegram on this device? (Sign in with phone)',
              icon: const Icon(Icons.phone_iphone_rounded, size: 20),
              backgroundColor: const Color(AppColors.telegramBlue),
              onPressed: () {
                controller.chooseAuthMethod(AuthMethod.phone);
              },
            ),

            const SizedBox(height: AppDimensions.space12),

            SecondaryButton(
              text: l10n.isPersian
                  ? 'تست سریع با داده‌های نمونه (حالت دمو)'
                  : 'Quick Test with Demo Data',
              icon: const Icon(Icons.science_rounded, size: 18),
              borderColor: Colors.amber.shade700,
              foregroundColor: Colors.amber.shade900,
              onPressed: () {
                controller.startDemoMode();
              },
            ),

            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }
}
