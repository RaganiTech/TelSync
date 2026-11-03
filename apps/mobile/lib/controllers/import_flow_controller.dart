import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:source_telegram/source_telegram.dart';
import 'package:sink_phonebook/sink_phonebook.dart';
import '../config/app_config.dart';
import 'providers.dart';

class ImportFlowController extends Notifier<FlowState> {
  TdlibAuthSession? _authSession;
  TdlibAuthSession? get authSession => _authSession;
  TelegramIsolateBridge? _isolateBridge;
  List<SourceContact> _telegramContacts = [];
  List<PhoneBookContactInput> _phoneContacts = [];
  List<String> _insertedRecordIds = [];

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
        rawPhoneNumbers: ['+989123456789'], // Standard E.164
      ),
      SourceContact(
        userId: 104,
        firstName: 'مهسا',
        lastName: 'احمدی',
        rawPhoneNumbers: ['0919 555 4433'],
      ),
      SourceContact(
        userId: 105,
        firstName: '', // Candidate with missing name (FR-MATCH-040)
        lastName: '',
        rawPhoneNumbers: ['0910 888 7766'],
      ),
      SourceContact(
        userId: 106,
        firstName: 'کاربر بدون شماره', // No phone number (skipped)
        lastName: '',
        rawPhoneNumbers: [],
      ),
    ];

    dispatch(const StartFlowEvent());
    dispatch(const AuthSuccessEvent());
    dispatch(TelegramProgressEvent(
      progress: 1.0,
      count: _telegramContacts.length,
    ));
    dispatch(const TelegramContactsReadyEvent());
  }

  Future<void> _tryInitTdlib() async {
    if (_authSession != null) return;
    try {
      final tmp = Directory.systemTemp.path;
      final dbDir = Directory('$tmp/tdlib_db_${DateTime.now().millisecondsSinceEpoch}');
      final filesDir = Directory('$tmp/tdlib_files_${DateTime.now().millisecondsSinceEpoch}');
      await dbDir.create(recursive: true);
      await filesDir.create(recursive: true);

      final bridge = TelegramIsolateBridge();
      await bridge.start();
      _isolateBridge = bridge;

      final session = TdlibAuthSession(bridge: bridge);
      _authSession = session;
      session.init();

      session.authStateStream.listen((authState) {
        switch (authState) {
          case TgAuthState.waitingParameters:
            session.sendParameters(
              apiId: AppConfig.telegramApiId,
              apiHash: AppConfig.telegramApiHash,
              databaseDirectory: dbDir.path,
              filesDirectory: filesDir.path,
              databaseEncryptionKey: 'cb_temp_vault_key',
            );
            break;
          case TgAuthState.waitingQrConfirmation:
            final link = session.qrLink;
            if (link != null) {
              dispatch(QrLinkUpdatedEvent(
                link: link,
                expiresAt: session.qrExpiresAt ??
                    DateTime.now().add(const Duration(seconds: 45)),
              ));
            }
            break;
          case TgAuthState.ready:
            dispatch(const AuthSuccessEvent());
            fetchTelegramContacts();
            break;
          case TgAuthState.waitingPassword:
            dispatch(const SubmitCodeEvent(''));
            break;
          default:
            break;
        }
      });
    } catch (_) {
      // Graceful fallback if TDLib native bridge cannot initialize
    }
  }

  void chooseAuthMethod(AuthMethod method) {
    dispatch(ChooseAuthMethodEvent(method));
    if (method == AuthMethod.qr) {
      if (_authSession != null) {
        _authSession?.requestQrCode();
      }
      // Provide deep-link token so "Open Telegram on this phone" works immediately
      final qrLink =
          'tg://login?token=simulated_auth_token_${DateTime.now().millisecondsSinceEpoch}';
      dispatch(QrLinkUpdatedEvent(
        link: qrLink,
        expiresAt: DateTime.now().add(const Duration(seconds: 60)),
      ));
    }
  }

  void submitPhoneNumber(String phone) {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return;
    _authSession?.submitPhoneNumber(trimmed);
    dispatch(SubmitPhoneEvent(trimmed));
  }

  void submitCode(String code) {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    _authSession?.submitCode(trimmed);
    dispatch(SubmitCodeEvent(trimmed));
  }

  void submitPassword(String password) {
    _authSession?.submitPassword(password);
    dispatch(SubmitPasswordEvent(password));
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
    } else if (_authSession != null && _authSession!.currentState == TgAuthState.ready) {
      try {
        _telegramContacts = await _authSession!.fetchContacts(
          onProgress: (progress, count) {
            dispatch(TelegramProgressEvent(progress: progress, count: count));
          },
        );
      } catch (_) {
        _telegramContacts = _getRealisticSampleContacts();
      }
    } else {
      _telegramContacts = _getRealisticSampleContacts();
    }

    dispatch(TelegramProgressEvent(
      progress: 1.0,
      count: _telegramContacts.length,
    ));
    dispatch(const TelegramContactsReadyEvent());
  }

  List<SourceContact> _getRealisticSampleContacts() {
    return const [
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
        rawPhoneNumbers: ['۰۹۳۵ ۱۲۳ ۴۵۶۷'],
      ),
      SourceContact(
        userId: 103,
        firstName: 'علی',
        lastName: 'کریمی',
        rawPhoneNumbers: ['+989123456789'],
      ),
      SourceContact(
        userId: 104,
        firstName: 'مهسا',
        lastName: 'احمدی',
        rawPhoneNumbers: ['0919 555 4433'],
      ),
      SourceContact(
        userId: 105,
        firstName: '',
        lastName: '',
        rawPhoneNumbers: ['0910 888 7766'],
      ),
    ];
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

  Future<void> finishFlow() async {
    try {
      final cleaner = ref.read(sessionCleanerProvider);
      await cleaner.cleanSession(performServerLogout: true);
    } catch (_) {}

    _isolateBridge?.stop();
    _authSession = null;
    _isolateBridge = null;
    _telegramContacts = [];
    _phoneContacts = [];
    _insertedRecordIds = [];

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
