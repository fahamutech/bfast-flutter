import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/rules.dart';
import 'package:bfast/model/QueryModel.dart';
import 'package:bfast/model/UpdateModel.dart';
import 'package:bfast/model/transaction.dart';

import '../bfast_config.dart';

class TransactionController {
  List<TransactionModel> transactionRequests = [];
  RestAdapter _restAdapter;
  RulesController _rulesController;
  String _appName;

  TransactionController(
      this._appName, this._restAdapter, this._rulesController);

  Future commit(
      {Future<List<TransactionModel>> Function(
              List<TransactionModel> transactionsRequests)
          before,
      Future<void> Function() after,
      bool useMasterKey}) async {
    if (before != null) {
      List<TransactionModel> result = await before(this.transactionRequests);
      if (result != null && result is List && result.length > 0) {
        this.transactionRequests = result;
      } else if (result != null && result is List && result.length == 0) {
        this.transactionRequests = result;
      }
    }
    var transactionRule = await this._rulesController.transaction(
        this.transactionRequests,
        BFastConfig.getInstance().getAppCredential(this._appName),
        RequestOptions(userMasterKey: useMasterKey));
    RestResponse response = await this._restAdapter.post(
        BFastConfig.getInstance().databaseURL(this._appName), transactionRule);
    this.transactionRequests = [];
    if (after != null) {
      await after();
    }
    return response.data;
  }

  TransactionController create(String domainName, dynamic data) {
    this.transactionRequests.add(TransactionModel(
        data: data, action: TransactionAction.CREATE, domain: domainName));
    return this;
  }

  TransactionController delete<T extends Map>(
      String domainName, QueryModel query) {
    this.transactionRequests.add(TransactionModel(
        data: {"query": query},
        action: TransactionAction.DELETE,
        domain: domainName));
    return this;
  }

  TransactionController update<T extends Map>(
      String domainName, QueryModel queryModel, UpdateModel updateModel) {
    this.transactionRequests.add(TransactionModel(
        data: {"query": queryModel, "updateModel": updateModel},
        action: TransactionAction.UPDATE,
        domain: domainName));
    return this;
  }
}
