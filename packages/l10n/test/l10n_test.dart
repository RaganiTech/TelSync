import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

void main() {
  group('AppLocalizations tests', () {
    test('Persian strings match expected SRS values', () {
      const l10n = AppLocalizations(Locale('fa'));
      expect(l10n.isPersian, isTrue);
      expect(l10n.welcomeTitle, contains('مخاطبین تلگرامت'));
      expect(l10n.confirmTitle(5), equals('5 مخاطب جدید اضافه شود؟'));
      expect(l10n.destination('Google'), equals('ذخیره در: Google'));
      expect(l10n.floodWait(60), contains('60 ثانیه'));
    });

    test('English strings match expected SRS values', () {
      const l10n = AppLocalizations(Locale('en'));
      expect(l10n.isPersian, isFalse);
      expect(l10n.welcomeTitle, contains('Bring your Telegram contacts'));
      expect(l10n.confirmTitle(5), equals('Add 5 new contacts?'));
      expect(l10n.destination('iCloud'), equals('Save to: iCloud'));
      expect(l10n.floodWait(60), contains('60 seconds'));
    });

    test('Delegate supports fa and en', () {
      expect(AppLocalizations.delegate.isSupported(const Locale('fa')), isTrue);
      expect(AppLocalizations.delegate.isSupported(const Locale('en')), isTrue);
      expect(AppLocalizations.delegate.isSupported(const Locale('fr')), isFalse);
    });
  });
}
