import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/controller/database.dart';
import 'package:bfast/controller/realtime.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/rules.dart';
import 'package:bfast/controller/update.dart';
import 'package:bfast/model/FullTextModel.dart';
import 'package:bfast/model/QueryModel.dart';

import '../bfast_config.dart';

enum QueryOrder {
  ASCENDING,
  DESCENDING,
}

class QueryController {
  QueryModel _query = QueryModel(
    filter: {},
    returnFields: [],
    skip: 0,
    size: 100,
    orderBy: [
      {'createdAt': -1}
    ],
    count: false,
  );

  String domain;
  String appName;
  RestAdapter restAdapter;
  RulesController rulesController;
  CacheAdapter cacheAdapter;

  QueryController(
      this.domain, this.restAdapter, this.rulesController, this.appName);

  QueryController byId(String id) {
    this._query.id = id;
    return this;
  }

  QueryController count([bool countQuery = true]) {
    this._query.count = countQuery;
    return this;
  }

  QueryController size(int size) {
    this._query.size = size;
    return this;
  }

  QueryController skip(int skip) {
    this._query.skip = skip;
    return this;
  }

  QueryController orderBy(String field, QueryOrder order) {
    var orderBySet = Set.from(this._query.orderBy);
    orderBySet.add({
      [field]: order
    });
    this._query.orderBy = orderBySet.toList();
    return this;
  }

  QueryController equalTo(String field, dynamic value) {
    this._query.filter.addAll({
      [field]: {"\$eq": value}
    });
    return this;
  }

  QueryController notEqualTo(String field, dynamic value) {
    this._query.filter.addAll({
      [field]: {"\$ne": value}
    });
    return this;
  }

  QueryController greaterThan(String field, dynamic value) {
    this._query.filter.addAll({
      [field]: {"\$gt": value}
    });
    return this;
  }

  QueryController greaterThanOrEqual(String field, dynamic value) {
    this._query.filter.addAll({
      [field]: {"\$gte": value}
    });
    return this;
  }

  includesIn(String field, List<dynamic> value) {
    this._query.filter.addAll({
      [field]: {"\$in": value}
    });
    return this;
  }

  QueryController notIncludesIn(String field, List<dynamic> value) {
    this._query.filter.addAll({
      [field]: {'\$nin': value}
    });
    return this;
  }

  QueryController lessThan(String field, List<dynamic> value) {
    this._query.filter.addAll({
      [field]: {"\$lt": value}
    });
    return this;
  }

  QueryController lessThanOrEqual(String field, List<dynamic> value) {
    this._query.filter.addAll({
      [field]: {"\$lte": value}
    });
    return this;
  }

  QueryController exists(String field, [bool value = true]) {
    this._query.filter.addAll({
      [field]: {"\$exists": value}
    });
    return this;
  }

  QueryController searchByRegex(String field, dynamic regex) {
    this._query.filter.addAll({
      [field]: {"\$regex": regex}
    });
    return this;
  }

  QueryController fullTextSearch(String field, FullTextModel text) {
    this._query.filter.addAll({
      "\$text": {
        "\$search": text.search,
        "\$language": text.language,
        "\$caseSensitive": text.caseSensitive,
        "\$diacriticSensitive": text.diacriticSensitive
      }
    });
    return this;
  }

  QueryController raw(dynamic query) {
    this._query.filter = query;
    return this;
  }

  QueryModel _buildQuery() {
    return this._query;
  }

  Future<T> delete<T>([RequestOptions options]) async {
    var deleteRule = await this.rulesController.deleteRule(
        this.domain,
        this._buildQuery(),
        BFastConfig.getInstance().getAppCredential(this.appName),
        options);
    var response = await this.restAdapter.post(
        BFastConfig.getInstance().databaseURL(this.appName),
        data: deleteRule);
    return DatabaseController.extractResultFromServer(
        response.data, 'delete', this.domain);
  }

  UpdateController updateBuilder() {
    return new UpdateController(this.domain, this._buildQuery(), this.appName,
        this.restAdapter, this.rulesController);
  }

  DatabaseChangesController changes(
      {Function onConnect, Function onDisconnect, RequestOptions options}) {
    String applicationId =
        BFastConfig.getInstance().getAppCredential(this.appName).applicationId;
    String projectId =
        BFastConfig.getInstance().getAppCredential(this.appName).projectId;
    String masterKey =
        BFastConfig.getInstance().getAppCredential(this.appName).appPassword;
    var match = {};
    if (this._buildQuery != null && this._buildQuery().filter != null) {
      match = this._buildQuery().filter;
      match.keys.forEach((key) {
        match['fullDocument.$key'] = match[key];
        match.remove(key);
      });
    }

    SocketController socketController;
    socketController = new SocketController('/v2/__changes__',
        appName: this.appName, onConnect: () {
      if (onConnect != null) {
        onConnect();
      }
      socketController.emit(auth: {
        'applicationId': applicationId,
        'topic': '${projectId}_${this.domain}',
        'masterKey': options.useMasterKey == true ? masterKey : null
      }, body: {
        'domain': this.domain,
        'pipeline': match != null
            ? [
                {'\$match': match}
              ]
            : []
      });
    }, onDisconnect: onDisconnect);
    return new DatabaseChangesController(socketController);
  }

// ********* need improvement ************ //
  Future<V> aggregate<V>(List<dynamic> pipeline, RequestOptions options) async {
    var aggregateRule = await this.rulesController.aggregateRule(
        this.domain,
        pipeline,
        BFastConfig.getInstance().getAppCredential(this.appName),
        options);
    return this.aggregateRuleRequest(aggregateRule);
  }

  Future<T> find<T>({RequestOptions options}) async {
    var queryRule = await this.rulesController.queryRule(
          this.domain,
          this._buildQuery(),
          BFastConfig.getInstance().getAppCredential(this.appName),
          options: options,
        );
    return await this._queryRuleRequest(queryRule);
  }

  Future<dynamic> _queryRuleRequest(dynamic queryRule) async {
    RestResponse response = await this.restAdapter.post(
        BFastConfig.getInstance().databaseURL(this.appName),
        data: queryRule);
    var data = response.data;
    if (data != null && data['query${this.domain}'] != null) {
      return data['query${this.domain}'];
    } else {
      Map errors = data['errors'];
      var queryError = {"message": "Query not succeed"};
      errors.forEach((key, value) {
        if (value.toString().contains('query') == true) {
          queryError = errors[value];
        }
      });
      queryError.putIfAbsent('errors', () => errors as dynamic);
      throw queryError;
    }
  }

  Future<dynamic> aggregateRuleRequest(dynamic pipelineRule) async {
    RestResponse response = await this.restAdapter.post(
        BFastConfig.getInstance().databaseURL(this.appName),
        data: pipelineRule);
    var data = response.data;
    if (data != null && data['aggregate${this.domain}'] != null) {
      return data['aggregate${this.domain}'];
    } else {
      Map errors = data['errors'];
      var aggregateError = {"message": "Aggregation not succeed"};
      errors.forEach((key, value) {
        if (value.toString().contains('aggregate') == true) {
          aggregateError = errors[value];
        }
      });
      aggregateError['errors'] = errors as dynamic;
      throw aggregateError;
    }
  }
}
