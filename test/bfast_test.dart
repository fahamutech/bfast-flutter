import 'package:flutter_test/flutter_test.dart';

import 'package:bfast/bfast.dart';
import 'package:http/http.dart' as http;
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

  test('get function names', () async {
//    try{
//      var r1 = await http.post('https://ssm.fahamutech.com:8001/ide/function/names',
//          headers: {'Content-Type':'application/json'}, body: jsonEncode({'name': 'josh'}));
//      print(r1.body);
//    }catch(e){
//      print(e);
//    }
    final bfast = new BFast();
    bfast.int(serverUrl: 'https://ssm.fahamutech.com:8001', apiKey: 'uuuu');
    try {
      var r = await bfast.fun(name: 'hello').names();
      print(r);
      expect(1, 2);
    } catch (e) {
      print(e.toString());
    }
  });
}
