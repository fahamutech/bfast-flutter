library bfast;

import 'package:bfast/configuration.dart';
import 'package:bfast/controller/function.dart';

class BFast {

  int({serverUrl: String, apiKey: String}){
    Config.serverUrl = serverUrl;
    Config.apiKey = apiKey;
  }

  domain(String name){
    // return new
  }

  FunctionController fun({name: String}){
    return new FunctionController(name, new Config());
  }

}
