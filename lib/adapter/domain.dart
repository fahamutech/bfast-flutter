import 'package:bfast/adapter/query.dart';
import 'package:bfast/controller/query.dart';

abstract class DomainAdapter {
  Future<R> save<T, R>(T model, [RequestOptions options]);

  Future<List<R>> getAll<R>(
      [Map<String, dynamic> pagination, RequestOptions options]);

  Future<R> get<R>(String objectId, [RequestOptions options]);

  QueryController<R> query<R>([RequestOptions options]);

  Future<R> update<T, R>(String objectId, T data, [RequestOptions options]);

  Future<R> delete<R>(String objectId, [RequestOptions options]);
}
