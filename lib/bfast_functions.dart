import 'package:bfast/adapter/function.dart';
import 'package:bfast/adapter/realtime.dart';
import 'package:bfast/configuration.dart';
import 'package:bfast/controller/function.dart';
import 'package:bfast/controller/realtime.dart';
import 'package:bfast/controller/rest.dart';

class BFastFunctions {
  String _appName;

  BFastFunctions({String appName = BFastConfig.DEFAULT_APP}) {
    this._appName = appName;
  }

  FunctionAdapter request(String path) {
    return FunctionController(path, DartHttpClientController(),
        appName: this._appName);
  }

  /// listen for a realtime event from a bfast::functions
  /// @param eventName
  /// @param onConnect {function} callback when connection established
  /// @param onDisconnect {function} callback when connection terminated
  RealtimeAdapter event(String eventName,
      {Function(dynamic data) onConnect, Function(dynamic data) onDisconnect}) {
    return new RealtimeController(eventName,
        appName: this._appName,
        onConnect: onConnect,
        onDisconnect: onDisconnect);
  }
}
