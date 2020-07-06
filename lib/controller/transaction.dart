import 'dart:convert';

import 'package:bfast/adapter/rest.dart';
import 'package:bfast/adapter/transaction.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/model/transaction.dart';

import '../configuration.dart';

class TransactionController implements TransactionAdapter {
  List<TransactionModel> transactionRequests = [];
  bool _isNormalBatch;
  RestAdapter _restAdapter;
  String _appName;

  TransactionController(String appName, RestAdapter restAdapter,
      {bool isNormalBatch = false}) {
    this._isNormalBatch = isNormalBatch;
    this._appName = appName;
    this._restAdapter = restAdapter;
  }

  @override
  Future commit(
      {Future<List<TransactionModel>> Function(
              List<TransactionModel> transactionsRequests)
          before,
      Future<void> Function() after,
      bool useMasterKey}) async {
    if (before != null) {
      List<TransactionModel> result = await before(this.transactionRequests);
      if (result != null &&
          result is List &&
          result.length > 0 &&
          result[0].body != null &&
          result[0].path != null &&
          result[0].method != null) {
        this.transactionRequests = result;
      } else if (result != null && result is List && result.length == 0) {
        this.transactionRequests = result;
      }
    }

    var requests = this.transactionRequests.map<Map>((value) {
      return {"method": value.method, "path": value.path, "body": value.body};
    }).toList();

    RestResponse response = await this._restAdapter.post(
        '${BFastConfig.getInstance().databaseURL(this._appName, '/batch')}',
        {
          "requests": requests,
          "transaction": !this._isNormalBatch,
        },
        RestRequestConfig(
          headers: (useMasterKey == true)
              ? BFastConfig.getInstance().getMasterHeaders(this._appName)
              : BFastConfig.getInstance().getHeaders(this._appName),
        ));
    this.transactionRequests = [];
    if (after != null) {
      await after();
    }
    return response.data;
  }

  @override
  TransactionAdapter create<T extends Map>(String domainName, T data) {
    this.transactionRequests.add(TransactionModel<T>(
        body: data, method: "POST", path: '/classes/$domainName'));
    return this;
  }

  @override
  TransactionAdapter createMany<T extends Map>(
      String domainName, List<T> data) {
    List<TransactionModel> trans = data.map<TransactionModel>((payLoad) {
      return TransactionModel(
          body: payLoad, method: "POST", path: '/classes/$domainName');
    }).toList();
    this.transactionRequests.addAll(trans);
    return this;
  }

  @override
  TransactionAdapter delete<T extends Map>(
      String domainName, DeletePayload<T> payload) {
    this.transactionRequests.add(TransactionModel(
        body: payload?.data != null ? payload.data : {},
        method: "DELETE",
        path: '/classes/$domainName/${payload.objectId}'));
    return this;
  }

  @override
  TransactionAdapter deleteMany<T extends Map>(
      String domainName, List<DeletePayload<T>> data) {
    List<TransactionModel> trans = data.map<TransactionModel>((payLoad) {
      return TransactionModel(
          body: payLoad?.data != null ? payLoad.data : {},
          method: "DELETE",
          path: '/classes/$domainName/${payLoad.objectId}');
    }).toList();
    this.transactionRequests.addAll(trans);
    return this;
  }

  @override
  TransactionAdapter update<T extends Map>(
      String domainName, UpdatePayLoad<T> payLoad) {
    this.transactionRequests.add(TransactionModel(
        body: payLoad.data,
        method: "PUT",
        path: '/classes/$domainName/${payLoad.objectId}'));
    return this;
  }

  @override
  TransactionAdapter updateMany<T extends Map>(
      String domainName, List<UpdatePayLoad<T>> data) {
    List<TransactionModel> trans = data.map<TransactionModel>((payLoad) {
      return TransactionModel(
          body: payLoad.data,
          method: "PUT",
          path: '/classes/$domainName/${payLoad.objectId}');
    }).toList();
    this.transactionRequests.addAll(trans);
    return this;
  }
}
