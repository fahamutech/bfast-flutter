import 'dart:convert';

import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/model/QueryModel.dart';

import '../configuration.dart';

class QueryController extends QueryAdapter {
  String collectionName;
  String appName;
  RestAdapter restAdapter;
  CacheAdapter cacheAdapter;

  QueryController(String collectionName, CacheAdapter cacheAdapter,
      RestAdapter restAdapter, String appName) {
    this.collectionName = collectionName;
    this.restAdapter = restAdapter;
    this.cacheAdapter = cacheAdapter;
    this.appName = appName;
  }

  @override
  Future aggregate(List<AggregationOptions> pipeline,
      [RequestOptions options]) async {
    String pipelineToStrings = jsonEncode(pipeline);
    pipelineToStrings = pipelineToStrings.length > 7
        ? pipelineToStrings.substring(0, 7)
        : pipelineToStrings;
    var identifier =
        'aggregate_${this.collectionName}_${pipelineToStrings != null ? pipelineToStrings : ''}';
    if (this.cacheAdapter.cacheEnabled(options)) {
      var cacheResponse = await this.cacheAdapter.get(identifier);
      if (cacheResponse) {
        this._aggregateReq(pipeline, options).then((value) {
          var data = value.data.results;
          if (options != null && options.freshDataCallback != null) {
            options.freshDataCallback(identifier: identifier, data: data);
          }
          return this.cacheAdapter.set(identifier, data);
        }).catchError((onError) {});
        return cacheResponse;
      }
    }
    var response = await this._aggregateReq(pipeline, options);
    this
        .cacheAdapter
        .set(identifier, response.data.results)
        .catchError((onError) {});
    return response.data.results;
  }

  @override
  Future<int> count([Map filter, RequestOptions options]) async {
    var identifier =
        'count_${this.collectionName}_${filter != null ? filter : {}}';
    if (this.cacheAdapter.cacheEnabled(options)) {
      var cacheResponse = await this.cacheAdapter.get(identifier);
      if (cacheResponse) {
        this._countReq(filter, options).then((value) {
          var data = value.data.count;
          if (options != null && options.freshDataCallback != null) {
            options.freshDataCallback(identifier: identifier, data: data);
          }
          return this.cacheAdapter.set(identifier, data);
        }).catchError((onError) {});
        return cacheResponse;
      }
    }
    var response = await this._countReq(filter, options);
    this
        .cacheAdapter
        .set(identifier, response.data.count)
        .catchError((onError) {});
    return response.data.count;
  }

  @override
  Future distinct<K>(K key, QueryModel queryModel,
      [RequestOptions options]) async {
    var identifier =
        'distinct_${this.collectionName}_${jsonEncode(queryModel != null && queryModel.filter != null ? queryModel.filter : {})}';
    if (this.cacheAdapter.cacheEnabled(options)) {
      var cacheResponse = await this.cacheAdapter.get(identifier);
      if (cacheResponse) {
        this._distinctReq(key, queryModel, options).then((value) {
          var data = value.data.results;
          if (options != null && options.freshDataCallback != null) {
            options.freshDataCallback(identifier: identifier, data: data);
          }
          return this.cacheAdapter.set(identifier, data);
        }).catchError((onError) {});
        return cacheResponse;
      }
    }
    var response = await this._distinctReq(key, queryModel, options);
    this
        .cacheAdapter
        .set(identifier, response.data.results)
        .catchError((onError) {});
    return response.data.results;
  }

  @override
  Future find(QueryModel queryModel, [RequestOptions options]) async {
    var identifier =
        'find_${this.collectionName}_${jsonEncode(queryModel != null && queryModel.filter != null ? queryModel.filter : {})}';
    if (this.cacheAdapter.cacheEnabled(options)) {
      var cacheResponse = await this.cacheAdapter.get(identifier);
      if (cacheResponse) {
        this._findReq(queryModel, options).then((value) {
          var data = value.data.results;
          if (options != null && options.freshDataCallback != null) {
            options.freshDataCallback(identifier: identifier, data: data);
          }
          return this.cacheAdapter.set(identifier, data);
        }).catchError((onError) {});
        return cacheResponse;
      }
    }
    var response = await this._findReq(queryModel, options);
    this
        .cacheAdapter
        .set(identifier, response.data.results)
        .catchError((onError) {});
    return response.data.results;
  }

  @override
  Future first(QueryModel queryModel, [RequestOptions options]) async {
    var identifier =
        'first_${this.collectionName}_${jsonEncode(queryModel != null && queryModel.filter != null ? queryModel.filter : {})}';
    if (this.cacheAdapter.cacheEnabled(options)) {
      var cacheResponse = await this.cacheAdapter.get(identifier);
      if (cacheResponse) {
        this._firstReq(queryModel, options).then((value) {
          var data = value.data.results;
          if (options != null && options.freshDataCallback != null) {
            options.freshDataCallback(
                identifier: identifier,
                data: data.length == 1 ? data[0] : null);
          }
          return this
              .cacheAdapter
              .set(identifier, data.length == 1 ? data[0] : null);
        }).catchError((onError) {});
        return cacheResponse;
      }
    }
    var response = await _firstReq(queryModel, options);
    var data = response.data.results;
    this
        .cacheAdapter
        .set(identifier, data.length == 1 ? data[0] : null)
        .catchError((onError) {});
    return data.length == 1 ? data[0] : null;
  }

  Future<RestResponse> _distinctReq(dynamic key, QueryModel queryModel,
      [RequestOptions options]) {
    return this.restAdapter.get(
        '${BFastConfig.getInstance().databaseURL(this.appName)}/aggregate/${this.collectionName}',
        RestRequestConfig(
            headers: BFastConfig.getInstance().getMasterHeaders(this.appName),
            params: {
              "limit": (queryModel != null && queryModel.size != null)
                  ? queryModel.size
                  : 100,
              "skip": (queryModel != null && queryModel.skip != null)
                  ? queryModel.skip
                  : 0,
              "order": (queryModel != null && queryModel.orderBy != null)
                  ? queryModel.orderBy?.join(',')
                  : '-createdAt',
              "keys": (queryModel != null && queryModel.keys != null)
                  ? queryModel.keys?.join(',')
                  : null,
              "where": (queryModel != null && queryModel.filter != null)
                  ? queryModel.filter
                  : {},
              "distinct": key
            }));
  }

  Future<RestResponse> _getReq(String objectId, RequestOptions options) {
    return this.restAdapter.get(
          '${BFastConfig.getInstance().databaseURL(this.appName)}/classes/${this.collectionName}/$objectId',
          RestRequestConfig(
              headers: options != null && options.useMasterKey == true
                  ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                  : BFastConfig.getInstance().getHeaders(this.appName)),
        );
  }

  Future<RestResponse> _countReq(Map filter, RequestOptions options) {
    return this.restAdapter.get(
        '${BFastConfig.getInstance().databaseURL(this.appName)}/classes/${this.collectionName}',
        RestRequestConfig(
            headers: (options != null && options.useMasterKey == true)
                ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                : BFastConfig.getInstance().getHeaders(this.appName),
            params: {
              "count": 1,
              "limit": 0,
              "where": filter != null ? filter : {}
            }));
  }

  Future<RestResponse> _firstReq(QueryModel queryModel, RequestOptions options) {
    return this.restAdapter.get(
        '${BFastConfig.getInstance().databaseURL(this.appName)}/classes/${this.collectionName}',
        RestRequestConfig(
            headers: (options != null && options.useMasterKey == true)
                ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                : BFastConfig.getInstance().getHeaders(this.appName),
            params: {
              "limit": 1,
              "skip": 0,
              "order": (queryModel != null && queryModel.orderBy != null)
                  ? queryModel.orderBy?.join(',')
                  : '-createdAt',
              "keys": (queryModel != null && queryModel.keys != null)
                  ? queryModel.keys?.join(',')
                  : null,
              "where": (queryModel != null && queryModel.filter != null)
                  ? queryModel.filter
                  : {}
            }));
  }

  Future<RestResponse> _aggregateReq(dynamic pipeline, RequestOptions options) {
    return this.restAdapter.get(
        '${BFastConfig.getInstance().databaseURL(this.appName)}/aggregate/${this.collectionName}',
        RestRequestConfig(
            headers: (options != null && options.useMasterKey == true)
                ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                : BFastConfig.getInstance().getHeaders(this.appName),
            params: pipeline));
  }

  Future<RestResponse> _findReq(QueryModel queryModel, [RequestOptions options]) {
    return this.restAdapter.get(
        '${BFastConfig.getInstance().databaseURL(this.appName)}/classes/${this.collectionName}',
        RestRequestConfig(
            headers: (options != null && options.useMasterKey == true)
                ? BFastConfig.getInstance().getMasterHeaders(this.appName)
                : BFastConfig.getInstance().getHeaders(this.appName),
            params: {
              "limit": (queryModel != null && queryModel.size != null)
                  ? queryModel.size
                  : 100,
              "skip": (queryModel != null && queryModel.skip != null)
                  ? queryModel.skip
                  : 0,
              "order": (queryModel != null && queryModel.orderBy != null)
                  ? queryModel.orderBy?.join(',')
                  : '-createdAt',
              "keys": (queryModel != null && queryModel.keys != null)
                  ? queryModel.keys?.join(',')
                  : null,
              "where": (queryModel != null && queryModel.filter != null)
                  ? queryModel.filter
                  : {}
            }));
  }

  @override
  Future get(String objectId, [RequestOptions options]) async {
    String identifier = this.collectionName + '_' + objectId;
    if (this.cacheAdapter.cacheEnabled(options)) {
      var cacheResponse = await this.cacheAdapter.get(identifier);
      if (cacheResponse) {
        this._getReq(objectId, options).then((value) {
          var data = value.data;
          if (options != null && options.freshDataCallback != null) {
            options.freshDataCallback(identifier: identifier, data: data);
          }
          return this.cacheAdapter.set(identifier, data);
        }).catchError((e) {});
        return cacheResponse;
      }
    }
    var response = await this._getReq(objectId, options);
    this.cacheAdapter.set(identifier, response.data).catchError((e) {});
    return response.data;
  }
}
