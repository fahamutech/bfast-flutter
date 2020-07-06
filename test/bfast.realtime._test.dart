import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/realtime.dart';
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
//      RealtimeController realtimeController = RealtimeController(
//        'test',
//        appName: BFastConfig.DEFAULT_APP,
//        onConnect: (e) => print("socket connected"),
//        onDisconnect: (e) => print("socket disconnected"),
//      );
//      realtimeController.listener((data) {
//        print(data);
//      });
//      realtimeController.emit(auth: {"name": "Joshua"}, payload: "Hello");
//      realtimeController.emit(auth: {"name": "ethan"}, payload: "Ethan");
//      await Future.delayed(Duration(seconds: 10));
    });
  });
}
