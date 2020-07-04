import 'package:bfast/adapter/realtime.dart';
import 'package:bfast/configuration.dart';
import 'package:socket_io_client/socket_io_client.dart';

class RealtimeController extends RealtimeAdapter {
  Socket socket;

  String eventName;
  String _appName;

  RealtimeController(String eventName,
      {String appName = BFastConfig.DEFAULT_APP,
      void Function(dynamic e) onConnect,
      void Function(dynamic e) onDisconnect}) {
    this.socket = io(
        BFastConfig.getInstance().functionsURL('/', appName), <String, dynamic>{
      //  'transports': ['websocket'],
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
  }

  @override
  void emit({dynamic auth, dynamic payload}) {
    this.socket.emit(this.eventName, {"auth": auth, "payload": payload});
  }

  @override
  void listener(dynamic Function({dynamic auth, dynamic payload}) handler) {
    this.socket.on(this.eventName,
        (data) => handler(auth: data?.auth, payload: data?.payload));
  }

  void close() {
    if (this.socket.connected) {
      this.socket.disconnect();
    }
  }

  void open() {
    if (this.socket.disconnected) {
      this.socket.connect();
    }
  }
}
