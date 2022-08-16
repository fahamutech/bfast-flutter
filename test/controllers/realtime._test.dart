import 'dart:async';

import 'package:bfast/controller/realtime.dart';
import 'package:bfast/options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("RealtimeController", () {
    group("realtimeServerUrl", () {
      test("should return a database changes event url", () {
        var app = App(applicationId: 'test', projectId: 'test');
        var testAppEventUrl = realtimeServerUrl(app);
        expect(testAppEventUrl('/v2/__changes__'),
            'https://test-daas.bfast.fahamutech.com/v2/__changes__');
      });
      test(
          "should return a database changes event url if databaseURL is specified",
          () {
        var app = App(
            applicationId: 'test',
            projectId: 'test',
            databaseURL: 'https://test.d');
        var testAppEventUrl = realtimeServerUrl(app);
        expect(testAppEventUrl('/v2/__changes__'),
            'https://test.d/v2/__changes__');
      });
      test("should return a function url for event", () {
        var app = App(applicationId: 'test', projectId: 'test');
        var testAppEventUrl = realtimeServerUrl(app);
        expect(testAppEventUrl('/sale'),
            'https://test-faas.bfast.fahamutech.com/sale');
      });
      test("should return a function url for event if functionsURL specified",
          () {
        var app = App(
            applicationId: 'test',
            projectId: 'test',
            functionsURL: 'https://test.a');
        var testAppEventUrl = realtimeServerUrl(app);
        expect(testAppEventUrl('/sale'), 'https://test.a/sale');
      });
      test(
          "should return a function url for event if functionsURL specified and event is not absolute",
          () {
        var app = App(
            applicationId: 'test',
            projectId: 'test',
            functionsURL: 'https://test.a');
        var testAppEventUrl = realtimeServerUrl(app);
        expect(testAppEventUrl('sale'), 'https://test.a/sale');
      });
    });
    group("RealtimeFactory", () {
      var realtime = RealtimeFactory();
      var app = App(applicationId: 'kazisquare', projectId: 'kazisquare');
      group("singleton", () {
        test("should return single object", () {
          expect(realtime, RealtimeFactory());
        });
      });
      group("receive & send", () {
        test("should create and send if not exist", () async {
          var completer = Completer();
          var receiver = (d) {
            expect(d, {
              "body": {"body": 1}
            });
            completer.complete();
          };
          var dbChanges = realtime.receive(app, '/echo');
          dbChanges(receiver);
          var send = realtime.send(app, '/echo');
          send({"body": 1});
          return completer.future;
        });
      });
      group("count & close", () {
        var app2 = App(applicationId: 't', projectId: 't');
        test("must be idempotent for same app", () async {
          var receiver = (d) => '';
          var dbChanges = realtime.receive(app, '/echo');
          dbChanges(receiver);
          var send = realtime.send(app, '/echo');
          send({"body": 1});
          send({"body": 2});
          expect(realtime.count(app), 1);
          realtime.close(app, '/echo');
        });
        test("must count all remain socket", () async {
          [1,2].forEach((x) {
            var receiver = (d) => '';
            var dbChanges = realtime.receive(app, '/echo/$x');
            dbChanges(receiver);
            var send = realtime.send(app, '/echo/$x');
            send({"body": 1});
          });
          expect(realtime.count(app), 2);
        });
        test("must close all of an app", () {
          var dbChanges = realtime.receive(app2, '/echo');
          dbChanges((d)=>2);
          realtime.closeAllOfApp(app);
          expect(realtime.count(app), 0);
          expect(realtime.count(app2), 1);
        });
        test("must close all regardless app", (){
          realtime.closeAll();
          expect(realtime.count(app2), 0);
          expect(realtime.count(app), 0);
        });
      });
    });
  });
}
