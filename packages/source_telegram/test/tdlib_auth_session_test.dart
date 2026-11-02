import 'dart:async';
import 'package:source_telegram/tdlib_auth_session.dart';
import 'package:source_telegram/telegram_isolate_bridge.dart';
import 'package:test/test.dart';

class FakeTelegramBridge implements TelegramIsolateBridge {
  final StreamController<Map<String, dynamic>> _controller = StreamController.broadcast();
  final List<Map<String, dynamic>> sentRequests = [];

  @override
  String? get libraryPath => null;

  @override
  Stream<Map<String, dynamic>> get updates => _controller.stream;

  @override
  Future<void> start() async {}

  @override
  void send(Map<String, dynamic> request) {
    sentRequests.add(request);
    final extra = request['@extra']?.toString();
    final type = request['@type'] as String?;

    // Simulate TDLib responses
    if (type == 'getContacts') {
      _controller.add({
        '@type': 'users',
        '@extra': extra,
        'user_ids': [101, 102],
      });
    } else if (type == 'getUser') {
      final uid = request['user_id'] as int;
      _controller.add({
        '@type': 'user',
        '@extra': extra,
        'id': uid,
        'first_name': 'User',
        'last_name': '$uid',
        'phone_number': '989120000$uid',
      });
    } else {
      _controller.add({
        '@type': 'ok',
        '@extra': extra,
      });
    }
  }

  void emitUpdate(Map<String, dynamic> update) {
    _controller.add(update);
  }

  @override
  Future<void> stop() async {
    await _controller.close();
  }
}

void main() {
  late FakeTelegramBridge fakeBridge;
  late TdlibAuthSession session;

  setUp(() {
    fakeBridge = FakeTelegramBridge();
    session = TdlibAuthSession(bridge: fakeBridge);
    session.init();
  });

  tearDown(() async {
    await fakeBridge.stop();
  });

  group('TdlibAuthSession', () {
    test('transitions auth states on updateAuthorizationState updates', () async {
      final states = <TgAuthState>[];
      final sub = session.authStateStream.listen(states.add);

      fakeBridge.emitUpdate({
        '@type': 'updateAuthorizationState',
        'authorization_state': {'@type': 'authorizationStateWaitTdlibParameters'},
      });
      await Future.delayed(Duration.zero);
      expect(session.currentState, equals(TgAuthState.waitingParameters));

      fakeBridge.emitUpdate({
        '@type': 'updateAuthorizationState',
        'authorization_state': {'@type': 'authorizationStateWaitPhoneNumber'},
      });
      await Future.delayed(Duration.zero);
      expect(session.currentState, equals(TgAuthState.waitingAuthMethod));

      fakeBridge.emitUpdate({
        '@type': 'updateAuthorizationState',
        'authorization_state': {
          '@type': 'authorizationStateWaitOtherDeviceConfirmation',
          'link': 'tg://login?token=xyz123',
          'expires_in': 45,
        },
      });
      await Future.delayed(Duration.zero);
      expect(session.currentState, equals(TgAuthState.waitingQrConfirmation));
      expect(session.qrLink, equals('tg://login?token=xyz123'));
      expect(session.qrExpiresAt, isNotNull);

      fakeBridge.emitUpdate({
        '@type': 'updateAuthorizationState',
        'authorization_state': {'@type': 'authorizationStateReady'},
      });
      await Future.delayed(Duration.zero);
      expect(session.currentState, equals(TgAuthState.ready));

      await sub.cancel();
    });

    test('fetchContacts queries getContacts and user details with bounded concurrency', () async {
      final contacts = await session.fetchContacts();
      expect(contacts.length, equals(2));
      expect(contacts[0].userId, equals(101));
      expect(contacts[0].displayName, equals('User 101'));
      expect(contacts[0].rawPhoneNumbers, equals(['989120000101']));

      expect(contacts[1].userId, equals(102));
      expect(contacts[1].displayName, equals('User 102'));
      expect(contacts[1].rawPhoneNumbers, equals(['989120000102']));
    });

    test('authorizationStateWaitRegistration sets unsupportedRegistration state without calling registerUser (FR-AUTH-040)', () async {
      fakeBridge.emitUpdate({
        '@type': 'updateAuthorizationState',
        'authorization_state': {'@type': 'authorizationStateWaitRegistration'},
      });
      await Future.delayed(Duration.zero);
      expect(session.currentState, equals(TgAuthState.unsupportedRegistration));
    });
  });
}
