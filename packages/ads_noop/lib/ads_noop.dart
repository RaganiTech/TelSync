abstract interface class AdProvider {
  bool get isEnabled;
}

class NoopAdProvider implements AdProvider {
  const NoopAdProvider();

  @override
  bool get isEnabled => false;
}
