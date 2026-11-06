import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import '../controllers/providers.dart';

class CountryOption {
  final String flag;
  final String nameEn;
  final String nameFa;
  final String dialCode;

  const CountryOption({
    required this.flag,
    required this.nameEn,
    required this.nameFa,
    required this.dialCode,
  });
}

const List<CountryOption> _kCountries = [
  CountryOption(flag: '🇮🇷', nameEn: 'Iran', nameFa: 'ایران', dialCode: '+98'),
  CountryOption(flag: '🇺🇸', nameEn: 'United States', nameFa: 'ایالات متحده', dialCode: '+1'),
  CountryOption(flag: '🇬🇧', nameEn: 'United Kingdom', nameFa: 'انگلستان', dialCode: '+44'),
  CountryOption(flag: '🇩🇪', nameEn: 'Germany', nameFa: 'آلمان', dialCode: '+49'),
  CountryOption(flag: '🇦🇪', nameEn: 'United Arab Emirates', nameFa: 'امارات', dialCode: '+971'),
  CountryOption(flag: '🇹🇷', nameEn: 'Turkey', nameFa: 'ترکیه', dialCode: '+90'),
  CountryOption(flag: '🇨🇦', nameEn: 'Canada', nameFa: 'کانادا', dialCode: '+1'),
  CountryOption(flag: '🇫🇷', nameEn: 'France', nameFa: 'فرانسه', dialCode: '+33'),
  CountryOption(flag: '🌐', nameEn: 'Other', nameFa: 'سایر کشورها', dialCode: '+'),
];

class S3AuthPhoneView extends ConsumerStatefulWidget {
  const S3AuthPhoneView({super.key});

  @override
  ConsumerState<S3AuthPhoneView> createState() => _S3AuthPhoneViewState();
}

class _S3AuthPhoneViewState extends ConsumerState<S3AuthPhoneView> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  late CountryOption _selectedCountry;

  @override
  void initState() {
    super.initState();
    // Default country: Iran if Persian or default, else Iran/US
    _selectedCountry = _kCountries[0];
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _normalizeDigits(String input) {
    const pDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const aDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(pDigits[i], '$i').replaceAll(aDigits[i], '$i');
    }
    return input;
  }

  void _showCountryPicker() {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                l10n.isPersian ? 'انتخاب کشور' : 'Select Country',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _kCountries.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  ),
                  itemBuilder: (c, idx) {
                    final item = _kCountries[idx];
                    final isSelected = item.dialCode == _selectedCountry.dialCode &&
                        item.nameEn == _selectedCountry.nameEn;
                    return ListTile(
                      leading: Text(item.flag, style: const TextStyle(fontSize: 24)),
                      title: Text(
                        l10n.isPersian ? item.nameFa : item.nameEn,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      trailing: Text(
                        item.dialCode,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCountry = item;
                        });
                        Navigator.of(ctx).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    final l10n = AppLocalizations.of(context);
    String text = _phoneController.text.trim();
    text = _normalizeDigits(text);

    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.isPersian
                ? 'لطفاً شماره تلفن را کامل وارد کنید.'
                : 'Please enter a valid complete phone number.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    String e164Phone;
    if (text.startsWith('+')) {
      e164Phone = '+$digits';
    } else if (_selectedCountry.dialCode == '+98') {
      if (digits.startsWith('98')) {
        e164Phone = '+$digits';
      } else if (digits.startsWith('09')) {
        e164Phone = '+98${digits.substring(1)}';
      } else if (digits.startsWith('9')) {
        e164Phone = '+98$digits';
      } else {
        e164Phone = '+98$digits';
      }
    } else {
      final dialDigits = _selectedCountry.dialCode.replaceAll(RegExp(r'\D'), '');
      if (dialDigits.isNotEmpty && digits.startsWith(dialDigits)) {
        e164Phone = '+$digits';
      } else if (digits.startsWith('0')) {
        e164Phone = '+$dialDigits${digits.substring(1)}';
      } else {
        e164Phone = '+$dialDigits$digits';
      }
    }

    final controller = ref.read(importFlowControllerProvider.notifier);
    final ok = await controller.ensureVpnIfFiltered(context);
    if (!ok) return;

    // Set loading state immediately to prevent double-tap
    setState(() => _isLoading = true);
    final res = await controller.submitPhoneNumber(e164Phone);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res != null && res['@type'] == 'error') {
      final msg = res['message']?.toString() ?? '';
      String userMsg = '${l10n.isPersian ? "خطای اتصال به تلگرام" : "Telegram connection error"}: $msg';
      if (msg.contains('PHONE_NUMBER_INVALID')) {
        userMsg = l10n.phoneInvalidError;
      } else if (msg.contains('PHONE_NUMBER_UNOCCUPIED')) {
        userMsg = l10n.phoneUnoccupiedError;
      } else if (msg.contains('PHONE_NUMBER_BANNED')) {
        userMsg = l10n.phoneBannedError;
      } else if (msg.contains('FLOOD_WAIT')) {
        userMsg = l10n.floodWaitError;
      } else if (msg.contains('REQUEST_TIMEOUT')) {
        userMsg = l10n.requestTimeoutError;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userMsg),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importFlowControllerProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      title: l10n.phoneAuthTitle,
      showBackButton: true,
      onBack: () => controller.dispatch(const StartFlowEvent()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space12),

            Text(
              l10n.phoneInputLabel,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: AppDimensions.space12),

            // High-Contrast Input Container with perfect anti-alias rounded clipping
            Directionality(
              textDirection: TextDirection.ltr,
              child: Container(
                clipBehavior: Clip.antiAlias, // Eliminates any square bleed
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(AppColors.telegramBlue),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(AppColors.telegramBlue).withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Clickable Country Code Badge
                      Material(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        child: InkWell(
                          onTap: _showCountryPicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_selectedCountry.flag, style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 6),
                                Text(
                                  _selectedCountry.dialCode,
                                  style: TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 20,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Phone Input
                      Expanded(
                        child: Center(
                          child: TextField(
                            controller: _phoneController,
                            autofocus: true,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            inputFormatters: const [
                              PersianToEnglishDigitsFormatter(maxLength: 16),
                            ],
                            cursorColor: const Color(AppColors.telegramBlue),
                            cursorWidth: 2.5,
                            cursorHeight: 24,
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            decoration: InputDecoration(
                              hintText: _selectedCountry.dialCode == '+98'
                                  ? '9121234567'
                                  : '1234567890',
                              hintStyle: TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: 16,
                                letterSpacing: 1.2,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : Colors.black.withValues(alpha: 0.3),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                            onSubmitted: (_) => _submit(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l10n.phoneInputHelper,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.space20),

            PrimaryButton(
              text: l10n.getTelegramCode,
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              isLoading: _isLoading,
              onPressed: _submit,
            ),

            const SizedBox(height: AppDimensions.space20),

            // Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(AppColors.telegramBlue).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.telegram_rounded,
                      color: Color(AppColors.telegramBlue),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.phoneAuthNote,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 12.5,
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }
}
