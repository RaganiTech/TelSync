import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';
import 'package:mobile/controllers/providers.dart';
import 'package:mobile/views/flow_screen_host.dart';
import 'package:mobile/views/s11_preview_view.dart';
import 'package:sink_phonebook/sink_phonebook.dart';

class TestMockPhoneBookAdapter extends Fake implements PhoneBookAdapter {
  final List<String> inserted = [];

  @override
  Future<ContactsPermissionStatus> requestPermission() async =>
      ContactsPermissionStatus.granted;

  @override
  Future<List<PhoneBookContactInput>> readAllContacts() async {
    return [
      const PhoneBookContactInput(
        contactId: 'device_c1',
        displayName: 'مخاطب موجود در گوشی',
        rawPhoneNumbers: ['+989121111111'],
      ),
    ];
  }

  @override
  Future<WriteResult> writeBatch({
    required List<ImportCandidate> candidates,
    required String? destinationAccount,
    void Function(int processed, int total)? onProgress,
  }) async {
    final ids = candidates.map((c) => c.id).toList();
    inserted.addAll(ids);
    onProgress?.call(ids.length, ids.length);
    return WriteResult(
      successfullyAddedIds: ids,
      failedCandidateIds: const [],
      skippedDuplicateCandidateIds: const [],
    );
  }

  @override
  Future<int> undoCreatedContacts(List<String> contactIds) async {
    inserted.clear();
    return contactIds.length;
  }
}

Widget createTestApp({
  required ProviderContainer container,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('fa'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      home: const FlowScreenHost(),
    ),
  );
}

void main() {
  group('UI Flow Widget Tests (S1 through S14)', () {
    late ProviderContainer container;
    late TestMockPhoneBookAdapter mockAdapter;

    setUp(() {
      mockAdapter = TestMockPhoneBookAdapter();
      container = ProviderContainer(
        overrides: [
          phoneBookAdapterProvider.overrideWithValue(mockAdapter),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('S1 Welcome View renders title, trust cards and reacts to Start button',
        (tester) async {
      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('مخاطبین تلگرامت را به گوشی بیاور'), findsOneWidget);
      expect(find.text('شروع'), findsOneWidget);
      expect(find.byType(TrustCard), findsOneWidget);

      await tester.tap(find.text('شروع'));
      await tester.pumpAndSettle();

      // Should transition to S2 Auth Choose
      expect(find.text('نمایش کد QR'), findsOneWidget);
      expect(find.text('ورود با شماره و کد'), findsOneWidget);
    });

    testWidgets('S2 Choose Auth -> S3 Phone Entry -> S4 OTP Code -> S7 Fetching -> S8 Permission',
        (tester) async {
      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      // Tap Start
      await tester.tap(find.text('شروع'));
      await tester.pumpAndSettle();

      // Choose Phone
      await tester.tap(find.text('ورود با شماره و کد'));
      await tester.pumpAndSettle();

      // In S3 Phone View
      expect(find.text('ادامه'), findsOneWidget);
      await tester.tap(find.text('ادامه'));
      await tester.pumpAndSettle();

      // In S4 OTP Code View
      expect(find.text('کد تأیید'), findsOneWidget);

      // Simulate Auth Success -> enters FetchingTelegramState
      final flowNotifier = container.read(importFlowControllerProvider.notifier);
      flowNotifier.simulateAuthSuccess();
      await tester.pump(); // Render Fetching screen

      expect(find.text('دریافت مخاطبین'), findsOneWidget);

      // Advance through fetching delay
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('دسترسی به مخاطبین'), findsOneWidget);
    });

    testWidgets('S8 Permission Rationale to S10 Summary and S11 Preview with Candidate Selection',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      final flowNotifier = container.read(importFlowControllerProvider.notifier);

      // Walk through auth to reaching Fetching state
      flowNotifier.startImport();
      flowNotifier.chooseAuthMethod(AuthMethod.phone);
      flowNotifier.submitPhoneNumber('+989123456789');
      flowNotifier.submitCode('12345');
      flowNotifier.simulateAuthSuccess();

      // Feed Telegram contact and trigger permission request
      await flowNotifier.fetchTelegramContacts(mockContacts: [
        const SourceContact(
          userId: 101,
          firstName: 'سارا',
          lastName: 'محمدی',
          rawPhoneNumbers: ['+989129999999'],
        ),
      ]);
      await tester.pump(const Duration(milliseconds: 100));

      // In S8 Permission View
      expect(find.text('دادن دسترسی'), findsOneWidget);

      // Grant permission
      await flowNotifier.requestPhonePermission(mockGranted: true);
      await tester.pump(const Duration(milliseconds: 100));

      // In S10 Summary View
      expect(find.text('نتیجه بررسی مخاطبین'), findsOneWidget);
      expect(find.text('مشاهده و انتخاب مخاطبین'), findsOneWidget);

      // Click to go to S11 Preview View
      await tester.tap(find.text('مشاهده و انتخاب مخاطبین'));
      await tester.pumpAndSettle();

      // In S11 Preview View
      expect(find.text('پیش‌نمایش مخاطبین'), findsOneWidget);
      expect(find.text('سارا محمدی'), findsOneWidget);

      // Click Confirm CTA
      expect(find.textContaining('ادامه و تأیید'), findsOneWidget);
      await tester.tap(find.textContaining('ادامه و تأیید'));
      await tester.pumpAndSettle();

      // In S12 Confirm Sheet
      expect(find.text('تأیید نهایی افزودن'), findsOneWidget);
      expect(find.text('مخاطبین فعلی تو بدون تغییر می‌مانند.'), findsOneWidget);

      // Confirm Write
      await tester.tap(find.textContaining('افزودن قطعی'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // In S14 Report View
      expect(find.text('گزارش پایان کار'), findsOneWidget);
      expect(find.text('1 مخاطب اضافه شد'), findsOneWidget);
      expect(find.text('بازگردانی افزوده‌ها'), findsOneWidget);

      // Test Undo by triggering button callback
      final secondaryBtn = tester.widget<SecondaryButton>(find.byType(SecondaryButton));
      secondaryBtn.onPressed!();
      await tester.pumpAndSettle();
      expect(mockAdapter.inserted.isEmpty, isTrue);

      // In S17 Cleanup / Safe reset View
      expect(find.text('ورود به صفحه اصلی'), findsOneWidget);
      await tester.tap(find.text('ورود به صفحه اصلی'));
      await tester.pumpAndSettle();

      // Reverts back to Welcome View
      expect(find.text('مخاطبین تلگرامت را به گوشی بیاور'), findsOneWidget);
    });
  });
}
