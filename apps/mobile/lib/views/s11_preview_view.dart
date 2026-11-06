import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';
import '../services/ad_service.dart';

class S11PreviewView extends ConsumerStatefulWidget {
  final PreviewState state;
  const S11PreviewView({super.key, required this.state});

  @override
  ConsumerState<S11PreviewView> createState() => _S11PreviewViewState();
}

class _S11PreviewViewState extends ConsumerState<S11PreviewView> {
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    AdService.instance.preloadInterstitial();
  }

  void _showEditNameDialog(
    BuildContext context,
    ImportCandidate candidate,
  ) {
    final textController = TextEditingController(text: candidate.displayName);
    final controller = ref.read(importFlowControllerProvider.notifier);

    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.isPersian ? 'ویرایش نام مخاطب' : 'Edit Contact Name'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.isPersian ? 'نام و نام خانوادگی' : 'Full Name',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateCandidateName(candidate.id, textController.text);
              Navigator.of(ctx).pop();
            },
            child: Text(l10n.isPersian ? 'ذخیره' : 'Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);
    final theme = Theme.of(context);

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
      '${l10n.tabAll} (${widget.state.candidates.length})',
      '${l10n.tabNew} (${newCandidates.length})',
      '${l10n.tabRelated} (${relatedCandidates.length})',
      '${l10n.tabReview} (${reviewCandidates.length})',
      '${l10n.tabSkipped} ($skippedCount)',
    ];

    Widget currentContent;
    switch (_currentTabIndex) {
      case 0:
        currentContent = _buildCandidateList(widget.state.candidates, null, null);
        break;
      case 1:
        currentContent = _buildCandidateList(newCandidates, l10n.tabNew, Colors.green);
        break;
      case 2:
        currentContent = _buildCandidateList(relatedCandidates, 'شماره دیگر در گوشی', const Color(AppColors.telegramBlue));
        break;
      case 3:
        currentContent = _buildCandidateList(reviewCandidates, l10n.tabReview, Colors.amber.shade800);
        break;
      case 4:
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
                  '$skippedCount شماره از قبل در مخاطبین گوشی شما وجود دارد و طبق اصل عدم دست‌کاری (INV-02) بدون تغییر باقی می‌مانند.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppTypography.bodySize,
                    height: AppTypography.bodyHeight,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
    }

    final allSelected = widget.state.candidates.isNotEmpty &&
        widget.state.candidates.every((c) => c.selected);

    return AppScaffold(
      title: 'پیش‌نمایش مخاطبین',
      body: Column(
        children: [
          const SizedBox(height: AppDimensions.space8),

          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final isSelected = _currentTabIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(tabs[index]),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                    checkmarkColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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

          const SizedBox(height: AppDimensions.space8),

          // Interactive "Select All" / "Deselect All" Banner Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space12),
            child: Material(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  controller.selectAll(null, !allSelected);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.15,
                        child: Checkbox(
                          value: allSelected,
                          tristate: widget.state.selectedCount > 0 && !allSelected,
                          onChanged: (val) {
                            controller.selectAll(null, val ?? true);
                          },
                          activeColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        allSelected
                            ? 'لغو انتخاب همه'
                            : 'انتخاب همه مخاطبین (${widget.state.candidates.length} مورد)',
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${widget.state.selectedCount} انتخاب شده',
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),
          const Divider(height: 1),
          Expanded(child: currentContent),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
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
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Flexible(
                  child: Text(
                    'آماده برای ذخیره در گوشی',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppTypography.captionSize,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),
            PrimaryButton(
              text: 'ادامه و تأیید (${widget.state.selectedCount} مخاطب)',
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
    String? badgeText,
    Color? badgeColor,
  ) {
    final controller = ref.read(importFlowControllerProvider.notifier);

    if (candidates.isEmpty) {
      return Center(
        child: Text(
          'موردی در این دسته وجود ندارد.',
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppTypography.captionSize,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space8,
      ),
      child: Column(
        children: candidates.map<Widget>((c) {
          final phone = c.numbers.isNotEmpty
              ? (c.numbers.first.e164 ?? c.numbers.first.raw)
              : '';
          final isMissingName = c.warnings.contains(CandidateWarning.nameMissing);

          String resolvedBadge;
          Color resolvedColor;
          if (badgeText != null) {
            resolvedBadge = badgeText;
            resolvedColor = badgeColor ?? Theme.of(context).colorScheme.primary;
          } else {
            switch (c.kind) {
              case CandidateKind.newContact:
                resolvedBadge = 'جدید';
                resolvedColor = Colors.green;
                break;
              case CandidateKind.relatedToExisting:
                resolvedBadge = 'شماره دیگر در گوشی هست';
                resolvedColor = const Color(AppColors.telegramBlue);
                break;
              case CandidateKind.needsReview:
                resolvedBadge = 'نیاز به بررسی';
                resolvedColor = Colors.amber.shade800;
                break;
            }
          }

          return ContactTile(
            displayName: c.displayName,
            phoneNumber: phone,
            badgeText: resolvedBadge,
            badgeColor: resolvedColor,
            isSelected: c.selected,
            isMissingName: isMissingName,
            onSelectedChanged: (val) {
              controller.toggleCandidate(c.id);
            },
            onEditName: () => _showEditNameDialog(context, c),
          );
        }).toList()
          ..add(
            const TapsellNativeBannerWidget(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 32),
            ),
          ),
      ),
    );
  }
}
