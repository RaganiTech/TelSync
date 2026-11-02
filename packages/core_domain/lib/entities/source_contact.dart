import 'package:meta/meta.dart';
import 'normalized_number.dart';

@immutable
class SourceContact {
  final int userId;
  final String firstName;
  final String lastName;
  final List<String> rawPhoneNumbers;
  final List<NormalizedNumber> normalizedNumbers;

  const SourceContact({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.rawPhoneNumbers,
    this.normalizedNumbers = const [],
  });

  String get displayName {
    final parts = [firstName.trim(), lastName.trim()]
        .where((s) => s.isNotEmpty)
        .toList();
    return parts.join(' ');
  }

  SourceContact copyWith({
    List<NormalizedNumber>? normalizedNumbers,
  }) {
    return SourceContact(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      rawPhoneNumbers: rawPhoneNumbers,
      normalizedNumbers: normalizedNumbers ?? this.normalizedNumbers,
    );
  }
}
