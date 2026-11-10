import 'package:meta/meta.dart';

/// Request factory implementing SRS §8.3 (INV-10).
/// Only the requests listed in the official allowlist are exposed.
/// Calling any other method is a compile-time impossibility.
class TdRequestFactory {
  const TdRequestFactory();

  /// 1. setTdlibParameters
  Map<String, dynamic> setTdlibParameters({
    required int apiId,
    required String apiHash,
    required String databaseDirectory,
    required String filesDirectory,
    String? databaseEncryptionKey,
    String deviceModel = 'Android',
    String systemVersion = 'Android',
    String applicationVersion = '1.0.2',
    String systemLanguageCode = 'fa',
  }) {
    return {
      '@type': 'setTdlibParameters',
      'use_test_dc': false,
      'database_directory': databaseDirectory,
      'files_directory': filesDirectory,
      'use_file_database': false,
      'use_chat_info_database': false,
      'use_message_database': false,
      'use_secret_chats': false,
      'api_id': apiId,
      'api_hash': apiHash,
      'system_language_code': systemLanguageCode,
      'device_model': deviceModel,
      'system_version': systemVersion,
      'application_version': applicationVersion,
      'enable_storage_optimizer': true,
    };
  }

  /// checkDatabaseEncryptionKey
  Map<String, dynamic> checkDatabaseEncryptionKey([String key = '']) {
    return {
      '@type': 'checkDatabaseEncryptionKey',
      'encryption_key': key,
    };
  }

  /// 2. setAuthenticationPhoneNumber
  Map<String, dynamic> setAuthenticationPhoneNumber(String phoneNumber) {
    return {
      '@type': 'setAuthenticationPhoneNumber',
      'phone_number': phoneNumber,
    };
  }

  /// 3. checkAuthenticationCode
  Map<String, dynamic> checkAuthenticationCode(String code) {
    return {
      '@type': 'checkAuthenticationCode',
      'code': code,
    };
  }

  /// 4. checkAuthenticationPassword
  Map<String, dynamic> checkAuthenticationPassword(String password) {
    return {
      '@type': 'checkAuthenticationPassword',
      'password': password,
    };
  }

  /// 5. requestQrCodeAuthentication
  Map<String, dynamic> requestQrCodeAuthentication([List<int> otherUserIds = const []]) {
    return {
      '@type': 'requestQrCodeAuthentication',
      'other_user_ids': otherUserIds,
    };
  }

  /// 6. resendAuthenticationCode
  Map<String, dynamic> resendAuthenticationCode() {
    return {
      '@type': 'resendAuthenticationCode',
    };
  }

  /// 7. getContacts
  Map<String, dynamic> getContacts() {
    return {
      '@type': 'getContacts',
    };
  }

  /// 8. getUser
  Map<String, dynamic> getUser(int userId) {
    return {
      '@type': 'getUser',
      'user_id': userId,
    };
  }

  /// 9. logOut
  Map<String, dynamic> logOut() {
    return {
      '@type': 'logOut',
    };
  }

  /// 10. close
  Map<String, dynamic> close() {
    return {
      '@type': 'close',
    };
  }

  /// Set of all allowable method names
  static const Set<String> allowableMethods = {
    'setTdlibParameters',
    'checkDatabaseEncryptionKey',
    'setAuthenticationPhoneNumber',
    'checkAuthenticationCode',
    'checkAuthenticationPassword',
    'requestQrCodeAuthentication',
    'resendAuthenticationCode',
    'getContacts',
    'getUser',
    'logOut',
    'close',
  };
}
