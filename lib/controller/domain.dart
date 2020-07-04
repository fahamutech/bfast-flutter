import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/domain.dart';
import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/controller/query.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/model/QueryModel.dart';

import '../configuration.dart';

class DomainController implements DomainAdapter {
  String domainName;
  CacheAdapter cacheAdapter;
  RestAdapter restAdapter;
  String appName;

  DomainController(String domainName, CacheAdapter cacheAdapter,
      RestAdapter restAdapter, String appName) {
    this.appName = appName;
    this.restAdapter = restAdapter;
    this.domainName = domainName;
    this.cacheAdapter = cacheAdapter;
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
      return await this.query().get(objectId, options);
    } catch (e) {
      throw {"message": this._getErrorMessage(e)};
    }
  }

  @override
  Future<List<T>> getAll<T>(
      [Map<String, dynamic> pagination, RequestOptions options]) async {
    var number = pagination != null
        ? pagination['size']
        : await this.query().count({}, options);
    return await this.query().find(
        QueryModel(
            skip: pagination != null ? pagination["skip"] : 0, size: number),
        options);
  }

  @override
  QueryController<T> query<T>([RequestOptions options]) {
    return QueryController(
        this.domainName, this.cacheAdapter, this.restAdapter, this.appName);
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

  String _getErrorMessage(dynamic err) {
    return err.toString();
  }
}
