import 'package:bfast/bfast_config.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketController {
  Socket socket;

  String eventName;

  SocketController(String eventName,
      {appName = BFastConfig.DEFAULT_APP,
      void Function(dynamic e) onConnect,
      void Function(dynamic e) onDisconnect}) {
    String path = eventName.length > 0 && eventName[0] == '/'
        ? eventName
        : '/' + eventName;
    var url = path == '/__changes__'
        ? BFastConfig.getInstance().databaseURL(appName, path)
        : BFastConfig.getInstance().functionsURL(path, appName);
    this.socket = io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      // 'extraHeaders': {'foo': 'bar'} // optional
    });
    this.eventName = eventName;
    if (onConnect != null) {
      this.socket.on("connect", (data) => onConnect(data));
    }
    if (onDisconnect != null) {
      this.socket.on("disconnect", (data) => onDisconnect(data));
    }
    this.open();
  }

  void emit({dynamic auth, @required dynamic body}) {
    this.socket.emit(this.eventName, {"auth": auth, "body": body});
  }

  void listener(dynamic Function(dynamic response) handler) {
    this.socket.on(this.eventName, (data) => handler(data));
  }

  void close() {
    if (this.socket.connected == true) {
      this.socket.close();
    }
  }

  void open() {
    if (this.socket.disconnected == true) {
      this.socket.open();
    }
  }
}
