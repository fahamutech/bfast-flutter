import 'package:bfast/controller/rest.dart';

abstract class RestAdapter {
  Future<RestResponse<T>> get<T>(String url, [RestRequestConfig config]);

  Future<RestResponse<T>> delete<T>(String url, [RestRequestConfig config]);

  Future<RestResponse<T>> head<T>(String url, [RestRequestConfig config]);

  Future<RestResponse<T>> options<T>(String url, [RestRequestConfig config]);

  Future<RestResponse<T>> post<T>(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]);

  Future<RestResponse<T>> put<T>(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]);

  Future<RestResponse<T>> patch<T>(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]);
}

class RestRequestConfig {
  String url;
  String method;
  String baseURL;
  Map<String, String> headers;
  Map<String, dynamic> params;

  RestRequestConfig(
  {String url,
      String method,
      String baseURL,
      Map<String, String> headers,
      Map<String, dynamic> params}) {
    this.url = url;
    this.method = method;
    this.baseURL = baseURL;
    this.headers = headers;
    this.params = params;
  }
}
