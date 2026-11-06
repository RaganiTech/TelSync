import 'dart:async';
import 'dart:isolate';
import 'td_json_client.dart';

class TelegramIsolateBridge {
  final String? libraryPath;

  SendPort? _isolateSendPort;
  Isolate? _isolate;
  final StreamController<Map<String, dynamic>> _updateController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get updates => _updateController.stream;

  TelegramIsolateBridge({this.libraryPath});

  Future<void> start() async {
    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      _isolateEntry,
      _IsolateConfig(
        sendPort: receivePort.sendPort,
        libraryPath: libraryPath,
      ),
    );

    final completer = Completer<void>();
    receivePort.listen((message) {
      if (message is SendPort) {
        _isolateSendPort = message;
        if (!completer.isCompleted) completer.complete();
      } else if (message == null) {
        if (!completer.isCompleted) completer.complete();
      } else if (message is Map<String, dynamic>) {
        _updateController.add(message);
      }
    });

    await completer.future;
  }

  void send(Map<String, dynamic> request) {
    if (_isolateSendPort == null) {
      throw StateError('Telegram isolate bridge is not started');
    }
    _isolateSendPort!.send(request);
  }

  Future<void> stop() async {
    if (_isolateSendPort != null) {
      _isolateSendPort!.send(const _StopCommand());
      _isolateSendPort = null;
    }
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    await _updateController.close();
  }

  static void _isolateEntry(_IsolateConfig config) {
    TdJsonClient? client;
    try {
      client = TdJsonClient(libraryPath: config.libraryPath);
    } catch (e) {
      // Library not found on this platform (e.g. unit test runner)
      config.sendPort.send(null);
      return;
    }

    final commandPort = ReceivePort();
    config.sendPort.send(commandPort.sendPort);

    Timer? pollTimer;
    commandPort.listen((message) {
      if (message is _StopCommand) {
        pollTimer?.cancel();
        client?.destroy();
        commandPort.close();
      } else if (message is Map<String, dynamic>) {
        try {
          client?.send(message);
        } catch (_) {}
      }
    });

    // Non-blocking polling loop that yields to the isolate event loop
    pollTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      try {
        while (true) {
          final res = client?.receive(timeout: 0.0);
          if (res == null) break;
          config.sendPort.send(res);
        }
      } catch (_) {}
    });
  }
}

class _IsolateConfig {
  final SendPort sendPort;
  final String? libraryPath;
  _IsolateConfig({required this.sendPort, this.libraryPath});
}

class _StopCommand {
  const _StopCommand();
}
