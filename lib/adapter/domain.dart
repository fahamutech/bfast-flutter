import 'package:bfast/adapter/query.dart';
import 'package:bfast/controller/query.dart';

abstract class DomainAdapter<T> {
  Future<T> save(T model, [RequestOptions options]);

  Future<List<T>> getAll(
      [Map<String, dynamic> pagination, RequestOptions options]);

  Future<dynamic> get(String objectId, [RequestOptions options]);

  QueryController query<T>([RequestOptions options]);

  Future<T> update(String objectId, T data, [RequestOptions options]);

  Future<dynamic> delete(String objectId, [RequestOptions options]);
}
