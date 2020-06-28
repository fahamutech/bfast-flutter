import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/domain.dart';
import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/controller/query.dart';

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
  Future delete(String objectId, [RequestOptions options]) {
    // TODO: implement delete
    throw UnimplementedError();
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
      [Map<String, dynamic> pagination, RequestOptions options]) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  QueryController query<T>([RequestOptions options]) {
    // TODO: implement query
    throw UnimplementedError();
  }

  @override
  Future<T> save(T model, [RequestOptions options]) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<T> update(String objectId, T data, [RequestOptions options]) {
    // TODO: implement update
    throw UnimplementedError();
  }

  String _getErrorMessage(dynamic err) {
    return err.toString();
  }
}
