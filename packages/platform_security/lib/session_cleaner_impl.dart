import 'dart:io';
import 'package:core_domain/ports/platform_ports.dart';

class SessionCleanerImpl implements SessionCleaner {
  final SecureVault vault;
  final Directory tdlibDbDir;
  final Directory tdlibFilesDir;
  final Future<void> Function()? onServerLogOut;

  SessionCleanerImpl({
    required this.vault,
    required this.tdlibDbDir,
    required this.tdlibFilesDir,
    this.onServerLogOut,
  });

  @override
  Future<void> cleanSession({required bool performServerLogout}) async {
    // 1. Server-side logout if requested (INV-11, FR-AUTH-032)
    if (performServerLogout && onServerLogOut != null) {
      try {
        await onServerLogOut!();
      } catch (_) {
        // If network fails, proceed to local wipe anyway and show manual advice notice (SRS §8.4 step 4)
      }
    }

    // 2. Delete the encryption key from hardware-backed vault
    await vault.clearEncryptionKey();

    // 3. Recursively wipe local TDLib directories (INV-11)
    await _deleteDir(tdlibDbDir);
    await _deleteDir(tdlibFilesDir);

    // 4. Verification pass
    if (await tdlibDbDir.exists() || await tdlibFilesDir.exists()) {
      throw StateError('TDLib files wipe verification failed');
    }
  }

  Future<void> _deleteDir(Directory dir) async {
    if (await dir.exists()) {
      try {
        await dir.delete(recursive: true);
      } catch (_) {}
    }
  }
}
