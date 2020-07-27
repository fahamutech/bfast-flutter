import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/domain.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/model/QueryModel.dart';
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
  DomainController domainController = DomainController(
      'test',
      CacheMockController({"name": "John"}),
      BFastHttpClientController(httpClient: mockHttpClient),
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

      var r = await domainController.save<Map, Map>({"name": "Joshua"});
      expect(r['objectId'], 'WpBNH3dAKXFEf6D0');
      // expect(r["createdAt"], !null);
    });
    test("should not save null data", () async {
      try {
        await domainController.save<Map, dynamic>(null);
      } catch (r) {
        expect(r['message'], 'please provide data to save');
      }
    });
    test("should not save same object twice", () async {
      try {
        when(
            mockHttpClient.post(
                argThat(
                    startsWith('${mockHttpClient.mockDaasAPi}/classes/test')),
                headers: anyNamed('headers'),
                body: jsonEncode({
                  "objectId": 'WpBNH3dAKXFEf6D0',
                  "name": 'joshua'
                }))).thenAnswer((_) async => http.Response(
            '{"code":137,"error":"A duplicate value for a field with unique values was provided"}',
            400));
        await domainController.save<Map, dynamic>(
            {"objectId": 'WpBNH3dAKXFEf6D0', "name": 'joshua'});
      } catch (r) {
        expect(r['message'],
            '{"code":137,"error":"A duplicate value for a field with unique values was provided"}');
        expect(r['statusCode'], 400);
      }
    });

    test("should not save string data", () async {
      try {
        when(mockHttpClient.post(
                argThat(
                    startsWith('${mockHttpClient.mockDaasAPi}/classes/test')),
                headers: anyNamed('headers'),
                body: anyNamed('body')))
            .thenAnswer((_) async => http.Response('Bad data', 400));
        await domainController.save<Map, dynamic>("joshua" as dynamic);
      } catch (r) {
        expect(r.toString(),
            "type 'String' is not a subtype of type 'Map<dynamic, dynamic>'");
      }
    });
    test("should not save number data", () async {
      try {
        when(mockHttpClient.post(
                argThat(
                    startsWith('${mockHttpClient.mockDaasAPi}/classes/test')),
                headers: anyNamed('headers'),
                body: anyNamed('body')))
            .thenAnswer((_) async => http.Response(
                'Invalid argument(s): Invalid request body "1234".', 400));
        await domainController.save<int, dynamic>(1234);
      } catch (r) {
        expect(
            r["message"], 'Invalid argument(s): Invalid request body "1234".');
      }
    });
  });

  group('Update data from bfast cloud database', () {
    test("should updated exist data in bfast", () async {
      when(mockHttpClient.put(
          argThat(startsWith(
              '${mockHttpClient.mockDaasAPi}/classes/test/WpBNH3dAKXFEf6D0')),
          headers: anyNamed('headers'),
          body:
              jsonEncode({"name": "ethan"}))).thenAnswer(
          (realInvocation) async =>
              http.Response('{"updatedAt": "2020-07-04T13:41:22.326Z"}', 200));
      var r = await domainController
          .update<Map, dynamic>('WpBNH3dAKXFEf6D0', {"name": "ethan"});
      expect(r["updatedAt"], '2020-07-04T13:41:22.326Z');
      expect(true, r['updatedAt'] is String);
    });
    test("should not update non exist data in bfast cloud database", () async {
      try {
        when(mockHttpClient.put(
                argThat(startsWith(
                    '${mockHttpClient.mockDaasAPi}/classes/test/EpBNH3dAKXFEf6D1')),
                headers: anyNamed('headers'),
                body: anyNamed('body')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        await domainController
            .update<Map, Map>('EpBNH3dAKXFEf6D1', {"name": "ethan"});
      } catch (r) {
        expect(r["message"], 'Not Found');
        expect(r["statusCode"], 404);
        expect(true, r['message'] is String);
      }
    });
  });

  group("Delete data from bfast cloud database", () {
    test("should delete existing data in bfast cloud database", () async {
      when(mockHttpClient.delete(
              argThat(startsWith(
                  '${mockHttpClient.mockDaasAPi}/classes/test/saCgUAJwEhCtK7a5')),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('{}', 200));
      var r = await domainController.delete<Map>('saCgUAJwEhCtK7a5');
      expect(true, r != null);
      expect(r.length, 0);
    });

    test("should return error when delete non exist record in database",
        () async {
      try {
        when(mockHttpClient.delete(
                argThat(startsWith(
                    '${mockHttpClient.mockDaasAPi}/classes/test/saCgUAJwEhCtK7a5')),
                headers: anyNamed('headers')))
            .thenAnswer((_) async =>
                http.Response('{"code":101,"error":"Object not found."}', 404));
        await domainController.delete<Map>('saCgUAJwEhCtK7a5');
      } catch (r) {
        expect(true, r != null);
        expect(r['statusCode'], 404);
        expect(r["message"], '{"code":101,"error":"Object not found."}');
      }
    });
  });

  group("Query data from bfast cloud database", () {
    test("should return all data available", () async {
      when(mockHttpClient.get(
              argThat(startsWith(
                  '${mockHttpClient.mockDaasAPi}/classes/test?count=1&limit=0')),
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response('{"count":2,"results":[]}', 200));
      when(mockHttpClient.get(
              argThat(startsWith(
                  '${mockHttpClient.mockDaasAPi}/classes/test?limit=2')),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                "results": [
                  {
                    "objectId": "R2zZV8eSyvA8PAd9",
                    "name": "Joshua",
                    "createdAt": "2020-07-02T19:23:46.165Z",
                    "updatedAt": "2020-07-02T19:23:46.165Z"
                  },
                  {
                    "objectId": "WpBNH3dAKXFEf6D0",
                    "name": "ethan",
                    "createdAt": "2020-07-02T17:13:54.411Z",
                    "updatedAt": "2020-07-04T13:45:32.607Z"
                  }
                ]
              }),
              200));
      var r = await domainController.getAll();
      expect(true, r is List);
      expect(true, r != null);
      expect(r.length, 2);
    });
    test("should return a single data when supply its id", () async {
      when(mockHttpClient.get(argThat(startsWith('${mockHttpClient.mockDaasAPi}/classes/test/R2zZV8eSyvA8PAd9')),
      headers: anyNamed('headers')))
      .thenAnswer((realInvocation) async => http.Response(jsonEncode({"objectId": "R2zZV8eSyvA8PAd9", "name": "Joshua", "createdAt": "2020-07-02T19:23:46.165Z", "updatedAt": "2020-07-02T19:23:46.165Z"}),200));
      var r = await domainController.get('R2zZV8eSyvA8PAd9');
      expect(true, r!=null);
      expect(true, r['objectId'] is String);
      expect(r['objectId'],"R2zZV8eSyvA8PAd9");
    });
    test("should return data based on size of query model", ()async {
      when(mockHttpClient.get(
          argThat(startsWith(
              '${mockHttpClient.mockDaasAPi}/classes/test')),
          headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
          jsonEncode({
            "results": [
              {
                "objectId": "R2zZV8eSyvA8PAd9",
                "name": "Joshua",
                "createdAt": "2020-07-02T19:23:46.165Z",
                "updatedAt": "2020-07-02T19:23:46.165Z"
              }
            ]
          }),
          200));
      var r = await domainController.query().find(QueryModel(size: 1));
      expect(r.length, 1);
      expect(true, r!=null);
      expect(r[0]["objectId"], "R2zZV8eSyvA8PAd9");
    });
    test("should return data based on query model", ()async {
      when(mockHttpClient.get(
          argThat(startsWith(
              '${mockHttpClient.mockDaasAPi}/classes/test')),
          headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
          jsonEncode({
            "results": [
              {
                "objectId": "R2zZV8eSyvA8PAd9",
                "name": "Joshua",
                "createdAt": "2020-07-02T19:23:46.165Z",
                "updatedAt": "2020-07-02T19:23:46.165Z"
              }
            ]
          }),
          200));
      var r = await domainController.query().find(QueryModel(keys: ["name"],orderBy: ["createdAt"], filter: {
        "name": {
          "\$regex":"^Josh"
        }
      }));
      expect(r.length, 1);
      expect(true, r!=null);
      expect(r[0]["objectId"], "R2zZV8eSyvA8PAd9");
    });
  });
}
