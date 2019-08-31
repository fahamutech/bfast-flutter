import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {
  String mockAPi = 'http://bfast.com';
}

void main() {
  group('bfast domain test', () {
    test("should save a domain", () async {
      final client = MockClient();
      final bfast = new BFast();
      bfast.int(serverUrl: client.mockAPi, httpClient: client, apiKey: '');

      when(client.post('${client.mockAPi}/ide/api/tests',
              headers: anyNamed('headers'),
              body: jsonEncode({"name": "Joshua"})))
          .thenAnswer(
              (_) async => http.Response('{"message": "Object created"}', 201));

      var r = await bfast.domain('tests').set("name", "Joshua").save();

      expect(r['message'], 'Object created');
    });

    test("should delete a domain", () async {
      final client = MockClient();
      final bfast = new BFast();
      bfast.int(serverUrl: client.mockAPi, httpClient: client, apiKey: '');

      when(client.delete(
              '${client.mockAPi}/ide/api/tests/5d6912d19470450007f48717',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response('{"message": "Object deleted"}', 204));

      var r =
          await bfast.domain('tests').delete(id: '5d6912d19470450007f48717');
      // print(r);
      expect(r['message'], 'Object deleted');
    });




  });

  group('bfast function test', () {
    test(
        'throws an exception if the http call to '
        'function names completes with an error', () async {
      final client = MockClient();
      final bfast = new BFast();

      when(client.post('${client.mockAPi}/ide/faas/names',
              headers: anyNamed('headers'), body: jsonEncode({})))
          .thenAnswer(
              (_) async => http.Response('{"message": "Not Found"}', 404));

      bfast.int(serverUrl: client.mockAPi, httpClient: client, apiKey: '');
      try {
        await bfast.fun().names();
      } catch (e) {
        expect(e, isException);
      }
    });

    test('get function names when succesful', () async {
      final client = MockClient();
      final bfast = BFast();
      when(client.post('${client.mockAPi}/ide/faas/names',
              headers: anyNamed('headers'), body: jsonEncode({})))
          .thenAnswer((_) async => http.Response('{"names": ["hello"]}', 200));

      bfast.int(serverUrl: client.mockAPi, httpClient: client, apiKey: '');
      var r = await bfast.fun().names();
      expect(r['names'], isList);
    });

    test('should get a specific function', () async {
      final client = MockClient();
      final bfast = BFast();
      when(client.post('${client.mockAPi}/ide/function/hello',
              headers: anyNamed('headers'), body: jsonEncode({})))
          .thenAnswer(
              (_) async => http.Response('{"message": "Hello, world!"}', 200));

      bfast.int(serverUrl: client.mockAPi, httpClient: client, apiKey: '');
      var r = await bfast.fun(name: 'hello').run();
      expect(r['message'], 'Hello, world!');
    });

    test(
        'should throw exception when get a specific function status is not 200',
        () async {
      final client = MockClient();
      final bfast = BFast();
      when(
          client.post('${client.mockAPi}/ide/function/pay',
              headers: anyNamed('headers'),
              body: jsonEncode({}))).thenAnswer((_) async =>
          http.Response('{"message": "pay function is not available"}', 404));

      bfast.int(serverUrl: client.mockAPi, httpClient: client, apiKey: '');
      try {
        await bfast.fun(name: 'pay').run();
      } catch (e) {
        expect(e, isException);
        expect(e.toString(), contains('function is not available'));
      }
    });
  });
}
