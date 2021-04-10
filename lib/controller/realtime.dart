import 'package:bfast/bfast_config.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketController {
  Socket socket;

  String eventName;

  SocketController(String eventName,
      {appName = BFastConfig.DEFAULT_APP,
      dynamic Function() onConnect,
      dynamic Function() onDisconnect}) {
    String path = eventName.length > 0 && eventName[0] == '/'
        ? eventName
        : '/' + eventName;
    var url = path == '/v2/__changes__'
        ? BFastConfig.getInstance().databaseURL(appName, path)
        : BFastConfig.getInstance().functionsURL(path, appName);
    this.socket = io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': double.infinity,
      'reconnectionDelay': 2000,        // how long to initially wait before attempting a new reconnection
      'reconnectionDelayMax': 5000,     // maximum amount of time to wait between reconnection attempts. Each attempt increases the reconnection delay by 2x along with a randomization factor
      'randomizationFactor': 0.5,
      // 'extraHeaders': {'foo': 'bar'} // optional
    });
    this.eventName = eventName;
    if (onConnect != null) {
      this.socket.on("connect", (_) => onConnect());
    }
    if (onDisconnect != null) {
      this.socket.on("disconnect", (_) => onDisconnect());
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
