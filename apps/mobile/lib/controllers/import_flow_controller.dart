import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:core_domain/core_domain.dart';
import 'package:source_telegram/source_telegram.dart';
import 'package:sink_phonebook/sink_phonebook.dart';
import '../config/app_config.dart';
import '../services/network_location_service.dart';
import '../views/vpn_guardian_dialog.dart';
import 'providers.dart';

class ImportFlowController extends Notifier<FlowState> {
  TdlibAuthSession? _authSession;
  TdlibAuthSession? get authSession => _authSession;
  TelegramIsolateBridge? _isolateBridge;
  Directory? _dbDir;
  Directory? _filesDir;
  List<SourceContact> _telegramContacts = [];
  List<PhoneBookContactInput> _phoneContacts = [];
  List<String> _insertedRecordIds = [];
  String? _lastSubmittedPhone;

  @override
  FlowState build() {
    return const WelcomeState();
  }

  void dispatch(FlowEvent event) {
    state = reduce(state, event);
  }

  void startImport() {
    dispatch(const StartFlowEvent());
    _tryInitTdlib();
  }

  /// Checks if user is located in Iran (or filtered region) and prompts to enable VPN.
  /// Automatically waits for IP change to a safe country before returning true.
  Future<bool> ensureVpnIfFiltered(BuildContext context) async {
    try {
      final locService = NetworkLocationService();
      final loc = await locService.checkLocation();
      if (loc.isFiltered) {
        if (!context.mounted) return false;
        final proceeded = await VpnGuardianDialog.show(context, initialResult: loc);
        return proceeded;
      }
      return true;
    } catch (e) {
      debugPrint('[VPN] Location check error: $e');
      return true;
    }
  }

  /// Instant test mode with realistic Persian contacts across all SRS matching categories
  void startDemoMode() {
    _telegramContacts = const [
      SourceContact(
        userId: 101,
        firstName: 'محمد',
        lastName: 'رضایی',
        rawPhoneNumbers: ['09121234567'],
      ),
      SourceContact(
        userId: 102,
        firstName: 'فاطمه',
        lastName: 'حسینی',
        rawPhoneNumbers: ['۰۹۳۵ ۱۲۳ ۴۵۶۷'], // Persian digits
      ),
      SourceContact(
        userId: 103,
        firstName: 'علی',
        lastName: 'کریمی',
        rawPhoneNumbers: ['+989123456789', '09129998877'], // Has new secondary number
      ),
      SourceContact(
        userId: 104,
        firstName: 'مهسا',
        lastName: 'احمدی',
        rawPhoneNumbers: ['0919 555 4433'],
      ),
      SourceContact(
        userId: 105,
        firstName: 'سینا',
        lastName: 'مرادی',
        rawPhoneNumbers: ['0910 888 7766'],
      ),
      SourceContact(
        userId: 106,
        firstName: 'امیررضا',
        lastName: 'صادقی',
        rawPhoneNumbers: ['0936 111 2233'],
      ),
      SourceContact(
        userId: 107,
        firstName: 'زهرا',
        lastName: 'سعیدی',
        rawPhoneNumbers: ['0902 333 4455'],
      ),
      SourceContact(
        userId: 108,
        firstName: 'نیما',
        lastName: 'کاظمی',
        rawPhoneNumbers: ['0918 777 8899'],
      ),
    ];

    _phoneContacts = const [
      PhoneBookContactInput(
        contactId: 'sample_p1',
        displayName: 'علی کریمی',
        rawPhoneNumbers: ['+989123456789'],
      ),
      PhoneBookContactInput(
        contactId: 'sample_p2',
        displayName: 'مخاطب قدیمی گوشی',
        rawPhoneNumbers: ['09121111111'],
      ),
    ];

    final matchEngine = ref.read(matchEngineProvider);
    final analysisInput = AnalysisInput(
      telegramContacts: _telegramContacts,
      phoneContacts: _phoneContacts,
    );
    final result = matchEngine.analyze(analysisInput);

    state = PreviewState(
      candidates: result.candidates,
      counters: result.counters,
    );
  }

  Future<void> _tryInitTdlib() async {
    if (_authSession != null) return;
    try {
      Directory cacheDir;
      try {
        cacheDir = await getTemporaryDirectory();
      } catch (e) {
        debugPrint('[TDLib] getTemporaryDirectory error: $e');
        cacheDir = Directory.systemTemp;
      }

      final dbDir = Directory('${cacheDir.path}/tdlib_db_${DateTime.now().millisecondsSinceEpoch}');
      final filesDir = Directory('${cacheDir.path}/tdlib_files_${DateTime.now().millisecondsSinceEpoch}');
      await dbDir.create(recursive: true);
      await filesDir.create(recursive: true);
      _dbDir = dbDir;
      _filesDir = filesDir;
      debugPrint('[TDLib] Storage directories created: ${dbDir.path}');

      final bridge = TelegramIsolateBridge();
      await bridge.start();
      _isolateBridge = bridge;

      final session = TdlibAuthSession(bridge: bridge);
      _authSession = session;
      session.init();
      debugPrint('[TDLib] Session initialized, listening to auth states...');

      session.authStateStream.listen((authState) {
        debugPrint('[TDLib] AuthState received: $authState');
        switch (authState) {
          case TgAuthState.waitingParameters:
            debugPrint('[TDLib] Sending TDLib parameters...');
            session.sendParameters(
              apiId: AppConfig.telegramApiId,
              apiHash: AppConfig.telegramApiHash,
              databaseDirectory: dbDir.path,
              filesDirectory: filesDir.path,
              databaseEncryptionKey: '',
            );
            break;
          case TgAuthState.waitingAuthMethod:
            debugPrint('[TDLib] Ready for phone number or QR code auth');
            break;
          case TgAuthState.waitingQrConfirmation:
            final link = session.qrLink;
            debugPrint('[TDLib] QR link received: $link');
            if (link != null) {
              dispatch(QrLinkUpdatedEvent(
                link: link,
                expiresAt: session.qrExpiresAt ??
                    DateTime.now().add(const Duration(seconds: 45)),
              ));
            }
            break;
          case TgAuthState.waitingCode:
            debugPrint('[TDLib] Waiting for authentication code from Telegram/SMS');
            final phone = _lastSubmittedPhone ?? session.currentPhoneNumber ?? '';
            if (phone.isNotEmpty) {
              dispatch(SubmitPhoneEvent(phone));
            }
            break;
          case TgAuthState.waitingPassword:
            debugPrint('[TDLib] 2FA Password required: hint=${session.passwordHint}');
            dispatch(RequirePasswordEvent(hint: session.passwordHint));
            break;
          case TgAuthState.ready:
            debugPrint('[TDLib] Authorization successful!');
            dispatch(const AuthSuccessEvent());
            break;
          default:
            break;
        }
      });
    } catch (e, st) {
      debugPrint('[TDLib] Init failed: $e\n$st');
    }
  }

  void chooseAuthMethod(AuthMethod method) {
    dispatch(ChooseAuthMethodEvent(method));
    if (method == AuthMethod.qr) {
      if (_authSession != null) {
        _authSession?.requestQrCode();
      } else {
        final qrLink =
            'tg://login?token=auth_token_${DateTime.now().millisecondsSinceEpoch}';
        dispatch(QrLinkUpdatedEvent(
          link: qrLink,
          expiresAt: DateTime.now().add(const Duration(seconds: 60)),
        ));
      }
    }
  }

  Future<Map<String, dynamic>?> submitPhoneNumber(String phone) async {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return null;
    _lastSubmittedPhone = trimmed;

    if (_authSession != null) {
      if (_authSession!.currentState != TgAuthState.waitingAuthMethod) {
        debugPrint(
            '[TDLib] Waiting for TgAuthState.waitingAuthMethod before submit (current: ${_authSession!.currentState})...');
        try {
          await _authSession!.authStateStream
              .firstWhere((s) => s == TgAuthState.waitingAuthMethod)
              .timeout(const Duration(seconds: 8));
        } catch (e) {
          debugPrint('[TDLib] Timed out waiting for waitingAuthMethod: $e');
        }
      }

      debugPrint('[TDLib] Submitting phone number: $trimmed');
      final res = await _authSession!.submitPhoneNumber(trimmed);
      debugPrint('[TDLib] Phone submit response: $res');
      if (res['@type'] == 'error') {
        return res;
      }
      // On success, advance to AuthCodeState
      dispatch(SubmitPhoneEvent(trimmed));
      return res;
    }

    // Offline / Mock fallback
    dispatch(SubmitPhoneEvent(trimmed));
    return null;
  }

  Future<Map<String, dynamic>?> submitCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return null;
    if (_authSession != null) {
      debugPrint('[TDLib] Submitting auth code: $trimmed');
      final res = await _authSession!.submitCode(trimmed);
      debugPrint('[TDLib] Code submit response: $res');
      if (res['@type'] == 'error') {
        return res;
      }
      if (_authSession!.currentState == TgAuthState.waitingPassword) {
        debugPrint('[TDLib] Code accepted -> 2FA Password required');
        dispatch(RequirePasswordEvent(hint: _authSession!.passwordHint));
        return null;
      }
      if (_authSession!.currentState == TgAuthState.ready) {
        debugPrint('[TDLib] Code accepted -> Authorization ready');
        dispatch(const AuthSuccessEvent());
        return null;
      }
    }
    dispatch(SubmitCodeEvent(trimmed));
    return null;
  }

  Future<Map<String, dynamic>?> submitPassword(String password) async {
    final trimmed = password.trim();
    if (trimmed.isEmpty) return null;
    if (_authSession != null) {
      debugPrint('[TDLib] Submitting 2FA password...');
      final res = await _authSession!.submitPassword(trimmed);
      debugPrint('[TDLib] Password submit response: $res');
      if (res['@type'] == 'error') {
        return res;
      }
      if (_authSession!.currentState == TgAuthState.ready) {
        debugPrint('[TDLib] Password accepted -> Authorization ready');
        dispatch(const AuthSuccessEvent());
        return null;
      }
    }
    dispatch(SubmitPasswordEvent(trimmed));
    return null;
  }

  void simulateAuthSuccess() {
    dispatch(const AuthSuccessEvent());
  }

  Future<void> fetchTelegramContacts({
    List<SourceContact>? mockContacts,
  }) async {
    dispatch(const TelegramProgressEvent(progress: 0.1, count: 0));

    if (mockContacts != null) {
      _telegramContacts = mockContacts;
    } else if (_authSession != null) {
      try {
        if (_authSession!.currentState != TgAuthState.ready) {
          debugPrint('[TDLib] Waiting for TgAuthState.ready before fetching contacts...');
          await _authSession!.authStateStream
              .firstWhere((s) => s == TgAuthState.ready)
              .timeout(const Duration(seconds: 15));
        }

        debugPrint('[TDLib] Fetching real contacts from live Telegram account...');
        _telegramContacts = await _authSession!.fetchContacts(
          onProgress: (progress, count) {
            dispatch(TelegramProgressEvent(progress: progress, count: count));
          },
        );
        debugPrint('[TDLib] Live contacts fetched: ${_telegramContacts.length}');
      } catch (e, st) {
        debugPrint('[TDLib] Error fetching real contacts: $e\n$st');
        _telegramContacts = [];
      }
    } else {
      debugPrint('[TDLib] AuthSession is null; returning empty contacts');
      _telegramContacts = [];
    }

    dispatch(TelegramProgressEvent(
      progress: 1.0,
      count: _telegramContacts.length,
    ));
    dispatch(const TelegramContactsReadyEvent());
  }

  Future<void> requestPhonePermission({
    bool? mockGranted,
    bool isLimitedIos = false,
  }) async {
    dispatch(const RequestPermissionEvent());

    bool granted = mockGranted ?? false;
    bool limited = isLimitedIos;

    if (mockGranted == null) {
      try {
        final adapter = ref.read(phoneBookAdapterProvider);
        final status = await adapter.requestPermission();
        granted = status == ContactsPermissionStatus.granted;
        limited = status == ContactsPermissionStatus.limitedIos;
      } catch (_) {
        granted = false;
      }
    }

    dispatch(PermissionResultEvent(
      granted: granted,
      isLimitedIos: limited,
    ));

    if (granted) {
      await readPhoneBookAndAnalyze();
    }
  }

  Future<void> readPhoneBookAndAnalyze({
    List<PhoneBookContactInput>? mockPhoneContacts,
  }) async {
    dispatch(const PhoneBookProgressEvent(progress: 0.2, count: 0));

    if (mockPhoneContacts != null) {
      _phoneContacts = mockPhoneContacts;
    } else {
      try {
        final adapter = ref.read(phoneBookAdapterProvider);
        _phoneContacts = await adapter.readAllContacts();
      } catch (_) {
        _phoneContacts = [];
      }
    }

    dispatch(PhoneBookProgressEvent(
      progress: 0.8,
      count: _phoneContacts.length,
    ));

    final matchEngine = ref.read(matchEngineProvider);
    final analysisInput = AnalysisInput(
      telegramContacts: _telegramContacts,
      phoneContacts: _phoneContacts,
    );

    final result = matchEngine.analyze(analysisInput);

    dispatch(AnalysisCompleteEvent(
      candidates: result.candidates,
      counters: result.counters,
    ));
  }

  void proceedToPreview() {
    dispatch(const ProceedToPreviewEvent());
  }

  void toggleCandidate(String candidateId) {
    dispatch(ToggleCandidateEvent(candidateId));
  }

  void selectAll(CandidateKind? kind, bool select) {
    dispatch(SelectAllEvent(kind: kind, select: select));
  }

  void updateCandidateName(String candidateId, String newName) {
    dispatch(UpdateCandidateNameEvent(
      candidateId: candidateId,
      newName: newName,
    ));
  }

  void setDestination(String destination) {
    dispatch(SetDestinationEvent(destination));
  }

  void openConfirmSheet() {
    dispatch(const OpenConfirmSheetEvent());
  }

  void closeConfirmSheet() {
    dispatch(const CloseConfirmSheetEvent());
  }

  Future<void> confirmAndWrite({
    PhoneBookAdapter? adapterOverride,
  }) async {
    final currentState = state;
    if (currentState is! ConfirmSheetState) return;

    final selected = currentState.preview.candidates
        .where((c) => c.selected)
        .toList();

    dispatch(const ConfirmWriteEvent());

    final PhoneBookAdapter adapter =
        adapterOverride ?? ref.read(phoneBookAdapterProvider);
    final total = selected.length;
    _insertedRecordIds = [];

    try {
      final writeResult = await adapter.writeBatch(
        candidates: selected,
        destinationAccount: currentState.preview.selectedDestination,
        onProgress: (processed, count) {
          dispatch(WriteProgressEvent(processed: processed, total: count));
        },
      );

      _insertedRecordIds = writeResult.successfullyAddedIds;

      final updatedCounters = currentState.preview.counters.copyWith(
        added: writeResult.successfullyAddedIds.length,
        failed: writeResult.failedCandidateIds.length,
      );

      dispatch(WriteCompleteEvent(
        counters: updatedCounters,
        createdContactIds: _insertedRecordIds,
      ));
    } catch (_) {
      dispatch(WriteCompleteEvent(
        counters: currentState.preview.counters.copyWith(
          failed: total,
        ),
        createdContactIds: const [],
      ));
    }
  }

  Future<void> undo({PhoneBookAdapter? adapterOverride}) async {
    final PhoneBookAdapter adapter =
        adapterOverride ?? ref.read(phoneBookAdapterProvider);
    if (_insertedRecordIds.isNotEmpty) {
      try {
        await adapter.undoCreatedContacts(_insertedRecordIds);
      } catch (_) {}
      _insertedRecordIds = [];
    }
    dispatch(const RequestUndoEvent());
  }

  Future<void> logOutAndCleanSession() async {
    try {
      if (_authSession != null) {
        debugPrint('[TDLib] Explicit server logOut initiated...');
        await _authSession!.logOut().timeout(const Duration(seconds: 4), onTimeout: () => {});
      }
    } catch (e) {
      debugPrint('[TDLib] logOut error: $e');
    }

    try {
      _isolateBridge?.stop();
    } catch (_) {}

    _authSession = null;
    _isolateBridge = null;

    if (_dbDir != null && await _dbDir!.exists()) {
      try {
        await _dbDir!.delete(recursive: true);
        debugPrint('[TDLib] TDLib database erased: ${_dbDir!.path}');
      } catch (_) {}
    }
    if (_filesDir != null && await _filesDir!.exists()) {
      try {
        await _filesDir!.delete(recursive: true);
        debugPrint('[TDLib] TDLib files erased: ${_filesDir!.path}');
      } catch (_) {}
    }

    _dbDir = null;
    _filesDir = null;
    _telegramContacts = [];
    _phoneContacts = [];
    _insertedRecordIds = [];
  }

  Future<void> cancelFlow() async {
    await logOutAndCleanSession();
    dispatch(const CancelFlowEvent());
  }

  Future<void> finishFlow() async {
    await logOutAndCleanSession();
    dispatch(const FinishFlowEvent());
    dispatch(const CleanupFinishedEvent());
  }

  Future<void> emergencyWipeAndReset() async {
    try {
      final cleaner = ref.read(sessionCleanerProvider);
      await cleaner.cleanSession(performServerLogout: false);
    } catch (_) {}
    _isolateBridge?.stop();
    _authSession = null;
    _isolateBridge = null;
    _telegramContacts = [];
    _phoneContacts = [];
    _insertedRecordIds = [];
    state = const WelcomeState();
  }
}
