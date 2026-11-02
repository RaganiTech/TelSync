import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef TdCreateNative = Pointer<Void> Function();
typedef TdCreateDart = Pointer<Void> Function();

typedef TdSendNative = Void Function(Pointer<Void> client, Pointer<Utf8> request);
typedef TdSendDart = void Function(Pointer<Void> client, Pointer<Utf8> request);

typedef TdReceiveNative = Pointer<Utf8> Function(Pointer<Void> client, Double timeout);
typedef TdReceiveDart = Pointer<Utf8> Function(Pointer<Void> client, double timeout);

typedef TdExecuteNative = Pointer<Utf8> Function(Pointer<Void> client, Pointer<Utf8> request);
typedef TdExecuteDart = Pointer<Utf8> Function(Pointer<Void> client, Pointer<Utf8> request);

typedef TdDestroyNative = Void Function(Pointer<Void> client);
typedef TdDestroyDart = void Function(Pointer<Void> client);

class TdJsonClient {
  late final DynamicLibrary _lib;
  late final TdCreateDart _create;
  late final TdSendDart _send;
  late final TdReceiveDart _receive;
  late final TdExecuteDart _execute;
  late final TdDestroyDart _destroy;

  Pointer<Void>? _client;

  TdJsonClient({String? libraryPath}) {
    _lib = _openLibrary(libraryPath);
    _create = _lib.lookupFunction<TdCreateNative, TdCreateDart>('td_json_client_create');
    _send = _lib.lookupFunction<TdSendNative, TdSendDart>('td_json_client_send');
    _receive = _lib.lookupFunction<TdReceiveNative, TdReceiveDart>('td_json_client_receive');
    _execute = _lib.lookupFunction<TdExecuteNative, TdExecuteDart>('td_json_client_execute');
    _destroy = _lib.lookupFunction<TdDestroyNative, TdDestroyDart>('td_json_client_destroy');

    _client = _create();
  }

  void send(Map<String, dynamic> request) {
    if (_client == null) throw StateError('TDLib client is not initialized');
    final jsonStr = jsonEncode(request);
    final nativeStr = jsonStr.toNativeUtf8();
    try {
      _send(_client!, nativeStr);
    } finally {
      calloc.free(nativeStr);
    }
  }

  Map<String, dynamic>? receive({double timeout = 1.0}) {
    if (_client == null) return null;
    final ptr = _receive(_client!, timeout);
    if (ptr.address == 0) return null;
    final str = ptr.toDartString();
    if (str.isEmpty) return null;
    return jsonDecode(str) as Map<String, dynamic>?;
  }

  Map<String, dynamic>? execute(Map<String, dynamic> request) {
    final jsonStr = jsonEncode(request);
    final nativeStr = jsonStr.toNativeUtf8();
    try {
      final ptr = _execute(_client ?? Pointer.fromAddress(0), nativeStr);
      if (ptr.address == 0) return null;
      final str = ptr.toDartString();
      if (str.isEmpty) return null;
      return jsonDecode(str) as Map<String, dynamic>?;
    } finally {
      calloc.free(nativeStr);
    }
  }

  void destroy() {
    if (_client != null) {
      _destroy(_client!);
      _client = null;
    }
  }

  static DynamicLibrary _openLibrary(String? customPath) {
    if (customPath != null) {
      return DynamicLibrary.open(customPath);
    }
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libtdjson.so');
    } else if (Platform.isIOS) {
      return DynamicLibrary.process();
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('tdjson.dll');
    } else if (Platform.isMacOS) {
      return DynamicLibrary.open('libtdjson.dylib');
    } else {
      return DynamicLibrary.open('libtdjson.so');
    }
  }
}
