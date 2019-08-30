import 'package:bfast/core/function.dart';
import 'package:bfast/configuration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FunctionController implements FunctionI {
  String _functionName;
  Config _config;

  FunctionController(String name, Config config) {
    this._functionName = name;
    this._config = config;
  }

  @override
  Future names() async{
    var headers = this._config.getHeaders();
    var results = await http.post('${this._config.getFaasApi()}/names',
        headers: headers, body: jsonEncode({}));
    // print(results.body);
    return results.body;
  }

  @override
  Future run({body = Map}) async {
    return null;
  }
}
