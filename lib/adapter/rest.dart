import 'dart:typed_data';

import 'package:bfast/controller/rest.dart';
import 'package:http/http.dart' as http;

abstract class RestAdapter {
  Future<RestResponse<R>> get<T, R>(String url, [RestRequestConfig config]);

  Future<RestResponse<R>> delete<T, R>(String url, [RestRequestConfig config]);

  Future<RestResponse<R>> head<T, R>(String url, [RestRequestConfig config]);

  Future<RestResponse<R>> options<T, R>(String url, [RestRequestConfig config]);

  Future<RestResponse<R>> post<T, R>(String url,
      [T data, RestRequestConfig config]);

  Future<RestResponse> multiPartRequest(String url, ByteBuffer data,
      {http.MultipartRequest multipartRequest,RestRequestConfig config});

  Future<RestResponse<R>> put<T, R>(String url,
      [T data, RestRequestConfig config]);

  Future<RestResponse<R>> patch<T, R>(String url,
      [T data, RestRequestConfig config]);
}

class RestRequestConfig {
  String url;
  String method;
  String baseURL;
  Function uploadProgress;
  Map<String, String> headers;
  Map<String, dynamic> params;

  RestRequestConfig({
    this.headers,
    this.baseURL,
    this.method,
    this.params,
    this.uploadProgress,
    this.url,
  });
}
