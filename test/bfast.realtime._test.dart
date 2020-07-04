import 'package:bfast/bfast.dart';
import 'package:bfast/configuration.dart';
import 'package:bfast/controller/function.dart';
import 'package:bfast/controller/realtime.dart';
import 'package:bfast/controller/rest.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {
  String mockDaasAPi =
      BFastConfig.getInstance().databaseURL(BFastConfig.DEFAULT_APP);
  String mockFaasAPi =
      BFastConfig.getInstance().functionsURL('', BFastConfig.DEFAULT_APP);
}

void main() {
  BFast.int(AppCredentials("smartstock_lb", "smartstock"));
  MockHttpClient mockHttpClient = MockHttpClient();

  group("BFast realtime", () {
    test("should connect to events from bfast cloud functions", () async {
      RealtimeController realtimeController = RealtimeController(
        'test',
        appName: BFastConfig.DEFAULT_APP,
        onConnect: (e) => print("connected"),
        onDisconnect: (e) => print("disconnected"),
      );
      realtimeController.open();
      realtimeController.listener(({auth, payload}){
        print(auth);
        print(payload);
      });
      realtimeController.emit(auth: {},payload: "Hello");
      print(realtimeController.socket.connected);
      print(realtimeController.socket.disconnected);
      await Future.delayed(Duration(seconds: 10));
    });
  });
}
