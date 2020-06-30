import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/domain.dart';
import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/controller/query.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/model/QueryModel.dart';

import '../configuration.dart';

class DomainController<T> implements DomainAdapter<T> {
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
  Future delete(String objectId, [RequestOptions options]) async {
    try {
      RestResponse response = await this.restAdapter.delete(
          '${BFastConfig.getInstance().databaseURL(this.appName)}/classes/${this.domainName}/$objectId',
          RestRequestConfig(
              headers: (options != null && options.useMasterKey == true)
                  ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                  : BFastConfig.getInstance().getHeaders(this.appName)));
      return response.data;
    } catch (e) {
      throw {"message": this._getErrorMessage(e)};
    }
  }

  @override
  Future get(String objectId, [RequestOptions options]) async {
    try {
      return await this.query().get(objectId, options);
    } catch (e) {
      throw {"message": this._getErrorMessage(e)};
    }
  }

  @override
  Future<List<T>> getAll(
      [Map<String, dynamic> pagination, RequestOptions options]) async {
    try {
      var number = pagination != null
          ? pagination['size']
          : await this.query().count({}, options);
      return await this.query().find(
          QueryModel(
              skip: pagination != null ? pagination["skip"] : 0, size: number),
          options);
    } catch (e) {
      throw {"message": this._getErrorMessage(e)};
    }
  }

  @override
  QueryController query<T>([RequestOptions options]) {
    return QueryController(
        this.domainName, this.cacheAdapter, this.restAdapter, this.appName);
  }

  @override
  Future<T> save(dynamic model, [RequestOptions options]) async {
    if (model != null) {
      try {
        RestResponse response = await this.restAdapter.post(
            '${BFastConfig.getInstance().databaseURL(this.appName)}/classes/${this.domainName}',
            model,
            RestRequestConfig(
                headers: (options != null && options.useMasterKey == true)
                    ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                    : BFastConfig.getInstance().getHeaders(this.appName)));
        return response.data;
      } catch (e) {
        throw {"message": this._getErrorMessage(e)};
      }
    } else {
      throw {"message": 'please provide data to save'};
    }
  }

  @override
  Future<T> update(String objectId, T data, [RequestOptions options]) async {
    try {
      var response = await this.restAdapter.put(
          '${BFastConfig.getInstance().databaseURL(this.appName)}/classes/${this.domainName}/$objectId',
          data as dynamic,
          RestRequestConfig(
              headers: (options != null && options.useMasterKey == true)
                  ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                  : BFastConfig.getInstance().getHeaders(this.appName)));
      return response.data;
    } catch (e) {
      throw {"message": this._getErrorMessage(e)};
    }
  }

  String _getErrorMessage(dynamic err) {
    return err.toString();
  }
}
