import 'dart:convert';

import 'package:bfast/controller/database.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:flutter_test/flutter_test.dart';

var mockOkResponse = RawResponse(
    body: '''{"create_test":{"a": 1, "id": 1, "createdAt": "leo"}}''',
    statusCode: 200);
var mockNotOkResponse = RawResponse(
    body:
        '''{"create_test":{},"errors": {"create._test": {"message": "err"}}}''',
    statusCode: 200);
var mockNotOkNoErrObjResponse =
    RawResponse(body: '''{"message": "unauthorized"}''', statusCode: 401);

void main() {
  group("Database Controller", () {
    group("executeRule", () {
      // var rule = {
      //   'create_test': {'a': 1}
      // };
      test("should return result of the http", () async {
        var createRequest = await  executeRule(() async => mockOkResponse);
        expect(createRequest, jsonDecode(mockOkResponse.body));
      });
      test("should return error message if request fail", () async {
        var createRequest = await executeRule(() => mockNotOkResponse);
        expect(createRequest, jsonDecode(mockNotOkResponse.body));
      });
      test("should return error message if request fail", () async {
        var createRequest = await executeRule(() => mockNotOkNoErrObjResponse);
        var responseMap = {
          'errors': jsonDecode(mockNotOkNoErrObjResponse.body)
        };
        expect(createRequest, responseMap);
      });
    });
    group("errorsMessage", () {
      test("should return errors message", () {
        var errMessage = errorsMessage({
          "errors": {
            "create.test": {"message": "test"}
          }
        });
        expect(
          errMessage,
          '{"create.test":{"message":"test"}}',
        );
      });
      test("should return empty message", () {
        String errMessage = errorsMessage({
          "err": {
            "create.test": {"message": "test"}
          }
        });
        expect(errMessage, '');
      });
      test("should return  empty string if not map", (){
        [[],()=>{},1,'','a', null].forEach((element) {
          String errMessage = errorsMessage(element);
          expect(errMessage, '');
        });
      });
    });
  });
}
