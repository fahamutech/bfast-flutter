import 'dart:convert';
import 'package:http/http.dart' as http;

class Config {
  static String serverUrl;
  static String apiKey;
  static http.Client client;

  getApiUrl(String domain, {Map params}) {
    if(params!=null){
      var paramsString = '?';
      params.forEach((key, value){
        paramsString = paramsString + '$key=$value&';
      });
      return '${Config.serverUrl}/ide/api/$domain$paramsString';
    }else{
      return '${Config.serverUrl}/ide/api/$domain';
    }
  }

  Map<dynamic, dynamic> parseApiUrl(String data) {
    if (data != null) {
      var stringData = data.replaceAll(
          new RegExp(r'http://ide:3000'), '${Config.serverUrl}/ide/api');
      return jsonDecode(stringData);
    } else {
      return null;
    }
  }

  Map<String, String> getHeaders() {
    return {'Content-Type': 'application/json', 'X-Api-Key': Config.apiKey};
  }

  String getFaasApi() {
    return '${Config.serverUrl}/ide/faas';
  }

  String getSearchApi(String domain, String queryName, {Map params}) {
    if(params!=null){
      var paramsString = '?';
      params.forEach((key, value){
        paramsString = paramsString + '$key=$value&';
      });
      return '${this.getApiUrl(domain)}/search/$queryName$paramsString';
    }else{
      return '${this.getApiUrl(domain)}/search/$queryName';
    }
  }

  String getFunctionApi(String name) {
    return '${Config.serverUrl}/ide/function/$name';
  }
}
