/// Application build configuration and environment parameters.
/// Values can be provided at build time using:
///   flutter run --dart-define=TELEGRAM_API_ID=12345 --dart-define=TELEGRAM_API_HASH=abcdef...
class AppConfig {
  /// Telegram API ID from my.telegram.org (INV-01 / INV-10)
  static const int telegramApiId =
      int.fromEnvironment('TELEGRAM_API_ID', defaultValue: 0);

  /// Telegram API Hash from my.telegram.org
  static const String telegramApiHash =
      String.fromEnvironment('TELEGRAM_API_HASH', defaultValue: '');

  /// Flag indicating whether mock Telegram source should be used for offline UI testing
  static const bool useMockTelegram =
      bool.fromEnvironment('USE_MOCK_TELEGRAM', defaultValue: false);

  /// Returns true if valid real Telegram API credentials are configured
  static bool get hasValidCredentials =>
      telegramApiId > 0 && telegramApiHash.isNotEmpty;
}
