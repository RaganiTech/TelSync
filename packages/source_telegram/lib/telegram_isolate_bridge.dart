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
        completer.complete();
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
    final client = TdJsonClient(libraryPath: config.libraryPath);
    final commandPort = ReceivePort();
    config.sendPort.send(commandPort.sendPort);

    bool running = true;
    commandPort.listen((message) {
      if (message is _StopCommand) {
        running = false;
        client.destroy();
        commandPort.close();
      } else if (message is Map<String, dynamic>) {
        client.send(message);
      }
    });

    // Receive loop
    while (running) {
      final res = client.receive(timeout: 0.5);
      if (res != null) {
        config.sendPort.send(res);
      }
    }
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
