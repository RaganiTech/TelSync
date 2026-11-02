import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/contacts_api.g.dart',
  dartTestOut: 'test/contacts_api_test.g.dart',
  kotlinOut: 'android/src/main/kotlin/com/contactbridge/sink_phonebook/ContactsApi.g.kt',
  kotlinOptions: KotlinOptions(
    package: 'com.contactbridge.sink_phonebook',
  ),
  swiftOut: 'ios/Classes/ContactsApi.g.swift',
  swiftOptions: SwiftOptions(),
))
enum NativePermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  limitedIos,
}

class NativeContact {
  final String contactId;
  final String displayName;
  final List<String?> phoneNumbers;
  final String? accountLabel;

  NativeContact({
    required this.contactId,
    required this.displayName,
    required this.phoneNumbers,
    this.accountLabel,
  });
}

class NativeAccount {
  final String name;
  final String type;
  final bool isDeviceLocal;
  final bool syncsToCloud;

  NativeAccount({
    required this.name,
    required this.type,
    required this.isDeviceLocal,
    required this.syncsToCloud,
  });
}

class NativeCandidate {
  final String id;
  final String displayName;
  final List<String?> numbers;

  NativeCandidate({
    required this.id,
    required this.displayName,
    required this.numbers,
  });
}

class NativeWriteResult {
  final List<String?> successfullyAddedIds;
  final List<String?> failedCandidateIds;
  final List<String?> createdRecordIds;

  NativeWriteResult({
    required this.successfullyAddedIds,
    required this.failedCandidateIds,
    required this.createdRecordIds,
  });
}

@HostApi()
abstract class ContactsHostApi {
  NativePermissionStatus getPermissionStatus();
  @async
  NativePermissionStatus requestPermission();
  @async
  List<NativeContact> readAllContacts();
  @async
  List<NativeAccount> getAvailableAccounts();
  @async
  NativeWriteResult writeContactsBatch(
    List<NativeCandidate> candidates,
    String? accountName,
    String? accountType,
  );
  @async
  int undoCreatedContacts(List<String> recordIds);
}
