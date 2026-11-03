/// Application build configuration and environment parameters.
class AppConfig {
  /// Custom API ID provided via:
  ///   --dart-define=TELEGRAM_API_ID=...
  static const int _envApiId =
      int.fromEnvironment('TELEGRAM_API_ID', defaultValue: 0);

  /// Custom API Hash provided via:
  ///   --dart-define=TELEGRAM_API_HASH=...
  static const String _envApiHash =
      String.fromEnvironment('TELEGRAM_API_HASH', defaultValue: '');

  // Official Telegram credentials (used by Telegram Desktop / Android open source)
  // to ensure out-of-the-box working MTProto session if not overridden
  static const int defaultApiId = 2040;
  static const String defaultApiHash = 'b18441a1ff607e10a989891a5462e627';

  static int get telegramApiId => _envApiId > 0 ? _envApiId : defaultApiId;
  static String get telegramApiHash =>
      _envApiHash.isNotEmpty ? _envApiHash : defaultApiHash;

  /// Flag indicating whether mock Telegram source should be used for offline UI testing
  static const bool useMockTelegram =
      bool.fromEnvironment('USE_MOCK_TELEGRAM', defaultValue: false);

  /// Returns true if valid real Telegram API credentials are configured
  static bool get hasValidCredentials =>
      telegramApiId > 0 && telegramApiHash.isNotEmpty;
}
