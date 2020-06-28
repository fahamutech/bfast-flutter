import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/model/QueryModel.dart';

class QueryController extends QueryAdapter {
  String collectionName;

  constructor(
      String collectionName,
      CacheAdapter cacheAdapter,
      RestAdapter restAdapter, String appName
      ) {
    this.collectionName = collectionName;
  }

  @override
  Future aggregate(List<AggregationOptions> pipeline,
      [RequestOptions options]) {
    // TODO: implement aggregate
    throw UnimplementedError();
  }

  @override
  Future<int> count([Map filter, RequestOptions options]) {
    // TODO: implement count
    throw UnimplementedError();
  }

  @override
  Future distinct<K>(K key, QueryModel queryModel, [RequestOptions options]) {
    // TODO: implement distinct
    throw UnimplementedError();
  }

  @override
  Future find(QueryModel queryModel, [RequestOptions options]) {
    // TODO: implement find
    throw UnimplementedError();
  }

  @override
  Future first(QueryModel queryModel, [RequestOptions options]) {
    // TODO: implement first
    throw UnimplementedError();
  }

  @override
  Future get(String objectId, [RequestOptions options]) {
    // TODO: implement get
    throw UnimplementedError();
  }
}
