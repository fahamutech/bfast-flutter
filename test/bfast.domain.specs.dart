import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {
  String mockAPi = 'http://bfast.com';
}

void main() {
  group('bfast domain/collection/table integration test', () {
    test("should save data in a collection", () async {
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
  });
}
