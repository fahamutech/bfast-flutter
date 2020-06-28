abstract class RestAdapter<T> {
  Future<T> get(String url, [RestRequestConfig config]);

  Future<T> delete(String url, [RestRequestConfig config]);

  Future<T> head(String url, [RestRequestConfig config]);

  Future<T> options(String url, [RestRequestConfig config]);

  Future<T> post(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]);

  Future<T> put(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]);

  Future<T> patch(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]);
}

class RestRequestConfig {
  String url;
  String method;
  String baseURL;
  Map<String, dynamic> headers;
  Map<dynamic, dynamic> params;

  RestRequestConfig(
      [String url,
      String method,
      String baseURL,
      Map<String, dynamic> headers,
      Map<dynamic, dynamic> params]) {
    this.url = url;
    this.method = method;
    this.baseURL = baseURL;
    this.headers = headers;
    this.params = params;
  }
}
