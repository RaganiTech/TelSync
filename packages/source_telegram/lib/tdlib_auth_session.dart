import 'dart:async';
import 'package:core_domain/entities/source_contact.dart';
import 'package:core_domain/ports/platform_ports.dart';
import 'td_request_factory.dart';
import 'telegram_isolate_bridge.dart';

enum TgAuthState {
  initial,
  waitingParameters,
  waitingAuthMethod,
  waitingQrConfirmation,
  waitingCode,
  waitingPassword,
  ready,
  unsupportedRegistration,
  closed,
  error,
}

class TdlibAuthSession {
  final TelegramIsolateBridge _bridge;
  final TdRequestFactory _factory;
  final AppLogger? _logger;

  TgAuthState _state = TgAuthState.initial;
  String? _qrLink;
  DateTime? _qrExpiresAt;
  String? _currentPhoneNumber;
  int? _codeTimeoutSeconds;

  final StreamController<TgAuthState> _stateController = StreamController<TgAuthState>.broadcast();
  final Map<String, Completer<Map<String, dynamic>>> _pendingRequests = {};
  int _extraCounter = 0;

  Stream<TgAuthState> get authStateStream => _stateController.stream;
  TgAuthState get currentState => _state;
  String? get qrLink => _qrLink;
  DateTime? get qrExpiresAt => _qrExpiresAt;

  TdlibAuthSession({
    required TelegramIsolateBridge bridge,
    TdRequestFactory factory = const TdRequestFactory(),
    AppLogger? logger,
  })  : _bridge = bridge,
        _factory = factory,
        _logger = logger;

  void init() {
    _bridge.updates.listen(_handleUpdate);
  }

  void _handleUpdate(Map<String, dynamic> update) {
    // Correlate with extra if present
    final extra = update['@extra']?.toString();
    if (extra != null && _pendingRequests.containsKey(extra)) {
      _pendingRequests.remove(extra)?.complete(update);
    }

    final type = update['@type'] as String?;
    if (type == 'updateAuthorizationState') {
      final authState = update['authorization_state'] as Map<String, dynamic>?;
      _handleAuthState(authState);
    }
  }

  void _handleAuthState(Map<String, dynamic>? authState) {
    if (authState == null) return;
    final type = authState['@type'] as String?;

    switch (type) {
      case 'authorizationStateWaitTdlibParameters':
        _updateState(TgAuthState.waitingParameters);

      case 'authorizationStateWaitPhoneNumber':
        _updateState(TgAuthState.waitingAuthMethod);

      case 'authorizationStateWaitOtherDeviceConfirmation':
        _qrLink = authState['link'] as String?;
        final ttl = (authState['expires_in'] as num?)?.toInt() ?? 30;
        _qrExpiresAt = DateTime.now().add(Duration(seconds: ttl));
        _updateState(TgAuthState.waitingQrConfirmation);

      case 'authorizationStateWaitCode':
        final codeInfo = authState['code_info'] as Map<String, dynamic>?;
        _codeTimeoutSeconds = (codeInfo?['timeout'] as num?)?.toInt();
        _updateState(TgAuthState.waitingCode);

      case 'authorizationStateWaitPassword':
        _updateState(TgAuthState.waitingPassword);

      case 'authorizationStateWaitRegistration':
        // FR-AUTH-040: Show unsupported, never call registerUser
        _updateState(TgAuthState.unsupportedRegistration);

      case 'authorizationStateReady':
        _updateState(TgAuthState.ready);

      case 'authorizationStateClosing':
      case 'authorizationStateClosed':
        _updateState(TgAuthState.closed);
    }
  }

  void _updateState(TgAuthState newState) {
    _state = newState;
    _stateController.add(newState);
    _logger?.log('TDLib AuthState changed to: $newState');
  }

  Future<void> sendParameters({
    required int apiId,
    required String apiHash,
    required String databaseDirectory,
    required String filesDirectory,
    required String databaseEncryptionKey,
  }) async {
    final req = _factory.setTdlibParameters(
      apiId: apiId,
      apiHash: apiHash,
      databaseDirectory: databaseDirectory,
      filesDirectory: filesDirectory,
      databaseEncryptionKey: databaseEncryptionKey,
    );
    await _sendRequest(req);
  }

  Future<void> requestQrCode() async {
    final req = _factory.requestQrCodeAuthentication();
    await _sendRequest(req);
  }

  Future<void> submitPhoneNumber(String phoneNumber) async {
    _currentPhoneNumber = phoneNumber;
    final req = _factory.setAuthenticationPhoneNumber(phoneNumber);
    await _sendRequest(req);
  }

  Future<void> submitCode(String code) async {
    final req = _factory.checkAuthenticationCode(code);
    await _sendRequest(req);
  }

  Future<void> submitPassword(String password) async {
    final req = _factory.checkAuthenticationPassword(password);
    await _sendRequest(req);
  }

  Future<List<SourceContact>> fetchContacts({
    void Function(double progress, int count)? onProgress,
  }) async {
    // 1. getContacts
    final contactsRes = await _sendRequest(_factory.getContacts());
    final userIds = (contactsRes['user_ids'] as List<dynamic>?)?.cast<int>() ?? [];

    final result = <SourceContact>[];
    const concurrencyLimit = 20; // Bounded concurrency (FR-TG-001)

    for (int i = 0; i < userIds.length; i += concurrencyLimit) {
      final chunk = userIds.sublist(
        i,
        (i + concurrencyLimit > userIds.length) ? userIds.length : i + concurrencyLimit,
      );

      final futures = chunk.map((uid) async {
        final user = await _sendRequest(_factory.getUser(uid));
        final fName = (user['first_name'] as String?) ?? '';
        final lName = (user['last_name'] as String?) ?? '';
        final phone = (user['phone_number'] as String?)?.trim() ?? '';

        final numbers = phone.isNotEmpty ? [phone] : <String>[];
        return SourceContact(
          userId: uid,
          firstName: fName,
          lastName: lName,
          rawPhoneNumbers: numbers,
        );
      });

      final chunkResults = await Future.wait(futures);
      result.addAll(chunkResults);

      final progress = result.length / userIds.length;
      onProgress?.call(progress, result.length);
    }

    return result;
  }

  Future<void> logOut() async {
    await _sendRequest(_factory.logOut());
  }

  Future<void> close() async {
    await _sendRequest(_factory.close());
    await _stateController.close();
  }

  Future<Map<String, dynamic>> _sendRequest(Map<String, dynamic> req) {
    _extraCounter++;
    final extra = 'req_$_extraCounter';
    final payload = Map<String, dynamic>.from(req);
    payload['@extra'] = extra;

    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[extra] = completer;

    _bridge.send(payload);
    return completer.future;
  }
}
