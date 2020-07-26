import 'package:bfast/adapter/realtime.dart';
import 'package:bfast/bfast_config.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

class RealtimeController extends RealtimeAdapter {
  Socket socket;

  String eventName;
  String _appName;

  RealtimeController(String eventName,
      {String appName = BFastConfig.DEFAULT_APP,
      void Function(dynamic e) onConnect,
      void Function(dynamic e) onDisconnect}) {
    String path = eventName.length > 0 && eventName[0] == '/'
        ? eventName
        : '/' + eventName;
    this.socket = io(
        BFastConfig.getInstance().functionsURL(path, appName),
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
          // 'extraHeaders': {'foo': 'bar'} // optional
        });
    this._appName = appName;
    this.eventName = eventName;
    if (onConnect != null) {
      this.socket.on("connect", (data) => onConnect(data));
    }
    if (onDisconnect != null) {
      this.socket.on("disconnect", (data) => onDisconnect(data));
    }
    this.open();
  }

  @override
  void emit({dynamic auth, @required dynamic body}) {
    this.socket.emit(this.eventName, {"auth": auth, "body": body});
  }

  @override
  void listener(void Function(dynamic data) handler) {
    this.socket.on(this.eventName, (data) => handler(data));
  }

  void close() {
    this.socket.close();
  }

  void open() {
    this.socket.open();
  }
}
