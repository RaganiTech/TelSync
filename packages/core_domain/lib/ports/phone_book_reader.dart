import '../ports/match_engine.dart';

enum ContactsPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  limitedIos,
}

abstract interface class PhoneBookReader {
  Future<ContactsPermissionStatus> checkPermission();
  Future<ContactsPermissionStatus> requestPermission();
  Future<List<PhoneBookContactInput>> readAllContacts();
}
