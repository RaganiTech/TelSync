import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state++;
}

final testProvider = NotifierProvider<TestNotifier, int>(TestNotifier.new);

void main() {
  test('Notifier works in flutter_riverpod', () {
    final container = ProviderContainer();
    expect(container.read(testProvider), 0);
    container.read(testProvider.notifier).increment();
    expect(container.read(testProvider), 1);
  });
}
