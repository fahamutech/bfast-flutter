import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/domain.dart';
import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/controller/query.dart';
import 'package:bfast/controller/realtime.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/model/QueryModel.dart';
import 'package:bfast/model/RealTimeResponse.dart';

import '../bfast_config.dart';

class DatabaseController implements DomainAdapter {
  String domainName;
  CacheAdapter cacheAdapter;
  RestAdapter restAdapter;
  String appName;

  DatabaseController(String domainName, CacheAdapter cacheAdapter,
      RestAdapter restAdapter, String appName) {
    this.domainName = domainName;
    this.restAdapter = restAdapter;
    private readonly authAdapter: AuthAdapter;
    private readonly rulesController: RulesController;
    this.appName = appName;
  }

  @override
  Future<R> delete<R>(String objectId, [RequestOptions options]) async {
    RestResponse response = await this.restAdapter.delete(
        '${BFastConfig.getInstance().databaseURL(this.appName)}/classes/${this.domainName}/$objectId',
        RestRequestConfig(
            headers: (options != null && options.useMasterKey == true)
                ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                : BFastConfig.getInstance().getHeaders(this.appName)));
    return response.data;
  }

  @override
  Future<T> get<T>(String objectId, [RequestOptions options]) async {
    try {
      return await this.query().byId(objectId).find(options);
    } catch (e) {
      throw {"message": DatabaseController._getErrorMessage(e)};
    }
  }

  @override
  Future<List<T>> getAll<T>(
      [Map<String, dynamic> pagination, RequestOptions options]) async {
    var number = pagination != null
        ? pagination['size']
        : await this.query().count().find(options);
    return this.query()
        .skip(pagination != null ? pagination["skip"] : 0)
        .size(number)
        .find(options);
  }

  @override
  QueryController query<T>([RequestOptions options]) {
    return QueryController(
        this.domainName, this.restAdapter,this.rulesController,  this.appName);
  }

  @override
  Future<R> save<T, R>(T model, [RequestOptions options]) async {
    if (model != null) {
      RestResponse response = await this.restAdapter.post(
          '${BFastConfig.getInstance().databaseURL(this.appName)}/classes/${this.domainName}',
          model,
          RestRequestConfig(
              headers: (options != null && options.useMasterKey == true)
                  ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                  : BFastConfig.getInstance().getHeaders(this.appName)));
      return response.data;
    } else {
      throw {"message": 'please provide data to save'};
    }
  }

  @override
  Future<R> update<T, R>(String objectId, T data,
      [RequestOptions options]) async {
    var response = await this.restAdapter.put<T, dynamic>(
        '${BFastConfig.getInstance().databaseURL(this.appName)}/classes/${this.domainName}/$objectId',
        data,
        RestRequestConfig(
            headers: (options != null && options.useMasterKey == true)
                ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                : BFastConfig.getInstance().getHeaders(this.appName)));
    return response.data;
  }

  static _extractResultFromServer(dynamic data, String rule,String domain) {
  if (data!=null && data['$rule$domain'] !=null) {
  return data['$rule$domain'];
  } else {
  if (data !=null && data['errors'] !=null && data['errors']['$rule'] !=null&& data['errors']['$rule'][domain] !=null) {
  throw data['errors']['$rule']['$domain'];
  } else {
  throw {"message": 'Server general failure', "errors": data['errors']};
  }
  }
  }

  static dynamic _getErrorMessage(dynamic e) {
  if (e['message'] !=null) {
  return e['message'];
  } else {
  return (e !=null && e['response'] !=null && e['response']['data']!=null) ? e['response']['data'] : e['toString']();
  }
  }
}

class DatabaseChangesController {
  RealtimeController socketController;
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
