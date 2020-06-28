import 'dart:async';

import 'package:bfast/core/function.dart';
import 'package:bfast/configuration.dart';
import 'dart:convert';

class FunctionController implements FunctionI {
  String _functionName;
  BFastConfig _config;

  FunctionController(String name, BFastConfig config) {
    this._functionName = name;
    this._config = config;
  }

  @override
  Future<Map<String, dynamic>> names() async{
    var headers = this._config.getHeaders();
    var results = await BFastConfig.client.post('${this._config.getFaasApi()}/names',
        headers: headers, body: jsonEncode({}));
    if(results.statusCode == 200){
      return jsonDecode(results.body);
    }else{
      throw Exception(jsonDecode(results.body));
    }
  }

  @override
  Future run({Map body}) async {
    var headers = _config.getHeaders();
    var results = await BFastConfig.client.post(_config.getFunctionApi(this._functionName),
    headers: headers, body: body!=null?jsonEncode(body):jsonEncode({}));
    if(results.statusCode == 200){
      return jsonDecode(results.body);
    }else{
      throw Exception(jsonDecode(results.body));
    }
  }
}
