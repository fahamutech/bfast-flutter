import 'package:bfast/options.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../adapter/realtime.dart';
import '../util.dart';

var _socketConfig = <String, dynamic>{
  'transports': ['websocket'],
  'autoConnect': true,
  'reconnection': true,
  'reconnectionAttempts': double.infinity,
  'reconnectionDelay': 2000,
  // how long to initially wait before attempting a new reconnection
  'reconnectionDelayMax': 5000,
  // maximum amount of time to wait between reconnection attempts.
  // Each attempt increases the reconnection delay by 2x along with a
  // randomization factor
  'randomizationFactor': 0.5,
  // 'extraHeaders': {'foo': 'bar'} // optional
};

// ((a) -> b) -> map(b.body -> Map)
// impure because it throw error.
// executeEvent(Function fn1, Function fn2) => (String name) => null;

bool _isAbsolute(x) => x != null && x.length > 0 && x[0] == '/';

bool _isDbChanges(x) => x is String && x == '/v2/__changes__';

Function _eventPath = ifDoElse(_isAbsolute, (y) => y, (y) => '/$y');

_eventUrl(app) => ifDoElse(_isDbChanges, databaseURL(app), functionsURL(app));

_socketKey(app, name) => ifDoElse(
      (f) => app is App,
      (_) => '${app.projectId}$name',
      (_) => name,
    )('');

// app:App -> event: String -> String
realtimeServerUrl(app) => compose(
    [(x) => '$x'.replaceAll('/v2/v2', '/v2'), _eventUrl(app), _eventPath]);

class RealtimeFactory implements RealtimeAdapter {
  static final RealtimeFactory _singleton = RealtimeFactory._internal();

  factory RealtimeFactory() => _singleton;

  RealtimeFactory._internal();

  Map<String, Socket> _socketMap = {};

  Socket _freshSocket(url) => io(url, _socketConfig);

  _lazyInitializeSocket(app) => ifDoElse(
        (_e) =>
            _socketMap.containsKey(_socketKey(app, _e)) &&
            _socketMap[_socketKey(app, _e)] != null,
        (_e) => _socketMap[_socketKey(app, _e)],
        (_e) {
          var url = realtimeServerUrl(app)(_e);
          var socket = _freshSocket(url);
          socket.on(
              'connect',
              (data) =>
                  print('INFO:: socket connected on ${_socketKey(app, _e)}'));
          socket.on(
              'disconnect',
              (data) =>
                  print('INFO:: socket disconnect on ${_socketKey(app, _e)}'));
          socket.open();
          _socketMap.putIfAbsent(_socketKey(app, _e), () => socket);
          return socket;
        },
      );

  @override
  Function(Map x) send(App app, String event) => (Map d) {
        var lazySocket = _lazyInitializeSocket(app);
        Socket socket = lazySocket(event);
        // {"auth": auth, "body": body} -> d
        socket.emit(event, d);
      };

  close(App app, String event) => ifDoElse(
        (e) =>
            _socketMap.containsKey(_socketKey(app, e)) &&
            _socketMap[_socketKey(app, e)] != null,
        (e) {
          _socketMap[_socketKey(app, e)]?.dispose();
          _socketMap.remove(_socketKey(app, e));
        },
        (e) => null,
      )(event);

  receive(App app, String event) => (Function(dynamic x) fn) {
        var lazySocket = _lazyInitializeSocket(app);
        Socket socket = lazySocket(event);
        socket.off(event);
        socket.on(event, fn);
      };

  closeAll(){
    _socketMap.keys.forEach((k) {
      _socketMap[k]?.dispose();
    });
    _socketMap.removeWhere((key, value) => true);
  }

  closeAllOfApp(App app) {
    _socketMap.keys
        .where((element) => element.startsWith('${app.projectId}'))
        .forEach((k) {
      _socketMap[k]?.dispose();
    });
    _socketMap.removeWhere((key, value) => key.startsWith('${app.projectId}'));
  }

  @override
  count(App app) => _socketMap.keys
      .where((element) => element.startsWith('${app.projectId}'))
      .length;
}
