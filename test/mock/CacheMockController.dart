import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/query.dart';

class MockCacheController extends CacheAdapter {
  Map _mockData = {};

  MockCacheController(Map mockData) {
    this._mockData = mockData;
  }

  @override
  bool cacheEnabled({RequestOptions options}) {
    return false;
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
  Future<List<String>> keys<String>() async {
    return [];
  }

  @override
  Future<bool> remove(String identifier, {bool force}) async {
    if (identifier == 'ok') {
      return true;
    }
    return false;
  }

  @override
  Future<T> set<T>(String identifier, T data, {int dtl}) async {
    return data;
  }
}
