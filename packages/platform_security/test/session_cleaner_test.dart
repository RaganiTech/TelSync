import 'dart:io';
import 'package:platform_security/in_memory_vault.dart';
import 'package:platform_security/session_cleaner_impl.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDbDir;
  late Directory tempFilesDir;
  late InMemoryVault vault;

  setUp(() async {
    final sysTemp = Directory.systemTemp;
    tempDbDir = await sysTemp.createTemp('tdlib_db_');
    tempFilesDir = await sysTemp.createTemp('tdlib_files_');

    // Create canary files inside
    await File('${tempDbDir.path}/canary.bin').writeAsString('sensitive data');
    await File('${tempFilesDir.path}/canary.png').writeAsString('avatar');

    vault = InMemoryVault();
    await vault.storeEncryptionKey([1, 2, 3, 4, 5]);
  });

  tearDown(() async {
    if (await tempDbDir.exists()) await tempDbDir.delete(recursive: true);
    if (await tempFilesDir.exists()) await tempFilesDir.delete(recursive: true);
  });

  group('SessionCleanerImpl', () {
    test('wipes local directories and clears vault on cleanSession', () async {
      bool serverLogoutCalled = false;
      final cleaner = SessionCleanerImpl(
        vault: vault,
        tdlibDbDir: tempDbDir,
        tdlibFilesDir: tempFilesDir,
        onServerLogOut: () async {
          serverLogoutCalled = true;
        },
      );

      await cleaner.cleanSession(performServerLogout: true);

      expect(serverLogoutCalled, isTrue);
      expect(await vault.getEncryptionKey(), isNull);
      expect(await tempDbDir.exists(), isFalse);
      expect(await tempFilesDir.exists(), isFalse);
    });

    test('proceeds to local wipe even if server logout throws network error (SRS §8.4)', () async {
      final cleaner = SessionCleanerImpl(
        vault: vault,
        tdlibDbDir: tempDbDir,
        tdlibFilesDir: tempFilesDir,
        onServerLogOut: () async {
          throw const SocketException('Network is down');
        },
      );

      // Must not throw, must complete local wipe
      await cleaner.cleanSession(performServerLogout: true);

      expect(await vault.getEncryptionKey(), isNull);
      expect(await tempDbDir.exists(), isFalse);
      expect(await tempFilesDir.exists(), isFalse);
    });
  });
}
