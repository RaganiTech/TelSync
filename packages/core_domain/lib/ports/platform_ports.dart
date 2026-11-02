abstract interface class SessionCleaner {
  /// Signs out of Telegram (server-side logout) and recursively wipes local TDLib storage and vault keys.
  Future<void> cleanSession({required bool performServerLogout});
}

abstract interface class SecureVault {
  Future<void> storeEncryptionKey(List<int> keyBytes);
  Future<List<int>?> getEncryptionKey();
  Future<void> clearEncryptionKey();
}

abstract interface class ScreenGuard {
  Future<void> enableProtection();
  Future<void> disableProtection();
}

abstract interface class AppLogger {
  void log(String message);
  void logStateTransition(String fromState, String toState);
}
