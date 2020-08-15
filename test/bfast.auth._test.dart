import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/auth.dart';
import 'package:bfast/controller/rest.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'mock/CacheMockController.dart';

class MockHttpClient extends Mock implements http.Client {
  String mockDaasAPi =
      BFastConfig.getInstance().databaseURL(BFastConfig.DEFAULT_APP);
  String mockFaasAPi =
      BFastConfig.getInstance().functionsURL('', BFastConfig.DEFAULT_APP);
}

void main() {
  BFast.init(AppCredentials("smartstock_lb", "smartstock"));
  MockHttpClient mockHttpClient = MockHttpClient();

  group("BFast transaction", () {
    test("should do a transaction on bfast database", () async {
      AuthController authController = AuthController(
          BFastHttpClientController(),
          CacheMockController({"name": "mock"}),
          BFastConfig.DEFAULT_APP);
//      var r = await authController.updateUser({"user":"joshua"});
//      print(r);
    });
  });
}
