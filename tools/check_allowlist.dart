import 'dart:io';

void main() {
  print('Running TDLib Allowlist Check (NFR-TEST-020)...');

  const allowableMethods = {
    'setTdlibParameters',
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

  const bannedKeywords = [
    'registerUser',
    'sendMessage',
    'openChat',
    'importContacts',
    'deleteContacts',
    'addContact',
    'changeImportedContacts',
    'createCall',
    'getChat',
    'getMessages',
  ];

  final rootDir = Directory('packages');
  if (!rootDir.existsSync()) {
    print('Directory packages not found.');
    exit(1);
  }

  bool violationFound = false;

  for (final file in rootDir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart') && !file.path.contains('test')) {
      final content = file.readAsStringSync();
      for (final banned in bannedKeywords) {
        if (content.contains(banned)) {
          print('VIOLATION: File ${file.path} contains banned TDLib call "$banned"');
          violationFound = true;
        }
      }
    }
  }

  if (violationFound) {
    print('FAILED: Banned TDLib methods detected outside allowlist!');
    exit(1);
  }

  print('PASSED: TDLib allowlist check succeeded with 0 violations.');
}
