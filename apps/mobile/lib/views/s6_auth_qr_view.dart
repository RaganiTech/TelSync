import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/providers.dart';

class S6AuthQrView extends ConsumerWidget {
  final AuthQrState state;
  const S6AuthQrView({super.key, required this.state});

  Future<void> _openTelegram(BuildContext context, String rawLink) async {
    final uri = Uri.parse(rawLink);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'امکان باز کردن مستقیم تلگرام فراهم نشد. لطفاً از گزینه کپی پیوند یا اسکن استفاده کنید.',
            ),
          ),
        );
      }
    }
  }

  void _copyLink(BuildContext context, String link) {
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('پیوند تایید ورود کپی شد.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(importFlowControllerProvider.notifier);
    final theme = Theme.of(context);
    final link = state.link.isNotEmpty ? state.link : 'tg://login?token=simulated_token';

    return AppScaffold(
      title: 'تایید ورود به تلگرام',
      showBackButton: true,
      onBack: () => controller.dispatch(const CancelFlowEvent()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space16),

            // Same Phone Primary Action Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(AppColors.telegramBlue).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(AppColors.telegramBlue).withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(AppColors.telegramBlue),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.smartphone_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'تلگرام روی همین گوشی نصب است؟',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'نیازی به دستگاه دوم یا اسکن با دوربین نیست! کافیست روی دکمه زیر بزنید تا تلگرام روی همین گوشی باز شود و با یک لمس ورود را تایید کنید:',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 12,
                      height: 1.6,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    text: 'باز کردن تلگرام و تایید ورود',
                    icon: const Icon(Icons.send_rounded, size: 20),
                    backgroundColor: const Color(AppColors.telegramBlue),
                    onPressed: () {
                      _openTelegram(context, link);
                    },
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text(
                      'کپی پیوند ورود برای باز کردن دستی در تلگرام',
                      style: TextStyle(fontSize: 11, fontFamily: AppTypography.fontFamily),
                    ),
                    onPressed: () => _copyLink(context, link),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.space24),

            // Divider for 2nd device
            Row(
              children: [
                Expanded(child: Divider(color: theme.colorScheme.outline)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'یا اسکن بارکد با گوشی/تبلت دیگر',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Expanded(child: Divider(color: theme.colorScheme.outline)),
              ],
            ),

            const SizedBox(height: AppDimensions.space16),

            Text(
              'در تلگرام دستگاه دیگر:\nتنظیمات ← دستگاه‌ها ← اتصال دستگاه (Scan QR)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 12,
                height: 1.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),

            const SizedBox(height: AppDimensions.space16),

            // Real QR Code Widget
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: link,
                  version: QrVersions.auto,
                  size: 200.0,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF1E3A8A),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.space24),

            // Alternative methods
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'ورود با شماره',
                    height: 44,
                    icon: const Icon(Icons.phone_rounded, size: 16),
                    onPressed: () {
                      controller.chooseAuthMethod(AuthMethod.phone);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    text: 'حالت دمو (تست)',
                    height: 44,
                    icon: const Icon(Icons.science_rounded, size: 16),
                    borderColor: Colors.amber.shade700,
                    foregroundColor: Colors.amber.shade900,
                    onPressed: () {
                      controller.startDemoMode();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }
}
