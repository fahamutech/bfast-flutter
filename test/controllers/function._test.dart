import 'dart:convert';

import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:flutter_test/flutter_test.dart';

var okResponse = RawResponse(body: '''{"total": 1000}''', statusCode: 200);
var errResponse =
    RawResponse(body: '''{"message": "no username"}''', statusCode: 400);

void main() {
  group("FunctionController", () {
    group("executeHttpFunction", () {
      test("should return the data from http request", () async {
        var response = await executeHttp(() => okResponse);
        expect(response, jsonDecode(okResponse.body));
      });
      test("should throw if not ok", () async {
        try {
          await executeHttp(() => errResponse);
        } catch (e) {
          expect(e, '{"message":"no username"}');
        }
      });
    });
  });
}
