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

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

    return AppScaffold(
      title: l10n.passwordLabel,
      showBackButton: true,
      onBack: () => controller.dispatch(const CancelFlowEvent()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space16),
            if (widget.state.hint != null)
              InfoBanner(
                message: 'راهنمای رمز: ${widget.state.hint}',
                type: BannerType.info,
              ),
            const SizedBox(height: AppDimensions.space24),
            PasswordField(
              controller: _passwordController,
              label: l10n.passwordLabel,
              onSubmitted: (pwd) {
                if (pwd.isNotEmpty) {
                  controller.submitPassword(pwd);
                }
              },
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        text: l10n.confirm,
        onPressed: () {
          if (_passwordController.text.isNotEmpty) {
            controller.submitPassword(_passwordController.text);
          }
        },
      ),
    );
  }
}
