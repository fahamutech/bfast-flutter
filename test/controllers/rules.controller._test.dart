import 'package:bfast/adapter/query.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/auth.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/rules.dart';
import 'package:bfast/model/QueryModel.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/CacheMockController.dart';

void main() {
  var restController = new BFastHttpClientController();
  var cache = new MockCacheController({"name": "Doe"});
  var authAdapter =
      new AuthController(restController, cache, BFastConfig.DEFAULT_APP);
  var ruleController = new RulesController(authAdapter);
  var appCredential = AppCredentials('test', 'test', appPassword: 'test');

  group("Create Rule Unit Test", () {
    test("should return a create rule when all element supplied", () async {
      var createRule = await ruleController.createRule(
          'test', {"name": "doe"}, appCredential);
      expect(createRule, {
        'applicationId': 'test',
        'createtest': {'name': 'doe', 'return': []},
        'token': null
      });
      expect(createRule['applicationId'], 'test');
      expect(createRule['token'], null);
      expect(createRule['createtest'], {'name': 'doe', 'return': []});
    });

    test("should return a create rule when all element supplied as a list",
        () async {
      var createRule = await ruleController.createRule(
        'test',
        [
          {"name": "doe"}
        ],
        appCredential,
      );
      expect(createRule, {
        'applicationId': 'test',
        'createtest': [
          {'name': 'doe', 'return': []}
        ],
        'token': null
      });
      expect(createRule['applicationId'], 'test');
      expect(createRule['token'], null);
      expect(createRule['createtest'], [
        {'name': 'doe', 'return': []}
      ]);
    });

    test(
        "should return a create rule when all element supplied as a list and return fields supplied",
        () async {
      var createRule = await ruleController.createRule(
          'test',
          [
            {
              "name": "doe",
            },
            {
              "name": "doe2",
            }
          ],
          appCredential,
          RequestOptions(returnFields: ['name']));
      expect(createRule, {
        'applicationId': 'test',
        'createtest': [
          {
            "name": "doe",
            'return': ['name']
          },
          {
            "name": "doe2",
            'return': ['name']
          },
        ],
        'token': null
      });
      expect(createRule['applicationId'], 'test');
      expect(createRule['token'], null);
      expect(createRule['createtest'], [
        {
          'name': 'doe',
          'return': ['name']
        },
        {
          'name': 'doe2',
          'return': ['name']
        },
      ]);
    });

    test('should return create rule with masterKey supplied', () async {
      var createRule = await ruleController.createRule('test', {"name": "doe"},
          appCredential, RequestOptions(userMasterKey: true));
      expect(createRule, {
        'applicationId': 'test',
        'masterKey': 'test',
        'createtest': {'name': 'doe', 'return': []},
        'token': null
      });
      expect(createRule['applicationId'], 'test');
      expect(createRule['masterKey'], 'test');
      expect(createRule['token'], null);
      expect(createRule['createtest'], {'name': 'doe', 'return': []});
    });

    test(
        'should return create rule with returnFields supplied and use masterKey false',
        () async {
      var createRule = await ruleController.createRule(
          'test',
          {"name": "doe"},
          appCredential,
          RequestOptions(userMasterKey: false, returnFields: ['name']));
      expect(createRule, {
        'applicationId': 'test',
        'createtest': {
          'name': 'doe',
          'return': ['name']
        },
        'token': null
      });
      expect(createRule['applicationId'], 'test');
      expect(createRule['token'], null);
      expect(createRule['createtest'], {
        'name': 'doe',
        'return': ['name']
      });
    });

    test('should not return a create rule when domain name is null', () async {
      try {
        await ruleController.createRule(null, {"name": "doe"}, appCredential);
      } catch (e) {
        expect(true, e.toString().contains("domain must not be null"));
      }
    });

    test('should not return a create rule when data parameter is null',
        () async {
      try {
        await ruleController.createRule('test', null, appCredential);
      } catch (e) {
        expect(true, e != null);
        expect(e, {'message': 'please provide data to save'});
        expect(e['message'], 'please provide data to save');
      }
    });

    test('should not return a create rule when appCredential parameter is null',
        () async {
      try {
        await ruleController.createRule('test', {'name': 'doe'}, null);
      } catch (e) {
        expect(true, e != null);
      }
    });
  });
  group("Delete Rule Unit Test", () {
    test("should return delete rule", () async {
      var query = QueryModel();
      query.filter = {'name': 'doe'};
      var deleteRule =
          await ruleController.deleteRule('test', query, appCredential);
      expect(deleteRule, {
        'applicationId': 'test',
        'deletetest': {
          'id': null,
          'filter': {'name': 'doe'}
        },
        'token': null
      });
      expect(deleteRule['applicationId'], 'test');
      expect(deleteRule['deletetest'], {
        'id': null,
        'filter': {'name': 'doe'}
      });
      expect(deleteRule['deletetest']['id'], null);
      expect(deleteRule['deletetest']['filter'], {'name': 'doe'});
    });
    test("should return delete rule with a masterKey", () async {
      var query = QueryModel();
      query.filter = {'name': 'doe'};
      var deleteRule = await ruleController.deleteRule(
          'test', query, appCredential, RequestOptions(userMasterKey: true));
      expect(deleteRule, {
        'applicationId': 'test',
        'masterKey': 'test',
        'deletetest': {
          'id': null,
          'filter': {'name': 'doe'}
        },
        'token': null
      });
      expect(deleteRule['applicationId'], 'test');
      expect(deleteRule['deletetest'], {
        'id': null,
        'filter': {'name': 'doe'}
      });
      expect(deleteRule['deletetest']['id'], null);
      expect(deleteRule['deletetest']['filter'], {'name': 'doe'});
    });

    test('should throw error when domain is null', () async {
      try {
        var query = QueryModel();
        query.filter = {"name": "doe"};
        await ruleController.deleteRule(null, query, appCredential);
      } catch (e) {
        expect(true, e.toString().contains("domain must not be null"));
      }
    });

    test('should not return a delete rule when data parameter is null',
        () async {
      try {
        await ruleController.deleteRule('test', null, appCredential);
      } catch (e) {
        print(e);
        expect(true, e != null);
        expect(true, e.toString().contains("query must not be null"));
      }
    });

    test('should not return a delete rule when appCredential parameter is null',
        () async {
      try {
        await ruleController.createRule('test', {'name': 'doe'}, null);
      } catch (e) {
        print(e);
        expect(true, e != null);
      }
    });
  });
  group("Query Rule Unit Test", () {
    test("should return a query rule", () async {
      var query = QueryModel();
      var queryRule =
          await ruleController.queryRule('test', query, appCredential);
      print(queryRule);
      expect(queryRule, {
        'applicationId': 'test',
        'token': null,
        'querytest': {}
      });
    });
  });
}
