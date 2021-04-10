import 'package:bfast/adapter/auth.dart';
import 'package:bfast/adapter/query.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/model/QueryModel.dart';
import 'package:bfast/model/UpdateModel.dart';
import 'package:bfast/model/transaction.dart';

class RulesController {
  AuthAdapter authAdapter;

  RulesController(this.authAdapter);

  Future<dynamic> createRule(
      String domain, var data, AppCredentials appCredential,
      [RequestOptions options]) async {
    assert(domain != null, 'domain must not be null');

    var createRule = {};
    if (options != null && options.useMasterKey == true) {
      createRule.addAll({"masterKey": appCredential.appPassword});
    }
    createRule.addAll({"applicationId": appCredential.applicationId});
    if (data != null) {
      assert(
          (data is Map<dynamic, dynamic> ||
                  data is List<Map<dynamic, dynamic>>) ==
              true,
          'data must either be Map<dynamic, dynamic> or List<Map<dynamic, dynamic>>');
      if (data is List) {
        data = data.map((value) {
          Map<dynamic, dynamic> _data = Map.from(value);
          _data['return'] = options != null && options.returnFields != null
              ? options.returnFields
              : [];
          return _data;
        }).toList();
      } else if (data is Map) {
        Map<dynamic, dynamic> _data = Map.from(data);
        _data['return'] = options != null && options.returnFields != null
            ? options.returnFields
            : [];
        data = _data;
      }
      createRule.addAll({'create$domain': data});
      return this.addToken(createRule);
    } else {
      throw {'message': 'please provide data to save'};
    }
  }

  Future<dynamic> deleteRule(
      String domain, QueryModel query, AppCredentials appCredential,
      [RequestOptions options]) {
    assert(domain != null, 'domain must not be null');
    assert(query != null, 'query must not be null');
    var deleteRule = {};
    if (options != null && options.useMasterKey == true) {
      deleteRule.addAll({"masterKey": appCredential.appPassword});
    }
    deleteRule.addAll({
      "applicationId": appCredential.applicationId,
      'delete$domain': {'id': query?.id, 'filter': query?.filter}
    });
    return this.addToken(deleteRule);
  }

  Future<dynamic> updateRule(String domain, QueryModel query,
      UpdateModel updateModel, AppCredentials appCredential,
      [RequestOptions options]) {
    var updateRule = {};
    if (options != null && options.useMasterKey == true) {
      updateRule.addAll({"masterKey": appCredential.appPassword});
    }
    query.returnFields = options != null && options.returnFields != null
        ? options.returnFields
        : [];
    query.update = updateModel;
    updateRule.addAll({
      "applicationId": appCredential.applicationId,
      ['update$domain']: query
    });
    return this.addToken(updateRule);
  }

  Future<dynamic> aggregateRule(
      String domain, List<dynamic> pipeline, AppCredentials appCredentials,
      [RequestOptions options]) {
    var aggregateRule = {};
    if (options != null && options.useMasterKey == true) {
      aggregateRule.addAll({'masterKey': appCredentials.appPassword});
    }
    aggregateRule.addAll({
      "applicationId": appCredentials.applicationId,
      ['aggregate$domain']: pipeline
    });
    return this.addToken(aggregateRule);
  }

  Future<dynamic> queryRule(
      String domain, QueryModel queryModel, AppCredentials appCredentials,
      {RequestOptions options}) {
    var queryRule = {};
    if (options != null && options.useMasterKey == true) {
      queryRule.addAll({'masterKey': appCredentials.appPassword});
    }
    queryModel.returnFields = options != null && options.returnFields != null
        ? options.returnFields
        : [];
    queryRule.addAll({
      "applicationId": appCredentials.applicationId,
      'query$domain': queryModel.toMap()
    });
    return this.addToken(queryRule);
  }

  Future<dynamic> transaction(
      List<TransactionModel> transactions, AppCredentials appCredentials,
      [RequestOptions options]) async {
    var transactionRule = <dynamic, dynamic>{
      "transaction": {"commit": {}},
      "applicationId": appCredentials.applicationId,
      "masterKey": appCredentials.appPassword,
    };
    transactions.forEach((value) async {
      if (value.action == TransactionAction.CREATE) {
        var createRule = await this
            .createRule(value.domain, value.data, appCredentials, options);
        transactionRule['transaction']['commit'].addAll({
          ['${value.action}${value.domain}']:
              createRule['${value.action}${value.domain}']
        });
      } else if (value.action == TransactionAction.UPDATE) {
        var updateRule = await this.updateRule(
            value.domain,
            value.data['query'],
            value.data['updateModel'],
            appCredentials,
            options);
        transactionRule['transaction']['commit'].addAll({
          ['${value.action}${value.domain}']:
              updateRule['${value.action}${value.domain}']
        });
      } else if (value.action == TransactionAction.DELETE) {
        var deleteQuery = await this.deleteRule(
            value.domain, value.data['query'], appCredentials, options);
        transactionRule['transaction']['commit'].addAll({
          ['${value.action}${value.domain}']:
              deleteQuery['${value.action}${value.domain}']
        });
      }
    });
    return this.addToken(transactionRule);
  }

  Future storage(String action, dynamic payload, AppCredentials appCredentials,
      [RequestOptions options]) async {
    var storageRule = {};
    if (options != null && options.useMasterKey == true) {
      storageRule.addAll({'masterKey': appCredentials.appPassword});
    }
    storageRule.addAll({
      "applicationId": appCredentials.applicationId,
      "files": {
        [action]: payload
      }
    });
    return this.addToken(storageRule);
  }

  Future<dynamic> addToken(Map<dynamic, dynamic> rule) async {
    var token = await this.authAdapter.getToken();
    rule.addAll({"token": token});
    return rule;
  }
}
