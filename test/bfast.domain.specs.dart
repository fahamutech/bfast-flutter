import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:bfast/configuration.dart';
import 'package:bfast/controller/domain.dart';
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
  BFast.int(AppCredentials("smartstock_lb", "smartstock"));
  MockHttpClient mockHttpClient = MockHttpClient();
  DomainController domainController = DomainController(
      'test',
      CacheMockController({"name": "John"}),
      BFastHttpClientController(httpClient: null),
      BFastConfig.DEFAULT_APP);

  group('Save data to bfast cloud database', () {
    test("should save data", () async {
      when(mockHttpClient.post(
          argThat(startsWith('${mockHttpClient.mockDaasAPi}/classes/test')),
          headers: anyNamed('headers'),
          body: jsonEncode(
              {"name": "Joshua"}))).thenAnswer((_) async => http.Response(
          '{"objectId": "WpBNH3dAKXFEf6D0", "createdAt": "2020-07-02T17:13:54.411Z"}',
          200));

      var r = await domainController.save({"name": "Joshua"});
      expect(r['objectId'], 'WpBNH3dAKXFEf6D0');
      // expect(r["createdAt"], !null);
    });

    test("should not save null data", () async {
      try {
        await domainController.save(null);
      } catch (r) {
        expect(r['message'], 'please provide data to save');
      }
    });

    test("should not save same object twice", ()async{
      try {
        var r = await domainController.save({"objectId":'WpBNH3dAKXFEf6D0',"name":'joshua'});
        print(r);
      } catch (r) {
        print(r);
        // expect(r['message'], 'please provide data to save');
      }
    });

  });
}
