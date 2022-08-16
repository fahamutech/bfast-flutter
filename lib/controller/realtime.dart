import 'package:bfast/options.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../util.dart';
import 'database.dart';

// ((a) -> b) -> map(b.body -> Map)
// impure because it throw error.
executeEvent(Function fn1, Function fn2)  => (String name) => null;

bool _isAbsolute(x)=>x!=null && x.length>0&&x[0]=='/';
Function eventPath = ifDoElse(_isAbsolute, (y)=>y, (y)=>'/$y');

bool _isDbChanges(x)=>x!=null&&x=='/v2/__changes__';

Function eventUrl = ifDoElse(_isDbChanges, (t)=>databaseURL(options: options), fn2)

Function url = compose([(x)=>,eventPath]);
// = compose([
//   ifThrow((x) => errorsMessage(x) != '', (x) => errorsMessage(x)),
//   executeRule
// ]);

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
