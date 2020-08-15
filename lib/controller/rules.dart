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
      String domain, dynamic data, AppCredentials appCredential,
      [RequestOptions options]) async {
    const createRule = {};
    if (options != null && options.useMasterKey != true) {
      createRule.addAll({"masterKey": appCredential.appPassword});
      createRule.addAll({"applicationId": appCredential.applicationId});
      if (data != null) {
        if (data is List) {
          data.map((x) {
            x['returnFields'] = options != null && options.returnFields != null
                ? options.returnFields
                : [];
            return x;
          });
        } else {
          data['returnFields'] = options != null && options.returnFields != null
              ? options.returnFields
              : [];
        }
        createRule.addAll({
          ['create$domain']: data
        });
        return this.addToken(createRule);
      } else {
        throw {'message': 'please provide data to save'};
      }
    }
  }

  Future<dynamic> deleteRule(
      String domain, QueryModel query, AppCredentials appCredential,
      [RequestOptions options]) {
    var deleteRule = Map();
    if (options != null && options.useMasterKey == true) {
      deleteRule.addAll({"masterKey": appCredential.appPassword});
    }
    deleteRule.addAll({
      "applicationId": appCredential.applicationId,
      ['delete$domain']: query
    });
    return this.addToken(deleteRule);
  }

  Future<dynamic> updateRule(String domain, QueryModel query,
      UpdateModel updateModel, AppCredentials appCredential,
      [RequestOptions options]) {
    const updateRule = {};
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
    const aggregateRule = {};
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
      [RequestOptions options]) {
    const queryRule = {};
    if (options != null && options.useMasterKey == true) {
      queryRule.addAll({'masterKey': appCredentials.appPassword});
    }
    queryModel.returnFields = options != null && options.returnFields != null
        ? options.returnFields
        : [];
    queryRule.addAll({
      "applicationId": appCredentials.applicationId,
      ['query$domain']: queryModel
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

  Future storage(
      String action, dynamic payload, AppCredentials appCredentials,
      [RequestOptions options]) async {
    const storageRule = {};
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
