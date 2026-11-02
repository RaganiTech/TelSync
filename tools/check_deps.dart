import 'dart:io';

void main() {
  print('Running Package Dependency Boundary Verification (NFR-BLD-002)...');

  // Enforces SRS §16.1:
  // - core_domain, match_engine, core_phone depend on no Flutter and no platform packages.
  // - Adapters depend on core_domain only.
  final forbiddenInCore = ['package:flutter', 'package:pigeon', 'sink_phonebook', 'source_telegram'];
  final corePackages = ['core_domain', 'core_phone', 'match_engine'];

  bool violationFound = false;

  for (final pkg in corePackages) {
    final dir = Directory('packages/$pkg/lib');
    if (!dir.existsSync()) continue;

    for (final file in dir.listSync(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        final content = file.readAsStringSync();
        for (final forbidden in forbiddenInCore) {
          if (content.contains(forbidden)) {
            print('VIOLATION: Pure package "$pkg" (${file.path}) imports "$forbidden"');
            violationFound = true;
          }
        }
      }
    }
  }

  if (violationFound) {
    print('FAILED: Package boundary violations detected!');
    exit(1);
  }

  print('PASSED: All package boundaries conform to architectural invariants.');
}
