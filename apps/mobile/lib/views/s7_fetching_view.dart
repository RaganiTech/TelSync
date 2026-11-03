import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import '../controllers/providers.dart';

class S7FetchingView extends ConsumerStatefulWidget {
  final FetchingTelegramState state;
  const S7FetchingView({super.key, required this.state});

  @override
  ConsumerState<S7FetchingView> createState() => _S7FetchingViewState();
}

class _S7FetchingViewState extends ConsumerState<S7FetchingView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(importFlowControllerProvider.notifier).fetchTelegramContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'دریافت مخاطبین',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppDimensions.space24),
            Text(
              'در حال دریافت فهرست مخاطبین از تلگرام…',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.titleSize,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              '${widget.state.count} مخاطب دریافت شده',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppTypography.captionSize,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
