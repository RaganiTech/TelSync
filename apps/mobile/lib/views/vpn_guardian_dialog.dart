import 'dart:async';
import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../services/network_location_service.dart';

class VpnGuardianDialog extends StatefulWidget {
  final LocationCheckResult initialResult;

  const VpnGuardianDialog({
    super.key,
    required this.initialResult,
  });

  static Future<bool> show(
    BuildContext context, {
    required LocationCheckResult initialResult,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => VpnGuardianDialog(initialResult: initialResult),
    );
    return result ?? false;
  }

  @override
  State<VpnGuardianDialog> createState() => _VpnGuardianDialogState();
}

class _VpnGuardianDialogState extends State<VpnGuardianDialog>
    with SingleTickerProviderStateMixin {
  final _service = NetworkLocationService();
  late LocationCheckResult _currentResult;
  Timer? _poller;
  bool _isChecking = false;
  bool _isResolved = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _currentResult = widget.initialResult;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Start auto-polling every 20 seconds
    _startPolling();
  }

  void _startPolling() {
    _poller?.cancel();
    _poller = Timer.periodic(const Duration(seconds: 20), (_) {
      _checkNow();
    });
  }

  Future<void> _checkNow() async {
    if (_isChecking || _isResolved || !mounted) return;
    setState(() => _isChecking = true);

    try {
      final res = await _service.checkLocation();
      if (!mounted) return;
      setState(() {
        _currentResult = res;
        _isChecking = false;
      });

      // If location is no longer Iran (or other filtered country) and has internet
      if (res.hasInternet && !res.isFiltered) {
        setState(() => _isResolved = true);
        _poller?.cancel();
        // Give user a brief visual feedback of success before auto-dismissing
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (_) {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  @override
  void dispose() {
    _poller?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = _isResolved
        ? Colors.green.shade600
        : const Color(0xFFF59E0B); // Amber / Warning

    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Animated Icon Header
            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = _isResolved
                      ? 1.0
                      : 1.0 + (_pulseController.value * 0.08);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _isResolved
                            ? Icons.verified_user_rounded
                            : Icons.vpn_lock_rounded,
                        size: 38,
                        color: primaryColor,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppDimensions.space16),

            // Title
            Text(
              _isResolved ? l10n.vpnConnectedSuccess : l10n.vpnModalTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle Description
            Text(
              _isResolved
                  ? (l10n.isPersian
                      ? 'اتصال اینترنت آزاد تایید شد. در حال بازگشت به برنامه...'
                      : 'Unfiltered connection verified. Returning to app...')
                  : l10n.vpnModalSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 13,
                height: 1.55,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),

            const SizedBox(height: AppDimensions.space16),

            // Network Details Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.vpnCurrentCountryLabel,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                        ),
                      ),
                      Row(
                        children: [
                          if (_currentResult.countryCode == 'IR')
                            const Text('🇮🇷 ')
                          else if (_currentResult.countryCode != null &&
                              _currentResult.countryCode!.isNotEmpty)
                            const Text('🌐 '),
                          Text(
                            _currentResult.countryCode == 'IR'
                                ? l10n.vpnIranDetected
                                : (_currentResult.countryCode ??
                                    (l10n.isPersian ? 'نامشخص' : 'Unknown')),
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _isResolved ||
                                      (_currentResult.countryCode != null &&
                                          _currentResult.countryCode != 'IR')
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_currentResult.ip != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.vpnCurrentIpLabel,
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                          ),
                        ),
                        Text(
                          _currentResult.ip!,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.space16),

            // Live Waiting Indicator
            if (!_isResolved)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _isChecking
                            ? (l10n.isPersian
                                ? 'در حال استعلام مجدد لوکیشن...'
                                : 'Checking location again...')
                            : l10n.vpnWaitingText,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 11.5,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              // Cancel Button
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Force Check Now Button
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: _isChecking ? null : _checkNow,
                  icon: _isChecking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(
                    l10n.vpnCheckNow,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
