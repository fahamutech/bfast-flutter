import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/query.dart';

class CacheMockController extends CacheAdapter {
  Map _mockData = {};

  CacheMockController(Map mockData) {
    this._mockData = mockData;
  }

  @override
  bool cacheEnabled([RequestOptions options]) {
    // TODO: implement cacheEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool> clearAll() async {
    return true;
  }

  @override
  Future<T> get<T>(String identifier) async {
    return this._mockData as T;
  }

  @override
  Future<List<String>> keys() async {
    return ['key1', 'key2'];
  }

  @override
  Future<bool> remove(String identifier, [bool force]) async {
    if (identifier == 'ok') {
      return true;
    }
    return false;
  }

  @override
  Future<T> set<T>(String identifier, T data, [int dtl]) async {
    return data;
  }
}
