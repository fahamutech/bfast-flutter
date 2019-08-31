import 'dart:convert';

import 'package:bfast/configuration.dart';
import 'package:bfast/core/domain.dart';

class DomainController implements DomainI {
  String _domainName;
  Map<String, Object> _model = Map();
  Config _config;

  DomainController(String domainName, Config config) {
    this._domainName = domainName;
    this._config = config;
  }

  @override
  Future delete({String link, String id}) async {
    var headers = this._config.getHeaders();
    if (link != null) {
      var results = await Config.client.delete(link, headers: headers);
      if (results.statusCode.toString().startsWith('2')) {
        return {"message": "Object deleted"};
      } else {
        throw Exception({"message": '${results.reasonPhrase}'});
      }
    } else if (id != null) {
      var results = await Config.client.delete(
          '${this._config.getApiUrl(this._domainName)}/$id',
          headers: headers);
      if (results.statusCode.toString().startsWith('2')) {
        return {"message": "Object deleted"};
      } else {
        throw Exception({"message": '${results.reasonPhrase}'});
      }
    } else {
      throw Exception({"message": "Please provide object id or link"});
    }
  }

  @override
  Future many({Map options}) async {
    var headers = this._config.getHeaders();
    var results = await Config.client.get(
        this._config.getApiUrl(this._domainName,
            params: options != null ? options : Map()),
        headers: headers);
    if (results.statusCode.toString().startsWith('2')) {
      var resultObj = this._config.parseApiUrl(results.body);
      return {
        this._domainName: resultObj['_embedded'][this._domainName],
        'links': resultObj['_links'],
        'page': resultObj['page']
      };
    } else {
      throw Exception(results.body);
    }
  }

  @override
  Future navigate(String link) async {
    var headers = this._config.getHeaders();
    var results = await Config.client.get(link, headers: headers);
    if (results.statusCode.toString().startsWith('2')) {
      var resultObj = this._config.parseApiUrl(results.body);
      return {
        this._domainName: resultObj['_embedded'][this._domainName],
        'links': resultObj['_links'] != null ? resultObj['_links'] : {},
        'page': resultObj['page'] != null ? resultObj['page'] : {}
      };
    } else {
      throw Exception(results.body);
    }
  }

  @override
  Future one({String link, String id}) async {
    var headers = this._config.getHeaders();
    if (link != null) {
      var results = await Config.client.get(link, headers: headers);
      if (results.statusCode.toString().startsWith('2')) {
        var resultObj = this._config.parseApiUrl(results.body);
        return {this._domainName: resultObj};
      } else {
        throw Exception({"message": '${results.reasonPhrase}'});
      }
    } else if (id != null) {
      var results = await Config.client.get(
          '${this._config.getApiUrl(this._domainName)}/$id',
          headers: headers);
      if (results.statusCode.toString().startsWith('2')) {
        var resultObj = this._config.parseApiUrl(results.body);
        return {this._domainName: resultObj};
      } else {
        throw Exception({"message": '${results.reasonPhrase}'});
      }
    } else {
      throw Exception(
          {"message": "Please provide ${this._domainName} objectId or link"});
    }
  }

  @override
  Future save() async {
    var headers = this._config.getHeaders();
    var results = await Config.client.post(
        this._config.getApiUrl(this._domainName),
        headers: headers,
        body: jsonEncode(this._model));
    this._model = Map();
    if (results.statusCode.toString().startsWith('2')) {
      return {"message": 'Object created', this._domainName: results.body};
    } else {
      throw Exception({"message": "Fails to create object"});
    }
  }

  @override
  Future search(String name, Map<String, Object> options) async {
    var headers = this._config.getHeaders();
    var results = await Config.client.get(
        this._config.getSearchApi(this._domainName, name, params: options),
        headers: headers);
    if (results.statusCode.toString().startsWith('2')) {
      var resultObj = this._config.parseApiUrl(results.body);
      // print(resultObj);
      return {
        this._domainName: resultObj['_embedded']!=null?resultObj['_embedded'][this._domainName]:resultObj,
        'links': resultObj['_links'] != null ? resultObj['_links'] : {},
        'page': resultObj['page'] != null ? resultObj['page'] : {}
      };
    } else {
      throw Exception(results.body);
    }
  }

  @override
  DomainController set(String name, Object value) {
    this._model[name] = value;
    return this;
  }

  @override
  DomainController setValues(Map<String, Object> model) {
    this._model = model;
    return this;
  }

  @override
  Future update({String link, String id}) async {
    var headers = this._config.getHeaders();
    if (link != null) {
      var results = await Config.client
          .patch(link, headers: headers, body: jsonEncode(this._model));
      this._model = Map();
      if (results.statusCode.toString().startsWith('2')) {
        return {"message": "${this._domainName} object update"};
      } else {
        throw Exception({"message": '${results.reasonPhrase}'});
      }
    } else if (id != null) {
      var results = await Config.client.patch(
          '${this._config.getApiUrl(this._domainName)}/$id',
          headers: headers,
          body: jsonEncode(this._model));
      this._model = Map();
      if (results.statusCode.toString().startsWith('2')) {
        return {"message": "${this._domainName} object update"};
      } else {
        throw Exception({"message": '${results.reasonPhrase}'});
      }
    } else {
      throw Exception(
          {"message": "Please provide ${this._domainName} objectId or link"});
    }
  }
}
