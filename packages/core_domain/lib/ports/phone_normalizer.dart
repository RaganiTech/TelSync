import '../entities/normalized_number.dart';

enum NumberSource {
  telegram,
  phonebook,
}

abstract interface class PhoneNormalizer {
  NormalizedNumber normalize(
    String raw, {
    required NumberSource source,
    String defaultRegion = 'IR',
  });
}
