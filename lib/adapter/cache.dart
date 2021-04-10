import 'package:bfast/adapter/query.dart';

abstract class CacheAdapter {
  Future<T> set<T>(String identifier, T data, {int dtl});

  Future<T> get<T>(String identifier);

  Future<List<K>> keys<K>();

  Future<bool> clearAll();

  Future<bool> remove(String identifier, {bool force});

  bool cacheEnabled({RequestOptions options});
}
