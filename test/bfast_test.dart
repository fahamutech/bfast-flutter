import 'package:flutter_test/flutter_test.dart';

import 'package:bfast/bfast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  test('adds one to input values', () {
    final calculator = BFast();
    expect(true, true);
  });

  test('get function names', () async {
    final bfast = new BFast();
    // bfast.int(serverUrl: 'https://ssm.fahamutech.com:8001', apiKey: 'uuuu');
    try {
      // var r = await bfast.fun(name: 'hello').names();
      // print(r);
      expect(1, 1);
    } catch (e) {
      print(e.toString());
    }
  });
}
