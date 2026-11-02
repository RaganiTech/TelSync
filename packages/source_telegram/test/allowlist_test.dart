import 'package:source_telegram/td_request_factory.dart';
import 'package:test/test.dart';

void main() {
  const factory = TdRequestFactory();

  group('TdRequestFactory - Strict Allowlist Enforcement (INV-10 & NFR-TEST-020)', () {
    test('all factory methods produce @type in allowableMethods', () {
      final samples = [
        factory.setTdlibParameters(
          apiId: 123,
          apiHash: 'hash',
          databaseDirectory: '/tmp/db',
          filesDirectory: '/tmp/files',
          databaseEncryptionKey: 'key',
        ),
        factory.setAuthenticationPhoneNumber('+989123456789'),
        factory.checkAuthenticationCode('12345'),
        factory.checkAuthenticationPassword('secret'),
        factory.requestQrCodeAuthentication(),
        factory.resendAuthenticationCode(),
        factory.getContacts(),
        factory.getUser(42),
        factory.logOut(),
        factory.close(),
      ];

      for (final req in samples) {
        final type = req['@type'] as String;
        expect(
          TdRequestFactory.allowableMethods.contains(type),
          isTrue,
          reason: '$type must be strictly in the allowlist',
        );
      }
    });

    test('banned methods are never in allowableMethods', () {
      const banned = [
        'registerUser',
        'sendMessage',
        'openChat',
        'importContacts',
        'deleteContacts',
        'addContact',
        'changeImportedContacts',
        'createCall',
      ];

      for (final method in banned) {
        expect(
          TdRequestFactory.allowableMethods.contains(method),
          isFalse,
          reason: 'Banned method $method must NEVER be in allowableMethods',
        );
      }
    });
  });
}
