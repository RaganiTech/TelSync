import 'package:flutter/material.dart';
import '../tokens/app_dimensions.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.bottomNavigationBar,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget = leading;
    if (leadingWidget == null && showBackButton) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      );
    }

    return Scaffold(
      appBar: title != null || leadingWidget != null || actions != null
          ? AppBar(
              title: title != null ? Text(title!) : null,
              leading: leadingWidget,
              actions: actions,
            )
          : null,
      body: SafeArea(
        child: SizedBox.expand(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenGutter,
                ),
                child: body,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar != null
          ? SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppDimensions.maxContentWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.screenGutter),
                    child: bottomNavigationBar,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
