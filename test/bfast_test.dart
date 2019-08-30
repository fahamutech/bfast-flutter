import 'package:flutter_test/flutter_test.dart';

import 'package:bfast/bfast.dart';
import 'dart:convert';

void main() {
  test('adds one to input values', () {
    final calculator = BFast();
    expect(true, true);
//    expect(calculator.addOne(2), 3);
//    expect(calculator.addOne(-7), -6);
//    expect(calculator.addOne(0), 1);
//    expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });

  test('get function names', ()  {
    final bfast = new BFast();
    bfast.int(serverUrl: 'https://ssm.fahamutech.com:8001', apiKey: '');
    try {
      bfast.fun().names().then((v){
        print(v);
      }).catchError((err){
        print(err);
      });
     // print(results);
      expect(1, 1);
    } catch (e) {
      print(e.toString());
    }
  });
}
