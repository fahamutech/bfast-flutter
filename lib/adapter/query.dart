import 'package:bfast/model/QueryModel.dart';

abstract class QueryAdapter<T> {
  Future<T> aggregate(List<AggregationOptions> pipeline,
      [RequestOptions options]);

  Future<int> count([Map<dynamic, dynamic> filter, RequestOptions options]);

  Future<T> distinct<K>(K key, QueryModel queryModel, [RequestOptions options]);

  Future<T> find(QueryModel queryModel, [RequestOptions options]);

  Future<dynamic> first([QueryModel queryModel, RequestOptions options]);

  Future<T> get(String objectId, [RequestOptions options]);
}

class CacheOptions {
  bool cacheEnable;
  int dtl;
  Function({String identifier, dynamic data}) freshDataCallback;

  CacheOptions({bool cacheEnable, int dtl, Function({String identifier, dynamic data}) freshDataCallback}) {
    this.cacheEnable = cacheEnable;
    this.dtl = dtl;
    this.freshDataCallback = freshDataCallback;
  }
}

class FullTextOptions {
  String language;
  String caseSensitive;
  String diacriticSensitive;
}

class AggregationOptions {
  Map<String, dynamic> group;
  Map<String, dynamic> match;
  Map<String, dynamic> project;
  Map<String, int> sort;
  int limit;
  int skip;

  AggregationOptions({
    Map<String, dynamic> group,
    Map<String, dynamic> match,
    Map<String, dynamic> project,
    Map<String, int> sort,
    int limit,
    int skip,
  }) {
    this.group = group;
    this.match = match;
    this.project = project;
    this.sort = sort;
    this.limit = limit;
    this.skip = skip;
  }
}

class RequestOptions extends CacheOptions {
  bool useMasterKey;

  RequestOptions([bool userMasterKey]) {
    this.useMasterKey = userMasterKey;
  }
}
