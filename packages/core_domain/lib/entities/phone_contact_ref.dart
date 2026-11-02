import 'package:meta/meta.dart';

@immutable
class PhoneContactRef {
  final String contactId;
  final String displayName;
  final String? accountLabel;

  const PhoneContactRef({
    required this.contactId,
    required this.displayName,
    this.accountLabel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneContactRef &&
          runtimeType == other.runtimeType &&
          contactId == other.contactId &&
          displayName == other.displayName;

  @override
  int get hashCode => Object.hash(contactId, displayName);
}
