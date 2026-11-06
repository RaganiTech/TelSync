import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:tapsell_mediation/src/show/native/NativeAdDispatch.dart';
import 'package:tapsell_mediation/tapsell_mediation.dart';

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  static const String appKey =
      '7a4ea919-7c1d-4265-9d8f-4697fbfcb401';
  static const String interstitialZoneId = '6aec9badf824952f9b2e05d5';
  static const String nativeBannerZoneId = '6aec9bf8a2434702499bd0e4';

  String? _preloadedInterstitialAdId;
  bool _isRequestingInterstitial = false;
  bool _hasShownInterstitialThisSession = false;

  bool get isSupportedPlatform =>
      !kIsWeb &&
      Platform.isAndroid &&
      !Platform.environment.containsKey('FLUTTER_TEST');

  /// Preload interstitial ad in the background silently
  Future<void> preloadInterstitial() async {
    if (!isSupportedPlatform || _hasShownInterstitialThisSession || _isRequestingInterstitial) {
      return;
    }
    if (_preloadedInterstitialAdId != null) return;

    _isRequestingInterstitial = true;
    try {
      final adId = await Tapsell.requestInterstitialAd(interstitialZoneId);
      if (adId != null && adId.isNotEmpty) {
        _preloadedInterstitialAdId = adId;
        debugPrint('[Tapsell] Interstitial ad preloaded: $adId');
      }
    } catch (e) {
      debugPrint('[Tapsell] Preload interstitial failed (silently ignored): $e');
    } finally {
      _isRequestingInterstitial = false;
    }
  }

  /// Show interstitial ad once per session, only after task completion
  Future<void> showInterstitialAfterCompletion({VoidCallback? onComplete}) async {
    if (!isSupportedPlatform || _hasShownInterstitialThisSession) {
      onComplete?.call();
      return;
    }

    final adId = _preloadedInterstitialAdId;
    if (adId == null || adId.isEmpty) {
      onComplete?.call();
      return;
    }

    _hasShownInterstitialThisSession = true;
    _preloadedInterstitialAdId = null;

    try {
      bool completed = false;
      void handleFinished() {
        if (!completed) {
          completed = true;
          onComplete?.call();
        }
      }

      await Tapsell.showInterstitialAd(
        adId,
        onAdImpression: () => debugPrint('[Tapsell] Interstitial shown'),
        onAdClosed: (state) {
          debugPrint('[Tapsell] Interstitial closed: $state');
          handleFinished();
        },
        onAdFailed: (msg) {
          debugPrint('[Tapsell] Interstitial failed: $msg');
          handleFinished();
        },
      );
    } catch (e) {
      debugPrint('[Tapsell] Exception showing interstitial: $e');
      onComplete?.call();
    }
  }
}

/// A polite, elegant Native Banner widget tailored for TelSync's UI.
/// Disappears completely (SizedBox.shrink) if ad is unavailable.
class TapsellNativeBannerWidget extends StatefulWidget {
  final String zoneId;
  final EdgeInsetsGeometry padding;

  const TapsellNativeBannerWidget({
    super.key,
    this.zoneId = AdService.nativeBannerZoneId,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  State<TapsellNativeBannerWidget> createState() => _TapsellNativeBannerWidgetState();
}

class _TapsellNativeBannerWidgetState extends State<TapsellNativeBannerWidget> {
  final NativeAdDispatch _adDispatch = NativeAdDispatch();
  String? _adId;
  bool _isAdReady = false;

  @override
  void initState() {
    super.initState();
    _adDispatch.addListener(_onAdUpdated);
    _loadNativeAd();
  }

  @override
  void dispose() {
    _adDispatch.removeListener(_onAdUpdated);
    if (_adId != null && AdService.instance.isSupportedPlatform) {
      Tapsell.destroyNativeAd(_adId!);
    }
    _adDispatch.dispose();
    super.dispose();
  }

  void _onAdUpdated() {
    if (mounted) {
      final valid = _adDispatch.title != null && _adDispatch.title!.isNotEmpty;
      if (valid != _isAdReady) {
        setState(() => _isAdReady = valid);
      }
    }
  }

  Future<void> _loadNativeAd() async {
    if (!AdService.instance.isSupportedPlatform) return;

    try {
      final adId = await Tapsell.requestNativeAd(widget.zoneId);
      if (adId != null && adId.isNotEmpty && mounted) {
        _adId = adId;
        await Tapsell.showNativeAd(
          adId,
          _adDispatch,
          onAdImpression: () => debugPrint('[Tapsell] Native ad impression'),
          onAdFailed: (msg) {
            debugPrint('[Tapsell] Native ad failed: $msg');
            if (mounted) setState(() => _isAdReady = false);
          },
        );
      }
    } catch (e) {
      debugPrint('[Tapsell] Native ad exception: $e');
    }
  }

  void _onAdClicked() {
    if (_adId != null && AdService.instance.isSupportedPlatform) {
      Tapsell.clickNativeAd(_adId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdReady) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final title = _adDispatch.title ?? '';
    final description = _adDispatch.description ?? '';
    final logoUrl = _adDispatch.logo;
    final ctaText = _adDispatch.callToActionText ?? 'مشاهده';

    return Padding(
      padding: widget.padding,
      child: Material(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: _onAdClicked,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Ad Icon / Thumbnail
                if (logoUrl != null && logoUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      logoUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.ads_click, size: 36),
                    ),
                  )
                else
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.star_rounded, color: theme.colorScheme.primary),
                  ),
                const SizedBox(width: 12),

                // Title and Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white12 : Colors.black12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'آگهی',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // CTA Button
                ElevatedButton(
                  onPressed: _onAdClicked,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(ctaText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
