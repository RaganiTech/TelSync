import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class S11PreviewView extends ConsumerStatefulWidget {
  final PreviewState state;
  const S11PreviewView({super.key, required this.state});

  @override
  ConsumerState<S11PreviewView> createState() => _S11PreviewViewState();
}

class _S11PreviewViewState extends ConsumerState<S11PreviewView> {
  int _currentTabIndex = 0;

  void _showEditNameDialog(
    BuildContext context,
    ImportCandidate candidate,
  ) {
    final textController = TextEditingController(text: candidate.displayName);
    final controller = ref.read(importFlowControllerProvider.notifier);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ویرایش نام مخاطب'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'نام و نام خانوادگی',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateCandidateName(candidate.id, textController.text);
              Navigator.of(ctx).pop();
            },
            child: const Text('ذخیره'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);

    final newCandidates = widget.state.candidates
        .where((c) => c.kind == CandidateKind.newContact)
        .toList();

    final relatedCandidates = widget.state.candidates
        .where((c) => c.kind == CandidateKind.relatedToExisting)
        .toList();

    final reviewCandidates = widget.state.candidates
        .where((c) => c.kind == CandidateKind.needsReview)
        .toList();

    final skippedCount = widget.state.counters.numbersAlreadyInPhone +
        widget.state.counters.numbersProbablyInPhone;

    final tabs = [
      '${l10n.tabNew} (${newCandidates.length})',
      '${l10n.tabRelated} (${relatedCandidates.length})',
      '${l10n.tabReview} (${reviewCandidates.length})',
      '${l10n.tabSkipped} ($skippedCount)',
    ];

    Widget currentContent;
    switch (_currentTabIndex) {
      case 0:
        currentContent = _buildCandidateList(newCandidates, l10n.tabNew, Colors.green);
        break;
      case 1:
        currentContent = _buildCandidateList(relatedCandidates, l10n.tabRelated, Colors.blue);
        break;
      case 2:
        currentContent = _buildCandidateList(reviewCandidates, l10n.tabReview, Colors.amber);
        break;
      case 3:
      default:
        currentContent = Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: AppDimensions.space16),
                Text(
                  '$skippedCount شماره از قبل در مخاطبین گوشی شما وجود دارد و طبق اصل عدم تغییر (INV-02) بدون تغییر باقی می‌مانند.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppTypography.bodySize,
                    height: AppTypography.bodyHeight,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
    }

    return AppScaffold(
      title: 'پیش‌نمایش مخاطبین',
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(tabs.length, (index) {
                final isSelected = _currentTabIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: AppDimensions.space8,
                  ),
                  child: ChoiceChip(
                    label: Text(tabs[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _currentTabIndex = index;
                        });
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space8,
              vertical: AppDimensions.space8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.select_all, size: 18),
                  label: Text(l10n.selectAll),
                  onPressed: () {
                    controller.selectAll(null, true);
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.deselect, size: 18),
                  label: Text(l10n.deselectAll),
                  onPressed: () {
                    controller.selectAll(null, false);
                  },
                ),
              ],
            ),
          ),
          Expanded(child: currentContent),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: AppDimensions.hairlineBorder,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.selectedCount(widget.state.selectedCount),
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppTypography.bodySize,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                Flexible(
                  child: Text(
                    l10n.confirmBody,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppTypography.captionSize,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),
            PrimaryButton(
              text: 'ادامه و تأیید (${widget.state.selectedCount})',
              icon: const Icon(Icons.check_circle_outline, size: 20),
              onPressed: widget.state.selectedCount > 0
                  ? () => controller.openConfirmSheet()
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCandidateList(
    List<ImportCandidate> candidates,
    String badgeText,
    Color badgeColor,
  ) {
    final controller = ref.read(importFlowControllerProvider.notifier);

    if (candidates.isEmpty) {
      return Center(
        child: Text(
          'موردی در این دسته وجود ندارد.',
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppTypography.captionSize,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      child: Column(
        children: candidates.map((c) {
          final phone = c.numbers.isNotEmpty
              ? (c.numbers.first.e164 ?? c.numbers.first.raw)
              : '';
          final isMissingName = c.warnings.contains(CandidateWarning.nameMissing);

          return ContactTile(
            displayName: c.displayName,
            phoneNumber: phone,
            badgeText: badgeText,
            badgeColor: badgeColor,
            isSelected: c.selected,
            isMissingName: isMissingName,
            onSelectedChanged: (val) {
              controller.toggleCandidate(c.id);
            },
            onEditName: () => _showEditNameDialog(context, c),
          );
        }).toList(),
      ),
    );
  }
}
