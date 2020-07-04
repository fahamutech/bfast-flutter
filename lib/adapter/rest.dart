import 'package:bfast/controller/rest.dart';

abstract class RestAdapter {
  Future<RestResponse<R>> get<T, R>(String url, [RestRequestConfig config]);

  Future<RestResponse<R>> delete<T, R>(String url, [RestRequestConfig config]);

  Future<RestResponse<R>> head<T, R>(String url, [RestRequestConfig config]);

  Future<RestResponse<R>> options<T, R>(String url, [RestRequestConfig config]);

  Future<RestResponse<R>> post<T, R>(String url,
      [T data, RestRequestConfig config]);

  Future<RestResponse<R>> put<T, R>(String url,
      [T data, RestRequestConfig config]);

  Future<RestResponse<R>> patch<T, R>(String url,
      [T data, RestRequestConfig config]);
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
