import 'package:core_domain/ports/platform_ports.dart';

class InMemoryVault implements SecureVault {
  List<int>? _key;

  @override
  Future<void> storeEncryptionKey(List<int> keyBytes) async {
    _key = List<int>.from(keyBytes);
  }

  @override
  Future<List<int>?> getEncryptionKey() async {
    return _key != null ? List<int>.from(_key!) : null;
  }

  @override
  Future<void> clearEncryptionKey() async {
    _key = null;
  }
}
