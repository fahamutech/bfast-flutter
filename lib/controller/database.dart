import 'package:bfast/adapter/auth.dart';
import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/controller/query.dart';
import 'package:bfast/controller/realtime.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/rules.dart';

import '../bfast_config.dart';

class DatabaseController {
  String domainName;
  CacheAdapter cacheAdapter;
  AuthAdapter authAdapter;
  RulesController rulesController;
  RestAdapter restAdapter;
  String appName;

  DatabaseController(this.domainName, this.restAdapter, this.authAdapter,
      this.rulesController, this.appName);

  Future<T> get<T>(String objectId, [RequestOptions options]) async {
    try {
      return await this.query().byId(objectId).find(options: options);
    } catch (e) {
      throw {"message": DatabaseController.getErrorMessage(e)};
    }
  }

  Future<List<T>> getAll<T>(
      {int size, int skip, RequestOptions options}) async {
    try {
      var number = size!=null
          ? size
          : await this.query().count(true).find(options: options);
      return this
          .query()
          .skip(skip != null ? skip : 0)
          .size(number)
          .find(options: options);
    } catch (e) {
      throw {"message": DatabaseController.getErrorMessage(e)};
    }
  }

  QueryController query<T>() {
    return QueryController(
        this.domainName, this.restAdapter, this.rulesController, this.appName);
  }

  Future<R> save<T extends Map, R>(T model, [RequestOptions options]) async {
    var createRule = await this.rulesController.createRule(
        this.domainName,
        model,
        BFastConfig.getInstance().getAppCredential(this.appName),
        options);
    RestResponse response = await this.restAdapter.post(
        BFastConfig.getInstance().databaseURL(this.appName),
        data: createRule);
    return DatabaseController.extractResultFromServer(
        response.data, 'create', this.domainName);
  }

  static extractResultFromServer(dynamic data, String rule, String domain) {
    if (data != null && data['$rule$domain'] != null) {
      return data['$rule$domain'];
    } else {
      if (data != null &&
          data['errors'] != null &&
          data['errors']['$rule'] != null &&
          data['errors']['$rule'][domain] != null) {
        throw data['errors']['$rule']['$domain'];
      } else {
        throw {"message": 'Server general failure', "errors": data['errors']};
      }
    }
  }

  static dynamic getErrorMessage(dynamic e) {
    if (e['message'] != null) {
      return e['message'];
    } else {
      return (e != null &&
              e['response'] != null &&
              e['response']['data'] != null)
          ? e['response']['data']
          : e['toString']();
    }
  }
}

class DatabaseChangesController {
  SocketController socketController;

  DatabaseChangesController(this.socketController);

  addListener(dynamic Function(dynamic response) handler) {
    this.socketController.listener(handler);
  }

  close() {
    this.socketController.close();
  }

  open() {
    this.socketController.open();
  }
}
