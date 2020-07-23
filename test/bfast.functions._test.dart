import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/function.dart';
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
  BFast.init(AppCredentials("smartstock_lb", "smartstock"));
  MockHttpClient mockHttpClient = MockHttpClient();

  group("Http functions from bfast cloud", () {
    test("should call a custom function from bfast cloud which uses GET method",
        () async {
      when(mockHttpClient.get(argThat(startsWith('${mockHttpClient.mockFaasAPi}/functions/users/verifyEmail')),
      headers: anyNamed('headers'))).thenAnswer((_) async=> http.Response('<!DOCTYPE', 200));
      FunctionController functionController = FunctionController(
          '/functions/users/verifyEmail',
          BFastHttpClientController(httpClient: mockHttpClient),
          appName: BFastConfig.DEFAULT_APP);
      var r = await functionController.get();
      expect(true, r.toString().length > 1);
    });
//    test("should call a custom function from bfast cloud which uses POST method",
//            () async {
//          FunctionController functionController = FunctionController(
//              '/functions/users/confirmResetPassword/userId223',
//              BFastHttpClientController(httpClient: null),
//              appName: BFastConfig.DEFAULT_APP);
//          var r = await functionController.delete();
//          expect(true, r.toString().length > 1);
//        });
  });
}
