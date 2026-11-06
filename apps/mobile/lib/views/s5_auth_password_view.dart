import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S5AuthPasswordView extends ConsumerStatefulWidget {
  final AuthPasswordState state;
  const S5AuthPasswordView({super.key, required this.state});

  @override
  ConsumerState<S5AuthPasswordView> createState() => _S5AuthPasswordViewState();
}

class _S5AuthPasswordViewState extends ConsumerState<S5AuthPasswordView> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    final l10n = AppLocalizations.of(context);
    final pwd = _passwordController.text.trim();
    if (pwd.isEmpty) {
      setState(() {
        _errorMessage = l10n.isPersian
            ? 'لطفاً رمز عبور دومرحله‌ای خود را وارد کنید.'
            : 'Please enter your two-step verification password.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final controller = ref.read(importFlowControllerProvider.notifier);
    final res = await controller.submitPassword(pwd);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res != null && res['@type'] == 'error') {
      final msg = res['message']?.toString() ?? '';
      final l10n = AppLocalizations.of(context);
      String userMsg = l10n.password2faErrorInvalid;
      if (!msg.contains('PASSWORD_HASH_INVALID')) {
        userMsg = 'خطا در بررسی رمز: $msg';
      }
      setState(() {
        _errorMessage = userMsg;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userMsg),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);
    final theme = Theme.of(context);

    return AppScaffold(
      title: l10n.password2faTitle,
      showBackButton: true,
      onBack: () => controller.chooseAuthMethod(AuthMethod.phone),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space16),

            // 2FA Badge & Header
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(AppColors.telegramBlue).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.password_rounded,
                  color: Color(AppColors.telegramBlue),
                  size: 32,
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.space12),

            Text(
              l10n.password2faSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 13.5,
                height: 1.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),

            const SizedBox(height: AppDimensions.space16),

            // Hint Banner if provided by Telegram
            if (widget.state.hint != null && widget.state.hint!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.space16),
                child: InfoBanner(
                  message: '${l10n.password2faHintPrefix}${widget.state.hint!}',
                  type: BannerType.info,
                ),
              ),

            // Error display if failed
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.space16),
                child: InfoBanner(
                  message: _errorMessage!,
                  type: BannerType.danger,
                ),
              ),

            // Password Field
            PasswordField(
              controller: _passwordController,
              label: l10n.passwordLabel,
              errorText: _errorMessage,
              onSubmitted: (_) => _submit(),
            ),

            const SizedBox(height: AppDimensions.space20),

            PrimaryButton(
              text: l10n.isPersian ? 'تأیید و ورود' : 'Confirm & Sign In',
              icon: const Icon(Icons.check_rounded, size: 20),
              isLoading: _isLoading,
              onPressed: _submit,
            ),

            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }
}
