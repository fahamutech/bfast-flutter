import 'package:bfast/configuration.dart';
import 'package:bfast/core/domain.dart';
import 'dart:convert';

class DomainController implements DomainI {

  String _domainName;
  Map<String, Object> _model = Map();
  Config _config;

  DomainController(String domainName, Config config) {
    this._domainName = domainName;
    this._config = config;
  }

  @override
  Future delete({String link, String id}) {
    // TODO: implement delete
    return null;
  }

  @override
  Future many({Map options}) {
    // TODO: implement many
    return null;
  }

  @override
  Future navigate(String link) {
    // TODO: implement navigate
    return null;
  }

  @override
  Future one({String link, String id}) {
    // TODO: implement one
    return null;
  }

  @override
  Future save() async {
    var headers = this._config.getHeaders();
    var results = await Config.client.post(
        this._config.getApiUrl(this._domainName), headers: headers,
        body: jsonEncode(this._model));
    print(results.statusCode);
    this._model = Map();
    if(results.toString().startsWith('2')){
      return results.body;
    }else{
      throw Exception(results.body);
    }
  }

  @override
  Future search(String name, Map<String, Object> options) {
    // TODO: implement search
    return null;
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
  Future update({String link, String id}) {
    // TODO: implement update
    return null;
  }

}