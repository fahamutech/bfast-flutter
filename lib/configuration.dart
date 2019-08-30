import 'dart:convert';

class Config {
  static String serverUrl;
  static String apiKey;

  getApiUrl(String domain) {
    return '${Config.serverUrl}/ide/api/$domain';
  }

  Map<String, dynamic> parseApiUrl(Map<String, dynamic> data) {
    if (data != null) {
      var stringData = jsonEncode(data);
      stringData = stringData.replaceAll(new RegExp(r'http://ide:3000'), '${Config.serverUrl}/ide/api');
      return jsonDecode(stringData);
    } else {
      return null;
    }
  }

  Map<String, dynamic> getHeaders() {
    var map = new Map();
    map['Content-Type'] = 'application/json';
    map['X-Api-Key'] = Config.apiKey;
    return map;
  }

  String getFaasApi() {
    return '${Config.serverUrl}/ide/faas';
  }

  String getSearchApi(String domain, String queryName) {
    return '${this.getApiUrl(domain)}/search/$queryName';
  }

  String getFunctionApi(String name) {
    return '${Config.serverUrl}/ide/function/$name';
  }
}
