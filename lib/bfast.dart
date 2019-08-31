library bfast;

import 'package:bfast/configuration.dart';
import 'package:bfast/controller/domain.dart';
import 'package:bfast/controller/function.dart';
import 'package:http/http.dart' as http;

class BFast {
  int({String serverUrl, String apiKey, http.Client httpClient}) {
    Config.serverUrl = serverUrl;
    Config.apiKey = apiKey;
    if (httpClient != null) {
      Config.client = httpClient;
    } else {
      Config.client = http.Client();
    }
  }

  DomainController domain(String name) {
    return DomainController(name, Config());
  }

  FunctionController fun({String name}) {
    return FunctionController(name, Config());
  }
}
