import 'dart:convert';

import '../model/raw_response.dart';
import '../util.dart';

// ((a) -> b) -> map(b.body-> Map)
executeRule<T>(Function() httpPost) async {
  RawResponse response = await httpPost();
  var isOk = (_) => '${response.statusCode}'.startsWith('20');
  var exposeErr = compose([
    map((m) => {'errors': m}),
    jsonDecode
  ]);
  var mapOfResult = ifDoElse(isOk, jsonDecode, exposeErr);
  return mapOfResult(response.body);
}

// this will be running in the app specific code
// var ruleResult = compose([ifThrow((x)=>errorsMessage(x)!='', (x)=>x)]);

_errorIsMap(e) => ifDoElse((_) => e['errors'] != null,
    (_) => jsonEncode(e['errors']), (_) => '')('');

//  * -> String
errorsMessage(dynamic e) =>
    ifDoElse((_) => e is Map, _errorIsMap, (_) => '')(e);