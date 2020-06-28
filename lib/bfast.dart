library bfast;

import 'package:bfast/configuration.dart';
import 'package:bfast/controller/domain.dart';
import 'package:bfast/controller/function.dart';
import 'package:http/http.dart' as http;


class BFast {
  static int(AppCredentials options, [String appName = BFastConfig.DEFAULT_APP]) {
//    BFastConfig.serverUrl = serverUrl;
//    BFastConfig.apiKey = apiKey;
//    if (httpClient != null) {
//      BFastConfig.client = httpClient;
//    } else {
//      BFastConfig.client = http.Client();
//    }
  }

  DomainController domain(String name) {
   // return DomainController(name, BFastConfig());
  }

  DomainController collection(String name) {
    return domain(name);
  }

  DomainController table(String name) {
    return domain(name);
  }

  FunctionController fun({String name}) {
   // return FunctionController(name, BFastConfig());
  }
}
