import 'package:bfast/core/function.dart';
import 'package:bfast/configuration.dart';
import 'package:http/http.dart' as http;

class FunctionController implements FunctionI {
  String _functionName;
  Config _config;

  FunctionController(String name, Config config) {
    this._functionName = name;
    this._config = config;
  }

  @override
  Future names() {
    print('${this._config.getFaasApi()}/name');
    return http.post('${this._config.getFaasApi()}/name', headers: this._config.getHeaders(), body: {});
  }

  @override
  Future run({body = Map}) async {
    return null;
  }
}
