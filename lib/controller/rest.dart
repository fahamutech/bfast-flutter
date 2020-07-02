import 'dart:convert';

import 'package:bfast/adapter/rest.dart';
import 'package:http/http.dart' as http;

class BFastHttpClientController extends RestAdapter {
  http.Client _httpClient;

  BFastHttpClientController({http.Client httpClient}) {
    if (httpClient != null) {
      this._httpClient = httpClient;
    } else {
      this._httpClient = http.Client();
    }
  }

  @override
  Future<RestResponse<T>> delete<T>(String url,
      [RestRequestConfig config]) async {
    var response = await this._httpClient.delete(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw {"message": response.reasonPhrase, "statusCode": response.statusCode};
    }
  }

  @override
  Future<RestResponse<T>> get<T>(String url, [RestRequestConfig config]) async {
    var response = await this._httpClient.get(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw {"message": response.reasonPhrase, "statusCode": response.statusCode};
    }
  }

  String _encodeUrlQueryParams(String url, Map params) {
    String urlWithParams = url;
    urlWithParams += '?';
    if (params != null) {
      params.forEach((key, value) {
        urlWithParams +=
            '${key.toString()}=${Uri.encodeQueryComponent(value.toString())}&';
      });
    }
    return urlWithParams;
  }

  @override
  Future<RestResponse<T>> head<T>(String url,
      [RestRequestConfig config]) async {
    var response = await this._httpClient.head(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw {"message": response.reasonPhrase, "statusCode": response.statusCode};
    }
  }

  @override
  Future<RestResponse<T>> options<T>(String url,
      [RestRequestConfig config]) async {
    var response = await this._httpClient.head(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw {"message": response.reasonPhrase, "statusCode": response.statusCode};
    }
  }

  @override
  Future<RestResponse<T>> patch<T>(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]) async {
    var response = await this._httpClient.patch(
        this._encodeUrlQueryParams(url, config?.params),
        body: data,
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw {"message": response.reasonPhrase, "statusCode": response.statusCode};
    }
  }

  @override
  Future<RestResponse<T>> post<T>(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]) async {
    var response = await this._httpClient.post(
        this._encodeUrlQueryParams(url, config?.params),
        body: jsonEncode(data),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw {"message": response.body, "statusCode": response.statusCode};
    }
  }

  @override
  Future<RestResponse<T>> put<T>(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]) async {
    var response = await this._httpClient.put(
        this._encodeUrlQueryParams(url, config?.params),
        body: jsonEncode(data),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw {"message": response.reasonPhrase, "statusCode": response.statusCode};
    }
  }
}

class RestResponse<T> {
  T data;

  RestResponse({T data}) {
    this.data = data;
  }
}
