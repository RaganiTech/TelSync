import 'package:flutter/material.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';

class S13WritingView extends StatelessWidget {
  final WritingState state;
  const S13WritingView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final percent = state.total > 0 ? (state.processed / state.total) : 0.0;

    return AppScaffold(
      title: l10n.writing,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: percent > 0 ? percent : null,
                strokeWidth: 6,
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              l10n.writing,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.titleSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.space12),
            Text(
              '${state.processed} از ${state.total} مخاطب اضافه شد',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.bodySize,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              'دسته‌ها در بسته‌های ۵۰ تایی با امنیت بالا ذخیره می‌شوند.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.captionSize,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
