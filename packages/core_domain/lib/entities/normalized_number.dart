import 'package:meta/meta.dart';

enum NumberStatus {
  valid,
  invalid,
  ambiguous,
  anonymousTg,
  noNumber,
}

enum NumberType {
  mobile,
  fixedLine,
  other,
}

@immutable
class NormalizedNumber {
  final String raw;
  final String? e164;
  final String? nsn;
  final String digitsOnly;
  final bool assumedRegion;
  final NumberStatus status;
  final NumberType? type;
  final bool hasExtension;

  const NormalizedNumber({
    required this.raw,
    this.e164,
    this.nsn,
    required this.digitsOnly,
    required this.assumedRegion,
    required this.status,
    this.type,
    this.hasExtension = false,
  });

  bool get isValid => status == NumberStatus.valid;
  bool get isAnonymousTg => status == NumberStatus.anonymousTg;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NormalizedNumber &&
          runtimeType == other.runtimeType &&
          raw == other.raw &&
          e164 == other.e164 &&
          digitsOnly == other.digitsOnly &&
          status == other.status;

  @override
  int get hashCode => Object.hash(raw, e164, digitsOnly, status);

  @override
  String toString() =>
      'NormalizedNumber(e164: $e164, digits: $digitsOnly, status: $status, assumed: $assumedRegion)';
}
