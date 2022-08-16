import 'package:bfast/options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Options", () {
    group("databaseURL", () {
      var url = 'https://test.test';
      var app = App(applicationId: 'test', projectId: 'test', databaseURL: url);
      test("should return specified url if start with http", () {
        var testDbUrl = databaseURL(app);
        expect(testDbUrl(''), url);
      });
      test("should return specified url with suffix if start with http", () {
        var testDbUrl = databaseURL(app);
        expect(testDbUrl('/database'), '$url/database');
      });
      test("should return default database url", () {
        var _app = App(applicationId: 'test', projectId: 'test');
        var testDbUrl = databaseURL(_app);
        expect(testDbUrl(''),
            'https://${_app.projectId}-daas.bfast.fahamutech.com/v2');
      });
      test("should return default database url with suffix", () {
        var _app = App(applicationId: 'test', projectId: 'test');
        var testDbUrl = databaseURL(_app);
        expect(testDbUrl('/v3'),
            'https://${_app.projectId}-daas.bfast.fahamutech.com/v2/v3');
      });
      test("should return null default if no app", () {
        [1, '', 'a', {}, () => 2, [], null].forEach((x) {
          var dbUrl = databaseURL(x as dynamic);
          expect(dbUrl(''), 'https://null-daas.bfast.fahamutech.com/v2');
        });
      });
      test("should return null default if no app nor suffix", () {
        [1, '', {}, () => 2, [], null].forEach((x) {
          var dbUrl = databaseURL(x);
          expect(dbUrl(x), 'https://null-daas.bfast.fahamutech.com/v2');
        });
      });
    });
    group("functionsURL", () {
      var url = 'https://functons.test';
      var app =
          App(applicationId: 'test', projectId: 'test', functionsURL: url);
      test("should return path url if start with http", () {
        var testDbUrl = functionsURL(app);
        var _url = 'https://functions.test/a';
        expect(testDbUrl(_url), _url);
      });
      test("should return specified url if start with http", () {
        var testDbUrl = functionsURL(app);
        expect(testDbUrl(''), url);
      });
      test("should return specified url with path if start with http", () {
        var testDbUrl = functionsURL(app);
        expect(testDbUrl('/login'), '$url/login');
      });
      test("should return default functions url", () {
        var _app = App(applicationId: 'test', projectId: 'test');
        var testDbUrl = functionsURL(_app);
        expect(testDbUrl(''),
            'https://${_app.projectId}-faas.bfast.fahamutech.com');
      });
      test("should return default functions url with suffix", () {
        var _app = App(applicationId: 'test', projectId: 'test');
        var testDbUrl = functionsURL(_app);
        expect(testDbUrl('/v3'),
            'https://${_app.projectId}-faas.bfast.fahamutech.com/v3');
      });
      test("should return null default if no app", () {
        [1, '', 'a', {}, () => 2, [], null].forEach((x) {
          var dbUrl = functionsURL(x as dynamic);
          expect(dbUrl(''), 'https://null-faas.bfast.fahamutech.com');
        });
      });
      test("should return null default if no app nor path", () {
        [1, '', {}, () => 2, [], null].forEach((x) {
          var dbUrl = functionsURL(x);
          expect(dbUrl(x), 'https://null-faas.bfast.fahamutech.com');
        });
      });
    });
    group("cacheDatabaseName", () {
      var app = App(applicationId: 'test', projectId: 'test');
      test("return a database url string if app exist", (){
        var tableName = cacheDatabaseName(app);
        expect(tableName('sales'), '/bfast/test/sales');
      });
      test("return a database url string if app not exist", (){
        [1,'','a',[],{},()=>1].forEach((x) {
          var tableName = cacheDatabaseName(x);
          expect(tableName('sales'), '/bfast/cache/sales');
        });
      });
      test("should ignore table if its not string and app exist", (){
        [1,[],{},()=>1].forEach((x) {
          var tableName = cacheDatabaseName(app);
          expect(tableName(x), '/bfast/test');
        });
      });
      test("should ignore table if its not string and app not exist", (){
        [1,[],{},()=>1].forEach((x) {
          var tableName = cacheDatabaseName(x);
          expect(tableName(x), '/bfast/cache');
        });
      });
    });
  });
}
